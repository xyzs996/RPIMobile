//
//  RosterViewController.m
//  RPIMobile
//
//  Created by Stephen Silber on 6/18/12.
//  Copyright (c) 2012 Rensselaer Polytechnic Institute. All rights reserved.
//

#import "RosterViewController.h"
#import "JSONKit.h"
#import "ASIHTTPRequest.h"
#import "ASIDownloadCache.h"

#import "Athlete.h"

#define kCustomRowHeight  45.0
#define kAppIconHeight    48

@implementation RosterViewController
@synthesize rosterURL, entries, athleteData;

-(void) refresh {
    [self.tableView reloadData];
}
- (void)downloadData
{
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"http://silb.es/rpi/roster.php?url=%@", rosterURL]];
    httprequest = [ASIHTTPRequest requestWithURL:url usingCache:[ASIDownloadCache sharedCache]];
    [httprequest setSecondsToCache:60*60*24*7]; //Cache roster for 1 week to save resources

    
    self.title = @"Downloading...";
    [httprequest setDelegate:self];
    [httprequest startAsynchronous];
}

- (void)requestFinished:(ASIHTTPRequest *)request
{
    //Reset back to normal look and feel
    self.title = @"Roster";
//    self.tableView.alpha = 1;
    self.tableView.userInteractionEnabled = YES;
    
    // Use when fetching text data
    NSString *responseString = [request responseString];
    NSArray *team = [responseString objectFromJSONString];

    athleteData = [[NSMutableArray alloc] init];
    for(int i = 1; i < [team count]; ++i) {
        NSLog(@"team: %@", [team objectAtIndex:i]);
        Athlete *tempAthlete = [[Athlete alloc] initWithArray:[team objectAtIndex:i]];
        NSLog(@"Temp Athlete: %@", tempAthlete);
        if(tempAthlete) 
            [athleteData addObject:tempAthlete]; 
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
    return [athleteData count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
    }
    
    cell.textLabel.text = [[athleteData objectAtIndex:indexPath.row] name];
    cell.detailTextLabel.text = [[athleteData objectAtIndex:indexPath.row] hometown];
//    cell.imageView.image = [UIImage imageNamed:@"Placeholder.png"];
//    [lazyImages addLazyImageForCell:cell withIndexPath:indexPath];
    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}
- (id)initWithCoder:(NSCoder *)aDecoder
{
	if ((self = [super initWithCoder:aDecoder]))
	{
		lazyImages = [[MHLazyTableImages alloc] init];
		lazyImages.placeholderImage = [UIImage imageNamed:@"Placeholder"];
		lazyImages.delegate = self;
	}
	return  self;
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark -
#pragma mark MHLazyTableImagesDelegate

- (NSURL*)lazyImageURLForIndexPath:(NSIndexPath*)indexPath
{
	Athlete* rosterEntry = [self.athleteData objectAtIndex:indexPath.row];
	return [NSURL URLWithString:rosterEntry.imageURL];
}

- (UIImage*)postProcessLazyImage:(UIImage*)image forIndexPath:(NSIndexPath*)indexPath
{
    if (image.size.width != kAppIconHeight && image.size.height != kAppIconHeight)
	{
        CGSize itemSize = CGSizeMake(kAppIconHeight, kAppIconHeight);
		UIGraphicsBeginImageContextWithOptions(itemSize, YES, 0);
		CGRect imageRect = CGRectMake(0.0, 0.0, itemSize.width, itemSize.height);
		[image drawInRect:imageRect];
		UIImage* newImage = UIGraphicsGetImageFromCurrentImageContext();
		UIGraphicsEndImageContext();
		return newImage;
    }
    else
    {
        return image;
    }
}


#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    lazyImages.tableView = self.tableView;
	self.tableView.rowHeight = kCustomRowHeight;
    
    athleteData = [[NSMutableArray alloc] initWithObjects: nil];
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
    lazyImages.tableView = nil;

}

- (void)dealloc
{
	[entries release];
    
	lazyImages.delegate = nil;
	[lazyImages release];
    
	[super dealloc];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

@end
