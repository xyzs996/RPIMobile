//
//  CalendarViewController.m
//  RPIMobile
//
//  Created by Stephen Silber on 7/3/12.
//  Copyright (c) 2012 Rensselaer Polytechnic Institute. All rights reserved.
//

#import "CalendarViewController.h"
#import "EventViewController.h"
#import "FilterCalendarViewController.h"
#import "JSONKit.h"
#import "CalendarEntryInfo.h"
#import "CalendarEntryDetails.h"
#import "AppDelegate.h"

#define kPaddingHeight 10
int calendarShadowOffset = (int)-20;


@implementation CalendarViewController
@synthesize eventArray, dataDictionary, calendarData, managedObjectContext, fetchedResultsController, currentDate;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

// Show/Hide the calendar by sliding it down/up from the top of the device.
- (void)toggleCalendar {
    UIView *calendar;
    for (UIView *subView in self.view.subviews) {
        if ([subView isKindOfClass:[TKCalendarMonthView class]]) {
            calendar = subView;
            break;
        }
    }
	// If calendar is off the screen, show it, else hide it (both with animations)
	if (calendar.frame.origin.y == -calendar.frame.size.height+calendarShadowOffset) {
		// Show
        calendarShadowOffset = (int)-20;
		[UIView beginAnimations:nil context:NULL];
		[UIView setAnimationDuration:.25];
		calendar.frame = CGRectMake(0, 0, calendar.frame.size.width, calendar.frame.size.height);
		[UIView commitAnimations];
//        self.tableView.frame = CGRectMake(0, calendar.frame.size.height, 320, (super.view.frame.size.height-calendar.frame.size.height));
	} else {
		// Hide
        calendarShadowOffset = (int)0;
		[UIView beginAnimations:nil context:NULL];
		[UIView setAnimationDuration:.25];
		calendar.frame = CGRectMake(0, -calendar.frame.size.height+calendarShadowOffset, calendar.frame.size.width, calendar.frame.size.height);		
		[UIView commitAnimations];
        self.tableView.frame = CGRectMake(0, 44, 320, self.view.frame.size.height-44);
	}
    
	[self updateTableOffset:YES]; //Need to account for navigation bar!
}

-(void) fetchRecords {
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription
                                   entityForName:@"CalendarEntryInfo" inManagedObjectContext:managedObjectContext];
        
    NSLog(@"Comparing event date with: %@", [self.monthView dateSelected]);
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"(startDate <= %@ AND endDate >= %@)", [self.monthView dateSelected],[self.monthView dateSelected]];
    
    [fetchRequest setEntity:entity];
    [fetchRequest setPredicate:predicate];
    
    NSError *error;
    
    self.eventArray = [NSMutableArray arrayWithArray:[managedObjectContext executeFetchRequest:fetchRequest error:&error]];
    
//    for(int i = 0; i < [eventArray count]; ++i) {
//        if([self longEvent:[[eventArray objectAtIndex:i] startDate] end:[[eventArray objectAtIndex:i] endDate]]) {
//            NSLog(@"REMOVED OBJECT: %@", [[eventArray objectAtIndex:i] summary]);
//            [eventArray removeObjectAtIndex:i];
//          }
//
//    }
//    
    //Records fetched, array set, reload table data
    [self.tableView reloadData];
}

-(void)filterCalendar {
    FilterCalendarViewController *filterView = [[FilterCalendarViewController alloc] initWithNibName:@"FilterCalendarViewController" bundle:nil];
    [self.navigationController pushViewController:filterView animated:YES];
    [filterView release];

}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self.monthView selectDate:[NSDate month]];
    [self parseUrlForCalendar:@"http://events.rpi.edu/webcache/v1.0/jsonDays/31/list-json/%28catuid%3D%2700f18254-27fe1f37-0127-fe1f37da-00000001%27%7Ccatuid%3D%2700f18254-27fe1f37-0127-fe1f4be6-00000111%27%7Ccatuid%3D%2700f18254-27fe1f37-0127-fe1f3994-00000018%27%7Ccatuid%3D%2700f18254-27fe1f37-0127-fe1f5bab-000001e5%27%29/no--object.json"];
    self.calendarData = [NSMutableArray array];

    managedObjectContext = [(AppDelegate *)[[UIApplication sharedApplication] delegate] managedObjectContext]; 
    NSLog(@"After managedObjectContext: %@",  managedObjectContext);
    
    self.navigationItem.rightBarButtonItem = [[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemEdit target:self action:@selector(toggleCalendar)] autorelease];
    
    
    [self fetchRecords];

    
}

-(BOOL) longEvent:(NSDate *) dateStart end:(NSDate *) dateEnd {
    if([dateStart daysBetweenDate:dateEnd] > 30) 
        return YES;

    return NO;
    
}

- (BOOL)isDate:(NSDate *)date inRangeFirstDate:(NSDate *)firstDate lastDate:(NSDate *)lastDate {
    return [date compare:firstDate] == NSOrderedDescending &&
    [date compare:lastDate]  == NSOrderedAscending;
}

- (NSArray*) calendarMonthView:(TKCalendarMonthView*)monthView marksFromDate:(NSDate*)startDate toDate:(NSDate*)lastDate{
    
    int numDays = [lastDate daysBetweenDate:startDate];
    NSMutableArray *marksArray = [NSMutableArray arrayWithCapacity:numDays];
//    NSDate *d = startDate;
//    for(int i = 0; i < numDays; ++i) {
//        for(id ev in eventArray) {
//            if([self isDate:d inRangeFirstDate:[ev startDate] lastDate:[ev endDate]]) {
//                [marksArray insertObject:[NSNumber numberWithBool:YES] atIndex:i];
//                break;
//            }
//        }
//        d = [d dateByAddingDays:1];
//        
//    }
//    
    NSLog(@"MARKS ARRAY: %@", marksArray);
	return marksArray;
}
- (void) calendarMonthView:(TKCalendarMonthView*)monthView didSelectDate:(NSDate*)date{
	
	// CHANGE THE DATE TO YOUR TIMEZONE
	TKDateInformation info = [date dateInformationWithTimeZone:[NSTimeZone timeZoneForSecondsFromGMT:0]];
	NSDate *myTimeZoneDay = [NSDate dateFromDateInformation:info timeZone:[NSTimeZone systemTimeZone]];
    NSLog(@"Date Selected: %@",myTimeZoneDay);
    
    [self fetchRecords];
	[self.tableView reloadData];
}
- (void) calendarMonthView:(TKCalendarMonthView*)mv monthDidChange:(NSDate*)d animated:(BOOL)animated{
	[super calendarMonthView:mv monthDidChange:d animated:animated];
	[self.tableView reloadData];
}


- (NSInteger) numberOfSectionsInTableView:(UITableView *)tableView {
	return 1;
	
}

- (CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath 
{
    return tableView.rowHeight + kPaddingHeight;
}


- (NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {	
    return [eventArray count];
}
- (UITableViewCell *) tableView:(UITableView *)tv cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tv dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
    
    cell.textLabel.font = [UIFont boldSystemFontOfSize:13];
	cell.textLabel.text = [[eventArray objectAtIndex:indexPath.row] summary];
    cell.textLabel.numberOfLines = 3;
    
    
    if( [[[eventArray objectAtIndex:indexPath.row] details] eventDescription])
        cell.detailTextLabel.text =  [[[eventArray objectAtIndex:indexPath.row] details] eventDescription];
    
//    cell.detailTextLabel.text = 
	
    return cell;
	
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (void)requestFinished:(ASIHTTPRequest *)request
{
    NSString *responseString = [request responseString];
    [self processJSON:[responseString objectFromJSONString]];
}

-(void) addEvent:(NSMutableDictionary *) eventData {
    NSManagedObjectContext *context = [self managedObjectContext];
    CalendarEntryInfo *eventInfo = [NSEntityDescription insertNewObjectForEntityForName:@"CalendarEntryInfo" inManagedObjectContext:context];
    
    eventInfo.summary = [eventData objectForKey:@"summary"];

    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setLocale:[[NSLocale alloc] initWithLocaleIdentifier:@"en_US"]];
    [formatter setDateFormat:@"LL/d/yy"];
    
    eventInfo.startDate = [formatter dateFromString:[[eventData objectForKey:@"start"] objectForKey:@"shortdate"]];
    eventInfo.endDate = [formatter dateFromString:[[eventData objectForKey:@"end"] objectForKey:@"shortdate"]];
    
    [formatter setDateFormat:@"d"];
    
    NSNumberFormatter * f = [[NSNumberFormatter alloc] init];
    [f setNumberStyle:NSNumberFormatterNoStyle];
    eventInfo.dayOfMonth = [f numberFromString:[formatter stringFromDate:eventInfo.startDate]];
    [f release];
    [formatter release];

    CalendarEntryDetails *eventDetails = [NSEntityDescription insertNewObjectForEntityForName:@"CalendarEntryDetails" inManagedObjectContext:context];
    


    
    eventDetails.eventDescription = [eventData objectForKey:@"description"];
    eventDetails.cost = [eventData objectForKey:@"cost"];
    
//    eventDetails.contactInfo = [eventData objectForKey:@"contact"];
//    eventDetails.location = [eventData objectForKey:@"location"];
//    eventDetails.categories = [eventData objectForKey:@"categories"];
    
    eventInfo.details = eventDetails;
    eventDetails.info = eventInfo;
    
    NSError *error;
    if (![context save:&error]) {
        NSLog(@"Whoops, couldn't save: %@", [error localizedDescription]);
    }
    
    
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];

    EventViewController *nextView = [[EventViewController alloc] initWithStyle:UITableViewStyleGrouped];
    
    nextView.entryInfo = [eventArray objectAtIndex:indexPath.row];
    nextView.entryDetails = [[eventArray objectAtIndex:indexPath.row] details];
    
    [self.navigationController pushViewController:nextView animated:YES];
    [nextView release];

}

-(NSArray *) processJSON:(NSDictionary *) events {
    NSArray *innerEvents = [[events objectForKey:@"bwEventList"] objectForKey:@"events"];
    
    for(id event in innerEvents) {
        [self addEvent:event];
    }
    [self fetchRecords];
    return nil;
}

- (void)requestFailed:(ASIHTTPRequest *)request {
    NSError *error = [request error];
    self.title = @"Error";
    NSLog(@"Could not download: %@", error);
}

-(void) parseUrlForCalendar:(NSString *)url {
    ASIHTTPRequest *request = [ASIHTTPRequest requestWithURL:[NSURL URLWithString:url] usingCache:[ASIHTTPRequest defaultCache]];
    [request setDelegate:self];
    [request setSecondsToCache:60*60*243]; //3 day cache
    [request startAsynchronous];
}

- (void)dealloc {  
    [managedObjectContext release];  
    [eventArray release];  
    [super dealloc];  
}   

@end
