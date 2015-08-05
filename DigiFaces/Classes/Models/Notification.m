//
//  Notification.m
//  DigiFaces
//
//  Created by confiz on 27/06/2015.
//  Copyright (c) 2015 Usasha studio. All rights reserved.
//

#import "Notification.h"

@implementation Notification
/*
-(instancetype)initWithDictionary:(NSDictionary *)dict
{
    self = [super init];
    if (self) {
        self.activityID = [[dict valueForKey:@"ActivityId"] integerValue];
        _commenterUserInfo = [[UserInfo alloc] initWithDictioanry:[dict valueForKey:@"CommenterUserInfo"]];
        self.dateCreated = [dict valueForKey:@"DateCreated"];
        self.dateCreatedFormated = [dict valueForKey:@"DateCreatedFormatted"];
        self.isRead = [[dict valueForKey:@"IsRead"] boolValue];
        self.isDailyNotification = [[dict valueForKey:@"IsDailyDiaryNotification"] boolValue];
        self.notificationID = [[dict valueForKey:@"NotificationId"] integerValue];
        self.notificationType = [dict valueForKey:@"NotificationType"];
        self.notificationTypeID = [[dict valueForKey:@"NotificationTypeId"] integerValue];
        self.projectID = [[dict valueForKey:@"ProjectId"] integerValue];
        self.userID = [dict valueForKey:@"UserId"];
    }
    return self;
}*/

- (NotificationType)type {
    NSInteger t = self.notificationTypeId.integerValue;
    if (t == 1 || t == 2) {
        return NotificationTypeThreadComment;
    } else if (t == 3) {
        return NotificationTypeModeratorMessage;
    } else {
        return NotificationTypeUnknown;
    }
}

- (NSString*)usefulMessage {
    NSInteger t = self.notificationTypeId.integerValue;
    switch (t) {
        case 1:
            return @"New comment on your thread.";
            break;
        case 2:
            return @"New comment on a thread you commented on.";
            break;
        case 3:
            return @"New response to your message.";
        default:
            return self.notificationType;
            break;
    }
}
@end
