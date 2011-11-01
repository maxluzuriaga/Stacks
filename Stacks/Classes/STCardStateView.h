//
//  STCardStateView.h
//  Stacks
//
//  Created by Max Luzuriaga on 10/31/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "STCardView.h"

@class STLabel;

@protocol STCardStateViewDelegate

- (void)cardStateViewDidChangeToState:(STCardViewState)state;

@end

@interface STCardStateView : UIView {
    STLabel *_label;
    UIButton *_flipButton;
}

@property (nonatomic) STCardViewState state;
@property (weak, nonatomic) id<STCardStateViewDelegate> delegate;

- (void)flip;

@end
