//
//  Shuttle.h
//  Shuttle-Tracker
//
//  Created by Brendon Justin on 11/14/11.
//  Copyright (c) 2011 Brendon Justin. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class ETA, Route;

@interface Shuttle : NSManagedObject

@property (nonatomic, retain) NSNumber * heading;
@property (nonatomic, retain) NSNumber * latitude;
@property (nonatomic, retain) NSNumber * longitude;
@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) NSNumber * speed;
@property (nonatomic, retain) NSDate * updateTime;
@property (nonatomic, retain) NSNumber * routeId;
@property (nonatomic, retain) NSSet *eta;
@property (nonatomic, retain) Route *route;
@end

@interface Shuttle (CoreDataGeneratedAccessors)

- (void)addEtaObject:(ETA *)value;
- (void)removeEtaObject:(ETA *)value;
- (void)addEta:(NSSet *)values;
- (void)removeEta:(NSSet *)values;

@end
