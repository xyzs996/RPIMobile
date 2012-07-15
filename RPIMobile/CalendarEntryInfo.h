//
//  CalendarEntryInfo.h
//  RPIMobile
//
//  Created by Stephen Silber on 7/11/12.
//  Copyright (c) 2012 Rensselaer Polytechnic Institute. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class CalendarEntryDetails;

@interface CalendarEntryInfo : NSManagedObject

@property (nonatomic, retain) NSNumber * dayOfMonth;
@property (nonatomic, retain) NSDate * endDate;
@property (nonatomic, retain) NSDate * startDate;
@property (nonatomic, retain) NSString * summary;
@property (nonatomic, retain) CalendarEntryDetails *details;

@end
