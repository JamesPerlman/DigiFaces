//
//  AppDelegate.m
//  DigiFaces
//
//  Created by Apple on 02/06/2015.
//  Copyright (c) 2015 Usasha studio. All rights reserved.
//

#import "AppDelegate.h"
#import "Reachability.h"
#import "NointernetController.h"
#import <Fabric/Fabric.h>
#import <Crashlytics/Crashlytics.h>

#import "DFResponseDescriptorsProvider.h"
@interface AppDelegate ()
{
    Reachability * internetReachable;
    NointernetController * noInternetContrller;
}
@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
    [DFDataManager setPersistentStoreURL:[self persistentStoreURL]];
    
    [DFDataManager resetDatabase];
    
    [self setupRestKit];
    
    [DFDataManager setManagedObjectContext:[RKObjectManager sharedManager].managedObjectStore.mainQueueManagedObjectContext];
    // Override point for customization after application launch.

    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(checkNetworkStatus:) name:kReachabilityChangedNotification object:nil];
    
    internetReachable = [Reachability reachabilityForInternetConnection];
    [internetReachable startNotifier];
    
    //[[UIApplication sharedApplication] setStatusBarHidden:NO];
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
    
    [[UINavigationBar appearance] setBarTintColor:[UIColor blackColor]];
    [[UINavigationBar appearance] setTitleTextAttributes:@{NSForegroundColorAttributeName : [UIColor colorWithRed:38/255.0f green:218/255.0f blue:1 alpha:1]}];
    [[UINavigationBar appearance] setTintColor:[UIColor whiteColor]];
    
    
    
    
    UIStoryboard * storyBoard = [UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]];
    UIViewController * rootViewController = [storyBoard instantiateViewControllerWithIdentifier:@"autoLoginController"];
    UINavigationController * navController = [[UINavigationController alloc] initWithRootViewController:rootViewController];
    
    [self.window setRootViewController:navController];
    [self.window makeKeyAndVisible];
    
    [Fabric with:@[CrashlyticsKit]];
    
    return YES;
}

-(void)showNetworkError
{
    if (!noInternetContrller) {
        UIStoryboard * storyBoard = [UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]];
        noInternetContrller = [storyBoard instantiateViewControllerWithIdentifier:@"noInternetController"];
        
    }
    
    [noInternetContrller.view setFrame:self.window.rootViewController.view.frame];
    [self.window.rootViewController.view addSubview:noInternetContrller.view];
}

-(void)hideNetworkError
{
    [noInternetContrller.view removeFromSuperview];
}

- (void)checkNetworkStatus:(NSNotification *)notice {
    NetworkStatus internetStatus = [internetReachable currentReachabilityStatus];
    NSLog(@"Network status: %lu", (long)internetStatus);
    
    if (internetStatus == NotReachable) {
        [self showNetworkError];
    }
    else{
        [self hideNetworkError];
    }
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

#pragma mark - Core Data stack

@synthesize managedObjectContext = _managedObjectContext;
@synthesize managedObjectModel = _managedObjectModel;
@synthesize persistentStoreCoordinator = _persistentStoreCoordinator;

- (NSURL *)applicationDocumentsDirectory {
    // The directory the application uses to store the Core Data store file. This code uses a directory named "com.inet360.DigiFaces" in the application's documents directory.
    return [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject];
}

- (NSManagedObjectModel *)managedObjectModel {
    // The managed object model for the application. It is a fatal error for the application not to be able to find and load its model.
    if (_managedObjectModel != nil) {
        return _managedObjectModel;
    }
    NSURL *modelURL = [[NSBundle mainBundle] URLForResource:@"DigiFaces" withExtension:@"momd"];
    _managedObjectModel = [[NSManagedObjectModel alloc] initWithContentsOfURL:modelURL];
    return _managedObjectModel;
}

- (NSPersistentStoreCoordinator *)persistentStoreCoordinator {
    // The persistent store coordinator for the application. This implementation creates and return a coordinator, having added the store for the application to it.
    if (_persistentStoreCoordinator != nil) {
        return _persistentStoreCoordinator;
    }
    
    // Create the coordinator and store
    
    _persistentStoreCoordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:[self managedObjectModel]];
    
    NSError *error = nil;
    
    NSString *failureReason = @"There was an error creating or loading the application's saved data.";
    if (![_persistentStoreCoordinator addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:[self persistentStoreURL] options:nil error:&error]) {
        // Report any error we got.
        NSMutableDictionary *dict = [NSMutableDictionary dictionary];
        dict[NSLocalizedDescriptionKey] = @"Failed to initialize the application's saved data";
        dict[NSLocalizedFailureReasonErrorKey] = failureReason;
        dict[NSUnderlyingErrorKey] = error;
        error = [NSError errorWithDomain:@"YOUR_ERROR_DOMAIN" code:9999 userInfo:dict];
        // Replace this with code to handle the error appropriately.
        // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
        NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
        abort();
    }
    
    return _persistentStoreCoordinator;
}


- (NSManagedObjectContext *)managedObjectContext {
    // Returns the managed object context for the application (which is already bound to the persistent store coordinator for the application.)
    if (_managedObjectContext != nil) {
        return _managedObjectContext;
    }
    
    NSPersistentStoreCoordinator *coordinator = [self persistentStoreCoordinator];
    if (!coordinator) {
        return nil;
    }
    _managedObjectContext = [[NSManagedObjectContext alloc] init];
    [_managedObjectContext setPersistentStoreCoordinator:coordinator];
    return _managedObjectContext;
}



- (NSURL *)persistentStoreURL {
    return [[self applicationDocumentsDirectory] URLByAppendingPathComponent:@"DigiFaces.sqlite"];
}

#pragma mark - Core Data Saving support

- (void)saveContext {
    NSManagedObjectContext *managedObjectContext = self.managedObjectContext;
    if (managedObjectContext != nil) {
        NSError *error = nil;
        if ([managedObjectContext hasChanges] && ![managedObjectContext save:&error]) {
            // Replace this implementation with code to handle the error appropriately.
            // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
            NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
            abort();
        }
    }
}


#pragma mark - RestKit setup

- (void)setupRestKit
{
    
#if DEBUG
    RKLogConfigureByName("RestKit/Network", RKLogLevelTrace);
    RKLogConfigureByName("RestKit/CoreData", RKLogLevelTrace);
#endif
    
    // Initialize RestKit
    NSURL *baseURL = [[NSURL alloc] initWithString:APIServerAddress];
    
    [RKMIMETypeSerialization registerClass:[RKNSJSONSerialization class] forMIMEType:@"text/html"];
    [RKMIMETypeSerialization registerClass:[RKNSJSONSerialization class] forMIMEType:@"text/plain"];
    
    RKObjectManager *objectManager = [RKObjectManager managerWithBaseURL:baseURL];
    objectManager.requestSerializationMIMEType = RKMIMETypeFormURLEncoded;
    [objectManager.HTTPClient setReachabilityStatusChangeBlock:^(AFNetworkReachabilityStatus status) {
        if (status == AFNetworkReachabilityStatusNotReachable) {
            UIAlertView *alert = [[UIAlertView alloc]
                                  initWithTitle:DFLocalizedString(@"app.error.no_internet", nil)
                                  message:DFLocalizedString(@"app.error.no_internet_descriptive",
                                                            nil)
                                  delegate:nil
                                  cancelButtonTitle:DFLocalizedString(@"app.misc.alert.ok",  nil)
                                  otherButtonTitles:nil];
            [alert show];
        }
    }];
    
    
    // Enable Activity Indicator Spinner
    [AFNetworkActivityIndicatorManager sharedManager].enabled = YES;
    

    //    NSDateFormatter *dateFormatter = [NSDateFormatter new];
    //    [dateFormatter setDateFormat:@"yyyy-MM-dd'T'HH:mm:ss"];
    //    dateFormatter.timeZone = [NSTimeZone timeZoneForSecondsFromGMT:0];
    //    [[RKValueTransformer defaultValueTransformer] insertValueTransformer:dateFormatter atIndex:0];
    //
  
    /**
     Complete Core Data stack initialization
     */
    // Initialize managed object store
    NSManagedObjectModel *managedObjectModel = [NSManagedObjectModel mergedModelFromBundles:nil];
    RKManagedObjectStore *managedObjectStore = [[RKManagedObjectStore alloc] initWithManagedObjectModel:managedObjectModel];
    objectManager.managedObjectStore = managedObjectStore;
    
    
    [managedObjectStore createPersistentStoreCoordinator];
    NSString *storePath = [RKApplicationDataDirectory() stringByAppendingPathComponent:@"DigiFaces.sqlite"];
    NSError *error;
    
    [managedObjectStore addSQLitePersistentStoreAtPath:storePath fromSeedDatabaseAtPath:nil withConfiguration:nil options:nil error:&error];
    //NSAssert(persistentStore, @"Failed to add persistent store with error: %@", error);
    
    
    // Create the managed object contexts
    [managedObjectStore createManagedObjectContexts];
    
    // Configure a managed object cache to ensure we do not create duplicate objects
    managedObjectStore.managedObjectCache = [[RKInMemoryManagedObjectCache alloc] initWithManagedObjectContext:managedObjectStore.persistentStoreManagedObjectContext];
    
    // init response descriptors
    [objectManager addResponseDescriptorsFromArray:[[DFResponseDescriptorsProvider sharedInstance] responseDescriptors]];
    
  
}

@end
