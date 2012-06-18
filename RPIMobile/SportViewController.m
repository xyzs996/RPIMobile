//
//  SportViewController.m
//  RPIMobile
//
//  Created by Stephen Silber on 6/18/12.
//  Copyright (c) 2012 Rensselaer Polytechnic Institute. All rights reserved.
//

#import "SportViewController.h"
#import "PrettyKit.h"

@implementation SportViewController
@synthesize menuList, sportName;

#define start_color [UIColor colorWithHex:0xEEEEEE]
#define end_color [UIColor colorWithHex:0xDEDEDE]

#pragma mark -
#pragma mark Table View Data Source Methods

- (NSInteger)tableView:(UITableView *)tableView
 numberOfRowsInSection:(NSInteger)section
{
    return [listItems count];
}

- (CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath 
{
    return tableView.rowHeight + [PrettyTableViewCell tableView:tableView neededHeightForIndexPath:indexPath];
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

- (UITableViewCell *)tableView:(UITableView *)tableView
         cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    static NSString *CellIdentifier = @"Cell";
    
    PrettyTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[[PrettyTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
        cell.tableViewBackgroundColor = tableView.backgroundColor;        
        cell.gradientStartColor = start_color;
        cell.gradientEndColor = end_color;  
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }
    [cell prepareForTableView:tableView indexPath:indexPath];
    cell.textLabel.backgroundColor = [UIColor clearColor];
    
    
    cell.textLabel.text = [listItems objectAtIndex:[indexPath row]];
    return cell;
    
}

- (void) setUpShadows {
    [PrettyShadowPlainTableview setUpTableView:self.menuList];
}

-(NSString *)getLink {
    NSMutableDictionary *sports = [[NSMutableDictionary alloc]initWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"AthleticLinks" ofType:@"plist"]];

    if([sports valueForKey:sportName]) {
        return [[sports valueForKey:sportName] valueForKey:currentGender];
    } else {
        return NULL;
    }
}


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
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
    
    //Debug until NSUserDefaults implemented
    if(!currentGender)
        currentGender = @"Men";

    listItems = [[NSArray alloc]initWithObjects:@"News", @"Roster", @"Schedule & Results", @"Videos", @"Archives", nil];
    UISegmentedControl *genderControl = [[UISegmentedControl alloc] initWithItems:[NSArray arrayWithObjects:@"Men", @"Women", nil]];
    genderControl.segmentedControlStyle = UISegmentedControlStyleBar;
    genderControl.selectedSegmentIndex = 0;
    genderControl.tintColor = COLOR(190, 0, 0);
    
    currentLink = [self getLink];
    
    NSLog(@"Current Link: %@", currentLink);
    
    UIBarButtonItem * segmentBarItem = [[[UIBarButtonItem alloc] initWithCustomView: genderControl] autorelease];
    self.navigationItem.rightBarButtonItem = segmentBarItem;
    [genderControl release];

    self.menuList.rowHeight = 60;
    self.menuList.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.menuList.backgroundColor = [UIColor scrollViewTexturedBackgroundColor];
    
    [self setUpShadows];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
    listItems = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

@end
