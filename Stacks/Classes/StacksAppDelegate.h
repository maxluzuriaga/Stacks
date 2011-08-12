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
}

@property (strong, nonatomic) UIWindow *window;

@property (readonly, strong, nonatomic) NSManagedObjectContext *managedObjectContext;
@property (readonly, strong, nonatomic) NSManagedObjectModel *managedObjectModel;
@property (readonly, strong, nonatomic) NSPersistentStoreCoordinator *persistentStoreCoordinator;

- (void)saveContext;
- (NSURL *)applicationDocumentsDirectory;
- (void)mergeiCloudChanges:(NSDictionary *)noteInfo forContext:(NSManagedObjectContext *)moc;
- (void)mergeChangesFromiCloud:(NSNotification *)notification;

@property (strong, nonatomic) UINavigationController *navigationController;

@end
