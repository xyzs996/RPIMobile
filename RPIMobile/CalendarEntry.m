//
//  EventParser.m
//  RPIMobile
//
//  Created by Stephen Silber on 7/3/12.
//  Copyright (c) 2012 Rensselaer Polytechnic Institute. All rights reserved.
//

#import "CalendarEntry.h"

@implementation CalendarEntry

@synthesize eventLink, eventEndDate, eventSummary, eventStartDate, eventDescription, contactInfo, location, categories, startTime, endTime, cost, dayOfMonth;

-(id) initWithDictionary:(NSMutableDictionary *) data {
    if((self = [super init])) {
        
        self.startTime = [[data objectForKey:@"start"] objectForKey:@"time"];
        self.endTime = [[data objectForKey:@"end"] objectForKey:@"time"];
        
        self.eventSummary = [data objectForKey:@"summary"];
        self.eventDescription = [data objectForKey:@"description"];
        
        self.cost = [data objectForKey:@"cost"];
        
        self.contactInfo = [data objectForKey:@"contact"];
        self.location = [data objectForKey:@"location"];
        self.categories = [data objectForKey:@"categories"];
        
        
        if([[[data objectForKey:@"start"] objectForKey:@"allday"] isEqualToString:@"true"])
            allDay = YES;
        
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        [formatter setLocale:[[NSLocale alloc] initWithLocaleIdentifier:@"en_US"]];
        [formatter setDateFormat:@"LL/d/yy"];
        
        self.eventStartDate = [formatter dateFromString:[[data objectForKey:@"start"] objectForKey:@"shortdate"]];
        self.eventEndDate = [formatter dateFromString:[[data objectForKey:@"end"] objectForKey:@"shortdate"]];
        
        [formatter setDateFormat:@"d"];
        
        dayOfMonth = [[formatter stringFromDate:self.eventStartDate] intValue];
        
        [formatter release];
        
        
    }
    
    return self;
}

-(void) setData:(NSMutableDictionary *) data {
    self.startTime = [[data objectForKey:@"start"] objectForKey:@"time"];
    self.endTime = [[data objectForKey:@"end"] objectForKey:@"time"];
    
    self.eventSummary = [data objectForKey:@"summary"];
    self.eventDescription = [data objectForKey:@"description"];
    
    self.cost = [data objectForKey:@"cost"];
    
    self.contactInfo = [data objectForKey:@"contact"];
    self.location = [data objectForKey:@"location"];
    self.categories = [data objectForKey:@"categories"];
    
    
    if([[[data objectForKey:@"start"] objectForKey:@"allday"] isEqualToString:@"true"])
        allDay = YES;
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setLocale:[[NSLocale alloc] initWithLocaleIdentifier:@"en_US"]];
    [formatter setDateFormat:@"LL/d/yy"];
    
    self.eventStartDate = [formatter dateFromString:[[data objectForKey:@"start"] objectForKey:@"shortdate"]];
    self.eventEndDate = [formatter dateFromString:[[data objectForKey:@"end"] objectForKey:@"shortdate"]];
    
    [formatter setDateFormat:@"d"];
    
    dayOfMonth = [[formatter stringFromDate:self.eventStartDate] intValue];
    
    [formatter release];
}

@end
