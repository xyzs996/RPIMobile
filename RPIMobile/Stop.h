//
//  Stop.h
//  Shuttle-Tracker
//
//  Created by Brendon Justin on 11/14/11.
//  Copyright (c) 2011 Brendon Justin. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class ETA, FavoriteStop, Route;

@interface Stop : NSManagedObject

@property (nonatomic, retain) NSString * idTag;
@property (nonatomic, retain) NSNumber * latitude;
@property (nonatomic, retain) NSNumber * longitude;
@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) NSString * shortName;
@property (nonatomic, retain) NSNumber * stopNum;
@property (nonatomic, retain) NSSet *etas;
@property (nonatomic, retain) NSSet *favorites;
@property (nonatomic, retain) NSSet *routes;
@end

@interface Stop (CoreDataGeneratedAccessors)

- (void)addEtasObject:(ETA *)value;
- (void)removeEtasObject:(ETA *)value;
- (void)addEtas:(NSSet *)values;
- (void)removeEtas:(NSSet *)values;

- (void)addFavoritesObject:(FavoriteStop *)value;
- (void)removeFavoritesObject:(FavoriteStop *)value;
- (void)addFavorites:(NSSet *)values;
- (void)removeFavorites:(NSSet *)values;

- (void)addRoutesObject:(Route *)value;
- (void)removeRoutesObject:(Route *)value;
- (void)addRoutes:(NSSet *)values;
- (void)removeRoutes:(NSSet *)values;

@end
