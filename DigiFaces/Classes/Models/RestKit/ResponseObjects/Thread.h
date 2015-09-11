//
//  Thread.h
//  DigiFaces
//
//  Created by James on 7/29/15.
//  Copyright (c) 2015 INET360. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Thread : NSManagedObject

@property (nonatomic, strong) NSNumber *threadId;
@property (nonatomic, strong) NSNumber *activityId;
@property (nonatomic, strong) NSNumber *isDraft;
@property (nonatomic, strong) NSNumber *isActive;

@end
