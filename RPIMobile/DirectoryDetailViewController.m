//
//  DetailViewController.m
//  RPI Directory
//
//  Created by Brendon Justin on 4/13/12.
//  Copyright (c) 2012 Brendon Justin. All rights reserved.
//

#import "DirectoryDetailViewController.h"
#import "Person.h"
//#import "PrettyKit.h"

//#define start_color [UIColor colorWithHex:0xEEEEEE]
//#define end_color [UIColor colorWithHex:0xDEDEDE]

@interface DirectoryDetailViewController ()
//@property (strong, nonatomic) UIPopoverController *masterPopoverController;
- (void)configureView;
@end

@implementation DirectoryDetailViewController

@synthesize person;
//@synthesize masterPopoverController = _masterPopoverController;

#pragma mark - Managing the detail item

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:UITableViewStyleGrouped];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)setPerson:(Person *)newPerson
{
    if (person != newPerson) {
        person = newPerson;
        
        // Update the view.
        [self configureView];
    }   
}

- (void)configureView
{
    // Update the user interface for the person.

    if (self.person) {
        [self.tableView reloadData];
    }
}
//
//- (void) setUpShadows {
//    [PrettyShadowPlainTableview setUpTableView:self.tableView];
//}

- (void)viewDidLoad
{
    [super viewDidLoad];
//    self.tableView.rowHeight = 100;
//    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
//    self.tableView.backgroundColor = [UIColor lightGrayColor];

    
    
//    [self setUpShadows];
    [self configureView];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    self.person = nil;
}

#pragma mark - Table View

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *labelString = nil;
    NSString *detailString = nil;
    CGFloat height, height2, greaterHeight, padding;
    
    int count = 0;
    for (NSString *string in self.person.details) {
        if (count++ == indexPath.row) {
            labelString = string;
            detailString = [self.person.details objectForKey:string];
        }
    }
    
    if (labelString == nil || detailString == nil) {
        return 44;
    } else {
        labelString = [labelString stringByReplacingOccurrencesOfString:@"_" 
                                                             withString:@" "];
        
        //  Based on code by Tim Rupe on StackOverflow:
        //  http://stackoverflow.com/questions/129502/how-do-i-wrap-text-in-a-uitableviewcell-without-a-custom-cell
        UIFont *cellFont = [UIFont fontWithName:@"Helvetica" size:12.0];
        CGSize constraintSize = CGSizeMake(67.0f, MAXFLOAT);
        CGSize labelSize = [labelString sizeWithFont:cellFont 
                                   constrainedToSize:constraintSize 
                                       lineBreakMode:UILineBreakModeWordWrap];
        
        height = labelSize.height;
        
        cellFont = [UIFont fontWithName:@"Helvetica" size:17.0];
        constraintSize = CGSizeMake(320.0f - 67.0f - 20.0f, MAXFLOAT);
        
        if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPad) {
            constraintSize = CGSizeMake(768.0f - 67.0f - 60.0f, MAXFLOAT);
        }
        labelSize = [detailString sizeWithFont:cellFont 
                             constrainedToSize:constraintSize 
                                 lineBreakMode:UILineBreakModeWordWrap];
        height2 = labelSize.height;
        
        //  Find the greater of the two.  If it is less than 30 pixels (empirically determined),
        //  then just return 44.
        if (height > height2) {
            greaterHeight = height;
            padding = 14;
        } else {
            greaterHeight = height2;
            padding = 10;
        }
        
        return greaterHeight > 30 ? greaterHeight + padding : 44;
    }
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (self.person) {
        return [self.person.details count];
    } else {
        return 0;
    }
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    if (self.person) {
        return person.name;
    } else {
        return @"Details for selection will appear here.";
    }
}



- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";

    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue2 
                                          reuseIdentifier:@"DetailCell"] autorelease];
//        cell.tableViewBackgroundColor = tableView.backgroundColor;        
//        cell.gradientStartColor = start_color;
//        cell.gradientEndColor = end_color;  
        cell.textLabel.numberOfLines = 0;
        cell.detailTextLabel.numberOfLines = 0;

    }

    cell.textLabel.backgroundColor = [UIColor clearColor];
    cell.detailTextLabel.backgroundColor = [UIColor clearColor];
    int count = 0;
    for (NSString *string in self.person.details) {
        if (count++ == indexPath.row) {
            cell.textLabel.text = [string stringByReplacingOccurrencesOfString:@"_" 
                                                                    withString:@" "];
            cell.detailTextLabel.text = [self.person.details objectForKey:string];
        }
    }
    
    if([cell.textLabel.text isEqualToString:@"email"] == NO)
    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];

//    [cell prepareForTableView:tableView indexPath:indexPath];
    return cell;
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return NO;
}

-(void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [self.tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if([[[[tableView cellForRowAtIndexPath:indexPath] textLabel ] text] isEqualToString:@"email"]) {
        //Email cell clicked, call mailto: link behavior
        NSLog(@"OPEN EMAIL TO THIS PERSON");
    }
}
@end
