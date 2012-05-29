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
#import <RestKit/RestKit.h>

@class MyLauncherViewController;

@interface AppDelegate : NSObject <UIApplicationDelegate> {
    UIWindow *window;
    PrettyNavigationController *navigationController;
}

@property (strong, nonatomic) UIWindow *window;
@property (strong, nonatomic) PrettyNavigationController *navigationController;

@end
