//
//  SportNewsViewController.h
//  RPIMobile
//
//  Created by Stephen Silber on 6/19/12.
//  Copyright (c) 2012 Rensselaer Polytechnic Institute. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ASIHTTPRequest.h"
#import "ASIDownloadCache.h"
#import "MWFeedParser.h"

@interface SportNewsViewController : UITableViewController <ASIHTTPRequestDelegate, MWFeedParserDelegate> {
    MWFeedParser *feedParser;
    NSString *feedURL;
    NSMutableArray *_items;
    
    NSArray *newsItems;
    NSMutableArray *parsedItems;
    NSDateFormatter *formatter;
}

@property (nonatomic, retain) NSMutableArray *items;
@property (nonatomic, retain) NSArray *newsItems;
@end
