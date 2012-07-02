//
//  MasterViewController.h
//  RPI Directory
//
//  Created by Brendon Justin on 4/13/12.
//  Copyright (c) 2012 Brendon Justin. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ASIHTTPRequest.h"
#import "MBProgressHUD.h"

@class DirectoryDetailViewController;

@interface DirectorySearchViewController : UIViewController <UITableViewDataSource, UITableViewDelegate,UISearchDisplayDelegate, UISearchBarDelegate, ASIHTTPRequestDelegate, MBProgressHUDDelegate> {
    IBOutlet UISearchBar *PersonSearchBar;
    IBOutlet UITableView *resultsTableView;
    MBProgressHUD *HUD;
}
@property (nonatomic, retain) IBOutlet UISearchBar *PersonSearchBar;
@property (strong, nonatomic) DirectoryDetailViewController *detailViewController;
@property (nonatomic, retain) IBOutlet UITableView *resultsTableView;
@end
