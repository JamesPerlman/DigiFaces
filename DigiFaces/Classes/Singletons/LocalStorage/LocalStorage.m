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
#import "UserInfo.h"

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

- (UserInfo*)myUserInfo {
    if (_myUserInfo) {
        return _myUserInfo;
    } else {
        // try looking in CoreData db
        NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
        NSEntityDescription *entity = [NSEntityDescription entityForName:@"UserInfo" inManagedObjectContext:self.managedObjectContext];
        [fetchRequest setEntity:entity];
        // Specify criteria for filtering which objects to fetch
        NSPredicate *predicate = [NSPredicate predicateWithFormat:@"id = %@", LS[LSMyUserIdKey]];
        [fetchRequest setPredicate:predicate];
        // Specify how the fetched objects should be sorted
        NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"id"
                                                                       ascending:YES];
        [fetchRequest setSortDescriptors:[NSArray arrayWithObjects:sortDescriptor, nil]];
        
        NSError *error = nil;
        NSArray *fetchedObjects = [self.managedObjectContext executeFetchRequest:fetchRequest error:&error];
        if (fetchedObjects == nil) {
            return nil;
        } else {
            _myUserInfo = fetchedObjects.firstObject;
            return _myUserInfo;
        }
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

#pragma mark - CoreData

- (NSManagedObjectContext*)managedObjectContext {
    return [RKObjectManager sharedManager].managedObjectStore.mainQueueManagedObjectContext;
}

@end
