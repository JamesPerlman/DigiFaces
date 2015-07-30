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
@property (nonatomic, strong) NSNumber * activityID;
@property (nonatomic, retain) NSString * dateCreated;
@property (nonatomic, retain) NSString * dateCreatedFormated;
@property (nonatomic, strong) NSNumber * isDailyNotification;
@property (nonatomic, strong) NSNumber * isRead;
@property (nonatomic, strong) NSNumber * notificationID;
@property (nonatomic, retain) NSString * notificationType;
@property (nonatomic, strong) NSNumber * notificationTypeID;
@property (nonatomic, strong) NSNumber * projectID;
@property (nonatomic, retain) NSString * userID;


@end
