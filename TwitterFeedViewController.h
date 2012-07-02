//
//  TwitterFeedViewController.h
//  RPIMobile
//
//  Created by Stephen Silber on 7/1/12.
//  Copyright (c) 2012 Rensselaer Polytechnic Institute. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MWFeedParser.h"
@interface TwitterFeedViewController : UITableViewController <MWFeedParserDelegate> {
    MWFeedParser *feedParser;
    NSMutableArray *feedItems;
    NSArray *newsItems;
    NSDateFormatter *formatter;
}

@property (nonatomic, retain) NSArray *newsItems;

@end
