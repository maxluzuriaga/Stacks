//
//  STPagingView.h
//  Stacks
//
//  Created by Max Luzuriaga on 10/31/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface STPagingView : UIView <UIScrollViewDelegate> {
    UIScrollView *_scrollView;
    
    NSArray *_cards;
    NSMutableArray *_views;
    
    NSInteger _currentPage;
    
    CGRect _leftTapTarget;
    CGRect _rightTapTarget;
}

- (void)handleSingleTapFrom:(UITapGestureRecognizer *)gestureRecognizer;
- (void)loadViewAtIndex:(NSInteger)index;
- (void)adjustViewsAlpha;
- (void)restart;

@end
