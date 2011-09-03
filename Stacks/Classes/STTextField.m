//
//  STTextField.m
//  Stacks
//
//  Created by Max Luzuriaga on 7/27/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "STTextField.h"

@implementation STTextField

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.background = [[UIImage imageNamed:@"textFieldBackground"] resizableImageWithCapInsets:UIEdgeInsetsMake(0, 15, 0, 15)];
        
        self.placeholder = @"Name";
        self.font = [UIFont systemFontOfSize:15];
        self.textColor = [UIColor colorWithRed:0.15 green:0.15 blue:0.15 alpha:1.0];
        self.returnKeyType = UIReturnKeyDone;
        self.spellCheckingType = UITextSpellCheckingTypeNo;
        self.autocapitalizationType = UITextAutocapitalizationTypeNone;
    }
    
    return self;
}

- (CGRect)textRectForBounds:(CGRect)bounds
{
    return CGRectMake(16, 13, self.frame.size.width - 32, self.frame.size.height - 13);
}

- (CGRect)editingRectForBounds:(CGRect)bounds
{
    return CGRectMake(16, 13, self.frame.size.width - 32, self.frame.size.height - 13);
}

@end
