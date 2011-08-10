//
//  STStackCell.h
//  Stacks
//
//  Created by Max Luzuriaga on 8/9/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@class STStack;

@interface STStackCell : UITableViewCell {
    UIImageView *disclosureIndicator;
    
    BOOL _animationsDisabled;
}

@property (nonatomic) BOOL animationsDisabled;

@end
