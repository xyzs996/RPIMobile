//
//  EventViewController.m
//  RPIMobile
//
//  Created by Stephen Silber on 7/10/12.
//  Copyright (c) 2012 Rensselaer Polytechnic Institute. All rights reserved.
//

#import "EventViewController.h"

@implementation EventViewController
@synthesize entryInfo, entryDetails;

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:UITableViewStyleGrouped];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    NSLog(@"EVENT INFORMATION: \n");
    NSLog(@"%@", entryInfo.dayOfMonth);
    NSLog(@"%@", entryInfo.startDate);
    NSLog(@"%@", entryInfo.endDate);
    NSLog(@"%@", entryDetails.location);
    NSLog(@"%@", entryDetails.location);
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
 
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
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


- (CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath 
{
    return 180;
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 5;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    switch (section) {
        case 0: //Event Summary & Description (cost included too)
            return 3;
        case 1: //Event Start & End date/time
            return 4; 
        case 2: //Event location
            return 2;
        case 3: //Contact (name, phone, link)
            return 3;
        case 4: //Links (event and regular)
            return 2;
        case 5: //Categories
            return 0; //get array count from eventDetails -> categories stored
        default:
            return 4;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
    

    switch (indexPath.section) {
        case 0:
            if(indexPath.row == 0) {
                cell.textLabel.numberOfLines = 4;
                cell.textLabel.font = [UIFont systemFontOfSize:16];
                cell.textLabel.text = entryInfo.summary;
            } else if(indexPath.row == 1) {
                cell.textLabel.text = entryDetails.eventDescription;
                cell.textLabel.font = [UIFont systemFontOfSize:12];
                cell.textLabel.numberOfLines = 10;
            } else {
                cell.textLabel.text = entryDetails.cost;
            }
            break;
        default:
            cell.textLabel.text = @"Put stuff here";
            break;
    }

	
    return cell;

}


#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Navigation logic may go here. Create and push another view controller.
    /*
     <#DetailViewController#> *detailViewController = [[<#DetailViewController#> alloc] initWithNibName:@"<#Nib name#>" bundle:nil];
     // ...
     // Pass the selected object to the new view controller.
     [self.navigationController pushViewController:detailViewController animated:YES];
     [detailViewController release];
     */
}

@end
