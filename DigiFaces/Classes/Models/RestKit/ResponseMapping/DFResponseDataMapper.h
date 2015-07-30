//
//  DFResponseDataMapper.h
//  DigiFaces
//
//  Created by James on 7/28/15.
//  Copyright (c) 2015 INET360. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DFResponseDataMapper : NSObject
+ (instancetype)sharedInstance;
- (RKObjectMapping*)tokenMapping;
- (RKObjectMapping*)userInfoMapping;
- (RKObjectMapping*)aboutMapping;
- (RKObjectMapping*)fileMapping;
- (RKObjectMapping*)projectMapping;
- (RKObjectMapping*)notificationsResponseMapping;
- (RKObjectMapping*)notificationMapping;
@end
