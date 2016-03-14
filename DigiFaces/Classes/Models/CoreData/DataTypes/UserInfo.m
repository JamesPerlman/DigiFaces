//
//  UserInfo.m
//  
//
//  Created by James on 9/11/15.
//
//

#import "UserInfo.h"
#import "File.h"
#import "Project.h"


@implementation UserInfo

@dynamic aboutMeText;
@dynamic appUserName;
@dynamic avatarFileId;
@dynamic currentProjectId;
@dynamic defaultLanguageId;
@dynamic email;
@dynamic firstName;
@dynamic hasRegistered;
@dynamic id;
@dynamic isModerator;
@dynamic isUserNameSet;
@dynamic lastName;
@dynamic loginProvider;
@dynamic password;
@dynamic userId;
@dynamic userName;
@dynamic avatarFile;
@dynamic currentProject;
@dynamic projectRoleId;
@dynamic projects;


@end

@implementation UserInfo (DynamicMethods)

- (BOOL)canEmailMods {
    return ![self.projectRoleId isEqualToNumber:@1];
}

- (BOOL)canReplyToDiaries {
    return !([self.projectRoleId isEqualToNumber:@1] || [self.projectRoleId isEqualToNumber:@3] || [self.projectRoleId isEqualToNumber:@4]);
}

- (BOOL)canReplyToThemes {
    return [self canReplyToDiaries];
}

- (BOOL)canAddComments {
    return !([self.projectRoleId isEqualToNumber:@3] || [self.projectRoleId isEqualToNumber:@4]);
}


@end
