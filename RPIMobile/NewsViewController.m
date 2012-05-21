//
//  NewsViewController.m
//  RPIMobile
//
//  Created by Stephen Silber on 5/20/12.
//  Copyright (c) 2012 Rensselaer Polytechnic Institute. All rights reserved.
//

#import "NewsViewController.h"
#import "NewsDetailViewController.h"
#import "PrettyKit.h"
#import "NSString+HTML.h"
#define start_color [UIColor colorWithHex:0xEEEEEE]
#define end_color [UIColor colorWithHex:0xDEDEDE]
#define numToDisplay 50


@implementation NewsViewController
@synthesize newsItems, launcherImage, newsTable;
@synthesize horizMenu = _horizMenu;
@synthesize items = _items;

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


- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
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
	self.title = info.title;
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
    
    self.navigationItem.title = @"RPI News";
    [self.newsTable setScrollsToTop:YES];
    self.newsTable.rowHeight = 90;
    self.newsTable.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.newsTable.backgroundColor = [UIColor scrollViewTexturedBackgroundColor];
    
    self.items = [NSArray arrayWithObjects:@"All News", @"Academics", @"Faculty", @"Research", @"Arts", @"Community", @"Calendar", @"Research Review", @"Athletics", nil];    
    [self.horizMenu reloadData];
    
    newsFeeds = [[NSMutableDictionary dictionaryWithObjectsAndKeys:@"http://www.rpi.edu/news/rss/allnews.xml", @"All News", @"http://www.rpi.edu/news/rss/academics.xml", @"Academics", @"http://www.rpi.edu/news/rss/faculty.xml", @"Faculty", @"http://www.rpi.edu/news/rss/research.xml", @"Research", @"http://www.rpi.edu/news/rss/arts.xml", @"Arts", @"http://www.rpi.edu/news/rss/community.xml", @"Community", @"http://www.rpi.edu/dept/cct/apps/oth/data/rpiTodaysEvents.rss", @"Calendar", @"http://www.rpi.edu/research/magazine/rpi_research_review.xml", @"Research Review", @"http://www.rpiathletics.com/rss.aspx", @"Athletics",nil] retain];


    [self.horizMenu setSelectedIndex:0 animated:YES];
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

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }   
    else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
{
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    // Navigation logic may go here. Create and push another view controller.

    MWFeedItem *item = [newsItems objectAtIndex:indexPath.row];
    if (item) {
        
        NewsDetailViewController *detailViewController = [[NewsDetailViewController alloc] initWithNibName:@"NewsDetailViewController" bundle:nil];
        
        //Hack - View not being initialized, referenced here: http://stackoverflow.com/questions/2720662/uilabel-not-updating
        NSLog(@"%@",detailViewController.view);
        
		// Process
		NSString *itemTitle = item.title ? [item.title stringByConvertingHTMLToPlainText] : @"[No Title]";
        NSString *stringFromDate = [formatter stringFromDate:item.date];
        NSString *itemURL = item.link ? [item.link stringByConvertingHTMLToPlainText] : @"";
//        NSString *itemSummary = item.summary ? [item.summary stringByConvertingHTMLToPlainText] : @"[No Summary]";
        NSString *itemContent = item.content ? [item.content stringByConvertingHTMLToPlainText] : item.content;

        [detailViewController setTitleText:itemTitle date:stringFromDate content:itemContent url:itemURL];
        [self.navigationController pushViewController:detailViewController animated:YES];
        [NewsDetailViewController release];
    }

     
}

#pragma mark -
#pragma mark HorizMenu Data Source
- (UIImage*) selectedItemImageForMenu:(MKHorizMenu*) tabMenu
{
    return [[UIImage imageNamed:@"ButtonSelected"] stretchableImageWithLeftCapWidth:16 topCapHeight:0];
}

- (UIColor*) backgroundColorForMenu:(MKHorizMenu *)tabView
{
    return [UIColor colorWithPatternImage:[UIImage imageNamed:@"MenuBar"]];
}

- (int) numberOfItemsForMenu:(MKHorizMenu *)tabView
{
    return [self.items count];
}

- (NSString*) horizMenu:(MKHorizMenu *)horizMenu titleForItemAtIndex:(NSUInteger)index
{
    return [self.items objectAtIndex:index];
}

#pragma mark -
#pragma mark HorizMenu Delegate

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
-(void) horizMenu:(MKHorizMenu *)horizMenu itemSelectedAtIndex:(NSUInteger)index
{  
     NSLog(@"Item at index: %@", [self.items objectAtIndex:index]);

    [self parseNewFeed:[self.items objectAtIndex:index]];
    
}

@end
