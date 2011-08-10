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

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reuseIdentifier];
    if (self) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        
        self.textLabel.textAlignment = UITextAlignmentCenter;
        self.textLabel.font = [UIFont boldSystemFontOfSize:17];
        
        UIImageView *backgroundImage = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, self.frame.size.width)];
        backgroundImage.image = [UIImage imageNamed:@"stackCellBackground"];
        
        self.backgroundView = backgroundImage;
        
        UIImageView *selectedBackgroundImage = [[UIImageView alloc] initWithFrame:backgroundImage.frame];
        selectedBackgroundImage.image = [UIImage imageNamed:@"stackCellSelectedBackground"];
        
        self.selectedBackgroundView = selectedBackgroundImage;
        
        disclosureIndicator = [[UIImageView alloc] initWithFrame:CGRectMake(283, 27, 9, 14)];
        disclosureIndicator.image = [UIImage imageNamed:@"disclosureIndicator"];
        
        [self.contentView addSubview:disclosureIndicator];
        
        animationsDisabled = NO;
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
    
    if (animationsDisabled) return;
    
    if (!editing) self.backgroundView.frame = CGRectMake(32, 0, self.backgroundView.frame.size.width, self.backgroundView.frame.size.height);
    
    CGRect oldFrame = self.backgroundView.frame;
    
    float xOrigin = (editing) ? 32 : 0;
    CGRect frame = CGRectMake(xOrigin, oldFrame.origin.y, oldFrame.size.width, oldFrame.size.height);
    
    if (animated) {
        [UIView animateWithDuration:0.28 delay:0 options:UIViewAnimationOptionCurveEaseInOut animations:^(void) {
            self.backgroundView.frame = frame;
        } completion:nil];
    } else {
        self.backgroundView.frame = frame;
    }
}

- (void)willTransitionToState:(UITableViewCellStateMask)state
{
    [super willTransitionToState:state];
    
    if (state == UITableViewCellStateShowingDeleteConfirmationMask)
        animationsDisabled = YES;
}

- (void)didTransitionToState:(UITableViewCellStateMask)state
{
    [super didTransitionToState:state];
    
    if (state == UITableViewCellStateDefaultMask && animationsDisabled == YES)
        animationsDisabled = NO;
}

@end
