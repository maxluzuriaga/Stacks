//
//  STStackDetailViewController.h
//  Stacks
//
//  Created by Max Luzuriaga on 8/13/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@class STStack;
@class STEmptyDataSetView;
@class STTextField;

@interface STStackDetailViewController : UITableViewController <UITextFieldDelegate> {
    STStack *_stack;
    NSMutableArray *cards;
    
    STEmptyDataSetView *emptyDataSetView;
    STTextField *nameTextField;
}

@property (strong, nonatomic) NSManagedObjectContext *managedObjectContext;
@property (strong, nonatomic) STStack *stack;

- (void)reloadStack:(NSNotification *)note;
- (void)configureCell:(UITableViewCell *)cell atIndexPath:(NSIndexPath *)indexPath;
- (void)newCard;
- (void)shareStack;
- (void)study;
- (void)presentEmptyDataSetViewIfNeeded;

@end
