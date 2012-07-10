//
//  FilterCalendarViewController.h
//  RPIMobile
//
//  Created by Stephen Silber on 7/3/12.
//  Copyright (c) 2012 Rensselaer Polytechnic Institute. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ASIHTTPRequest.h"
#import "ASIDownloadCache.h"

@interface FilterCalendarViewController : UITableViewController <ASIHTTPRequestDelegate> {
    ASIHTTPRequest *jsonRequest;
    NSMutableArray *eventData;
    NSMutableDictionary *feedData;
    NSArray *tableData;
}

@property (nonatomic, retain) NSMutableArray *eventData;
@property (nonatomic, retain) NSMutableDictionary *feedData;

@end
