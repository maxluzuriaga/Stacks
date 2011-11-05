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

#import "STCardStateView.h"

@interface STCardDetailViewController : UIViewController <UITextViewDelegate, STCardStateViewDelegate> {
    STCard *_card;
    
    STCardStateView *_cardStateView;
    
    STCardView *_cardView;
}

@property (strong, nonatomic) STCard *card;

- (void)reloadCard:(NSNotification *)note;
- (void)flip;
- (void)configureView;

@end
