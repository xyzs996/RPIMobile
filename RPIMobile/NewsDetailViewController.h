//
//  NewsDetailViewController.h
//  RPIMobile
//
//  Created by Stephen Silber on 5/20/12.
//  Copyright (c) 2012 Rensselaer Polytechnic Institute. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PrettyKit.h"

@interface NewsDetailViewController : UIViewController <UITextViewDelegate> {
    IBOutlet UILabel *dateLabel, *titleLabel;
    IBOutlet UITextView *articleText;
    IBOutlet PrettyToolbar *newsBar;
    NSString *storyURL;
}

@property (nonatomic, assign) IBOutlet UILabel *dateLabel, *titleLabel;
@property (nonatomic, assign) IBOutlet UITextView *articleText;
@property (nonatomic, retain) NSString *storyURL;
@property (nonatomic, assign) IBOutlet PrettyToolbar *newsBar;

-(void) setTitleText:(NSString *)titleText date:(NSString *)dateText content:(NSString *)contentText url:(NSString *)urlText;

@end


