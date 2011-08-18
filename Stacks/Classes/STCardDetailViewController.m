//
//  STCardDetailViewController.m
//  Stacks
//
//  Created by Max Luzuriaga on 8/15/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "STCardDetailViewController.h"

#import <QuartzCore/QuartzCore.h>

#import "StacksAppDelegate.h"
#import "STCard.h"

#import "STCardView.h"

@implementation STCardDetailViewController

@synthesize card = _card;

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - Managing the Card view

- (void)setCard:(STCard *)card
{
    if (card != _card) {
        _card = card;
        
        [self configureView];
    }
}

- (void)flip
{
    _flipButton.enabled = NO;
    
    [_cardView flip];
    
    NSString *labelText;
    CGRect shownFrame = _stateLabel.frame;
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

- (void)configureView
{
    if (_card) {
        self.title = _card.frontText;
        
        _cardView.frontText = _card.frontText;
        _cardView.backText = _card.backText;
    }
}

- (void)textViewDidChange:(UITextView *)textView
{
    if (_cardView.state == STCardViewStateFront)
        self.title = textView.text;
}

- (BOOL)textViewShouldEndEditing:(UITextView *)textView
{
    if (_cardView.state == STCardViewStateFront)
        _cardView.frontText = _cardView.textView.text;
    else if (_cardView.state == STCardViewStateBack)
        _cardView.backText = _cardView.textView.text;
    
    return YES;
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.navigationItem.rightBarButtonItem = self.editButtonItem;
    
    _stateLabel = [[UILabel alloc] initWithFrame:CGRectMake(68, 22, 237, 23)];
    _stateLabel.numberOfLines = 0;
    _stateLabel.lineBreakMode = UILineBreakModeWordWrap;
    _stateLabel.textAlignment = UITextAlignmentLeft;
    _stateLabel.clipsToBounds = NO;
    _stateLabel.font = [UIFont fontWithName:@"FreestyleScriptEF-Reg" size:25];
    _stateLabel.textColor = [UIColor whiteColor];
    _stateLabel.backgroundColor = [UIColor clearColor];
    
    [self.view addSubview:_stateLabel];
    
    _flipButton = [[UIButton alloc] initWithFrame:CGRectMake(15, 15, 44, 30)];
    [_flipButton setImage:[UIImage imageNamed:@"flipButton"] forState:UIControlStateNormal];
    [_flipButton setImage:[UIImage imageNamed:@"flipButtonTapped"] forState:UIControlStateHighlighted];
    [_flipButton setImage:[UIImage imageNamed:@"flipButtonTapped"] forState:UIControlStateDisabled];
    [_flipButton addTarget:self action:@selector(flip) forControlEvents:UIControlEventTouchUpInside];
    
    [self.view addSubview:_flipButton];
    
    _cardView = [[STCardView alloc] initWithFrame:CGRectMake(15, 60, 290, CARD_VIEW_SHORT_HEIGHT)];
    _cardView.textView.delegate = self;
    
    [self.view addSubview:_cardView];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    StacksAppDelegate *delegate = (StacksAppDelegate *)[[UIApplication sharedApplication] delegate];
    [delegate hideShadowAtIndex:1];
    
    [self.navigationController setToolbarHidden:YES animated:YES];
    
    _stateLabel.text = NSLocalizedString(@"Front", nil);
    _cardView.state = STCardViewStateFront;
    
    [self configureView];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    StacksAppDelegate *delegate = (StacksAppDelegate *)[[UIApplication sharedApplication] delegate];
    [delegate showShadowAtIndex:1];
    
    [self.navigationController setToolbarHidden:NO animated:YES];
}

- (void)setEditing:(BOOL)editing animated:(BOOL)animated
{
    [super setEditing:editing animated:animated];
    
    if (editing) {
        [self.navigationItem setHidesBackButton:YES animated:YES];
        
        [self.navigationItem.rightBarButtonItem setBackgroundImage:[[UIImage imageNamed:@"barButtonItemHighlightedBackground"] resizableImageWithCapInsets:UIEdgeInsetsMake(0, 6, 0, 6)] forState:UIControlStateNormal barMetrics:UIBarMetricsDefault];
        
        _cardView.editable = YES;
    } else {
        [self.navigationItem setHidesBackButton:NO animated:YES];
        
        [self.navigationItem.rightBarButtonItem setBackgroundImage:[[UIImage imageNamed:@"barButtonItemBackground"] resizableImageWithCapInsets:UIEdgeInsetsMake(0, 6, 0, 6)] forState:UIControlStateNormal barMetrics:UIBarMetricsDefault];
        
        _cardView.editable = NO;
        
        _card.frontText = _cardView.frontText;
        _card.backText = _cardView.backText;
        
        NSManagedObjectContext *context = [(StacksAppDelegate *)[[UIApplication sharedApplication] delegate] managedObjectContext];
        NSError *error = nil;
        if (![context save:&error])
        {
            /*
             Replace this implementation with code to handle the error appropriately.
             
             abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development. If it is not possible to recover from the error, display an alert panel that instructs the user to quit the application by pressing the Home button.
             */
            NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
            abort();
        }
    }
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

@end
