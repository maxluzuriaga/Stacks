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
    
    UIImageView *backgroundImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 20, 320, 480)];
    backgroundImageView.image = [UIImage imageNamed:@"backgroundTexture"];
    [self.navigationController.view addSubview:backgroundImageView];
    [self.navigationController.view sendSubviewToBack:backgroundImageView];
    
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCancel target:self action:@selector(cancel)];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(save)];
    [self.navigationItem.rightBarButtonItem setBackgroundImage:[[UIImage imageNamed:@"barButtonItemHighlightedBackground"] resizableImageWithCapInsets:UIEdgeInsetsMake(0, 6, 0, 6)] forState:UIControlStateNormal barMetrics:UIBarMetricsDefault];
    
    [self.navigationItem.rightBarButtonItem setEnabled:NO];
    
    _stateLabel = [[STLabel alloc] initWithFrame:CGRectMake(68, 22, 237, 23)];
    _stateLabel.font = [UIFont fontWithName:@"FreestyleScriptEF-Reg" size:25];
    _stateLabel.text = NSLocalizedString(@"Front", nil);
    
    [self.view addSubview:_stateLabel];
    
    _flipButton = [[UIButton alloc] initWithFrame:CGRectMake(15, 15, 44, 30)];
    [_flipButton setImage:[UIImage imageNamed:@"flipButton"] forState:UIControlStateNormal];
    [_flipButton setImage:[UIImage imageNamed:@"flipButtonTapped"] forState:UIControlStateHighlighted];
    [_flipButton setImage:[UIImage imageNamed:@"flipButtonTapped"] forState:UIControlStateDisabled];
    [_flipButton addTarget:self action:@selector(flip) forControlEvents:UIControlEventTouchUpInside];
    
    [self.view addSubview:_flipButton];
    
    _cardView = [[STCardView alloc] initWithFrame:CGRectMake(15, 60, 290, CARD_VIEW_SHORT_HEIGHT)];
    _cardView.editable = YES;
    _cardView.textView.delegate = self;
    
    [self.view addSubview:_cardView];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reloadCard:) name:@"RefreshAllViews" object:[[UIApplication sharedApplication] delegate]];
}

#pragma mark - Managing the Card view

- (void)flip
{
    _flipButton.enabled = NO;
    
    [_cardView flip];
    
    NSString *labelText;
    CGRect shownFrame = CGRectMake(68, _stateLabel.frame.origin.y, _stateLabel.frame.size.width, _stateLabel.frame.size.height);
    CGRect hiddenFrame = CGRectMake(15, _stateLabel.frame.origin.y, _stateLabel.frame.size.width, _stateLabel.frame.size.height);
    
    switch (_cardView.state) {
        case STCardViewStateFront:
            labelText = NSLocalizedString(@"Front", nil);
            break;
            
        case STCardViewStateBack:
            labelText = NSLocalizedString(@"Back", nil);
            break;
            
        default:
            break;
    }
    
    [UIView animateWithDuration:0.25 animations:^(void) {
        _stateLabel.alpha = 0.0;
        _stateLabel.frame = hiddenFrame;
    } completion:^(BOOL finished) {
        _stateLabel.text = labelText;
        [UIView animateWithDuration:0.5 animations:^(void) {
            _stateLabel.alpha = 1.0;
            _stateLabel.frame = shownFrame;
        } completion:^(BOOL finished) {
            _flipButton.enabled = YES;
        }];
    }];
}

#pragma mark - UITextViewDelegate

- (void)textViewDidChange:(UITextView *)textView
{
    if (_cardView.state == STCardViewStateFront)
        self.title = textView.text;
    
    BOOL enabled;
    
    if (_cardView.state == STCardViewStateFront)
        enabled = [textView.text length] != 0;
    else
        enabled = [_cardView.frontText length] != 0;
    
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
