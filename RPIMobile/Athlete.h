//
//  Athlete.h
//  RPIMobile
//
//  Created by Stephen Silber on 6/18/12.
//  Copyright (c) 2012 Rensselaer Polytechnic Institute. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface Athlete : NSObject {
    NSString *name;
    NSString *hometown;
    NSString *profileURL;
    NSString *imageURL;
}

@property (nonatomic, retain) NSString *name, *hometown, *profileURL, *imageURL;

-(id) initWithArray:(NSArray *) data;
-(id) initWithName:(NSString *)aName hometown:(NSString *)aHometown imageURL:(NSString *)imgURL profileURL:(NSString *)profURL;

@end
