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
        
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        
        self.textLabel.textAlignment = UITextAlignmentCenter;
        self.textLabel.font = [UIFont boldSystemFontOfSize:17];
        self.textLabel.highlightedTextColor = [UIColor whiteColor];
        
        UIImageView *backgroundImage = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"stackCellBackground"]];
        self.backgroundView = backgroundImage;
        
        UIImageView *selectedBackgroundImage = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"stackCellSelectedBackground"]];
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
    
    NSLog(@"editing: %@, showingDeleteConfirmation: %@ lastEditing: %@", (self.editing ? @"YES" : @"NO"), (self.showingDeleteConfirmation ? @"YES" : @"NO"), (lastEditing ? @"YES" : @"NO"));
    
    self.textLabel.frame = CGRectMake(28, 25, 264, 18);
    
    float backgroundXOrigin;
    float disclosureOpacity;
    
    BOOL slidingToShowDeleteControl = (self.editing && self.showingDeleteConfirmation && !lastEditing);
    BOOL enteringEditMode = (self.editing && !self.showingDeleteConfirmation && !lastEditing);
    BOOL confirmingDeletion = (self.editing && self.showingDeleteConfirmation && lastEditing);
    BOOL rejectingDeletion = (self.editing && !self.showingDeleteConfirmation && lastEditing);
    
    if ((enteringEditMode || confirmingDeletion || rejectingDeletion) && !slidingToShowDeleteControl) {
        backgroundXOrigin = 32;
        disclosureOpacity = 0.0;
    } else {
        backgroundXOrigin = 0;
        disclosureOpacity = 1.0;
    }
    
    CGRect oldBackgroundFrame = self.backgroundView.frame;
    self.backgroundView.frame = CGRectMake(backgroundXOrigin, oldBackgroundFrame.origin.y, oldBackgroundFrame.size.width, oldBackgroundFrame.size.height);
    
    disclosureIndicator.alpha = disclosureOpacity;
}

- (void)prepareForReuse
{
    [super prepareForReuse];
    
    lastEditing = NO;
}

- (void)setEditing:(BOOL)editing animated:(BOOL)animated
{
    [super setEditing:editing animated:animated];
    
    lastEditing = editing;
}

@end
