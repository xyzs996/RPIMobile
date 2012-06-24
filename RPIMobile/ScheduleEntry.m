//
//  ScheduleEntry.m
//  RPIMobile
//
//  Created by Stephen Silber on 6/23/12.
//  Copyright (c) 2012 Rensselaer Polytechnic Institute. All rights reserved.
//

#import "ScheduleEntry.h"

@implementation ScheduleEntry
@synthesize date, location, result;
-(id) initWithDate:(NSString *)d location:(NSString *)l result:(NSString *)r {
    if ((self = [super init])) {
        self.date = d;
        self.location = l;
        self.result = r;
    }
    return self;
}
-(id) initWithArray:(NSArray *)data {
    if((self = [super init])) {
        if([data isKindOfClass:[NSArray class]]) {
            NSLog(@"Data: %@", data);
            if([data count] >= 3) {
                self.date = [data objectAtIndex:0];
                self.location = [data objectAtIndex:1];
                self.result = [data objectAtIndex:2];
            }
        }
    }
    return self;
}
@end
