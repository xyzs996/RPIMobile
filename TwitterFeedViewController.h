//
//  TwitterFeedViewController.h
//  RPIMobile
//
//  Created by Stephen Silber on 7/1/12.
//  Copyright (c) 2012 Rensselaer Polytechnic Institute. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ASIHTTPRequest.h"
#import "XMLReader.h"

@interface TwitterFeedViewController : UITableViewController <ASIHTTPRequestDelegate, NSXMLParserDelegate> {
    NSDictionary *feedDictionary;
    NSMutableArray *newsItems;
    NSArray *sortedItems;
    NSDateFormatter *formatter;
}
@property (nonatomic, retain) NSMutableArray *newsItems;
@property (nonatomic, retain) NSArray *sortedItems;

@end
