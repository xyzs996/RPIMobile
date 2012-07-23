//
//  AppDelegate.m
//  RPIMobile
//
//  Created by Stephen Silber on 5/20/12.
//  Copyright (c) 2012 Rensselaer Polytechnic Institute. All rights reserved.
//

#import "AppDelegate.h"
#import <CoreData/CoreData.h>
#import "ASIHTTPRequest.h"
#import "ASIDownloadCache.h"

//Shuttle Tracker
#import "DataManager.h"

@implementation AppDelegate



@synthesize window, navigationController, managedObjectModel, managedObjectContext, persistentStoreCoordinator;

//Shuttle Tracker
@synthesize dataManager = _dataManager;
@synthesize timeDisplayFormatter = _timeDisplayFormatter;
@synthesize dataUpdateTimer = _dataUpdateTimer;

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{

    window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    if (!window)
    {
        return NO;
    }
    window.backgroundColor = [UIColor blackColor];
    
    [ASIHTTPRequest setDefaultCache:[ASIDownloadCache sharedCache]];
    
	navigationController = [[PrettyNavigationController alloc] initWithRootViewController:[[RootViewController alloc] init]];
	
    [window addSubview:navigationController.view];
    [window makeKeyAndVisible];
    [window layoutSubviews];   
    
    //Added support for RPI Shuttle Tracker below
    // Override point for customization after application launch.
    DataManager *dataManager = [[DataManager alloc] init];
    self.dataManager = dataManager;
    [dataManager release];
    [self.dataManager setParserManagedObjectContext:self.managedObjectContext];
    
    //	dataManager creates a timeDisplayFormatter in its init method, so get
    //	a reference to it.
    self.timeDisplayFormatter = self.dataManager.timeDisplayFormatter;
    
    // Check if 12 or 24 hour mode
    BOOL use24Time = NO;
    
    NSDateFormatter *timeFormatter = [[NSDateFormatter alloc] init];
    [timeFormatter setTimeStyle:NSDateFormatterMediumStyle];
    
    NSMutableArray *dateArray = [[NSMutableArray alloc] init];
    [dateArray setArray:[[timeFormatter stringFromDate:[NSDate date]] componentsSeparatedByString:@" "]];
    
    if ([dateArray count] == 1) // if no am/pm extension exists
        use24Time = YES;
    
    [timeFormatter release];
    [dateArray release];
    
    // Set the application defaults
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSDictionary *appDefaults;
    appDefaults = [NSDictionary dictionaryWithObjects:[NSArray arrayWithObjects:use24Time ? @"YES" : @"NO", 
                                                       @"NO", @"YES", [NSNumber numberWithInt:5], @"NO", nil]
                                              forKeys:[NSArray arrayWithObjects:@"use24Time", 
                                                       @"useLocation", @"findClosestStop", 
                                                       @"dataUpdateInterval", @"useRelativeTimes", nil]];
    [defaults registerDefaults:appDefaults];
    [defaults synchronize];
    
    [[NSNotificationCenter defaultCenter] addObserver:self 
                                             selector:@selector(changeDataUpdateRate:)
                                                 name:@"dataUpdateInterval"
                                               object:nil];
    
	float updateInterval = [[defaults objectForKey:@"dataUpdateInterval"] floatValue];
	
	//	Schedule a timer to make the DataManager pull new data every 5 seconds
    self.dataUpdateTimer = [NSTimer scheduledTimerWithTimeInterval:updateInterval 
                                                            target:self.dataManager 
                                                          selector:@selector(updateData) 
                                                          userInfo:nil 
                                                           repeats:YES];

    
    return YES;
}

//Explicitly write Core Data accessors
- (NSManagedObjectContext *) managedObjectContext {
    if (managedObjectContext != nil) {
        return managedObjectContext;
    }
    NSPersistentStoreCoordinator *coordinator = [self persistentStoreCoordinator];
    if (coordinator != nil) {
        managedObjectContext = [[NSManagedObjectContext alloc] init];
        [managedObjectContext setPersistentStoreCoordinator: coordinator];
    }
    
    return managedObjectContext;
}

- (NSManagedObjectModel *)managedObjectModel {
    if (managedObjectModel != nil) {
        return managedObjectModel;
    }
    managedObjectModel = [[NSManagedObjectModel mergedModelFromBundles:nil] retain];
    
    return managedObjectModel;
}
/**
 Returns the persistent store coordinator for the application.
 If the coordinator doesn't already exist, it is created and the application's store added to it.
 */
- (NSPersistentStoreCoordinator *)persistentStoreCoordinator {
	
    if (persistentStoreCoordinator != nil) {
        return persistentStoreCoordinator;
    }
	
    NSURL *storeUrl = [NSURL fileURLWithPath: [[self applicationDocumentsDirectory] stringByAppendingPathComponent: @"database.sqlite"]];
	
    NSError *error = nil;
    persistentStoreCoordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel: [self managedObjectModel]];
    if (![persistentStoreCoordinator addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:storeUrl options:nil error:&error]) {
        // Handle error
    }    
	
    return persistentStoreCoordinator;
}
- (NSString *)applicationDocumentsDirectory {
    return [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
}


- (void)dealloc {
    [super dealloc];
    [managedObjectContext release];
    [managedObjectModel release];
    [persistentStoreCoordinator release];
}

/*
- (void)applicationDidFinishLaunching:(UIApplication*)application 
{
	window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    if (!window)
    {
        return;
    }
    window.backgroundColor = [UIColor blackColor];
    
    [ASIHTTPRequest setDefaultCache:[ASIDownloadCache sharedCache]];

	navigationController = [[PrettyNavigationController alloc] initWithRootViewController:
							[[RootViewController alloc] init]];
//	navigationController.navigationBar.tintColor = COLOR(2, 100, 162);
	
    [window addSubview:navigationController.view];
    [window makeKeyAndVisible];
    [window layoutSubviews];    
} */

- (void)applicationWillResignActive:(UIApplication *)application
{
    /*
     Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
     Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
     */
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    /*
     Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
     If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
     */
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    /*
     Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
     */
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    /*
     Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
     */
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    /*
     Called when the application is about to terminate.
     Save data if appropriate.
     See also applicationDidEnterBackground:.
     */
}

@end
