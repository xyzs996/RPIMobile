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

#import "GDataXMLNode.h"
#import "GDataXMLElement-Extras.h"

@interface SportNewsViewController : UITableViewController <ASIHTTPRequestDelegate> {
    NSString *feedURL;
    NSOperationQueue *_queue;
    NSMutableArray *newsItems;

}

@property (nonatomic, retain) NSString *feedURL;
@property (retain) NSOperationQueue *queue;
@property (nonatomic, retain) NSMutableArray *newsItems;

@end
