//
//  UnreadAnnouncementCounts.h
//  DigiFaces
//
//  Created by James on 8/4/15.
//  Copyright (c) 2015 INET360. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface APIAlertCounts : NSObject
@property (nonatomic, strong) NSNumber *totalUnreadCount;
@property (nonatomic, strong) NSNumber *announcementUnreadCount;
@property (nonatomic, strong) NSNumber *messagesUnreadCount;
@property (nonatomic, strong) NSNumber *notificationsUnreadCount;

@end
