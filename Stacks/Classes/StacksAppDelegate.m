//
//  StacksAppDelegate.m
//  Stacks
//
//  Created by Max Luzuriaga on 6/21/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "StacksAppDelegate.h"

#import "RootViewController.h"
#import "STCommonDefinitions.h"

#define UBIQUITY_CONTAINER_IDENTIFIER @"KA3366Q756.com.maxluzuriaga.Stacks"
#define PERSISTENT_STORE_FILE_NAME @"Stacks.sqlite"

@implementation StacksAppDelegate

@synthesize window = _window;
@synthesize managedObjectContext = __managedObjectContext;
@synthesize managedObjectModel = __managedObjectModel;
@synthesize persistentStoreCoordinator = __persistentStoreCoordinator;
@synthesize navigationController = _navigationController;
@synthesize ubiquitousQuery;

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    
    RootViewController *controller = [[RootViewController alloc] initWithNibName:@"RootViewController" bundle:nil];
    [[NSNotificationCenter defaultCenter] addObserver:controller selector:@selector(persistentStoreAdded) name:kPersistentStoreCoordinatorDidAddPersistentStoreNotification object:self];
    self.navigationController = [[UINavigationController alloc] initWithRootViewController:controller];
    self.window.rootViewController = self.navigationController;
    [self.window makeKeyAndVisible];
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application
{
    /*
     Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
     Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
     */
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    /*
     Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
     If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
     */
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    /*
     Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
     */
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    /*
     Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
     */
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Saves changes in the application's managed object context before the application terminates.
    [self saveContext];
}

- (void)saveContext
{
    NSError *error = nil;
    NSManagedObjectContext *managedObjectContext = self.managedObjectContext;
    if (managedObjectContext != nil)
    {
        if ([managedObjectContext hasChanges] && ![managedObjectContext save:&error])
        {
            /*
             Replace this implementation with code to handle the error appropriately.
             
             abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development. If it is not possible to recover from the error, display an alert panel that instructs the user to quit the application by pressing the Home button.
             */
            NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
            abort();
        } 
    }
}

#pragma mark - Core Data stack

/**
 Returns the managed object context for the application.
 If the context doesn't already exist, it is created and bound to the persistent store coordinator for the application.
 */
- (NSManagedObjectContext *)managedObjectContext
{
    if (__managedObjectContext != nil)
    {
        return __managedObjectContext;
    }
    
    NSPersistentStoreCoordinator *coordinator = [self persistentStoreCoordinator];
    
    if (coordinator != nil)
    {
        NSManagedObjectContext *moc = [[NSManagedObjectContext alloc] initWithConcurrencyType:NSMainQueueConcurrencyType];
        
        [moc performBlockAndWait:^{
            // even the post initialization needs to be done within the Block
            [moc setPersistentStoreCoordinator: coordinator];
            [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(mergeChangesFromiCloud:) name:NSPersistentStoreDidImportUbiquitousContentChangesNotification object:coordinator];
        }];
        __managedObjectContext = moc;
    }
    
    return __managedObjectContext;
}

/**
 Returns the managed object model for the application.
 If the model doesn't already exist, it is created from the application's model.
 */
- (NSManagedObjectModel *)managedObjectModel
{
    if (__managedObjectModel != nil)
    {
        return __managedObjectModel;
    }
    NSURL *modelURL = [[NSBundle mainBundle] URLForResource:@"Stacks" withExtension:@"momd"];
    __managedObjectModel = [[NSManagedObjectModel alloc] initWithContentsOfURL:modelURL];    
    return __managedObjectModel;
}

- (void)mergeChangesFromiCloud:(NSNotification *)notification
{
    NSLog(@"mergeChangesFromiCloud:");
}

- (NSPersistentStoreCoordinator *)persistentStoreCoordinator {
    if (__persistentStoreCoordinator != nil) {
        return __persistentStoreCoordinator;
    }
    
    // assign the PSC to our app delegate ivar before adding the persistent store in the background
    // this leverages a behavior in Core Data where you can create NSManagedObjectContext and fetch requests
    // even if the PSC has no stores.  Fetch requests return empty arrays until the persistent store is added
    // so it's possible to bring up the UI and then fill in the results later
    __persistentStoreCoordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel: [self managedObjectModel]];
    
    NSPersistentStoreCoordinator *psc = __persistentStoreCoordinator;
    
    // prep the store path and bundle stuff here since -mainBundle isn't totally thread safe
    NSString *storePath = [[[self applicationDocumentsDirectory] path] stringByAppendingPathComponent:@"Stacks.sqlite"];
    NSString *defaultStorePath = [[NSBundle mainBundle] pathForResource:@"Stacks" ofType:@"sqlite"];
    
    // do this asynchronously since if this is the first time this particular device is syncing with preexisting
    // iCloud content it may take a long long time to download
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        NSFileManager *fileManager = [NSFileManager defaultManager];
        NSURL *storeUrl = [NSURL fileURLWithPath:storePath];
        
        // this needs to match the entitlements and provisioning profile
        NSURL *cloudURL = [fileManager URLForUbiquityContainerIdentifier:UBIQUITY_CONTAINER_IDENTIFIER];
        
        // Build in error checking to see if iCloud is enabled, k?
        
        NSString *coreDataCloudContent = [[cloudURL path] stringByAppendingPathComponent:@"stacksCloudSync"];
        
        cloudURL = [NSURL fileURLWithPath:coreDataCloudContent];
        
        // here you add the API to turn on Core Data iCloud support
        NSDictionary *options = [NSDictionary dictionaryWithObjectsAndKeys:UBIQUITY_CONTAINER_IDENTIFIER, NSPersistentStoreUbiquitousContentNameKey, cloudURL, NSPersistentStoreUbiquitousContentURLKey, [NSNumber numberWithBool:YES], NSMigratePersistentStoresAutomaticallyOption, [NSNumber numberWithBool:YES], NSInferMappingModelAutomaticallyOption,nil];
        
        // Needed on iOS seed 3, but not Mac OS X
        [self workaround_weakpackages_9653904:options];
        
        NSError *error = nil;
        [psc lock];
        if (![psc addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:storeUrl options:options error:&error]) {
            /*
             Replace this implementation with code to handle the error appropriately.
             abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development. If it is not possible to recover from the error, display an alert panel that instructs the user to quit the application by pressing the Home button.
             Typical reasons for an error here include:
             * The persistent store is not accessible
             * The schema for the persistent store is incompatible with current managed object model
             Check the error message to determine what the actual problem was.
             */
            NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
            abort();
        }    
        [psc unlock];
        
        // tell the UI on the main thread we finally added the store and then
        // post a custom notification to make your views do whatever they need to such as tell their
        // NSFetchedResultsController to -performFetch again now there is a real store
        dispatch_async(dispatch_get_main_queue(), ^{
            NSLog(@"asynchronously added persistent store!");
            [[NSNotificationCenter defaultCenter] postNotificationName:kPersistentStoreCoordinatorDidAddPersistentStoreNotification object:self userInfo:nil];
        });
    });
    
    return __persistentStoreCoordinator;
}

#pragma mark - Application's Documents directory

- (NSURL *)applicationDocumentsDirectory
{
    return [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject];
}

#pragma mark - Needed in iOS seed 3 as a workaround for known issues

static dispatch_queue_t polling_queue;

- (void)workaround_weakpackages_9653904:(NSDictionary*)options {
#if 1
    
    NSURL* cloudURL = [options objectForKey:NSPersistentStoreUbiquitousContentURLKey];
    NSString* name = [options objectForKey:NSPersistentStoreUbiquitousContentNameKey];
    NSString* cloudPath = [cloudURL path];
    
    NSMetadataQuery *query = [[NSMetadataQuery alloc] init];
    [query setSearchScopes:[NSArray arrayWithObjects:NSMetadataQueryUbiquitousDataScope, NSMetadataQueryUbiquitousDocumentsScope, nil]];
    [query setPredicate:[NSPredicate predicateWithFormat:@"kMDItemFSName == '*'"]]; // Just get everything.
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(pollnewfiles_weakpackages:) name:NSMetadataQueryGatheringProgressNotification object:query];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(pollnewfiles_weakpackages:) name:NSMetadataQueryDidUpdateNotification object:query];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(pollnewfiles_weakpackages:) name:NSMetadataQueryDidFinishGatheringNotification object:query];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(pollnewfiles_weakpackages:) name:NSMetadataQueryDidStartGatheringNotification object:query];
    
    // May also register for NSMetadataQueryDidFinishGatheringNotification if you want to update any user interface items when the initial result-gathering phase of the query is complete.
    
    self.ubiquitousQuery = query;
    
    polling_queue = dispatch_queue_create("workaround_weakpackages_9653904", DISPATCH_QUEUE_SERIAL);
    
    dispatch_async(dispatch_get_main_queue(), ^{
        if (![query startQuery]) {
            NSLog(@"NSMetadataQuery failed to start!");
        } else {
            NSLog(@"started NSMetadataQuery!");
        };
    });
    
#endif
}

- (void)pollnewfiles_weakpackages:(NSNotification*)note {
    [self.ubiquitousQuery disableUpdates];
    NSArray *results = [self.ubiquitousQuery results];
    NSFileManager* fm = [NSFileManager defaultManager];
    NSFileCoordinator* fc = [[NSFileCoordinator alloc] initWithFilePresenter:nil];
    
    for (NSMetadataItem *item in results) {
        NSURL* itemurl = [item valueForAttribute:NSMetadataItemURLKey];
        
        NSString* filepath = [itemurl path];
        if (![fm fileExistsAtPath:filepath]) {
            dispatch_async(polling_queue, ^(void) {
//                NSLog(@"coordinated reading of URL '%@'", itemurl);
                [fc coordinateReadingItemAtURL:itemurl options:0 error:nil byAccessor:^(NSURL* url) { }];
            });
        }
    }
    
    [self.ubiquitousQuery enableUpdates];
    
}

@end
