//
//  SportViewController.h
//  RPIMobile
//
//  Created by Stephen Silber on 6/18/12.
//  Copyright (c) 2012 Rensselaer Polytechnic Institute. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ASIHTTPRequest.h"
#import "ASIDownloadCache.h"

@interface SportViewController : UIViewController <UITableViewDataSource, UITableViewDelegate, ASIHTTPRequestDelegate> {
    NSArray *listItems;
    ASIHTTPRequest *asiRequest;
    UITableView *menuList;
    UIImageView *teamPicture;
    UIProgressView *progressBar;
    UILabel *noImage;
    
    NSString *teamPicURL;
    
    NSString *sportName;
    NSString *currentGender;
    NSString *currentLink;
    
    NSMutableArray *links;
}

@property (nonatomic, retain) IBOutlet UITableView *menuList;
@property (nonatomic, retain) IBOutlet UIImageView *teamPicture;
@property (nonatomic, retain) IBOutlet UIProgressView *progressBar;
@property (nonatomic, retain) IBOutlet UILabel *noImage;
@property (nonatomic, retain) NSString *sportName, *currentGender, *currentLink;

@end
