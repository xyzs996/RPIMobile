//
//  SportViewController.h
//  RPIMobile
//
//  Created by Stephen Silber on 6/18/12.
//  Copyright (c) 2012 Rensselaer Polytechnic Institute. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SportViewController : UIViewController <UITableViewDataSource, UITableViewDelegate> {
    NSArray *listItems;
    UITableView *menuList;
    NSString *sportName;
    NSString *currentGender;
    NSString *currentLink;
}

@property (nonatomic, retain) IBOutlet UITableView *menuList;
@property (nonatomic, retain) NSString *sportName;

@end
