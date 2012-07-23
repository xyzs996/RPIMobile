//
//  NewsViewController.h
//  RPIMobile
//
//  Created by Stephen Silber on 5/20/12.
//  Copyright (c) 2012 Rensselaer Polytechnic Institute. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MWFeedParser.h"
#import "MKHorizMenu.h"

@interface NewsViewController : UIViewController <MWFeedParserDelegate, MKHorizMenuDataSource, MKHorizMenuDelegate, UITableViewDelegate, UITableViewDataSource> {
    NSMutableDictionary *newsFeeds;
    MWFeedParser *feedParser;
    UIImage *launcherImage;
    IBOutlet UITableView *newsTable;
    
    MKHorizMenu *_horizMenu;
    NSMutableArray *_items;
    
    NSArray *newsItems;
    NSMutableArray *parsedItems;
    NSDateFormatter *formatter;
    
    NSArray *entries;
}

@property (nonatomic, retain) IBOutlet MKHorizMenu *horizMenu;
@property (nonatomic, retain) IBOutlet UITableView *newsTable;
@property (nonatomic, retain) NSMutableArray *items;
@property (nonatomic, retain) NSArray *newsItems;
@property (nonatomic, assign) UIImage *launcherImage;

@end
