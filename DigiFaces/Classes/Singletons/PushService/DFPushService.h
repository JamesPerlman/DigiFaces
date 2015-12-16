//
//  DFPushService.h
//  DigiFaces
//
//  Created by James on 12/15/15.
//  Copyright © 2015 INET360. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DFPushService : NSObject

+ (DFPushService*)manager;

- (void)syncDeviceToken;

@end
