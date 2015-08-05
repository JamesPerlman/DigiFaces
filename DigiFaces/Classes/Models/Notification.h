//
//  Notification.h
//  DigiFaces
//
//  Created by confiz on 27/06/2015.
//  Copyright (c) 2015 Usasha studio. All rights reserved.
//
typedef enum : NSUInteger {
    NotificationTypeThreadComment,
    NotificationTypeModeratorMessage,
    NotificationTypeUnknown
} NotificationType;

#import <Foundation/Foundation.h>
#import "UserInfo.h"

@interface Notification : NSObject

@property (nonatomic, retain) UserInfo * commenterUserInfo;
@property (nonatomic, strong) NSNumber * activityId;
@property (nonatomic, retain) NSString * dateCreated;
@property (nonatomic, retain) NSString * dateCreatedFormatted;
@property (nonatomic, strong) NSNumber * isDailyDiaryNotification;
@property (nonatomic, strong) NSNumber * isRead;
@property (nonatomic, strong) NSNumber * notificationId;
@property (nonatomic, retain) NSString * notificationType;
@property (nonatomic, strong) NSNumber * notificationTypeId;
@property (nonatomic, strong) NSNumber * projectId;
@property (nonatomic, strong) NSNumber * referenceId;
@property (nonatomic, strong) NSNumber * referenceId2;
@property (nonatomic, retain) NSString * userId;

- (NSString *)usefulMessage;
- (NotificationType)type;

@end
