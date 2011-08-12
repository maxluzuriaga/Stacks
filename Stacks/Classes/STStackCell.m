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
        lastEditing = NO;
        
        self.selectionStyle = UITableViewCellSelectionStyleBlue;
        
        self.textLabel.textAlignment = UITextAlignmentCenter;
        self.textLabel.font = [UIFont boldSystemFontOfSize:17];
        
        [self configureTextLabel];
        
        self.textLabel.highlightedTextColor = [UIColor whiteColor];
        
        UIImageView *backgroundImage = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"stackCellBackground"]];
        self.backgroundView = backgroundImage;
        
        UIImageView *selectedBackgroundImage = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"stackCellSelectedBackground"]];
        selectedBackgroundImage.alpha = 0.7;
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
    
    float offset = 0;
    float disclosureOpacity = 1.0;
    
    BOOL adjustTextLabel = NO;
    
    BOOL slidingToShowDeleteControl = (self.editing && self.showingDeleteConfirmation && !lastEditing);
    BOOL enteringEditMode = (self.editing && !self.showingDeleteConfirmation && !lastEditing);
    BOOL confirmingDeletion = (self.editing && self.showingDeleteConfirmation && lastEditing);
    BOOL rejectingDeletion = (self.editing && !self.showingDeleteConfirmation && lastEditing);
    
    if ((enteringEditMode || confirmingDeletion || rejectingDeletion) && !slidingToShowDeleteControl) {
        offset = 32;
        disclosureOpacity = 0.0;
    }
    
    if (slidingToShowDeleteControl) {
        adjustTextLabel = YES;
        offset = -63;
        disclosureOpacity = 0.0;
    }
    
    self.textLabel.frame = CGRectMake((adjustTextLabel ? (28 + offset) : 28), 25, 264, 18);
    
    CGRect oldBackgroundFrame = self.backgroundView.frame;
    self.backgroundView.frame = CGRectMake(oldBackgroundFrame.origin.x + offset, oldBackgroundFrame.origin.y, oldBackgroundFrame.size.width, oldBackgroundFrame.size.height);
    
    disclosureIndicator.alpha = disclosureOpacity;
}

- (void)willTransitionToState:(UITableViewCellStateMask)state {
    
    [super willTransitionToState:state];
    
    if ((state == UITableViewCellStateDefaultMask) && lastEditing)
        self.backgroundView.frame = CGRectMake(32, 0, self.backgroundView.frame.size.width, self.backgroundView.frame.size.height);
}

- (void)prepareForReuse
{
    [super prepareForReuse];
    
    [self configureTextLabel];
    lastEditing = NO;
}

- (void)configureTextLabel
{
    if (self.highlighted) {
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
    self.alpha = 0.8;
}

- (void)setEditing:(BOOL)editing animated:(BOOL)animated
{
    [super setEditing:editing animated:animated];
    
    lastEditing = editing;
}

@end
