//
//  STCardView.h
//  Stacks
//
//  Created by Max Luzuriaga on 8/15/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

#define CARD_VIEW_SHORT_HEIGHT 125
#define CARD_VIEW_TALL_HEIGHT 178

typedef enum {
    STCardViewStateFront,
    STCardViewStateBack
} STCardViewState;

@interface STCardView : UIView {
    UIImageView *_backgroundImage;
    UITextView *_textView;
    
    NSString *_frontText;
    NSString *_backText;
    
    STCardViewState _state;
}

@property (strong, nonatomic) UITextView *textView;
@property (strong, nonatomic) NSString *frontText;
@property (strong, nonatomic) NSString *backText;
@property (nonatomic) STCardViewState state;

- (void)flip;
- (void)setEditable:(BOOL)editable;

@end
