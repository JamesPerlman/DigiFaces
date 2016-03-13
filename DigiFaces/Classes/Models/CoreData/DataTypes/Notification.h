//
//  Notification.h
//  
//
//  Created by James on 9/11/15.
//
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class UserInfo;

@interface Notification : NSManagedObject

@property (nonatomic, retain) NSNumber * activityId;
@property (nonatomic, retain) NSString * activityName;
@property (nonatomic, retain) NSString * dateCreated;
@property (nonatomic, retain) NSString * dateCreatedFormatted;
@property (nonatomic, retain) NSNumber * isDailyDiaryNotification;
@property (nonatomic, retain) NSNumber * isRead;
@property (nonatomic, retain) NSNumber * notificationId;
@property (nonatomic, retain) NSString * notificationType;
@property (nonatomic, retain) NSNumber * notificationTypeId;
@property (nonatomic, retain) NSNumber * projectId;
@property (nonatomic, retain) NSNumber * referenceId;
@property (nonatomic, retain) NSNumber * referenceId2;
@property (nonatomic, retain) NSString * userId;
@property (nonatomic, retain) UserInfo *commenterUserInfo;

@end

typedef enum : NSUInteger {
    NotificationTypeThreadComment,
    NotificationTypeModeratorMessage,
    NotificationTypeUnknown
} NotificationType;

@interface Notification (DynamicMethods)

- (NSString *)usefulMessage;
- (NotificationType)type;

@end
