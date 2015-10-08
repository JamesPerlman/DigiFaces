//
//  LocalStorage.h
//  Jarvis
//
//  Created by James on 5/9/15.
//  Copyright (c) 2015 Jarvis. All rights reserved.
//

#define LS [LocalStorage proxy]

#import <Foundation/Foundation.h>

#import "UserInfo.h"

@interface LocalStorage : NSObject

+ (instancetype)proxy;

@property (nonatomic) NSString *apiAuthToken;
@property (nonatomic) NSString *loginUsername;
@property (nonatomic) NSString *loginPassword;

@property (nonatomic, readonly) NSNumber *currentProjectId;

@property (nonatomic, strong) UserInfo *myUserInfo;

- (id)objectForKeyedSubscript:(NSString*)key;
- (void)setObject:(id)obj forKeyedSubscript:(NSString*)key;


- (void)setMyUserInfo:(UserInfo *)myUserInfo;
@end
