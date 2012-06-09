//
//  NewsDetailViewController.m
//  RPIMobile
//
//  Created by Stephen Silber on 5/20/12.
//  Copyright (c) 2012 Rensselaer Polytechnic Institute. All rights reserved.
//

#import "NewsDetailViewController.h"
#import "PrettyKit.h"


@implementation NewsDetailViewController
@synthesize articleText, titleLabel, dateLabel, storyURL, newsBar;
@synthesize storyView;


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

-(void) webViewDidFinishLoad:(UIWebView *)webView {
    NSLog(@"CURRENT WEBVIEW URL: %@", [self.storyView request]);
// NSString *readScript = @"javascript:function(){window.resizeTo(320,480)};);";
    
    
//    [storyView stringByEvaluatingJavaScriptFromString:readScript];
}
-(IBAction)showCurrentURL:(id)sender {
    NSLog(@"CURRENT WEBVIEW URL: %@", [self.storyView request]);
    NSString *readScript = @"javascript:(function(){var script = document.createElement(\"script\");script.src = \"http://ajax.googleapis.com/ajax/libs/jquery/1/jquery.min.js\";script.onload = script.onreadystatechange = function(){$('.contentinfo').remove();};document.body.appendChild( script );})();";
    
    
    [storyView stringByEvaluatingJavaScriptFromString:readScript];
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

-(void) setTitleText:(NSString *)titleText date:(NSString *)dateText content:(NSString *)contentText url:(NSString *)urlText {
    [self.titleLabel setText:titleText];
    [self.dateLabel setText:dateText];
    [self.articleText setText:contentText];

    NSLog(@"Set up view with %@", titleText);
    NSLog(@"UILabel text: %@", titleLabel.text);
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.newsBar.topLineColor =  [UIColor colorWithHex:0xFF1000];
    self.newsBar.gradientStartColor = [UIColor colorWithHex:0xDD0000];
    self.newsBar.gradientEndColor = [UIColor colorWithHex:0xAA0000];    
    self.newsBar.bottomLineColor = [UIColor colorWithHex:0x990000];   
    self.newsBar.tintColor = self.newsBar.gradientEndColor;


}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
}

- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

@end
