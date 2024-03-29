//
//  EventViewController.h
//  RPIMobile
//
//  Created by Stephen Silber on 7/10/12.
//  Copyright (c) 2012 Rensselaer Polytechnic Institute. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CalendarEntryInfo.h"
#import "CalendarEntryDetails.h"

@interface EventViewController : UITableViewController {
    CalendarEntryInfo *entryInfo;
    CalendarEntryDetails *entryDetails;
}

@property (nonatomic, retain) CalendarEntryInfo *entryInfo;
@property (nonatomic, retain) CalendarEntryDetails *entryDetails;
@end
