//
//  RadioViewController.h
//  RPIMobile
//
//  Created by Stephen Silber on 7/13/12.
//  Copyright (c) 2012 Rensselaer Polytechnic Institute. All rights reserved.
//

#import <UIKit/UIKit.h>

@class AudioStreamer;
@interface RadioViewController : UIViewController {
    AudioStreamer *streamer;
    NSTimer *progressUpdateTimer;
}

@end
