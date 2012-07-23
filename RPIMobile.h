//
//  RPIMobile.h
//  RPIMobile
//
//  Created by Stephen Silber on 7/10/12.
//  Copyright (c) 2012 Rensselaer Polytechnic Institute. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class CalendarEntryInfo;

@interface RPIMobile : NSManagedObject

@property (nonatomic, retain) NSNumber * allDay;
@property (nonatomic, retain) NSData * categories;
@property (nonatomic, retain) NSData * contactInfo;
@property (nonatomic, retain) NSString * cost;
@property (nonatomic, retain) NSString * eventDescription;
@property (nonatomic, retain) NSString * eventLink;
@property (nonatomic, retain) NSData * location;
@property (nonatomic, retain) CalendarEntryInfo *info;

@end
