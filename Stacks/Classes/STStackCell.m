//
//  STStackCell.m
//  Stacks
//
//  Created by Max Luzuriaga on 8/9/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "STStackCell.h"

#import "STStack.h"

@implementation STStackCell

@synthesize animationsDisabled = _animationsDisabled;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reuseIdentifier];
    if (self) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        
        self.textLabel.textAlignment = UITextAlignmentCenter;
        self.textLabel.font = [UIFont boldSystemFontOfSize:17];
        
        UIImageView *backgroundImage = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"stackCellBackground"]];
//        backgroundImage.image = [UIImage imageNamed:@"stackCellBackground"];
        
        self.backgroundView = backgroundImage;
        
        UIImageView *selectedBackgroundImage = [[UIImageView alloc] initWithFrame:backgroundImage.frame];
        selectedBackgroundImage.image = [UIImage imageNamed:@"stackCellSelectedBackground"];
        
        self.selectedBackgroundView = selectedBackgroundImage;
        
        disclosureIndicator = [[UIImageView alloc] initWithFrame:CGRectMake(283, 27, 9, 14)];
        disclosureIndicator.image = [UIImage imageNamed:@"disclosureIndicator"];
        
        [self.contentView addSubview:disclosureIndicator];
        }
    return self;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    self.textLabel.frame = CGRectMake(28, 25, 264, 18);
}

- (void)setEditing:(BOOL)editing animated:(BOOL)animated
{
    [super setEditing:editing animated:animated];
    
    NSLog(@"setEditing:%@", (self.editing ? @"YES" : @"NO"));
    
    if (_animationsDisabled) return;
    
    if (!editing) self.backgroundView.frame = CGRectMake(32, 0, self.backgroundView.frame.size.width, self.backgroundView.frame.size.height);
    
    CGRect oldFrame = self.backgroundView.frame;
    
    float xOrigin = editing ? 32 : 0;
    CGRect frame = CGRectMake(xOrigin, oldFrame.origin.y, oldFrame.size.width, oldFrame.size.height);
    
    float disclosureOpacity = editing ? 0.0 : 1.0;
    
    if (animated) {
        [UIView animateWithDuration:0.28 delay:0 options:UIViewAnimationOptionCurveEaseInOut animations:^(void) {
            self.backgroundView.frame = frame;
            disclosureIndicator.alpha = disclosureOpacity;
        } completion:nil];
    } else {
        self.backgroundView.frame = frame;
        disclosureIndicator.alpha = disclosureOpacity;
    }
}

- (void)willTransitionToState:(UITableViewCellStateMask)state
{
    [super willTransitionToState:state];
    
    NSLog(@"editing: %@", (self.editing ? @"Editing" : @"Not editing"));
    
    if (self.showingDeleteConfirmation)
        _animationsDisabled = YES;
}

- (void)didTransitionToState:(UITableViewCellStateMask)state
{
    [super didTransitionToState:state];
    
    if (state == UITableViewCellStateDefaultMask && _animationsDisabled == YES)
        _animationsDisabled = NO;
}

@end
