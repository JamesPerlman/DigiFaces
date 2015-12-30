//
//  DFPushService.m
//  DigiFaces
//
//  Created by James on 12/15/15.
//  Copyright © 2015 INET360. All rights reserved.
//

#define kUAPushChannelIDKeyPath @"channelID"
#define kLSMyUserIDKeyPath @"myUserInfo"

static NSString * const kDFPSAppIdentifier = @"com.shamsu.digifaces3";

#import "DFPushService.h"
#import <AirshipKit/AirshipKit.h>
#import <LNNotificationsUI/LNNotificationsUI.h>

@implementation DFPushService

+ (instancetype)manager {
    static DFPushService *_manager;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _manager = [[self alloc] init];
    });
    
    return _manager;
}

+ (void)begin {
    static BOOL didBegin = false;
    if (!didBegin) {
        didBegin = true;
        /*****  URBAN AIRSHIP ***/
        // Call takeOff (which creates the UAirship singleton)
        [UAirship takeOff];
        
        // User notifications will not be enabled until userPushNotificationsEnabled is
        // set YES on UAPush. Once enabled, the setting will be persisted and the user
        // will be prompted to allow notifications. Normally, you should wait for a more
        // appropriate time to enable push to increase the likelihood that the user will
        // accept notifications.
        [UAirship push].userPushNotificationsEnabled = YES;
        
        [UAirship push].userNotificationTypes = (UIUserNotificationTypeAlert |
                                                 UIUserNotificationTypeBadge |
                                                 UIUserNotificationTypeSound);
        
        [[self manager] beginObservingPushReadiness];
        
        /* LNNotificationsUI */
        [[LNNotificationCenter defaultCenter] registerApplicationWithIdentifier:kDFPSAppIdentifier name:@"DigiFaces" icon:[UIImage imageNamed:@"plus"] defaultSettings:LNNotificationDefaultAppSettings];
    }
    
}


// TODO: Move all the urban airship stuff from the AppDelegate to here

- (void)syncDeviceToken {
    static BOOL didSyncDeviceToken = false;
    NSString *userID = LS.myUserInfo.userId;
    NSString *channelID = [[UAirship push] channelID];
    
    if (!didSyncDeviceToken && userID != nil && channelID != nil) {
        didSyncDeviceToken = true;
        NSDictionary *params = @{@"ChannelId" : channelID,
                                 @"UserId" : userID,
                                 @"DeviceType" : @"ios"};
        [DFClient makeRequest:APIPathUARegisterDevice method:RKRequestMethodPOST params:params success:^(NSDictionary *response, id result) {
            NSLog(@"syncDeviceToken success");
        } failure:^(NSError *error) {
            NSLog(@"syncDeviceToken failure");
            // retry the request if it fails
        }];
    }
}

#pragma mark - App Triggers
- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken {
    UA_LTRACE(@"Application registered for remote notifications with device token: %@", deviceToken);
    [[UAirship push] appRegisteredForRemoteNotificationsWithDeviceToken:deviceToken];
}

- (void)application:(UIApplication *)application didRegisterUserNotificationSettings:(UIUserNotificationSettings *)notificationSettings {
    UA_LTRACE(@"Application did register with user notification types %ld", (unsigned long)notificationSettings.types);
    [[UAirship push] appRegisteredUserNotificationSettings];
}

- (void)application:(UIApplication *)application didFailToRegisterForRemoteNotificationsWithError:(NSError *) error {
    UA_LERR(@"Application failed to register for remote notifications with error: %@", error);
}

- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo {
    UA_LINFO(@"Application received remote notification: %@", userInfo);
    [[UAirship push] appReceivedRemoteNotification:userInfo applicationState:application.applicationState];
    [self handleNotification:userInfo application:application];
}

-(void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo fetchCompletionHandler:(void (^)(UIBackgroundFetchResult))completionHandler {
    UA_LINFO(@"Application received remote notification: %@", userInfo);
    [[UAirship push] appReceivedRemoteNotification:userInfo applicationState:application.applicationState fetchCompletionHandler:completionHandler];
    [self handleNotification:userInfo application:application];
}

- (void)handleNotification:(NSDictionary*)userInfo application:(UIApplication*)application {
    BOOL fromBackground = ( application.applicationState == UIApplicationStateInactive || application.applicationState == UIApplicationStateBackground );
    
    if (!fromBackground) {
        // show LNNotificationsUI
        LNNotification* notification = [LNNotification notificationWithMessage:userInfo[@"aps"][@"alert"]];
        notification.title = @"DigiFaces";
        notification.defaultAction = [LNNotificationAction actionWithTitle:@"Default Action" handler:^(LNNotificationAction *action) {
            NSLog(@"Handled notification action");
        }];
        // Present the LNNotification UI
        [[LNNotificationCenter defaultCenter] presentNotification:notification forApplicationIdentifier:kDFPSAppIdentifier];
    }
}

- (void)application:(UIApplication *)application handleActionWithIdentifier:(NSString *)identifier forRemoteNotification:(NSDictionary *)userInfo completionHandler:(void (^)())handler {
    UA_LINFO(@"Received remote notification button interaction: %@ notification: %@", identifier, userInfo);
    [[UAirship push] appReceivedActionWithIdentifier:identifier notification:userInfo applicationState:application.applicationState completionHandler:handler];
}


#pragma mark - KVO
- (void)beginObservingPushReadiness {
    [LS addObserver:self forKeyPath:kLSMyUserIDKeyPath options:NSKeyValueObservingOptionNew context:nil];
    [[UAirship push] addObserver:self forKeyPath:kUAPushChannelIDKeyPath options:NSKeyValueObservingOptionNew context:nil];
}

- (void)stopObservingPushReadiness {
    [LS removeObserver:self forKeyPath:kLSMyUserIDKeyPath];
    [[UAirship push] removeObserver:self forKeyPath:kUAPushChannelIDKeyPath];
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSString *,id> *)change context:(void *)context {
    BOOL hasNewChannelID = ([object isEqual:[UAirship push]] && [keyPath isEqualToString:kUAPushChannelIDKeyPath]);
    BOOL hasNewUserID = ([object isEqual:LS] && [keyPath isEqualToString:kLSMyUserIDKeyPath]);
    if (hasNewChannelID || hasNewUserID) {
        [self syncDeviceToken];
    }
}

#pragma mark - TearDown

- (void)dealloc {
    [self stopObservingPushReadiness];
}

@end
