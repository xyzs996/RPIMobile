//
//  Post.h
//  RPIMobile
//
//  Created by Stephen Silber on 6/21/12.
//  Copyright (c) 2012 Rensselaer Polytechnic Institute. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Post : NSObject {
    BOOL isRead;
    NSString *title;
    NSString *description;
    NSString *guid;
}
