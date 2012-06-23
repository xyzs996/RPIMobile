//
//  WeatherViewController.h
//  RPIMobile
//
//  Created by Stephen Silber on 6/21/12.
//  Copyright (c) 2012 Rensselaer Polytechnic Institute. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ASIHTTPRequest.h"
#import "ASIDownloadCache.h"
#import "PrettyKit.h"

@interface WeatherCondition : NSObject {
    NSString *dayOfWeek;
    NSString *tempF;
    NSString *tempC;
    NSString *low;
    NSString *high;
    NSString *iconURL;
    NSString *condition;
    NSString *wind;
    NSString *humidiy;
}
@property (nonatomic, retain) NSString *dayOfWeek, *tempF, *tempC, *low, *high, *iconURL, *condition, *wind, *humidity;
@end



@interface WeatherViewController : UITableViewController <NSXMLParserDelegate> {
    ASIHTTPRequest *weatherRequest;
    NSXMLParser *weatherParser;
    NSMutableDictionary *weatherDic;
    NSMutableArray *weatherArr;
    NSMutableString *currentStringValue;
    WeatherCondition *condition;
}

@end
