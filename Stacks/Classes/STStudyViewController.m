//
//  STStudyViewController.m
//  Stacks
//
//  Created by Max Luzuriaga on 10/23/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "STStudyViewController.h"

#import <QuartzCore/QuartzCore.h>

#import "StacksAppDelegate.h"
#import "STStack.h"
#import "STCard.h"

#import "STCardView.h"
#import "STLabel.h"

@implementation STStudyViewController

@synthesize stack;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        
    }
    return self;
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

/*
// Implement loadView to create a view hierarchy programmatically, without using a nib.
- (void)loadView
{
}
*/

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.title = NSLocalizedString(@"Study", nil);
    
    _rotatePrompt = [[UIView alloc] initWithFrame:CGRectMake(0, 130, 145, 140)];
    
    UIImageView *rotateImage = [[UIImageView alloc] initWithFrame:CGRectMake(40, 0, 56, 31)];
    rotateImage.image = [UIImage imageNamed:@"studyViewArrow"];
    [_rotatePrompt addSubview:rotateImage];
    
    UIWebView *rotateText = [[UIWebView alloc] initWithFrame:CGRectMake(15, 50, 145, 84)];
    rotateText.userInteractionEnabled = NO;
    rotateText.clipsToBounds = NO;
    rotateText.backgroundColor = [UIColor clearColor];
    rotateText.opaque = NO;
    
    NSString *css = @"* { margin: 0; padding: 0; font-weight: normal; } p { font-size: 30px; color: #9c9c9c; text-shadow: 0px -1px 0 #000; font-family: FreestyleScriptEF-Reg, Helvetica, sans-serif; line-height: 32px; }";;
    NSString *html = [NSString stringWithFormat:@"<style>%@</style><p>%@</p>", css, NSLocalizedString(@"Rotate your device to begin.", nil)];
    
    [rotateText loadHTMLString:html baseURL:nil];
    [_rotatePrompt addSubview:rotateText];
    
    [self.view addSubview:_rotatePrompt];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    if (interfaceOrientation == UIInterfaceOrientationPortrait) {
        [self.navigationController setToolbarHidden:NO animated:YES];
        [self.navigationController setNavigationBarHidden:NO animated:YES];
        
        [(StacksAppDelegate *)[[UIApplication sharedApplication] delegate] showShadowAtIndex:0];
        [(StacksAppDelegate *)[[UIApplication sharedApplication] delegate] showShadowAtIndex:1];
        
        [[UIApplication sharedApplication] setStatusBarHidden:NO];
        
        self.view.backgroundColor = nil;
    } else if (interfaceOrientation != UIInterfaceOrientationPortraitUpsideDown) {
        [self.navigationController setToolbarHidden:YES animated:YES];
        [self.navigationController setNavigationBarHidden:YES animated:YES];
        
        [(StacksAppDelegate *)[[UIApplication sharedApplication] delegate] hideShadowAtIndex:0];
        [(StacksAppDelegate *)[[UIApplication sharedApplication] delegate] hideShadowAtIndex:1];
        
        [[UIApplication sharedApplication] setStatusBarHidden:YES];
        
        self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"studyViewBackground"]];
    }
    
    
    return (interfaceOrientation != UIInterfaceOrientationPortraitUpsideDown);
}

@end
