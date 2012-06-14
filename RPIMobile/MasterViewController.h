//
//  MasterViewController.h
//  RPI Directory
//
//  Created by Brendon Justin on 4/13/12.
//  Copyright (c) 2012 Brendon Justin. All rights reserved.
//

#import <UIKit/UIKit.h>

@class DetailViewController;

@interface MasterViewController : UIViewController <UITableViewDataSource, UITableViewDelegate,UISearchDisplayDelegate, UISearchBarDelegate> {
    IBOutlet UISearchBar *PersonSearchBar;
    IBOutlet UITableView *resultsTableView;
}
@property (nonatomic, retain) IBOutlet UISearchBar *PersonSearchBar;
@property (strong, nonatomic) DetailViewController *detailViewController;
@property (nonatomic, retain) IBOutlet UITableView *resultsTableView;
@end
