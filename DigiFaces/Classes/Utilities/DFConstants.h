//
//  SDConstants.h
//  DigiFaces
//
//  Created by confiz on 20/06/2015.
//  Copyright (c) 2015 Usasha studio. All rights reserved.
//
#import <Foundation/Foundation.h>

#ifndef DigiFaces_SDConstants_h
#define DigiFaces_SDConstants_h

extern NSString * const DFLocalizedStringsDirectoryURLPath;
extern NSString * const DFLocalizedStringsFileExtension;
extern NSString * const DFLocalizationDidSynchronizeNotification;
extern NSTimeInterval const DFLocalizationSynchronizerUpdateInterval;

extern NSString * const APIServerAddress;

extern NSString * const DFAvatarGenericImageURLKey;

// Notifications
extern NSString * const DFNotificationDidChangeProject;

// misc api paths
extern NSString * const APIPathGetToken;
extern NSString * const APIPathUARegisterDevice;

// account
extern NSString * const APIPathChangeProject;
extern NSString * const APIPathGetProjects;
extern NSString * const APIPathGetUserInfo;
extern NSString * const APIPathGetAboutMe;
extern NSString * const APIPathUpdateAboutMe;
extern NSString * const APIPathUploadUserCustomAvatar;
extern NSString * const APIPathSendMessageToModerator;
extern NSString * const APIPathGetMessages;
extern NSString * const APIPathGetNotifications;
extern NSString * const APIPathIsUserNameAvailable;
extern NSString * const APIPathSetUserName;
extern NSString * const APIPathForgotPassword;
extern NSString * const APIPathReplyFromModerator;
extern NSString * const APIPathMarkMessageRead;
extern NSString * const APIPathMarkNotificationRead;
extern NSString * const APIPathLogout;

// activity
extern NSString * const APIPathActivityGetResponses;
extern NSString * const APIPathActivityUpdateComment;
extern NSString * const APIPathActivityUpdateInternalComment;
extern NSString * const APIPathActivityUpdateResearcherComment;
extern NSString * const APIPathActivityUpdateThread;
extern NSString * const APIPathActivityUpdateImageGalleryResponse;
extern NSString * const APIPathActivityUpdateTextareaResponse;
extern NSString * const APIPathActivityInsertThreadFile;
extern NSString * const APIPathActivityMarkThreadRead;
extern NSString * const APIPathActivityMarkCommentRead;

// project
extern NSString * const APIPathGetAlertCounts;
extern NSString * const APIPathGetHomeAnnouncement;
extern NSString * const APIPathGetDailyDiary;
extern NSString * const APIPathUpdateDailyDiary;
extern NSString * const APIPathProjectGetActivities;
extern NSString * const APIPathProjectMarkActivityRead;
extern NSString * const APIPathProjectMarkAnnouncementRead;
extern NSString * const APIPathProjectGetAnnouncements;

// system
extern NSString * const APIPathGetAbout;
extern NSString * const APIPathGetAvatarFiles;
extern NSString * const APIPathSendHelpMessage;
extern NSString * const APIPathGetLanguages;

#pragma mark - LocalStorage Keys
extern NSString * const LSAuthTokenKey;
extern NSString * const LSPasswordKey;
extern NSString * const LSUsernameKey;
extern NSString * const LSMyUserIdKey;
extern NSString * const LSMyLanguageCodeKey;



#define kPOST RKRequestMethodPOST
#define kGET RKRequestMethodGET
#define kPUT RKRequestMethodPUT


#pragma mark - Old, Messy vvv

typedef enum {
    ThemeTypeDisplayImage,
    ThemeTypeDisplayText,
    ThemeTypeMarkup,
    ThemeTypeImageGallery,
    ThemeTypeTextArea,
    ThemeTypeVideoResponse,
    ThemeTypeNone
}ThemeType;

/*
#define kS3AccessKey            @"AKIAIG2CIAZWZIA6L7YA"
#define kS3AccessSecret         @"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"
#define kS3Bucket               @"media.digifaces.com"
*/

#define kCognitoRegionType AWSRegionUSEast1
#define kS3DefaultServiceRegionType AWSRegionUSEast1
#define kCognitoIdentityPoolId @"us-east-1:633ad485-1e3e-49c4-9e3c-24382bf03749"//@"us-east-1:5e6119ff-7f36-4c36-be82-8b8eb5ff0ae9"
#define kS3BucketName @"ios.digifaces.com"//@"kar8g944" // TESTING ONLY
#define kS3URLSubdomain @"s3"


#define kCurrentPorjectID       @"CurrentProjectId"
#define kAboutMeText            @"AboutMeText"
#define kEmail                  @"Email"
#define kImageURL               @"ImageURL"

#define kViddlerAPIURL @"https://api.viddler.com/api/v2"

#define kBaseURL @"http://digifacesservices.focusforums.com/"

#define kGetHomeAnnouncements   @"api/Project/GetHomeAnnouncement/{projectId}"
#define kAboutMeUpdate          @"api/Account/UpdateAboutMe"
#define kSendHelpMessage        @"api/System/SendHelpMessage"
#define kModeratorMessage       @"api/Account/SendMessageToModerator/{projectId}/{parentMessageId}"
#define kUpdateAvatar           @"api/Account/UploadUserCustomAvatar"
#define kAboutDigifaces         @"api/System/GetAbout/{languageCode}"
#define kUploadCustomAvatar     @"api/Account/UploadUserCustomAvatar"
#define kDailyDiaryInfo         @"api/Project/GetDailyDiary/{diaryId}"
#define kGetNotifications       @"api/Account/GetNotifications/{projectId}"
#define kGetResponses           @"api/Activity/GetResponses/{activityId}"
#define kUpdateComments         @"api/Activity/UpdateComment"
#define kGetAboutMe             @"api/Account/GetAboutMe/{projectId}"
#define kGetActivties           @"api/Project/GetActivities/{projectId}"
#define kUpdateThread           @"api/Activity/UpdateThread"
#define kUpdateDailyDiary       @"api/Project/UpdateDailyDiary/{projectId}"
#define kUpdateTextAreaResponse @"api/Activity/UpdateTextareaResponse"
#define kUpdateGalleryResponse  @"api/Activity/UpdateImageGalleryResponse"
#define kInsertThreadFile       @"api/Activity/InsertThreadFile/{projectId}"

#define kFFGetViddlerCredentialsURL @"https://app.focusforums.com/viddler/uploadvariables.aspx"

#endif
