//
//  AppDelegate.h
//  RPIMobile
//
//  Created by Stephen Silber on 5/20/12.
//  Copyright (c) 2012 Rensselaer Polytechnic Institute. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RootViewController.h"
#import "PrettyNavigationController.h"

@class MyLauncherViewController;
@class DataManager;

@interface AppDelegate : NSObject <UIApplicationDelegate> {

    NSManagedObjectModel *managedObjectModel;
    NSManagedObjectContext *managedObjectContext;
    NSPersistentStoreCoordinator *persistentStoreCoordinator;
    
    UIWindow *window;
    PrettyNavigationController *navigationController;
}

@property (strong, nonatomic) UIWindow *window;
@property (strong, nonatomic) PrettyNavigationController *navigationController;

@property (nonatomic, retain, readonly) NSManagedObjectModel *managedObjectModel;
@property (nonatomic, retain, readonly) NSManagedObjectContext *managedObjectContext;
@property (nonatomic, retain, readonly) NSPersistentStoreCoordinator *persistentStoreCoordinator;

//Shuttle Tracker
@property (strong, nonatomic) DataManager *dataManager;
@property (strong, nonatomic) NSDateFormatter *timeDisplayFormatter;
@property (strong, nonatomic) NSTimer *dataUpdateTimer;


- (NSString *)applicationDocumentsDirectory;

@end
    