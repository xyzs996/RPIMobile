//
//  AthleticsViewController.h
//  RPIMobile
//
//  Created by Stephen Silber on 6/18/12.
//  Copyright (c) 2012 Rensselaer Polytechnic Institute. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AthleticsViewController : UIViewController <UITableViewDelegate, UITableViewDataSource> {
    UITableView *sportsList;
    NSMutableDictionary *sports;
    NSArray *sportsArr;
}

@property (nonatomic, retain) IBOutlet UITableView *sportsList;

@end
