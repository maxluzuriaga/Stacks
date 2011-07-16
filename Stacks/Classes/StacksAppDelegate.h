//
//  StacksAppDelegate.h
//  Stacks
//
//  Created by Max Luzuriaga on 6/21/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface StacksAppDelegate : UIResponder <UIApplicationDelegate> {
    @private
    NSMetadataQuery *ubiquitousQuery;
}

@property (strong, nonatomic) UIWindow *window;

@property (readonly, strong, nonatomic) NSManagedObjectContext *managedObjectContext;
@property (readonly, strong, nonatomic) NSManagedObjectModel *managedObjectModel;
@property (readonly, strong, nonatomic) NSPersistentStoreCoordinator *persistentStoreCoordinator;
@property (strong, nonatomic) NSMetadataQuery *ubiquitousQuery;

- (void)saveContext;
- (NSURL *)applicationDocumentsDirectory;
- (void)mergeiCloudChanged:(NSDictionary *)noteInfo forContext:(NSManagedObjectContext *)moc;
- (void)mergeChangesFromiCloud:(NSNotification *)notification;

// Needed in iOS beta 3
- (void)pollnewfiles_weakpackages:(NSNotification*)note;
- (void)workaround_weakpackages_9653904:(NSDictionary*)options;

@property (strong, nonatomic) UINavigationController *navigationController;

@end
