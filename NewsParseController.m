//
//  NewsParseController.m
//  RPIMobile
//
//  Created by Stephen Silber on 5/20/12.
//  Copyright (c) 2012 Rensselaer Polytechnic Institute. All rights reserved.
//

#import "NewsParseController.h"

@implementation NewsParseController

- (void) setUp
{    
    NSData *data = [[NSData alloc] initWithContentsOfFile:@"http://news.rpi.edu/update.do?artcenterkey=3043&setappvar=page(1)"];
    doc = [[TFHpple alloc] initWithHTMLData:data];
}


@end
