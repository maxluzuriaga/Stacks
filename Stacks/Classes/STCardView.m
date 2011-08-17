//
//  STCardView.m
//  Stacks
//
//  Created by Max Luzuriaga on 8/15/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "STCardView.h"

@implementation STCardView

@synthesize textView = _textView, frontText = _frontText, backText = _backText, state = _state;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        _state = STCardViewStateFront;
        
        _textView = [[UITextView alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height)];
        _textView.font = [UIFont systemFontOfSize:17];
        _textView.editable = NO;
        _textView.backgroundColor = [UIColor clearColor];
        
        [self addSubview:_textView];
        
        _backgroundImage = [[UIImageView alloc] initWithFrame:_textView.frame];
        
        [self addSubview:_backgroundImage];
        [self sendSubviewToBack:_backgroundImage];
        
        if (frame.size.height == CARD_VIEW_SHORT_HEIGHT)
            _backgroundImage.image = [UIImage imageNamed:@"cardViewShortBackground"];
        else if (frame.size.height == CARD_VIEW_TALL_HEIGHT)
            _backgroundImage.image = [UIImage imageNamed:@"cardViewTallBackground"];
    }
    return self;
}

- (void)setFrontText:(NSString *)frontText
{
    if (frontText != _frontText) {
        _frontText = frontText;
        
        if (_state == STCardViewStateFront)
            _textView.text = _frontText;
    }
}

- (void)seBackText:(NSString *)backText
{
    if (backText != _backText) {
        _backText = backText;
        
        if (_state == STCardViewStateBack)
            _textView.text = _backText;
    }
}

- (void)flip {
    [_textView resignFirstResponder];
    
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:0.75];
    [UIView setAnimationDelegate:self];
    [UIView setAnimationDidStopSelector:@selector(transitionDidStop:finished:context:)];
    
    if (_state == STCardViewStateBack) {
        [UIView setAnimationTransition:UIViewAnimationTransitionFlipFromLeft forView:self cache:YES];
        
        _backText = _textView.text;
        _textView.text = _frontText;
        
        _state = STCardViewStateFront;
    } else if (_state == STCardViewStateFront) {
        [UIView setAnimationTransition:UIViewAnimationTransitionFlipFromRight forView:self cache:YES];
        
        _frontText = _textView.text;
        _textView.text = _backText;
        
        _state = STCardViewStateBack;
    }
    
    [UIView commitAnimations];
}

- (void)transitionDidStop:(NSString *)animationID finished:(NSNumber *)finished context:(void *)context {
    if (_textView.editable)
        [_textView becomeFirstResponder];
}

@end
