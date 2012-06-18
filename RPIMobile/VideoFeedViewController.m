//
//  VideoFeedViewController.m
//  RPIMobile
//
//  Created by Stephen Silber on 6/12/12.
//  Copyright (c) 2012 Rensselaer Polytechnic Institute. All rights reserved.
//

#import "VideoFeedViewController.h"
#import "PrettyKit.h"
#import "NSString+HTML.h"

#define start_color [UIColor colorWithHex:0xEEEEEE]
#define end_color [UIColor colorWithHex:0xDEDEDE]
#define numToDisplay 50



@implementation VideoFeedViewController

@synthesize newsItems, newsTable, items, launcherImage;


- (void)quitView: (id) sender {
    [[NSNotificationCenter defaultCenter] postNotificationName:@"closeView" object:self.navigationController.view];
}

// Reset and reparse
- (void)refresh {
	self.title = @"Refreshing...";
	[parsedItems removeAllObjects];
	[feedParser stopParsing];
	[feedParser parse];
    self.newsTable.userInteractionEnabled = NO;
    self.newsTable.alpha = 0.3;
}

- (void)updateTableWithParsedItems {
	self.newsItems = [parsedItems sortedArrayUsingDescriptors:
                      [NSArray arrayWithObject:[[[NSSortDescriptor alloc] initWithKey:@"date" 
                                                                            ascending:NO] autorelease]]];
	self.newsTable.userInteractionEnabled = YES;
	self.newsTable.alpha = 1;
	[self.newsTable reloadData];
}

- (void) setUpShadows {
    [PrettyShadowPlainTableview setUpTableView:self.newsTable];
}


#pragma mark MWFeedParserDelegate

- (void)feedParserDidStart:(MWFeedParser *)parser {
	NSLog(@"Started Parsing: %@", parser.url);
}

- (void)feedParser:(MWFeedParser *)parser didParseFeedInfo:(MWFeedInfo *)info {
	NSLog(@"Parsed Feed Info: “%@”", info.title);
	self.title = @"RPI Videos";
}

- (void)feedParser:(MWFeedParser *)parser didParseFeedItem:(MWFeedItem *)item {
	NSLog(@"Parsed Feed Item: “%@”", item.title);
	if (item) [parsedItems addObject:item];	
    if([parsedItems count] > numToDisplay) {
        [feedParser stopParsing];
    }
}

- (void)feedParserDidFinish:(MWFeedParser *)parser {
	NSLog(@"Finished Parsing%@", (parser.stopped ? @" (Stopped)" : @""));
    [self updateTableWithParsedItems];
}

- (void)feedParser:(MWFeedParser *)parser didFailWithError:(NSError *)error {
	NSLog(@"Finished Parsing With Error: %@", error);
    if (parsedItems.count == 0) {
        self.title = @"Failed"; // Show failed message in title
    } else {
        // Failed but some items parsed, so show and inform of error
        UIAlertView *alert = [[[UIAlertView alloc] initWithTitle:@"Parsing Incomplete"
                                                         message:@"There was an error during the parsing of this feed. Not all of the feed items could parsed."
                                                        delegate:nil
                                               cancelButtonTitle:@"Dismiss"
                                               otherButtonTitles:nil] autorelease];
        [alert show];
    }
    [self updateTableWithParsedItems];
}


#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.navigationItem.title = @"RPI YouTube";
    [self.newsTable setScrollsToTop:YES];
    
    self.newsTable.rowHeight = 90;
    self.newsTable.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.newsTable.backgroundColor = [UIColor scrollViewTexturedBackgroundColor];

	self.title = @"Loading...";
	formatter = [[NSDateFormatter alloc] init];
	[formatter setDateFormat:@"dd MMM yyyy HH:mm:ss zzz"];
	[formatter setTimeStyle:NSDateFormatterShortStyle];
	parsedItems = [[NSMutableArray alloc] init];
	self.newsItems = [NSArray array];
	
	// Refresh button for feed
	self.navigationItem.rightBarButtonItem = [[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemRefresh 
																							target:self 
																							action:@selector(refresh)] autorelease];
    
    // Create feed parser and pass the URL of the feed
    NSURL *feedURL = [NSURL URLWithString:@"http://gdata.youtube.com/feeds/api/users/rpirensselaer/uploads"];
    
    // Parse
	feedParser = [[MWFeedParser alloc] initWithFeedURL:feedURL];
	feedParser.delegate = self;
	feedParser.feedParseType = ParseTypeFull; // Parse feed info and all items
	feedParser.connectionType = ConnectionTypeAsynchronously;
    [self refresh];

    [self setUpShadows]; 
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}

-(void) viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
}
- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
}

- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

#pragma mark - Table view data source

// Customize the number of sections in the table view.
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

// Customize the number of rows in the table view.
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return newsItems.count;
}


- (CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath 
{
    return tableView.rowHeight + [PrettyTableViewCell tableView:tableView neededHeightForIndexPath:indexPath];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    
    PrettyTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[[PrettyTableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier] autorelease];
        cell.tableViewBackgroundColor = tableView.backgroundColor;        
        cell.gradientStartColor = start_color;
        cell.gradientEndColor = end_color;
    }
    
    
    // Configure the cell.
	MWFeedItem *item = [newsItems objectAtIndex:indexPath.row];
    cell.textLabel.backgroundColor = [UIColor clearColor];
    cell.detailTextLabel.backgroundColor = [UIColor clearColor];
    
	if (item) {
		
		// Process
		NSString *itemTitle = item.title ? [item.title stringByConvertingHTMLToPlainText] : @"[No Title]";
		NSString *itemSummary = item.summary ? [item.summary stringByConvertingHTMLToPlainText] : @"[No Summary]";
        
        cell.textLabel.text = itemTitle;
        cell.textLabel.font = [UIFont boldSystemFontOfSize:12];
        cell.textLabel.lineBreakMode = UILineBreakModeWordWrap;
        [cell.textLabel setNumberOfLines:2];
        
        
        cell.detailTextLabel.text = itemSummary;
		cell.detailTextLabel.font = [UIFont systemFontOfSize:10];
        cell.detailTextLabel.lineBreakMode = UILineBreakModeWordWrap;
        [cell.detailTextLabel setNumberOfLines:3];
        
		/*NSMutableString *subtitle = [NSMutableString string];
         //if (item.date) [subtitle appendFormat:@"%@: ", [formatter stringFromDate:item.date]];
         [subtitle appendString:itemSummary];
         //		cell.summary.text = subtitle;
         */
		
	} else {
        cell.textLabel.text = @"Error";
    }
    [cell prepareForTableView:tableView indexPath:indexPath];
    
    
    return cell;
    
}

#pragma mark - Table view delegate

-(NSString *) getVideoID:(NSString *) url {
  //Break URL to get video id
    NSArray *subString = [url componentsSeparatedByString:@"&"];
    if([subString count] > 0) {
        NSString *vidID = [[subString objectAtIndex:0] substringFromIndex:[[subString objectAtIndex:0] length] - 11];
        NSLog(@"Video ID: %@", vidID);
        return vidID;
    }
    
    return @"";
}

//Implement autoplay trick, must create separate uiviewcontroller file
//for simplicity: http://stackoverflow.com/questions/3010708/youtube-video-autoplay-on-iphones-safari-or-uiwebview
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    // Navigation logic may go here. Create and push another view controller.
    
    MWFeedItem *item = [newsItems objectAtIndex:indexPath.row];
    if (item) {
        
        NSString *itemURL = item.link ? item.link : @"";
        NSLog(@"%@",itemURL); //&autoplay=1
        itemURL = [itemURL stringByAppendingString:@"&autoplay=1"];
        UIWebView *videoWebview = [[UIWebView alloc] initWithFrame:CGRectZero];
        
        NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:itemURL]];
        
        //URL Requst Object
        NSMutableURLRequest *requestObj = [NSURLRequest requestWithURL:url];
        
        //Load the request in the UIWebView.
        [videoWebview loadRequest:requestObj];
        

        
        UIViewController *videoView = [[UIViewController alloc] init];
        [videoView setView:videoWebview];
        [videoWebview release];
        /*
        
        - (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
        {
            // Return YES for supported orientations
            return (interfaceOrientation == UIInterfaceOrientationPortrait);
        }
        */
        
        [self.navigationController pushViewController:videoView animated:YES];
    }
    
    
}


-(void) parseNewFeed:(NSString *) key {
    
    // Create feed parser and pass the URL of the feed
    NSURL *feedURL = [NSURL URLWithString:[newsFeeds objectForKey:key]];
    
    // Parse
	feedParser = [[MWFeedParser alloc] initWithFeedURL:feedURL];
	feedParser.delegate = self;
	feedParser.feedParseType = ParseTypeFull; // Parse feed info and all items
	feedParser.connectionType = ConnectionTypeAsynchronously;
    [self refresh];
}

@end
