//
//  UserManagerShared.m
//  DigiFaces
//
//  Created by Apple on 16/06/2015.
//  Copyright (c) 2015 Usasha studio. All rights reserved.
//

#import "UserManagerShared.h"

@implementation UserManagerShared
+ (instancetype)sharedManager {
    static UserManagerShared *sharedMyManager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedMyManager = [[self alloc] init];
    });
    return sharedMyManager;
}

- (id)init {
    if (self = [super init]) {
        self.projectsArray = [[NSArray alloc]init];
        self.profilePic = [UIImage imageNamed:@"dummy_avatar.png"];
    }
    return self;
}
-(void)setProfilePicDict:(NSDictionary*)profile
{
    _avatarFile = [[File alloc] initWithDictionary:profile];
}
/*
-(void)setUserInfoDictionary:(NSDictionary*)dict
{
    self.aboutMeText = [dict valueForKey:@"AboutMeText"];
    self.appUserName = [dict valueForKey:@"AppUserName"];
    self.ID = [dict valueForKey:@"Id"];
    self.email = [dict valueForKey:@"Email"];
    self.currentProjectID = [[dict valueForKey:@"CurrentProjectId"] integerValue];
    self.FirstName = [dict valueForKey:@"FirstName"];
    self.LastName = [dict valueForKey:@"LastName"];
    self.IsModerator = [[dict valueForKey:@"IsModerator"] boolValue];
    _info = [[UserInfo alloc] initWithDictioanry:dict];
    _avatarFile = [[File alloc] initWithDictionary:[dict valueForKey:@"AvatarFile"]];
    
    _currentProject = [[Project alloc] initWithDictionary:[dict valueForKey:@"CurrentProject"]];
}*/

@end
