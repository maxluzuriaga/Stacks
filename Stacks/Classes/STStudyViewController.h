//
//  STStudyViewController.h
//  Stacks
//
//  Created by Max Luzuriaga on 10/23/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@class STStack;

@interface STStudyViewController : UIViewController {
    STStack *_stack;
    
    NSArray *_cards;
    
    UIView *_rotatePrompt;
    UIView *_loadingView;
}

@property (weak, nonatomic) STStack *stack;

@end
