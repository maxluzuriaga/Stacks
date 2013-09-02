//
//  STFlipCardButton.m
//  Stacks
//
//  Created by Max Luzuriaga on 12/19/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "STFlipCardButton.h"

@implementation STFlipCardButton

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setImage:[UIImage imageNamed:@"flipButton"] forState:UIControlStateNormal];
        [self setImage:[UIImage imageNamed:@"flipButtonTapped"] forState:UIControlStateHighlighted];
        [self setImage:[UIImage imageNamed:@"flipButtonTapped"] forState:UIControlStateDisabled];
    }
    
    return self;
}

- (UIView *)hitTest:(CGPoint)point withEvent:(UIEvent *)event
{
    int errorMargin = 15;
    CGRect hitFrame = CGRectMake(0 - errorMargin, 0 - errorMargin, 320, self.frame.size.height + errorMargin + errorMargin);
    return CGRectContainsPoint(hitFrame, point) ? self : nil;
}

@end
