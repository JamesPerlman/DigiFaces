//
//  DFUserPermissions.m
//  DigiFaces
//
//  Created by James on 3/13/16.
//  Copyright © 2016 INET360. All rights reserved.
//

#import "DFUserPermissions.h"
#import "UserInfo.h"

typedef NSUInteger bitmask;

typedef NS_OPTIONS(bitmask, kDFContentType) {
    kDFContentTypeModeratorEmail = 1 << 0,
    kDFContentTypeResponse = 1 << 1,
    kDFContentTypeComment = 1 << 2,
    kDFContentTypeResearcherComment = 1 << 3,
    kDFContentTypeInternalComment = 1 << 4
};

typedef enum kDFUserRole {
    kDFUserRoleModerator = 1,
    kDFUserRoleParticipant = 2,
    kDFUserRoleClient = 3,
    kDFUserRoleResearcher = 4
} kDFUserRole;

@interface DFUserPermissions ()

@property (nonatomic) bitmask read;
@property (nonatomic) bitmask write;

@end

@implementation DFUserPermissions

- (instancetype)initWithUserInfo:(UserInfo*)userInfo {
    if (userInfo != nil &&
        userInfo.projectRoleId != nil &&
        (self = [super init])) {
        
        kDFUserRole role = (kDFUserRole)userInfo.projectRoleId.integerValue;
        self.read = [self readPermissionsForRole:role];
        self.write = [self writePermissionsForRole:role];
    }
    return self;
}

#pragma mark - Permissions
// https://docs.google.com/spreadsheets/d/1NzSOOQG70JaBTWlMUesd8ZS-g8YVXwjAzBgznBsV15c/edit#gid=0
- (bitmask)basicReadPermissions {
    return kDFContentTypeResponse | kDFContentTypeComment;
}

- (bitmask)basicWritePermissions {
    return 0;
}

- (bitmask)readPermissionsForRole:(kDFUserRole)role {
    
    bitmask perms = [self basicReadPermissions];
    
    switch (role) {
        case kDFUserRoleModerator: {
            perms |= kDFContentTypeInternalComment;
            perms |= kDFContentTypeResearcherComment;
        } break;
        case kDFUserRoleParticipant: {
            perms |= kDFContentTypeModeratorEmail;
        } break;
        case kDFUserRoleClient: {
            perms |= kDFContentTypeModeratorEmail;
            perms |= kDFContentTypeResearcherComment;
        } break;
        case kDFUserRoleResearcher: {
            perms |= kDFContentTypeModeratorEmail;
            perms |= kDFContentTypeInternalComment;
            perms |= kDFContentTypeResearcherComment;
        }
        default: break;
    }
    
    return perms;
}

- (bitmask)writePermissionsForRole:(kDFUserRole)role {
    
    bitmask perms = [self basicWritePermissions];
    
    switch (role) {
        case kDFUserRoleModerator: {
            perms |= kDFContentTypeComment;
            perms |= kDFContentTypeInternalComment;
            perms |= kDFContentTypeResearcherComment;
        } break;
        case kDFUserRoleParticipant: {
            perms |= kDFContentTypeModeratorEmail;
            perms |= kDFContentTypeResponse;
            perms |= kDFContentTypeComment;
        } break;
        case kDFUserRoleClient: {
            perms |= kDFContentTypeModeratorEmail;
            perms |= kDFContentTypeResearcherComment;
            
        } break;
        case kDFUserRoleResearcher: {
            perms |= kDFContentTypeModeratorEmail;
            perms |= kDFContentTypeInternalComment;
            perms |= kDFContentTypeResearcherComment;
        } break;
        default: break;
    }
    return perms;
}


- (BOOL)canEmailMods {
    return self.write & kDFContentTypeModeratorEmail;
}

- (BOOL)canAddResponses {
    return self.write & kDFContentTypeResponse;
}

// internal notes (internal comments)
- (BOOL)canViewInternalComments {
    return self.read & kDFContentTypeInternalComment;
}

- (BOOL)canAddInternalComments {
    return self.write & kDFContentTypeInternalComment;
}

// notes (researcher comments)
- (BOOL)canViewResearcherComments {
    return self.read & kDFContentTypeResearcherComment;
}

- (BOOL)canAddResearcherComments {
    return self.write & kDFContentTypeResearcherComment;
}

// comments

- (BOOL)canAddComments {
    return self.write & kDFContentTypeComment;
}


@end
