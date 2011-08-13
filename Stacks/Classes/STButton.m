//
//  STButton.m
//  Stacks
//
//  Created by Max Luzuriaga on 7/25/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "STButton.h"

@implementation STButton

@synthesize disclosureImageEnabled = _disclosureImageEnabled;

- (id)initWithFrame:(CGRect)frame buttonColor:(STButtonColor)buttonColor disclosureImageEnabled:(BOOL)disclosureImageEnabled
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setButtonColor:buttonColor];
        
        self.titleLabel.font = [UIFont boldSystemFontOfSize:17];
        self.titleLabel.shadowOffset = CGSizeMake(0, 1);
        
        [self setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [self setTitleColor:[UIColor whiteColor] forState:UIControlStateHighlighted];
        
        [self setTitleShadowColor:[UIColor colorWithRed:1.0 green:1.0 blue:1.0 alpha:0.4] forState:UIControlStateNormal];
        [self setTitleShadowColor:[UIColor colorWithRed:0.0 green:0.0 blue:0.0 alpha:0.4] forState:UIControlStateHighlighted];
        
        self.reversesTitleShadowWhenHighlighted = YES;
        
        _disclosureImageEnabled = disclosureImageEnabled;
        
        if (_disclosureImageEnabled) {
            disclosureImage = [UIImage imageNamed:@"disclosureIndicator"];
            
            NSInteger oldWidth = self.frame.size.width;
            
            UIImageView *disclosureImageView = [[UIImageView alloc] initWithFrame:CGRectMake(oldWidth - 22, 16, 9, 14)];
            disclosureImageView.image = disclosureImage;
            
            [self addSubview:disclosureImageView];
        }
    }
    
    return self;
}

- (void)configureButtonColor
{
    UIEdgeInsets edgeInsets = UIEdgeInsetsMake(0, 12, 0, 12);
    
    NSString *color = nil;
    
    switch (_buttonColor) {
        case STButtonColorBlue:
            color = @"blue";
            break;
            
        default:
            break;
    }
    
    NSString *normalImageName = [NSString stringWithFormat:@"%@ButtonBackground", color];
    NSString *tappedImageName = [NSString stringWithFormat:@"%@ButtonTappedBackground", color];
    
    [self setBackgroundImage:[[UIImage imageNamed:normalImageName] resizableImageWithCapInsets:edgeInsets] forState:UIControlStateNormal];
    [self setBackgroundImage:[[UIImage imageNamed:tappedImageName] resizableImageWithCapInsets:edgeInsets] forState:UIControlStateHighlighted];
}

- (void)setButtonColor:(STButtonColor)buttonColor
{
    _buttonColor = buttonColor;
    [self configureButtonColor];
}

- (void)adjustTextLabelForDisclosureImage
{
    CGRect oldFrame = self.titleLabel.frame;
    
    self.titleLabel.frame = CGRectMake(oldFrame.origin.x - 5, oldFrame.origin.y, oldFrame.size.width, oldFrame.size.height);
}

- (void)setEnabled:(BOOL)enabled
{
    [super setEnabled:enabled];
    
    float opacity = enabled ? 1.0 : 0.5;
    self.alpha = opacity;
}

- (void)setEnabled:(BOOL)enabled animated:(BOOL)animated
{
    if (animated) {
        [UIView animateWithDuration:0.5 animations:^(void) {
            [self setEnabled:enabled];
        }];
    } else {
        [self setEnabled:enabled];
    }
}

@end
