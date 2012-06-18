//
//  RosterViewController.h
//  RPIMobile
//
//  Created by Stephen Silber on 6/18/12.
//  Copyright (c) 2012 Rensselaer Polytechnic Institute. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RosterViewController : UIViewController <UITableViewDelegate, UITableViewDataSource> {
    UIImageView *teamPicture;
    UITableView *rosterTable;
}

@property (nonatomic, retain) IBOutlet UIImageView *teamPicture;
@property (nonatomic, retain) IBOutlet UITableView *rosterTable;


@end
