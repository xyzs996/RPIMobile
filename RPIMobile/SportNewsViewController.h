//
//  SportNewsViewController.h
//  RPIMobile
//
//  Created by Stephen Silber on 6/21/12.
//  Copyright (c) 2012 Rensselaer Polytechnic Institute. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ASIHTTPRequest.h"
#import "ASIDownloadCache.h"
#import "PrettyKit.h"
#import "MWFeedParser.h"

@interface SportNewsViewController : UITableViewController <ASIHTTPRequestDelegate, MWFeedParserDelegate> {
    MWFeedParser *feedParser;
    NSString *feedURL;
    
    NSArray *newsItems;
    NSMutableArray *parsedItems;
    NSDateFormatter *formatter;
    
    NSArray *entries;
}
@property (nonatomic, retain) NSString *feedURL;
@property (nonatomic, retain) NSArray *newsItems;


@end
