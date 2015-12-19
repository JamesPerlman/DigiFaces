//
//  DFConstants.m
//  DigiFaces
//
//  Created by James on 7/28/15.
//  Copyright (c) 2015 INET360. All rights reserved.
//

#import "DFConstants.h"

NSString * const DFLocalizedStringsDirectoryURLPath = @"http://digifacesservices.focusforums.com/localization/"; //@"http://192.168.0.2/~home/DigiFaces/";
NSString * const DFLocalizedStringsFileExtension = @"txt"; //@"strings";
NSString * const DFLocalizationDidSynchronizeNotification = @"com.inet360.digifaces.notification.localizationDidSync";
NSTimeInterval const DFLocalizationSynchronizerUpdateInterval = 60;

NSString * const APIServerAddress = @"http://digifacesservices.focusforums.com/";

NSString * const DFAvatarGenericImageURLKey = @"https://www.digifaces.com/img/genericavatar.gif";

// notifications
NSString * const DFNotificationDidChangeProject = @"com.digifaces.notification.didChangeProject";

// misc
NSString * const APIPathGetToken = @"Token";
NSString * const APIPathUARegisterDevice = @"api/UrbanAirship/RegisterDevice";

// account
NSString * const APIPathChangeProject = @"api/Account/ChangeProject";
NSString * const APIPathGetUserInfo = @"api/Account/UserInfo";
NSString * const APIPathGetAboutMe = @"api/Account/GetAboutMe/:projectId";
NSString * const APIPathUpdateAboutMe = @"api/Account/UpdateAboutMe";
NSString * const APIPathUploadUserCustomAvatar = @"api/Account/UploadUserCustomAvatar";
NSString * const APIPathSendMessageToModerator = @"api/Account/SendMessageToModerator/:projectId/:parentMessageId";
NSString * const APIPathGetProjects = @"api/Account/GetProjects/:numberOfProjects";
NSString * const APIPathGetMessages = @"api/Account/GetMessages/:projectId";
NSString * const APIPathGetNotifications = @"api/Account/GetNotifications/:projectId";
NSString * const APIPathIsUserNameAvailable = @"api/Account/IsUserNameAvailable";
NSString * const APIPathSetUserName = @"api/Account/SetUserName";
NSString * const APIPathForgotPassword = @"api/Account/ForgotPassword";
NSString * const APIPathReplyFromModerator = @"api/Account/ReplyFromModerator/:projectId/:parentMessageId";
NSString * const APIPathMarkMessageRead = @"api/Account/MarkMessageRead/:messageId";
NSString * const APIPathMarkNotificationRead = @"api/Account/MarkNotificationRead/:notificationId";
NSString * const APIPathLogout = @"api/Account/Logout";

// activity
NSString * const APIPathActivityGetResponses = @"api/Activity/GetResponses/:activityId";
NSString * const APIPathActivityUpdateComment = @"api/Activity/UpdateComment";
NSString * const APIPathActivityUpdateThread = @"api/Activity/UpdateThread";
NSString * const APIPathActivityUpdateImageGalleryResponse = @"api/Activity/UpdateImageGalleryResponse";
NSString * const APIPathActivityUpdateTextareaResponse = @"api/Activity/UpdateTextareaResponse";
NSString * const APIPathActivityInsertThreadFile = @"api/Activity/InsertThreadFile/:projectId";
NSString * const APIPathActivityMarkThreadRead = @"api/Activity/MarkThreadRead/:threadId";
NSString * const APIPathActivityMarkCommentRead = @"api/Activity/MarkCommentRead/:commentId";

// system
NSString * const APIPathGetAbout = @"api/System/GetAbout/:languageCode";
NSString * const APIPathGetAvatarFiles = @"api/System/GetAvatarFiles";
NSString * const APIPathSendHelpMessage = @"api/System/SendHelpMessage";

// project
NSString * const APIPathGetAlertCounts = @"api/Project/GetAlertsCount/:projectId";
NSString * const APIPathGetHomeAnnouncement = @"api/Project/GetHomeAnnouncement/:projectId";
NSString * const APIPathGetDailyDiary = @"api/Project/GetDailyDiary/:diaryId";
NSString * const APIPathUpdateDailyDiary = @"api/Project/UpdateDailyDiary/:projectId";
NSString * const APIPathProjectGetActivities = @"api/Project/GetActivities/:projectId";//:activityId";
NSString * const APIPathProjectMarkActivityRead = @"api/Project/MarkActivityRead/:activityId";
NSString * const APIPathProjectMarkAnnouncementRead = @"api/Project/MarkAnnouncementRead/:announcementId";
NSString * const APIPathProjectGetAnnouncements = @"api/Project/GetAnnouncements/:projectId";

#pragma mark - LocalStorage keys
NSString * const LSAuthTokenKey = @"com.digifaces.api.auth_token";
NSString * const LSPasswordKey = @"com.digifaces.api.password";
NSString * const LSUsernameKey = @"com.digifaces.api.username";
NSString * const LSMyUserIdKey = @"com.digifaces.var.myUserId";