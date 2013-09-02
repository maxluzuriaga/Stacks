//
//  STCardStateView.m
//  Stacks
//
//  Created by Max Luzuriaga on 10/31/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "STCardStateView.h"

#import "STLabel.h"
#import "STFlipCardButton.h"

@implementation STCardStateView

@synthesize delegate = _delegate, state = _state;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        _label = [[STLabel alloc] initWithFrame:CGRectMake(53, 7, 237, 23)];
        _label.font = [UIFont fontWithName:@"FreestyleScriptEF-Reg" size:25];
        
        [self addSubview:_label];
                
        _flipButton = [[STFlipCardButton alloc] initWithFrame:CGRectMake(0, 0, 44, 30)];
        [_flipButton addTarget:self action:@selector(flip) forControlEvents:UIControlEventTouchUpInside];
        
        [self addSubview:_flipButton];
    }
    return self;
}

- (void)setState:(STCardViewState)state
{
    _state = state;
    
    switch (_state) {
        case STCardViewStateFront:
            _label.text = NSLocalizedString(@"Front", nil);
            break;
        
        case STCardViewStateBack:
            _label.text = NSLocalizedString(@"Back", nil);
            break;
            
        default:
            break;
    }
}

- (void)flip
{
    _flipButton.enabled = NO;
    
    CGRect shownFrame = CGRectMake(53, _label.frame.origin.y, _label.frame.size.width, _label.frame.size.height);
    CGRect hiddenFrame = CGRectMake(0, _label.frame.origin.y, _label.frame.size.width, _label.frame.size.height);
    
    [UIView animateWithDuration:0.25 animations:^(void) {
        _label.alpha = 0.0;
        _label.frame = hiddenFrame;
    } completion:^(BOOL finished) {
        switch (_state) {
            case STCardViewStateFront:
                self.state = STCardViewStateBack;
                break;
                
            case STCardViewStateBack:
                self.state = STCardViewStateFront;
                break;
                
            default:
                break;
        }
        [UIView animateWithDuration:0.5 animations:^(void) {
            _label.alpha = 1.0;
            _label.frame = shownFrame;
        } completion:^(BOOL finished) {
            _flipButton.enabled = YES;
        }];
    }];
    
    [_delegate cardStateViewDidChangeToState:_state];
}

@end
