//
//  EventParser.h
//  RPIMobile
//
//  Created by Stephen Silber on 7/3/12.
//  Copyright (c) 2012 Rensselaer Polytechnic Institute. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@interface CalendarEntry : NSManagedObject {
    NSDate *eventStartDate;
    NSDate *eventEndDate;  
    
    NSString *startTime;
    NSString *endTime;
    
    int dayOfMonth;
    
    NSString *cost;
    
    BOOL allDay;
    
    NSString *eventSummary;
    NSString *eventDescription;
    
    NSString *eventLink;
    
    NSMutableDictionary *contactInfo;
    NSMutableDictionary *location;
    NSMutableArray *categories;
}

@property (nonatomic, retain) NSDate *eventStartDate, *eventEndDate;
@property (nonatomic, retain) NSString *eventSummary, *eventDescription, *eventLink, *startTime, *endTime, *cost;
@property (nonatomic, retain) NSMutableDictionary *contactInfo, *location;
@property (nonatomic, retain) NSMutableArray *categories;
@property int dayOfMonth;

-(id) initWithDictionary:(NSMutableDictionary *) data;
-(void) setData:(NSMutableDictionary *) data;
@end


