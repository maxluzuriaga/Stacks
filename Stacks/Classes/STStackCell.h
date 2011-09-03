//
//  STStackCell.h
//  Stacks
//
//  Created by Max Luzuriaga on 8/9/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface STStackCell : UITableViewCell {
    UIImageView *disclosureIndicator;
    
    BOOL lastEditing;
    BOOL reusing;
    UITableViewCellStateMask _state;
}

- (void)configureTextLabel;

@end
