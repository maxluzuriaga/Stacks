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
        // Custom initialization
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

/*
// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad
{
    [super viewDidLoad];
}
*/

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
    } else {
        [self.navigationController setToolbarHidden:YES animated:YES];
        [self.navigationController setNavigationBarHidden:YES animated:YES];
        
        [(StacksAppDelegate *)[[UIApplication sharedApplication] delegate] hideShadowAtIndex:0];
        [(StacksAppDelegate *)[[UIApplication sharedApplication] delegate] hideShadowAtIndex:1];
        
        [[UIApplication sharedApplication] setStatusBarHidden:YES];
    }
    
    
    return (interfaceOrientation != UIInterfaceOrientationPortraitUpsideDown);
}

@end
