//
//  STNewCardViewController.m
//  Stacks
//
//  Created by Max Luzuriaga on 10/7/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "STNewCardViewController.h"

#import <QuartzCore/QuartzCore.h>

#import "StacksAppDelegate.h"

#import "STCardView.h"
#import "STLabel.h"

@implementation STNewCardViewController

@synthesize delegate = _delegate;

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.title = NSLocalizedString(@"New Card", nil);
    
    UIImageView *backgroundImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 20, 320, 480)];
    backgroundImageView.image = [UIImage imageNamed:@"backgroundTexture"];
    [self.navigationController.view addSubview:backgroundImageView];
    [self.navigationController.view sendSubviewToBack:backgroundImageView];
    
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCancel target:self action:@selector(cancel)];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(save)];
    [self.navigationItem.rightBarButtonItem setBackgroundImage:[[UIImage imageNamed:@"barButtonItemHighlightedBackground"] resizableImageWithCapInsets:UIEdgeInsetsMake(0, 6, 0, 6)] forState:UIControlStateNormal barMetrics:UIBarMetricsDefault];
    
    _cardStateView = [[STCardStateView alloc] initWithFrame:CGRectMake(15, 15, 290, 30)];
    _cardStateView.delegate = self;
    _cardStateView.state = STCardViewStateFront;
    
    [self.view addSubview:_cardStateView];
    
    [self.navigationItem.rightBarButtonItem setEnabled:NO];
    
    _cardView = [[STCardView alloc] initWithFrame:CGRectMake(15, 60, 290, CARD_VIEW_SHORT_HEIGHT)];
    _cardView.editable = YES;
    _cardView.textView.delegate = self;
    
    [self.view addSubview:_cardView];
    
    UISwipeGestureRecognizer *rightRecognizer = [[UISwipeGestureRecognizer alloc] initWithTarget:_cardStateView action:@selector(flip)];
    rightRecognizer.direction = UISwipeGestureRecognizerDirectionRight;
    rightRecognizer.enabled = NO;
    [self.view addGestureRecognizer:rightRecognizer];
    
    UISwipeGestureRecognizer *leftRecognizer = [[UISwipeGestureRecognizer alloc] initWithTarget:_cardStateView action:@selector(flip)];
    leftRecognizer.direction = UISwipeGestureRecognizerDirectionLeft;
    [self.view addGestureRecognizer:leftRecognizer];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reloadCard:) name:@"RefreshAllViews" object:[[UIApplication sharedApplication] delegate]];
}

#pragma mark - Managing the Card view

- (void)cardStateViewDidChangeToState:(STCardViewState)state
{
    [self flip];
}

- (void)flip
{
    [_cardView flip];
    
    for (UISwipeGestureRecognizer *recognizer in [self.view gestureRecognizers]) {
        recognizer.enabled = NO;
    }
    
    for (UISwipeGestureRecognizer *recognizer in [self.view gestureRecognizers]) {
        if (recognizer.direction == (_cardView.state == STCardViewStateFront ? UISwipeGestureRecognizerDirectionLeft : UISwipeGestureRecognizerDirectionRight))
            recognizer.enabled = YES;
    }
}

#pragma mark - UITextViewDelegate

- (void)textViewDidChange:(UITextView *)textView
{
    BOOL enabled;
    
    if (_cardView.state == STCardViewStateFront)
        enabled = ([textView.text length] != 0) && ([_cardView.backText length] != 0);
    else
        enabled = ([textView.text length] != 0) && ([_cardView.frontText length] != 0);
    
    [self.navigationItem.rightBarButtonItem setEnabled:enabled];
}

- (BOOL)textViewShouldEndEditing:(UITextView *)textView
{
    if (_cardView.state == STCardViewStateFront)
        _cardView.frontText = _cardView.textView.text;
    else if (_cardView.state == STCardViewStateBack)
        _cardView.backText = _cardView.textView.text;
    
    return YES;
}

#pragma mark - Save/Cancel

- (void)save
{
    [self.navigationController dismissModalViewControllerAnimated:YES];
    
    [_delegate newCardViewController:self didSaveWithFrontText:_cardView.frontText backText:_cardView.backText];
}

- (void)cancel
{
    [self.navigationController dismissModalViewControllerAnimated:YES];
}

@end
