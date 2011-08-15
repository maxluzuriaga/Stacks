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

@interface STStackDetailViewController : UITableViewController {
    STStack *_stack;
    NSMutableArray *cards;
    
    STEmptyDataSetView *emptyDataSetView;
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
