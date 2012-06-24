//
//  SportViewController.m
//  RPIMobile
//
//  Created by Stephen Silber on 6/18/12.
//  Copyright (c) 2012 Rensselaer Polytechnic Institute. All rights reserved.
//

#import "SportViewController.h"
#import "RosterViewController.h"
#import "SportNewsViewController.h"
#import "ScheduleViewController.h"
#import "PrettyKit.h"
#import "UIImageExtras.h"

@implementation SportViewController
@synthesize menuList, sportName, currentGender, progressBar, teamPicture, currentLink;

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
    if(indexPath.row == 0) {
        SportNewsViewController *nextView = [[SportNewsViewController alloc] initWithNibName:@"SportNewsViewController" bundle:nil];
        nextView.title = @"News";
        nextView.feedURL = [self getLink:1];
        [self.navigationController pushViewController:nextView animated:YES];
        [nextView release];
    } else if(indexPath.row == 1) {
        RosterViewController *nextView = [[RosterViewController alloc] initWithNibName:@"RosterViewController" bundle:nil];
        nextView.rosterURL = [self getLink:0];
        nextView.title = sportName;
        [self.navigationController pushViewController:nextView animated:YES];
        [nextView release];
    }  else if(indexPath.row == 2) {
        ScheduleViewController *nextView = [[ScheduleViewController alloc] initWithNibName:@"ScheduleViewController" bundle:nil];
        nextView.scheduleURL = [self getLink:2];
        nextView.title = @"Schedule";
        [self.navigationController pushViewController:nextView animated:YES];
        [nextView release];
    } 
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

-(void)imageDownloadFinished:(ASIHTTPRequest *) request {
    NSLog(@"Download Finished@");
    [self.progressBar setHidden:YES];
    UIImage *scaledPic = [[UIImage imageWithData:[request responseData]] resizedImageWithContentMode:UIViewContentModeScaleAspectFill imageToScale:[UIImage imageWithData:[request responseData]] bounds:CGSizeMake(320, 181) interpolationQuality:kCGInterpolationHigh];
    [teamPicture setImage:scaledPic];
    
}

-(void)imageDownloadFailed:(ASIHTTPRequest *) request {
    NSLog(@"Download Failed! %@", [request error]);
}
- (void)requestFinished:(ASIHTTPRequest *)request {
    NSLog(@"Link found: %@", [request responseString]);
    [self downloadPicture:[request responseString]];
}

- (void)requestFailed:(ASIHTTPRequest *)request
{
    NSError *error = [request error];
    self.title = @"Error";
    NSLog(@"Could not download: %@", error);
}
-(void) findPictureLink {

    ASIHTTPRequest *request = [ASIHTTPRequest requestWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"http://silb.es/rpi/teampic.php?url=%@",currentLink]] usingCache:[ASIHTTPRequest defaultCache]];
    NSLog(@"Finding picture with current link: %@", currentLink);
    [request setSecondsToCache:60*60*24*7]; //Cache for a week
    [request setDelegate:self];
    [request startAsynchronous];
}

-(void) downloadPicture:(NSString *)url {

    [self.progressBar setHidden:NO];
    
    ASIHTTPRequest *request = [ASIHTTPRequest requestWithURL:[NSURL URLWithString:url]];
    [request setDelegate:self];
    [request setSecondsToCache:60*60*24*7]; //Cache image for 1 week
    [request setCacheStoragePolicy:ASIAskServerIfModifiedWhenStaleCachePolicy];
    [request setDownloadProgressDelegate:progressBar];
    [request setDidFinishSelector:@selector(imageDownloadFinished:)];
    [request setDidFailSelector:@selector(imageDownloadFailed:)];
    [request startAsynchronous];
}

-(NSString *)getLink:(int) mode {
    NSMutableDictionary *sports = [[NSMutableDictionary alloc]initWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"AthleticLinks" ofType:@"plist"]];

    if([sports valueForKey:sportName]) {
        NSLog(@"Gender: %@ Sport: %@ return value: %@", currentGender, sportName, [[[sports valueForKey:sportName] valueForKey:currentGender] objectAtIndex:mode]);
        return [[[sports valueForKey:sportName] valueForKey:currentGender] objectAtIndex:mode];
    }
    return NULL;
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
//    self.teamPicture.contentMode = UIViewContentModeScaleAspectFit;
    self.progressBar.progress = 0.0;

    listItems = [[NSArray alloc]initWithObjects:@"News", @"Roster", @"Schedule & Results", @"Videos", @"Archives", nil];
    
    self.currentGender = [[NSUserDefaults standardUserDefaults] stringForKey:@"sportGender"];
    self.currentLink = [self getLink:0];
    [self findPictureLink];

    //Table customization
    self.menuList.rowHeight = 47;
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
