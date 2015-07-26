//
//  SDConstants.h
//  DigiFaces
//
//  Created by confiz on 20/06/2015.
//  Copyright (c) 2015 Usasha studio. All rights reserved.
//

#ifndef DigiFaces_SDConstants_h
#define DigiFaces_SDConstants_h


typedef enum {
    ThemeTypeDisplayImage,
    ThemeTypeDisplayText,
    ThemeTypeMarkup,
    ThemeTypeImageGallery,
    ThemeTypeTextArea,
    ThemeTypeNone
}ThemeType;

/*
#define kS3AccessKey            @"AKIAIG2CIAZWZIA6L7YA"
#define kS3AccessSecret         @"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"
#define kS3Bucket               @"media.digifaces.com"
*/

#define kCognitoRegionType AWSRegionUSEast1
#define kS3DefaultServiceRegionType AWSRegionUSWest2
#define kCognitoIdentityPoolId @"us-east-1:5e6119ff-7f36-4c36-be82-8b8eb5ff0ae9"
#define kS3BucketName @"kar8g944" // TESTING ONLY
#define kS3URLSubdomain @"s3-us-west-2"


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
