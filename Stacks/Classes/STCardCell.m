//
//  STCardCell.m
//  Stacks
//
//  Created by Max Luzuriaga on 8/13/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "STCardCell.h"

@implementation STCardCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reuseIdentifier];
    if (self) {
        lastEditing = NO;
        reusing = NO;
        
        self.selectionStyle = UITableViewCellSelectionStyleBlue;
        
        self.textLabel.font = [UIFont boldSystemFontOfSize:17];
        self.textLabel.backgroundColor = [UIColor greenColor];
        
        [self configureTextLabel];
        
        self.textLabel.highlightedTextColor = [UIColor whiteColor];
        
        UIImageView *backgroundImage = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"cardCellBackground"]];
        self.backgroundView = backgroundImage;
        
        UIImageView *selectedBackgroundImage = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"cardCellSelectedBackground"]];
        selectedBackgroundImage.alpha = 0.7;
        self.selectedBackgroundView = selectedBackgroundImage;
        
        disclosureIndicator = [[UIImageView alloc] initWithFrame:CGRectMake(283, 24, 9, 14)];
        disclosureIndicator.image = [UIImage imageNamed:@"disclosureIndicator"];
        
        [self.contentView addSubview:disclosureIndicator];
    }
    return self;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    float offset = 0;
    float disclosureOpacity = 1.0;
    
    BOOL adjustTextLabel = NO;
    
    BOOL slidingToShowDeleteControl = (self.editing && self.showingDeleteConfirmation && !lastEditing) || (_state == UITableViewCellStateShowingDeleteConfirmationMask);
    BOOL enteringEditMode = (self.editing && !self.showingDeleteConfirmation && !lastEditing);
    BOOL confirmingDeletion = (self.editing && self.showingDeleteConfirmation && lastEditing);
    BOOL rejectingDeletion = (self.editing && !self.showingDeleteConfirmation && lastEditing);
    
    if (reusing && !enteringEditMode) {
        self.textLabel.frame = CGRectMake(28, 22, 246, 18);
        self.backgroundView.frame = CGRectMake(0, 0, self.frame.size.width, self.frame.size.height);
        disclosureIndicator.alpha = 1.0;
        
        reusing = NO;
        return;
    }
    
    if ((enteringEditMode || confirmingDeletion || rejectingDeletion) && !slidingToShowDeleteControl) {
        offset = 32;
        disclosureOpacity = 0.0;
    }
    
    if (slidingToShowDeleteControl) {
        adjustTextLabel = YES;
        offset = -63;
        disclosureOpacity = 0.0;
    }
    
    self.textLabel.frame = CGRectMake((adjustTextLabel ? (28 + offset) : 28), 22, 246, 18);
    
    CGRect oldBackgroundFrame = self.backgroundView.frame;
    self.backgroundView.frame = CGRectMake(oldBackgroundFrame.origin.x + offset, oldBackgroundFrame.origin.y, oldBackgroundFrame.size.width, oldBackgroundFrame.size.height);
    
    disclosureIndicator.alpha = disclosureOpacity;
}

- (void)willTransitionToState:(UITableViewCellStateMask)state {
    
    [super willTransitionToState:state];
    
    _state = state;
    
    if ((state == UITableViewCellStateDefaultMask) && lastEditing)
        self.backgroundView.frame = CGRectMake(32, 0, self.backgroundView.frame.size.width, self.backgroundView.frame.size.height);
    
    self.userInteractionEnabled = NO;
}

- (void)didTransitionToState:(UITableViewCellStateMask)state
{
    [super didTransitionToState:state];
    
    self.userInteractionEnabled = YES;
}

- (void)prepareForReuse
{
    [super prepareForReuse];
    
    [self configureTextLabel];
    lastEditing = NO;
    
    reusing = YES;
}

- (void)configureTextLabel
{
    if (self.highlighted || self.selected) {
        self.textLabel.shadowOffset = CGSizeMake(0, -1);
        self.textLabel.shadowColor = [[UIColor blackColor] colorWithAlphaComponent:0.4];
    } else {
        self.textLabel.shadowOffset = CGSizeMake(0, 1);
        self.textLabel.shadowColor = [[UIColor whiteColor] colorWithAlphaComponent:0.4];
    }
}

- (void)setHighlighted:(BOOL)highlighted animated:(BOOL)animated
{
    [super setHighlighted:highlighted animated:animated];
    
    [self configureTextLabel];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];
    
    [self configureTextLabel];
}

- (void)setEditing:(BOOL)editing animated:(BOOL)animated
{
    [super setEditing:editing animated:animated];
    
    lastEditing = editing;
}

@end
