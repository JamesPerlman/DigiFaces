//
//  DFPushService.m
//  DigiFaces
//
//  Created by James on 12/15/15.
//  Copyright © 2015 INET360. All rights reserved.
//

#import "DFPushService.h"
#import <AirshipKit/AirshipKit.h>

@implementation DFPushService

+ (instancetype)manager {
    static DFPushService *_manager;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _manager = [[self alloc] init];
    });
    
    return _manager;
}

// TODO: Move all the urban airship stuff from the AppDelegate to here

- (void)syncDeviceToken {
    NSDictionary *params = @{@"ChannelId" : [[UAirship push] channelID],
                             @"UserId" : LS.myUserInfo.userId,
                             @"DeviceType" : @"ios"};
    [DFClient makeRequest:APIPathUARegisterDevice method:RKRequestMethodPOST params:params success:^(NSDictionary *response, id result) {
        NSLog(@"syncDeviceToken success");
    } failure:^(NSError *error) {
         NSLog(@"syncDeviceToken failure");
        // retry the request if it fails
    }];
}

@end
