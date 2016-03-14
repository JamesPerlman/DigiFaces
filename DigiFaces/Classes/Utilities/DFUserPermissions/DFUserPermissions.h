//
//  DFUserPermissions.h
//  DigiFaces
//
//  Created by James on 3/13/16.
//  Copyright © 2016 INET360. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DFUserPermissions : NSObject

- (instancetype)initWithUserInfo:(UserInfo*)userInfo;

// email mods
- (BOOL)canEmailMods;

// responses
- (BOOL)canAddResponses;

// internal notes (internal comments)
- (BOOL)canViewInternalComments;
- (BOOL)canAddInternalComments;

// notes (researcher comments)
- (BOOL)canViewResearcherComments;
- (BOOL)canAddResearcherComments;

// comments
- (BOOL)canAddComments;


@end
