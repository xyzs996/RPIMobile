//
//  ScheduleViewController.m
//  RPIMobile
//
//  Created by Stephen Silber on 6/23/12.
//  Copyright (c) 2012 Rensselaer Polytechnic Institute. All rights reserved.
//

#import "ScheduleViewController.h"
#import "ScheduleEntry.h"
#import "JSONKit.h"

#define kCustomRowHeight  80.0

@implementation ScheduleViewController
@synthesize scheduleData, scheduleURL, entries;
-(void) refresh {
    [self.tableView reloadData];
}
- (void)downloadData
{
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"http://silb.es/rpi/schedule.php?url=%@", scheduleURL]];
    httprequest = [ASIHTTPRequest requestWithURL:url usingCache:[ASIDownloadCache sharedCache]];
    [httprequest setSecondsToCache:60*60*24*7]; //Cache roster for 1 week to save resources
    
    
    self.title = @"Downloading...";
    [httprequest setDelegate:self];
    [httprequest startAsynchronous];
}

- (void)requestFinished:(ASIHTTPRequest *)request
{
    //Reset back to normal look and feel
    self.title = @"Schedule";
    //    self.tableView.alpha = 1;
    self.tableView.userInteractionEnabled = YES;
    
    // Use when fetching text data
    NSString *responseString = [request responseString];
    NSArray *sched = [responseString objectFromJSONString];
    NSLog(@"Response string: %@", sched);
    scheduleData = [[NSMutableArray alloc] init];
    
    for(int i = 1; i < [sched count]; ++i) {
        if([[sched objectAtIndex:i] count] > 0) {
            ScheduleEntry *tempEntry = [[ScheduleEntry alloc] initWithArray:[sched objectAtIndex:i]];
            if(tempEntry) {
                [scheduleData addObject:tempEntry]; 
            }
        }
    }
    //    NSLog(@"Used cache? %@", [request didUseCachedResponse]);
    [self.tableView reloadData];
}

- (void)requestFailed:(ASIHTTPRequest *)request
{
    NSError *error = [request error];
    self.title = @"Error";
    NSLog(@"Could not download: %@", error);
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    NSLog(@"Schedule data: %@", scheduleData); 
    return [scheduleData count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
    }
    
    //Temporary class allocation for simple syntax in cell creation
    ScheduleEntry *cellEntry = [scheduleData objectAtIndex:indexPath.row];

    //Check for home or away game
    if([cellEntry.location characterAtIndex:0] == '@')
        cell.textLabel.textColor = [UIColor grayColor];
    
    cell.textLabel.text = cellEntry.location;
    cell.textLabel.numberOfLines = 2;
    cell.textLabel.lineBreakMode = UILineBreakModeWordWrap;
    cell.textLabel.font = [UIFont boldSystemFontOfSize:16];
    
    cell.detailTextLabel.numberOfLines = 2;
    cell.detailTextLabel.text = [NSString stringWithFormat:@"Date: %@\nInfo: %@",cellEntry.date,cellEntry.result];


    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}



#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    
	self.tableView.rowHeight = kCustomRowHeight;
    
    scheduleData = [[NSMutableArray alloc] initWithObjects: nil];
    NSLog(@"Current URL: %@", scheduleURL);
    [self downloadData];
    
    //Disable until data downloaded
    //    self.tableView.alpha = 0.5;
    self.tableView.userInteractionEnabled = NO;
    
    
    [httprequest setDownloadCache:[ASIDownloadCache sharedCache]];
    [httprequest setCachePolicy:ASIAskServerIfModifiedWhenStaleCachePolicy];
    // Refresh button for feed
	self.navigationItem.rightBarButtonItem = [[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemRefresh 
																							target:self 
																							action:@selector(refresh)] autorelease];
    
    
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    
}

- (void)dealloc
{
	[scheduleData release];
	[super dealloc];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

@end
