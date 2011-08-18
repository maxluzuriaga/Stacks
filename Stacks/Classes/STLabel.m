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
    CGRect newFrame = CGRectMake(frame.origin.x - _offset, frame.origin.y - _offset, frame.size.width + (2 * _offset), frame.size.height + (2 * _offset));
    
    if (self = [super initWithFrame:newFrame]) {
        self.textColor = [UIColor whiteColor];
        self.backgroundColor = [UIColor clearColor];
    }
    return self;
}

- (void)drawTextInRect:(CGRect)rect
{
    UIEdgeInsets insets = UIEdgeInsetsMake(_offset, _offset, _offset, _offset);
    return [super drawTextInRect:UIEdgeInsetsInsetRect(rect, insets)];
}

@end
