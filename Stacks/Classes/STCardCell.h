//
//  STCardCell.h
//  Stacks
//
//  Created by Max Luzuriaga on 8/13/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface STCardCell : UITableViewCell {
    UIImageView *disclosureIndicator;
    
    BOOL lastEditing;
    BOOL reusing;
    UITableViewCellStateMask _state;
}

- (void)configureTextLabel;

@end
