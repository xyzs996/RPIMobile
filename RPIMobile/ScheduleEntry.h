//
//  ScheduleEntry.h
//  RPIMobile
//
//  Created by Stephen Silber on 6/23/12.
//  Copyright (c) 2012 Rensselaer Polytechnic Institute. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ScheduleEntry : NSObject {
    NSString *date;
    NSString *location;
    NSString *result;
}

@property (nonatomic, retain) NSString *result, *location, *date;

-(id) initWithDate:(NSString *)d location:(NSString *)l result:(NSString *)r;
-(id) initWithArray:(NSArray *)data;
@end
