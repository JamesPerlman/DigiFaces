//
//  Message.h
//  DigiFaces
//
//  Created by James on 8/4/15.
//  Copyright (c) 2015 INET360. All rights reserved.
//

#import <Foundation/Foundation.h>
@class UserInfo;

@interface Message : NSObject

@property (nonatomic, strong) NSNumber *messageId;
@property (nonatomic, strong) NSNumber *projectId;
@property (nonatomic, retain) NSString *fromUser;
@property (nonatomic, strong) UserInfo *fromUserInfo;
@property (nonatomic, retain) NSString *toUser;
@property (nonatomic, strong) UserInfo *toUserInfo;
@property (nonatomic, retain) NSString *subject;
@property (nonatomic, retain) NSString *response;
@property (nonatomic, retain) NSString *dateCreated;
@property (nonatomic, retain) NSString *dateCreatedFormatted;
@property (nonatomic, strong) NSNumber *isRead;
@property (nonatomic, strong) NSArray *childMessages;

@end
