//
//  RosterViewController.h
//  RPIMobile
//
//  Created by Stephen Silber on 6/18/12.
//  Copyright (c) 2012 Rensselaer Polytechnic Institute. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ASIHTTPRequest.h"
#import "ASIDownloadCache.h"


@interface RosterViewController : UITableViewController <ASIHTTPRequestDelegate> {

    ASIHTTPRequest *httprequest;
    NSString *rosterURL;
    NSMutableArray *athleteData;
}

@property (nonatomic, retain) NSMutableArray *athleteData;
@property (nonatomic, retain) NSString *rosterURL;
@property (nonatomic, retain) NSArray* entries;



@end
