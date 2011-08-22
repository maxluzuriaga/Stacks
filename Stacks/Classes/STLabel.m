//
//  STLabel.m
//  Stacks
//
//  Created by Max Luzuriaga on 8/17/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "STLabel.h"

@implementation STLabel

- (id)initWithFrame:(CGRect)frame
{
    _offset = 3;
    
    if (self = [super initWithFrame:frame]) {
        self.textColor = [UIColor whiteColor];
        self.backgroundColor = [UIColor clearColor];
    }
    return self;
}

- (CGRect)insetRect:(CGRect)original inverse:(BOOL)inverse
{
    float offset = _offset * (inverse ? -1 : 1);
    return CGRectMake(original.origin.x - offset, original.origin.y - offset, original.size.width + (2 * offset), original.size.height + (2 * offset));
}

- (void)setFrame:(CGRect)frame
{
    frame = [self insetRect:frame inverse:NO];
    [super setFrame:frame];
}

- (void)drawTextInRect:(CGRect)rect
{
    return [super drawTextInRect:[self insetRect:rect inverse:YES]];
}

@end
