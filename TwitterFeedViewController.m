//
//  TwitterFeedViewController.m
//  RPIMobile
//
//  Created by Stephen Silber on 7/1/12.
//  Copyright (c) 2012 Rensselaer Polytechnic Institute. All rights reserved.
//

#import "TwitterFeedViewController.h"
#import "NSString+HTML.h"
#import "UIImageView+WebCache.h"
#import "ASIHTTPRequest.h"
#import "XMLReader.h"

#define start_color [UIColor colorWithHex:0xEEEEEE]
#define end_color [UIColor colorWithHex:0xDEDEDE]
#define numToDisplay 50
#define kFeedURL @"http://api.twitter.com/1/stephensilber/lists/rpimobile/statuses.atom"

/* To-do for RPI Twitter page:
    -Add custom view for UITableViewCell that allows for clickable links, has the timestamp of the tweet, and dynamically sizes cell based on text content
    -Pull to refresh
    -TweetDetails page with either a separate view or expanded tableview cell. MGBox looks promising
 */

@interface feedItem : NSObject {
    NSString *username, *tweet, *avatarURL, *date;
}

@property (nonatomic, retain) NSString *username, *tweet, *avatarURL, *date;

@end

@implementation feedItem
@synthesize username, tweet, avatarURL, date;
@end


@implementation TwitterFeedViewController
@synthesize newsItems, sortedItems;

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

// Reset and reparse
- (void)refresh {
	self.title = @"Refreshing...";
    feedDictionary = [[NSDictionary alloc] init];
    [self fetchFeed];
}

//ASIHTTPRequest Delegate function
- (void)requestFinished:(ASIHTTPRequest *)request
{
    //Called with successful data from atom feed for twitter list, parse into dictionary
    self.title = @"RPI Twitter";    
    NSError *parseError = nil;
    feedDictionary = [XMLReader dictionaryForXMLString:[request responseString] error:&parseError];
    feedDictionary = [[feedDictionary objectForKey:@"feed"] objectForKey:@"entry"];
    
    newsItems = [[NSMutableArray alloc] init];
    
    //Read objects into an array for easy UITableView display and 
    for(id entry in feedDictionary) {
        
        feedItem *newItem = [[feedItem alloc] init];
        
        newItem.username = [[[entry objectForKey:@"author"] objectForKey:@"name"] objectForKey:@"text"];
        newItem.tweet = [[entry objectForKey:@"content"] objectForKey:@"text"];
        newItem.avatarURL = [[[entry objectForKey:@"link"] objectAtIndex:1] objectForKey:@"href"];
        newItem.date = [[entry objectForKey:@"published"] objectForKey:@"text"];

        //Clean up whitespace and other garbage from the parsed feed
        newItem.username = [newItem.username stringByRemovingNewLinesAndWhitespace];
        newItem.tweet = [newItem.tweet stringByRemovingNewLinesAndWhitespace];        
        
        [newsItems addObject:newItem];

        [newItem release];
    }
    
    //Set NSArray with NSMutableArray
    sortedItems = newsItems;
    
    [self.tableView reloadData];
}

- (void)requestFailed:(ASIHTTPRequest *)request
{
    //Called if atom feed for twitter list cannot be downloaded
    NSError *error = [request error];
    self.title = @"Error";
    NSLog(@"Could not download: %@", error);
}

-(void) fetchFeed {
    ASIHTTPRequest *request = [ASIHTTPRequest requestWithURL:[NSURL URLWithString:kFeedURL]];
    request.delegate = self;
    [request startAsynchronous];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    sortedItems = [NSArray array];
    
    formatter = [[NSDateFormatter alloc] init];
	[formatter setDateFormat:@"dd MMM yyyy HH:mm:ss zzz"];
	[formatter setTimeStyle:NSDateFormatterShortStyle];

    self.tableView.rowHeight = 70;
    
    [self fetchFeed];

    // Refresh button for feed
	self.navigationItem.rightBarButtonItem = [[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemRefresh 
																							target:self 
																							action:@selector(refresh)] autorelease];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    
    // Stop feed download / parsing
    [ASIHTTPRequest cancelPreviousPerformRequestsWithTarget:self];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (void)updateTableWithParsedItems {
	self.sortedItems = [sortedItems sortedArrayUsingDescriptors:
                      [NSArray arrayWithObject:[[[NSSortDescriptor alloc] initWithKey:@"date" 
                                                                            ascending:NO] autorelease]]];
	self.tableView.userInteractionEnabled = YES;
	self.tableView.alpha = 1;
	[self.tableView reloadData];
}

-(void) dealloc {
    [super dealloc];
    [newsItems release];
    [sortedItems release];
    [formatter release];
    [feedDictionary release];
}


#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return [sortedItems count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier] autorelease];
//        cell.tableViewBackgroundColor = tableView.backgroundColor;        
//        cell.gradientStartColor = start_color;
//        cell.gradientEndColor = end_color;
    }
    
    
    // Configure the cell.
	feedItem *item = [sortedItems objectAtIndex:indexPath.row];
    cell.textLabel.backgroundColor = [UIColor clearColor];
    cell.detailTextLabel.backgroundColor = [UIColor clearColor];
    
	if (item) {
		
        cell.textLabel.text = item.username;
        cell.textLabel.font = [UIFont boldSystemFontOfSize:14];
        cell.textLabel.lineBreakMode = UILineBreakModeWordWrap;
        [cell.textLabel setNumberOfLines:2];

        cell.detailTextLabel.text = item.tweet;
		cell.detailTextLabel.font = [UIFont systemFontOfSize:12];
        cell.detailTextLabel.lineBreakMode = UILineBreakModeWordWrap;
        [cell.detailTextLabel setNumberOfLines:3];
	} else {
        cell.textLabel.text = @"Error";
    }
//    [cell prepareForTableView:tableView indexPath:indexPath];
    [cell.imageView setImageWithURL:[NSURL URLWithString:item.avatarURL] placeholderImage:[UIImage imageNamed:@"Placeholder.png"]];
    
    return cell;
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
}

@end
