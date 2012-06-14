//
//  VideoFeedViewController.h
//  RPIMobile
//
//  Created by Stephen Silber on 6/12/12.
//  Copyright (c) 2012 Rensselaer Polytechnic Institute. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MWFeedParser.h"

@interface VideoFeedViewController : UIViewController <UITableViewDelegate, UITableViewDataSource, MWFeedParserDelegate> {
    NSMutableDictionary *newsFeeds;
    MWFeedParser *feedParser;
    UIImage *launcherImage;
    IBOutlet UITableView *newsTable;
    NSMutableArray *_items;
    NSArray *newsItems;
    NSMutableArray *parsedItems;
    NSDateFormatter *formatter;
}

@property (nonatomic, retain) IBOutlet UITableView *newsTable;
@property (nonatomic, retain) NSMutableArray *items;
@property (nonatomic, retain) NSArray *newsItems;
@property (nonatomic, assign) UIImage *launcherImage;

@end
