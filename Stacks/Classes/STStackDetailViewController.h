//
//  STStackDetailViewController.h
//  Stacks
//
//  Created by Max Luzuriaga on 8/13/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@class STStack;

@interface STStackDetailViewController : UITableViewController {
    STStack *_stack;
    NSMutableArray *cards;
}

@property (strong, nonatomic) NSManagedObjectContext *managedObjectContext;
@property (strong, nonatomic) STStack *stack;

- (void)reloadStack:(NSNotification *)note;
- (void)addNewStack;
- (void)presentEmptyDataSetViewIfNeeded;

@end
