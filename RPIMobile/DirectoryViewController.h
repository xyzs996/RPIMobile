//
//  MasterViewController.h
//  RPI Directory
//
//  Created by Brendon Justin on 4/13/12.
//  Copyright (c) 2012 Brendon Justin. All rights reserved.
//

#import <UIKit/UIKit.h>

@class DirectoryDetailViewController;

@interface DirectoryViewController : UIViewController <UISearchDisplayDelegate, UISearchBarDelegate> {
    IBOutlet UITableView *directoryTable;
}

@property (strong, nonatomic) DirectoryDetailViewController *detailViewController;
@property (strong, nonatomic) IBOutlet UITableView *directoryTable;
@end
