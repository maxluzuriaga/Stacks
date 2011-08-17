//
//  STCardDetailViewController.h
//  Stacks
//
//  Created by Max Luzuriaga on 8/15/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@class STCard;
@class STCardView;

@interface STCardDetailViewController : UIViewController {
    STCard *_card;
    
    UIButton *_flipButton;
    UILabel *_stateLabel;
    
    STCardView *_cardView;
}

@property (nonatomic, retain) STCard *card;

- (void)flip;
- (void)configureView;

@end
