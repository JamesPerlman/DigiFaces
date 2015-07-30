//
//  DFConstants.m
//  DigiFaces
//
//  Created by James on 7/28/15.
//  Copyright (c) 2015 INET360. All rights reserved.
//

#import "DFConstants.h"


NSString * const APIServerAddress = @"http://digifacesservices.focusforums.com/";
NSString * const APIPathGetToken = @"Token";


// account
NSString * const APIPathGetUserInfo = @"api/Account/UserInfo";
NSString * const APIPathGetAboutMe = @"api/Account/GetAboutMe/:projectId";
NSString * const APIPathUpdateAboutMe = @"api/Account/UpdateAboutMe";
NSString * const APIPathUploadUserCustomAvatar = @"api/Account/UploadUserCustomAvatar";
NSString * const APIPathSendMessageToModerator = @"api/Account/SendMessageToModerator/:projectId/:parentMessageId";
NSString * const APIPathGetProjects = @"api/Account/GetProjects/:numberOfProjects";
NSString * const APIPathGetNotifications = @"api/Account/GetNotifications/:projectId";
NSString * const APIPathIsUserNameAvailable = @"api/Account/IsUserNameAvailable";
NSString * const APIPathSetUserName = @"api/Account/SetUserName";
NSString * const APIPathForgotPassword = @"api/Account/ForgotPassword";
NSString * const APIPathLogout = @"api/Account/Logout";

// activity
NSString * const APIPathActivityGetResponses = @"api/Activity/GetResponses/:activityId";
NSString * const APIPathActivityUpdateComment = @"api/Activity/UpdateComment";
NSString * const APIPathActivityUpdateThread = @"api/Activity/UpdateThread";
NSString * const APIPathActivityUpdateImageGalleryResponse = @"api/Activity/UpdateImageGalleryResponse";
NSString * const APIPathActivityUpdateTextareaResponse = @"api/Activity/UpdateTextareaResponse";
NSString * const APIPathActivityInsertThreadFile = @"api/Activity/InsertThreadFile/:projectId";

// system
NSString * const APIPathGetAbout = @"api/System/GetAbout/:languageCode";
NSString * const APIPathGetAvatarFiles = @"api/System/GetAvatarFiles";
NSString * const APIPathSendHelpMessage = @"api/System/SendHelpMessage";

// project
NSString * const APIPathGetHomeAnnouncement = @"api/Project/GetHomeAnnouncement/:projectId";
NSString * const APIPathGetDailyDiary = @"api/Project/GetDailyDiary/:diaryId";
NSString * const APIPathUpdateDailyDiary = @"api/Project/UpdateDailyDiary/:projectId";
NSString * const APIPathProjectGetActivities = @"api/Project/GetActivities/:projectId";


#pragma mark - LocalStorage keys
NSString * const LSAuthTokenKey = @"com.digifaces.api.auth_token";
NSString * const LSPasswordKey = @"com.digifaces.api.password";
NSString * const LSUsernameKey = @"com.digifaces.api.username";