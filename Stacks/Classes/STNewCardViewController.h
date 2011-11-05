//
//  STNewCardViewController.h
//  Stacks
//
//  Created by Max Luzuriaga on 10/7/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@class STCardView;
@class STNewCardViewController;

#import "STCardStateView.h"

@protocol STNewCardViewControllerDelegate

- (void)newCardViewController:(STNewCardViewController *)newStackViewController didSaveWithFrontText:(NSString *)frontText backText:(NSString *)backText;

@end

@interface STNewCardViewController : UIViewController <UITextViewDelegate, STCardStateViewDelegate> {
    STCardStateView *_cardStateView;
    
//    UIButton *_flipButton;
//    UILabel *_stateLabel;
    
    STCardView *_cardView;
}

@property (weak, nonatomic) id<STNewCardViewControllerDelegate> delegate;

- (void)flip;
- (void)cancel;
- (void)save;

@end
