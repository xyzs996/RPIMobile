//
//  RootViewController.m
//  @rigoneri
//  
//  Copyright 2010 Rodrigo Neri
//  Copyright 2011 David Jarrett
//
//  Licensed under the Apache License, Version 2.0 (the "License");
//  you may not use this file except in compliance with the License.
//  You may obtain a copy of the License at
//
//    http://www.apache.org/licenses/LICENSE-2.0
//
//  Unless required by applicable law or agreed to in writing, software
//  distributed under the License is distributed on an "AS IS" BASIS,
//  WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
//  See the License for the specific language governing permissions and
//  limitations under the License.
//

#import "RootViewController.h"
#import "MyLauncherItem.h"
#import "CustomBadge.h"
#import "ASIHTTPRequest.h"

//Import Views for Launcher - Add header here if you are adding an icon to the launch screen
#import "NewsViewController.h"
#import "DirectorySearchViewController.h"
#import "QRViewController.h"
#import "VideoFeedViewController.h"
#import "AthleticsViewController.h"
#import "WeatherViewController.h"
#import "ShuttleViewController.h"
#import "TwitterFeedViewController.h"
#import "CalendarViewController.h"
#import "RadioViewController.h"


@implementation RootViewController

-(void)loadView
{    
	[super loadView];
    self.title = @"RPI Mobile";
    
    //Add your view controllers here to be picked up by the launcher; remember to import them above
    [[self appControllers] setObject:[NewsViewController class] forKey:@"NewsViewController"];
    [[self appControllers] setObject:[DirectorySearchViewController class] forKey:@"MasterViewController"];
    [[self appControllers] setObject:[QRViewController class] forKey:@"QRViewController"];
    [[self appControllers] setObject:[VideoFeedViewController class] forKey:@"VideoFeedViewController"];
    [[self appControllers] setObject:[AthleticsViewController class] forKey:@"AthleticsViewController"];    
    [[self appControllers] setObject:[WeatherViewController class] forKey:@"WeatherViewController"];
    [[self appControllers] setObject:[ShuttleViewController class] forKey:@"ShuttleViewController"];
    [[self appControllers] setObject:[TwitterFeedViewController class] forKey:@"TwitterFeedViewController"];
    [[self appControllers] setObject:[CalendarViewController class] forKey:@"CalendarViewController"];
    [[self appControllers] setObject:[RadioViewController class] forKey:@"RadioViewController"];
    
	if(![self hasSavedLauncherItems])
	{
		[self.launcherView setPages:[NSMutableArray arrayWithObjects: 
                                     [NSMutableArray arrayWithObjects: 
                                      [[MyLauncherItem alloc] initWithTitle:@"News"
                                                                iPhoneImage:@"news_hdpi" 
                                                                  iPadImage:@"itemImage-iPad"
                                                                     target:@"NewsViewController" 
                                                                targetTitle:@"RPI News"
                                                                  deletable:NO],
                                      [[MyLauncherItem alloc] initWithTitle:@"Athletics"
                                                                iPhoneImage:@"score_hdpi" 
                                                                  iPadImage:@"itemImage-iPad"
                                                                     target:@"AthleticsViewController" 
                                                                targetTitle:@"RPI Athletics" 
                                                                  deletable:NO],
                                      [[MyLauncherItem alloc] initWithTitle:@"Twitter"
                                                                iPhoneImage:@"twitter_hdpi" 
                                                                  iPadImage:@"itemImage-iPad"
                                                                     target:@"TwitterFeedViewController" 
                                                                targetTitle:@"RPI Twitter"
                                                                  deletable:NO],
                                      [[MyLauncherItem alloc] initWithTitle:@"Map"
                                                                iPhoneImage:@"maps_hdpi" 
                                                                  iPadImage:@"itemImage-iPad"
                                                                     target:@"NewsViewController" 
                                                                targetTitle:@"RPI Map"
                                                                  deletable:NO],
                                      [[MyLauncherItem alloc] initWithTitle:@"Events"
                                                                iPhoneImage:@"calendar_hdpi" 
                                                                  iPadImage:@"itemImage-iPad"
                                                                     target:@"CalendarViewController" 
                                                                targetTitle:@"RPI Events"
                                                                  deletable:NO],
                                      [[MyLauncherItem alloc] initWithTitle:@"WRPI"
                                                                iPhoneImage:@"radio_hdpi" 
                                                                  iPadImage:@"itemImage-iPad"
                                                                     target:@"RadioViewController" 
                                                                targetTitle:@"RPI Radio"
                                                                  deletable:NO],
                                      [[MyLauncherItem alloc] initWithTitle:@"Settings"
                                                                iPhoneImage:@"settings_hdpi" 
                                                                  iPadImage:@"itemImage-iPad"
                                                                     target:@"NewsViewController" 
                                                                targetTitle:@"Settings"
                                                                  deletable:NO],
                                      [[MyLauncherItem alloc] initWithTitle:@"TV Listings"
                                                                iPhoneImage:@"rpiTV_hdpi" 
                                                                  iPadImage:@"itemImage-iPad"
                                                                     target:@"NewsViewController" 
                                                                targetTitle:@"RPI TV"
                                                                  deletable:NO],
                                      [[MyLauncherItem alloc] initWithTitle:@"Shuttle Tracker"
                                                                iPhoneImage:@"shuttle_hdpi" 
                                                                  iPadImage:@"itemImage-iPad"
                                                                     target:@"ShuttleViewController" 
                                                                targetTitle:@"RPI Shuttles"
                                                                  deletable:NO],
                                      nil], [NSMutableArray arrayWithObjects:
                                             [[MyLauncherItem alloc] initWithTitle:@"Tour"
                                                                       iPhoneImage:@"compass_hdpi" 
                                                                         iPadImage:@"itemImage-iPad"
                                                                            target:@"NewsViewController" 
                                                                       targetTitle:@"RPI Tour"
                                                                         deletable:NO],
                                             [[MyLauncherItem alloc] initWithTitle:@"Directory"
                                                                       iPhoneImage:@"phonebook_hdpi" 
                                                                         iPadImage:@"itemImage-iPad"
                                                                            target:@"MasterViewController" 
                                                                       targetTitle:@"RPI Directory"
                                                                         deletable:NO],
                                             [[MyLauncherItem alloc] initWithTitle:@"QR Codes"
                                                                       iPhoneImage:@"qr_hdpi" 
                                                                         iPadImage:@"itemImage-iPad"
                                                                            target:@"QRViewController" 
                                                                       targetTitle:@"QR Scanner"
                                                                         deletable:NO],
                                             [[MyLauncherItem alloc] initWithTitle:@"Videos"
                                                                       iPhoneImage:@"youtube_hdpi" 
                                                                         iPadImage:@"itemImage-iPad"
                                                                            target:@"VideoFeedViewController" 
                                                                       targetTitle:@"RPI Videos"
                                                                         deletable:NO],
                                             [[MyLauncherItem alloc] initWithTitle:@"Weather"
                                                                       iPhoneImage:@"weather_hdpi" 
                                                                         iPadImage:@"itemImage-iPad"
                                                                            target:@"WeatherViewController" 
                                                                       targetTitle:@"RPI Weather"
                                                                         deletable:NO], nil],
                                     nil]];
        

        // Set number of immovable items below; only set it when you are setting the pages as the 
        // user may still be able to delete these items and setting this then will cause movable 
        // items to become immovable.
        // [self.launcherView setNumberOfImmovableItems:1];
        
        // Or uncomment the line below to disable editing (moving/deleting) completely!
        // [self.launcherView setEditingAllowed:NO];

	}
    

    
}
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation
{
	//If you don't want to support multiple orientations uncomment the line below
    //return (toInterfaceOrientation == UIInterfaceOrientationPortrait);
	return [super shouldAutorotateToInterfaceOrientation:toInterfaceOrientation];
}

- (void)didReceiveMemoryWarning 
{
    [super didReceiveMemoryWarning];
}

-(void) dealloc {
    [super dealloc];

}
- (void)viewDidUnload 
{
    [super viewDidUnload];
}

@end
