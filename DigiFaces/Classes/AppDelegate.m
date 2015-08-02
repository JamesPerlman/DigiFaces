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
#import "RKCustomBOOLTransformer.h"

#import "DFResponseDescriptorsProvider.h"
@interface AppDelegate ()
{
    Reachability * internetReachable;
    NointernetController * noInternetContrller;
}
@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    [Fabric with:@[CrashlyticsKit]];
    [self setupRestKit];
    // Override point for customization after application launch.

    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(checkNetworkStatus:) name:kReachabilityChangedNotification object:nil];
    
    internetReachable = [Reachability reachabilityForInternetConnection];
    [internetReachable startNotifier];
    
    [[UIApplication sharedApplication] setStatusBarHidden:YES];
    
    [[UINavigationBar appearance] setBarTintColor:[UIColor blackColor]];
    [[UINavigationBar appearance] setTitleTextAttributes:@{NSForegroundColorAttributeName : [UIColor colorWithRed:38/255.0f green:218/255.0f blue:1 alpha:1]}];
    [[UINavigationBar appearance] setTintColor:[UIColor whiteColor]];
    
    
    
    UIStoryboard * storyBoard = [UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]];
    
    UIViewController * rootViewController = [storyBoard instantiateViewControllerWithIdentifier:@"loginController"];

    UINavigationController * navController = [[UINavigationController alloc] initWithRootViewController:rootViewController];
    
    
    [self.window setRootViewController:navController];
    [self.window makeKeyAndVisible];

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
    NSLog(@"Network status: %i", internetStatus);
    
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
                                  initWithTitle:NSLocalizedString(@"No network connection", @"No network connection")
                                  message:NSLocalizedString(@"The Internet connection appears to be offline",
                                                            nil)
                                  delegate:nil
                                  cancelButtonTitle:NSLocalizedString(@"OK",  @"OK")
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
    [objectManager addResponseDescriptorsFromArray:[[DFResponseDescriptorsProvider sharedInstance] responseDescriptors]];
    [[RKValueTransformer defaultValueTransformer]
     insertValueTransformer:[RKCustomBOOLTransformer defaultTransformer] atIndex:0];
    
  
}

@end
