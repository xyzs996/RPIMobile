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
@synthesize menuList, sportName, currentGender, progressBar, teamPicture, currentLink, noImage;

#define start_color [UIColor colorWithHex:0xEEEEEE]
#define end_color [UIColor colorWithHex:0xDEDEDE]

#define red_start_color [UIColor colorWithHex:0x595959]
#define red_end_color [UIColor colorWithHex:0x303030]


#pragma mark -
#pragma mark Table View Data Source Methods

- (NSInteger)tableView:(UITableView *)tableView
 numberOfRowsInSection:(NSInteger)section
{
    return [listItems count];
}

- (CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath 
{
    if(indexPath.row == 0) {
        return 47 + [PrettyTableViewCell tableView:tableView neededHeightForIndexPath:indexPath];
    } else {
        return tableView.rowHeight + [PrettyTableViewCell tableView:tableView neededHeightForIndexPath:indexPath];
    }
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if(indexPath.row == 1) {
        SportNewsViewController *nextView = [[SportNewsViewController alloc] initWithNibName:@"SportNewsViewController" bundle:nil];
        nextView.title = @"News";
        nextView.feedURL = [self getLink:1];
        [self.navigationController pushViewController:nextView animated:YES];
        [nextView release];
    } else if(indexPath.row == 2) {
        RosterViewController *nextView = [[RosterViewController alloc] initWithNibName:@"RosterViewController" bundle:nil];
        nextView.rosterURL = [self getLink:0];
        nextView.title = sportName;
        [self.navigationController pushViewController:nextView animated:YES];
        [nextView release];
    }  else if(indexPath.row == 3) {
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
    if(indexPath.row == 0) {
        cell.gradientStartColor = red_start_color;
        cell.gradientEndColor = red_end_color;
        cell.accessoryType = UITableViewCellAccessoryNone;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.textLabel.textAlignment = UITextAlignmentCenter;
        cell.textLabel.textColor = [UIColor whiteColor];
    } else {
        cell.textLabel.font = [UIFont systemFontOfSize:16];
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
    [self.noImage setHidden:NO];
    [self.progressBar setHidden:YES];
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

    asiRequest = [ASIHTTPRequest requestWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"http://silb.es/rpi/teampic.php?url=%@",currentLink]] usingCache:[ASIHTTPRequest defaultCache]];
    NSLog(@"Finding picture with current link: %@", currentLink);
    [asiRequest setSecondsToCache:60*60*24*7]; //Cache for a week
    [asiRequest setDelegate:self];
    [asiRequest startAsynchronous];
}

-(void) downloadPicture:(NSString *)url {

    [self.progressBar setHidden:NO];
    
    asiRequest = [ASIHTTPRequest requestWithURL:[NSURL URLWithString:url]];
    [asiRequest setDelegate:self];
    [asiRequest setSecondsToCache:60*60*24*7]; //Cache image for 1 week
    [asiRequest setCacheStoragePolicy:ASIAskServerIfModifiedWhenStaleCachePolicy];
    [asiRequest setDownloadProgressDelegate:progressBar];
    [asiRequest setDidFinishSelector:@selector(imageDownloadFinished:)];
    [asiRequest setDidFailSelector:@selector(imageDownloadFailed:)];
    [asiRequest startAsynchronous];
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
    
    self.currentGender = [[NSUserDefaults standardUserDefaults] stringForKey:@"sportGender"];
    self.currentLink = [self getLink:0];
    [self findPictureLink];
    
    listItems = [[NSArray alloc]initWithObjects:[NSString stringWithFormat:@"%@'s %@", currentGender, sportName], @"News", @"Roster", @"Schedule & Results", nil];
    
    //Table customization
    self.menuList.rowHeight = 63;
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
    [asiRequest cancel];
    [asiRequest release];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

@end
