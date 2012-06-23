//
//  Athlete.m
//  RPIMobile
//
//  Created by Stephen Silber on 6/18/12.
//  Copyright (c) 2012 Rensselaer Polytechnic Institute. All rights reserved.
//

#import "Athlete.h"

@implementation Athlete 
@synthesize name, hometown, imageURL, profileURL;

-(id) initWithName:(NSString *)aName hometown:(NSString *)aHometown imageURL:(NSString *)imgURL profileURL:(NSString *)profURL {
    self.name = aName;
    self.hometown = aHometown;
    self.imageURL = imgURL;
    self.profileURL = profURL;
    
    return self;
}

-(id) initWithArray:(NSArray *) data {
    if([data count] == 4) {
        self.name = [data objectAtIndex:0];
        self.profileURL = [data objectAtIndex:1];
        self.imageURL = [data objectAtIndex:2];
        self.hometown = [data objectAtIndex:3];
        
    } else {
        NSLog(@"ERROR: Invalid array passed into athlete");
        return NULL;
    }
    
    return self;
}
@end
