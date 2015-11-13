//
//  Notification.m
//  
//
//  Created by James on 9/11/15.
//
//

#import "Notification.h"
#import "UserInfo.h"


@implementation Notification

@dynamic activityId;
@dynamic dateCreated;
@dynamic dateCreatedFormatted;
@dynamic isDailyDiaryNotification;
@dynamic isRead;
@dynamic notificationId;
@dynamic notificationType;
@dynamic notificationTypeId;
@dynamic projectId;
@dynamic referenceId;
@dynamic referenceId2;
@dynamic userId;
@dynamic commenterUserInfo;

@end

@implementation Notification (DynamicMethods)

- (NotificationType)type {
    NSInteger t = self.notificationTypeId.integerValue;
    if (t == 1 || t == 2 || t == 3) {
        return NotificationTypeThreadComment;
    }/* else if (t == 3) {
        return NotificationTypeModeratorMessage;
    } */else {
        return NotificationTypeUnknown;
    }
}

- (NSString*)usefulMessage {
    NSInteger t = self.notificationTypeId.integerValue;
    switch (t) {
        case 1:
            return DFLocalizedString(@"app.notification.new_thread_comment", nil);
            break;
        case 2:
            return DFLocalizedString(@"app.notification.new_comment_on_my_thread", nil);
            break;
        case 3:
            return DFLocalizedString(@"app.notification.new_thread_response", nil);
        default:
            return self.notificationType;
            break;
    }
}

@end
