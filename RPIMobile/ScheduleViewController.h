//
//  ScheduleViewController.h
//  RPIMobile
//
//  Created by Stephen Silber on 6/23/12.
//  Copyright (c) 2012 Rensselaer Polytechnic Institute. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ASIHTTPRequest.h"
#import "ASIDownloadCache.h"


@interface ScheduleViewController : UITableViewController <ASIHTTPRequestDelegate> {
    
    ASIHTTPRequest *httprequest;
    NSString *scheduleURL;
    NSMutableArray *scheduleData;
}

@property (nonatomic, retain) NSMutableArray *scheduleData;
@property (nonatomic, retain) NSString *scheduleURL;
@property (nonatomic, retain) NSArray* entries;



@end
