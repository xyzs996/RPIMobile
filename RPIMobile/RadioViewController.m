//
//  RadioViewController.m
//  RPIMobile
//
//  Created by Stephen Silber on 7/13/12.
//  Copyright (c) 2012 Rensselaer Polytechnic Institute. All rights reserved.
//

#import "RadioViewController.h"
#import "AudioStreamer.h"
#import <QuartzCore/CoreAnimation.h>
#import <MediaPlayer/MediaPlayer.h>
#import <CFNetwork/CFNetwork.h>
#import "BeamMusicPlayerViewController.h"

@implementation RadioViewController

static NSString *streamURL = @"http://icecast1.wrpi.org:8000/mp3-128.mp3";

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    BeamMusicPlayerViewController* controller = [[BeamMusicPlayerViewController alloc] initWithNibName:nil bundle:nil];
    controller.delegate = self;
    [self.navigationController pushViewController:controller animated:NO];
    [controller release];
    // Push the controller or s
}
- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

@end
