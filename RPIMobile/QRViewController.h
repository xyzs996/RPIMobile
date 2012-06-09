//
//  QRViewController.h
//  RPIMobile
//
//  Created by Stephen Silber on 6/7/12.
//  Copyright (c) 2012 Rensselaer Polytechnic Institute. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AudioToolbox/AudioToolbox.h>
#import "ZBarSDK.h"
@interface QRViewController : UIViewController <ZBarReaderDelegate> {
    UITextView *resultText;
    UIImageView *resultImage;
}
@property (nonatomic, retain) IBOutlet UITextView *resultText;
@property (nonatomic, retain) IBOutlet UIImageView *resultImage;
-(IBAction) scanButtonTapped;

@end
