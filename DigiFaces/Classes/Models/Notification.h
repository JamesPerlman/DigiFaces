//
//  Notification.h
//  DigiFaces
//
//  Created by confiz on 27/06/2015.
//  Copyright (c) 2015 Usasha studio. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "UserInfo.h"

@interface Notification : NSObject

@property (nonatomic, retain) UserInfo * commenterUserInfo;
@property (nonatomic, strong) NSNumber * activityId;
@property (nonatomic, retain) NSString * dateCreated;
@property (nonatomic, retain) NSString * dateCreatedFormated;
@property (nonatomic, strong) NSNumber * isDailyNotification;
@property (nonatomic, strong) NSNumber * isRead;
@property (nonatomic, strong) NSNumber * notificationId;
@property (nonatomic, retain) NSString * notificationType;
@property (nonatomic, strong) NSNumber * notificationTypeId;
@property (nonatomic, strong) NSNumber * projectId;
@property (nonatomic, retain) NSString * userId;


@end
