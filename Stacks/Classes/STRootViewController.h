//
//  STRootViewController.h
//  Stacks
//
//  Created by Max Luzuriaga on 6/21/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>

@class STStackDetailViewController;
@class STEmptyDataSetView;

@interface STRootViewController : UITableViewController <NSFetchedResultsControllerDelegate> {
    STEmptyDataSetView *emptyDataSetView;
}

@property (strong, nonatomic) NSFetchedResultsController *fetchedResultsController;
@property (strong, nonatomic) NSManagedObjectContext *managedObjectContext;
@property (strong, nonatomic) STStackDetailViewController *detailViewController;

- (void)persistentStoreAdded;
- (void)configureCell:(UITableViewCell *)cell atIndexPath:(NSIndexPath *)indexPath;
- (void)addNewStack;
- (void)presentEmptyDataSetViewIfNeeded;

@end
