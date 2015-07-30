//
//  LocalStorage.m
//  Jarvis
//
//  Created by James on 5/9/15.
//  Copyright (c) 2015 Jarvis. All rights reserved.
//

#define DEFAULTS [NSUserDefaults standardUserDefaults]
#define KEYCHAIN [FXKeychain defaultKeychain]

#import "LocalStorage.h"
#import <FXKeychain/FXKeychain.h>

@implementation LocalStorage

+ (instancetype)proxy
{
    static LocalStorage *_sharedInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _sharedInstance = [[LocalStorage alloc] init];
    });
    
    return _sharedInstance;
}

#pragma mark - Local Data Accessors

- (NSString*)apiAuthToken {
    return [DEFAULTS stringForKey:LSAuthTokenKey];
}

- (void)setApiAuthToken:(NSString*)authToken {
    if (nil == authToken) {
        [DEFAULTS removeObjectForKey:LSAuthTokenKey];
    } else {
        [DEFAULTS setObject:authToken forKey:LSAuthTokenKey];
        [DEFAULTS synchronize];
    }
}

- (id)objectForKeyedSubscript:(NSString *)key {
    return [DEFAULTS objectForKey:key];
}

- (void)setObject:(id)obj forKeyedSubscript:(NSString *)key {
    if (obj == nil) {
        [DEFAULTS removeObjectForKey:key];
    } else {
        [DEFAULTS setObject:obj forKey:key];
    }
    [DEFAULTS synchronize];
}

#pragma mark - Keychain Data Accessors

- (NSString*)loginPassword {
    return [KEYCHAIN objectForKey:LSPasswordKey];
}

- (void)setLoginPassword:(NSString *)loginPassword {
    if (nil == loginPassword)
        [KEYCHAIN removeObjectForKey:LSPasswordKey];
    else
        [KEYCHAIN setObject:loginPassword forKey:LSPasswordKey];
}

- (NSString*)loginUsername {
    return [KEYCHAIN objectForKey:LSUsernameKey];
}

- (void)setLoginUsername:(NSString *)loginUsername {
    if (nil == loginUsername)
        [KEYCHAIN removeObjectForKey:LSUsernameKey];
    else
        [KEYCHAIN setObject:loginUsername forKey:LSUsernameKey];
}

@end
