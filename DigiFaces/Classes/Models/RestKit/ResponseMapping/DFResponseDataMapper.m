//
//  DFResponseDataMapper.m
//  DigiFaces
//
//  Created by James on 7/28/15.
//  Copyright (c) 2015 INET360. All rights reserved.
//
#define MAPCLASS(classType) [RKObjectMapping mappingForClass:[classType class]]

#import "DFResponseDataMapper.h"

#import "APITokenResponse.h"
#import "APIIsUserNameAvailableResponse.h"
#import "APISetUserNameResponse.h"
#import "APIHomeAnnouncementResponse.h"

#import "UserInfo.h"
#import "About.h"
#import "AboutMe.h"
#import "Announcement.h"
#import "APIAlertCounts.h"
#import "Comment.h"
#import "DailyDiary.h"
#import "DailyDiaryResponse.h"
#import "Diary.h"
#import "DiaryTheme.h"
#import "DisplayText.h"
#import "DisplayFile.h"
#import "File.h"
#import "ImageGallery.h"
#import "ImageGalleryResponse.h"
#import "MarkUp.h"
#import "Message.h"
#import "Module.h"
#import "Notification.h"
#import "Project.h"
#import "Response.h"
#import "Textarea.h"
#import "TextareaResponse.h"
#import "Thread.h"


#import "NSArray+RKHelper.h"

@implementation DFResponseDataMapper

+ (instancetype)sharedInstance
{
    static DFResponseDataMapper *_sharedDataMapper = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _sharedDataMapper = [[DFResponseDataMapper alloc] init];
    });
    
    return _sharedDataMapper;
}

#pragma mark - Let the mapping begin

- (RKObjectMapping*)aboutMapping {
    RKObjectMapping *mapping = MAPCLASS(About);
    [mapping addAttributeMappingsFromDictionary:@[@"AboutId",
                                                  @"AboutTitle",
                                                  @"AboutText",
                                                  @"LanguageCode"].camelCaseDict];
    return mapping;
}

- (RKObjectMapping*)aboutMeMapping {
    RKObjectMapping *mapping = MAPCLASS(AboutMe);
    [mapping addAttributeMappingsFromDictionary:@[@"AboutMeId",
                                                  @"ProjectId",
                                                  @"UserId",
                                                  @"AboutMeText"].camelCaseDict];
    return mapping;
}

- (RKObjectMapping*)activityResponseMapping {
    RKObjectMapping *mapping = MAPCLASS(Response);
    
    
    [mapping addAttributeMappingsFromDictionary:@[@"ActivityId",
                                                  @"ThreadId",
                                                  @"DateCreated",
                                                  @"DateCreatedFormatted",
                                                  @"HasImageGalleryResponse",
                                                  @"HasTextareaResponse",
                                                  @"IsActive",
                                                  @"IsDraft",
                                                  @"IsRead"].camelCaseDict];
    
    
    [mapping addPropertyMapping:[RKRelationshipMapping relationshipMappingFromKeyPath:@"UserInfo" toKeyPath:@"userInfo" withMapping:[self userInfoMapping]]];
    
    [mapping addPropertyMapping:[RKRelationshipMapping relationshipMappingFromKeyPath:@"Files" toKeyPath:@"files" withMapping:[self fileMapping]]];
    
    [mapping addPropertyMapping:[RKRelationshipMapping relationshipMappingFromKeyPath:@"Comments" toKeyPath:@"comments" withMapping:[self commentMapping]]];
    
    [mapping addPropertyMapping:[RKRelationshipMapping relationshipMappingFromKeyPath:@"TextareaResponse" toKeyPath:@"textareaResponses" withMapping:[self textareaResponseMapping]]];
    
    [mapping addPropertyMapping:[RKRelationshipMapping relationshipMappingFromKeyPath:@"ImageGalleryResponse" toKeyPath:@"imageGalleryResponses" withMapping:[self imageGalleryResponseMapping]]];
    
    
    return mapping;
}

- (RKObjectMapping*)alertCountsMapping {
    RKObjectMapping *mapping = MAPCLASS(APIAlertCounts);
    [mapping addAttributeMappingsFromDictionary:@[@"TotalUnreadCount",
                                                 @"AnnouncementUnreadCount",
                                                 @"MessagesUnreadCount",
                                                  @"NotificationsUnreadCount"].camelCaseDict];
    return mapping;
}

- (RKObjectMapping*)announcementMapping {
    RKObjectMapping *mapping = MAPCLASS(Announcement);
    [mapping addAttributeMappingsFromDictionary:@[@"AnnouncementId",
                                                  @"Title",
                                                  @"Text",
                                                  @"DateCreated",
                                                  @"DateCreatedFormatted",
                                                  @"IsRead"].camelCaseDict];
    
    [mapping addPropertyMapping:[RKRelationshipMapping relationshipMappingFromKeyPath:@"Files" toKeyPath:@"files" withMapping:[self fileMapping]]];
    return mapping;
}

- (RKObjectMapping*)commentMapping {
    RKObjectMapping *mapping = MAPCLASS(Comment);
    
    [mapping addAttributeMappingsFromDictionary:@[@"CommentId",
                                                  @"DateCreated",
                                                  @"DateCreatedFormatted",
                                                  @"IsActive",
                                                  @"IsRead",
                                                  @"Response",
                                                  @"ThreadId",
                                                  @"UserId"].camelCaseDict];
    
    [mapping addPropertyMapping:[RKRelationshipMapping relationshipMappingFromKeyPath:@"UserInfo" toKeyPath:@"userInfo" withMapping:[self userInfoMapping]]];
    
    return mapping;
}

- (RKObjectMapping*)dailyDiaryMapping {
    RKObjectMapping *mapping = MAPCLASS(DailyDiary);
    
    [mapping addAttributeMappingsFromDictionary:@[@"DiaryId",
                                                  @"ActivityId",
                                                  @"DiaryQuestion",
                                                  @"DiaryIntroduction"].camelCaseDict];
    
    [mapping addPropertyMapping:[RKRelationshipMapping relationshipMappingFromKeyPath:@"UserDiaries" toKeyPath:@"userDiaries" withMapping:[self diaryMapping]]];
    
    [mapping addPropertyMapping:[RKRelationshipMapping relationshipMappingFromKeyPath:@"File" toKeyPath:@"file" withMapping:[self fileMapping]]];
    
    
    return mapping;
}

- (RKObjectMapping*)dailyDiaryResponseMapping {
    RKObjectMapping *mapping = MAPCLASS(DailyDiaryResponse);
    [mapping addAttributeMappingsFromDictionary:@[@"DailyDiaryResponseId",
                                                  @"DailyDiaryId",
                                                  @"ThreadId",
                                                  @"Title",
                                                  @"Response",
                                                  @"DiaryDate",
                                                  @"IsActive"].camelCaseDict];
    return mapping;
    
    
}

- (RKObjectMapping*)diaryMapping {
    RKObjectMapping *mapping = MAPCLASS(Diary);
    
    [mapping addAttributeMappingsFromDictionary:@[@"DateCreated",
                                                  @"DateCreatedFormatted",
                                                  @"IsRead",
                                                  @"Response",
                                                  @"ResponseId",
                                                  @"Title",
                                                  @"UserId",
                                                  @"ThreadId"].camelCaseDict];
    
    [mapping addPropertyMapping:[RKRelationshipMapping relationshipMappingFromKeyPath:@"Files" toKeyPath:@"files" withMapping:[self fileMapping]]];
    
    [mapping addPropertyMapping:[RKRelationshipMapping relationshipMappingFromKeyPath:@"Comments" toKeyPath:@"comments" withMapping:[self commentMapping]]];
    
    [mapping addPropertyMapping:[RKRelationshipMapping relationshipMappingFromKeyPath:@"UserInfo" toKeyPath:@"userInfo" withMapping:[self userInfoMapping]]];
    return mapping;
}

- (RKObjectMapping*)diaryThemeMapping {
    RKObjectMapping *mapping = MAPCLASS(DiaryTheme);
    [mapping addAttributeMappingsFromDictionary:@[@"ActivityId",
                                                  @"ActivityTypeId",
                                                  @"ParentActivityId",
                                                  @"ActivityTitle",
                                                  @"ActivityDesc",
                                                  @"IsActive",
                                                  @"IsRead",
                                                  @"UnreadResponses"].camelCaseDict];
    
    [mapping addPropertyMapping:[RKRelationshipMapping relationshipMappingFromKeyPath:@"Modules" toKeyPath:@"modules" withMapping:[self moduleMapping]]];
    
    return mapping;
}

- (RKObjectMapping*)displayFileMapping {
    RKObjectMapping *mapping = MAPCLASS(DisplayFile);
    
    [mapping addAttributeMappingsFromDictionary:@[@"DisplayFileId",
                                                  @"ActivityId",
                                                  @"FileId"].camelCaseDict];
    
    [mapping addPropertyMapping:[RKRelationshipMapping relationshipMappingFromKeyPath:@"File" toKeyPath:@"file" withMapping:[self fileMapping]]];
    
    return mapping;
}

- (RKObjectMapping*)displayTextMapping {
    RKObjectMapping *mapping = MAPCLASS(DisplayText);
    
    [mapping addAttributeMappingsFromDictionary:@[@"DisplayTextId",
                                                  @"ActivityId",
                                                  @"Text"].camelCaseDict];
    
    return mapping;
}

- (RKObjectMapping*)fileMapping {
    RKObjectMapping *mapping = MAPCLASS(File);
    [mapping addAttributeMappingsFromDictionary:@[@"FileId",
                                                  @"FileName",
                                                  @"FileTypeId",
                                                  @"FileType",
                                                  @"Extension",
                                                  @"IsAmazonFile",
                                                  @"AmazonKey",
                                                  @"IsViddlerFile",
                                                  @"ViddlerKey",
                                                  @"IsCameraTagFile",
                                                  @"CameraTagKey",
                                                  @"PositionId",
                                                  @"Position",
                                                  @"PublicFileUrl"].camelCaseDict];
    return mapping;
}

- (RKObjectMapping*)homeAnnouncementMapping {
    RKObjectMapping *mapping = MAPCLASS(APIHomeAnnouncementResponse);
    
    [mapping addAttributeMappingsFromDictionary:@[@"HomeAnnouncementId",
                                                  @"Title",
                                                  @"Text",
                                                  @"DateCreated",
                                                  @"DateCreatedFormatted"].camelCaseDict];
    
    [mapping addPropertyMapping:[RKRelationshipMapping relationshipMappingFromKeyPath:@"File" toKeyPath:@"file" withMapping:[self fileMapping]]];
    
    return mapping;
}

- (RKObjectMapping*)imageGalleryResponseMapping {
    RKObjectMapping *mapping = MAPCLASS(ImageGalleryResponse);
    [mapping addAttributeMappingsFromDictionary:@[@"ImageGalleryResponseId",
                                                  @"ImageGalleryId",
                                                  @"ThreadId",
                                                  @"GalleryIds",
                                                  @"Response",
                                                  @"UserId",
                                                  @"IsActive"].camelCaseDict];
    return mapping;
}

- (RKObjectMapping*)imageGalleryMapping {
    RKObjectMapping *mapping = MAPCLASS(ImageGallery);
    
    [mapping addAttributeMappingsFromDictionary:@[@"ImageGalleryId", @"ActivityId"].camelCaseDict];
    
    [mapping addPropertyMapping:[RKRelationshipMapping relationshipMappingFromKeyPath:@"Files" toKeyPath:@"files" withMapping:[self fileMapping]]];
    
    return mapping;
}

- (RKObjectMapping*)isUserNameAvailableResponseMapping {
    RKObjectMapping *mapping = MAPCLASS(APIIsUserNameAvailableResponse);
    [mapping addAttributeMappingsFromDictionary:@[@"IsAvailable", @"Error"].camelCaseDict];
    return mapping;
}

- (RKObjectMapping*)markUpMapping {
    RKObjectMapping *mapping = MAPCLASS(MarkUp);
    
    [mapping addAttributeMappingsFromDictionary:@[@"MarkupId",
                                                  @"MarkupUrl"].camelCaseDict];
    
    return mapping;
}

- (RKObjectMapping*)messageMapping {
    RKObjectMapping *mapping = MAPCLASS(Message);
    
    return mapping;
}

- (RKObjectMapping*)moduleMapping {
    RKObjectMapping *mapping = MAPCLASS(Module);
    
    [mapping addAttributeMappingsFromDictionary:@[@"ActivityModuleId",
                                                  @"ActivityId",
                                                  @"ActivityTypeId",
                                                  @"ActivityType",
                                                  @"ModuleId",
                                                  @"SortOrder"].camelCaseDict];
    
    [mapping addPropertyMapping:[RKRelationshipMapping relationshipMappingFromKeyPath:@"DisplayText" toKeyPath:@"displayText" withMapping:[self displayTextMapping]]];
    
    [mapping addPropertyMapping:[RKRelationshipMapping relationshipMappingFromKeyPath:@"DisplayFile" toKeyPath:@"displayFile" withMapping:[self displayFileMapping]]];
    
    [mapping addPropertyMapping:[RKRelationshipMapping relationshipMappingFromKeyPath:@"Textarea" toKeyPath:@"textarea" withMapping:[self textareaMapping]]];
    
    [mapping addPropertyMapping:[RKRelationshipMapping relationshipMappingFromKeyPath:@"ImageGallery" toKeyPath:@"imageGallery" withMapping:[self imageGalleryMapping]]];
    
    [mapping addPropertyMapping:[RKRelationshipMapping relationshipMappingFromKeyPath:@"MarkUp" toKeyPath:@"markUp" withMapping:[self markUpMapping]]];
    
    return mapping;
}


- (RKObjectMapping*)notificationMapping {
    RKObjectMapping *mapping = MAPCLASS(Notification);
    
    [mapping addAttributeMappingsFromDictionary:@[@"CommenterUserInfo",
                                                  @"ActivityId",
                                                  @"DateCreated",
                                                  @"DateCreatedFormatted",
                                                  @"IsDailyNotification",
                                                  @"IsRead",
                                                  @"NotificationId",
                                                  @"NotificationType",
                                                  @"NotificationTypeId",
                                                  @"ProjectId",
                                                  @"UserId"].camelCaseDict];
    return mapping;
}

- (RKObjectMapping*)projectMapping {
    RKObjectMapping *mapping = MAPCLASS(Project);
    
    [mapping addAttributeMappingsFromDictionary:@[@"ProjectId",
                                                  @"CompanyId",
                                                  @"RegionId",
                                                  @"ProjectInternalName",
                                                  @"ProjectName",
                                                  @"ProjectStartDate",
                                                  @"ProjectEndDate",
                                                  @"LanguageId",
                                                  @"AllowProfilePicUpload",
                                                  @"EnableAvatarLibrary",
                                                  @"HasDailyDiary",
                                                  @"DailyDiaryList",
                                                  @"IsTrial",
                                                  @"IsActive"].camelCaseDict];
    
    return mapping;
}

- (RKObjectMapping*)setUserNameResponseMapping {
    RKObjectMapping *mapping = MAPCLASS(APISetUserNameResponse);
    [mapping addAttributeMappingsFromDictionary:@{@"NewUserName" : @"userName"}];
    return mapping;
}

- (RKObjectMapping*)textareaMapping {
    RKObjectMapping *mapping = MAPCLASS(Textarea);
    
    [mapping addAttributeMappingsFromDictionary:@[@"TextareaId",
                                                  @"ActivityId",
                                                  @"QuestionText",
                                                  @"PlaceHolder",
                                                  @"MaxCharacters"].camelCaseDict];
    
    return mapping;
}

- (RKObjectMapping*)textareaResponseMapping {
    RKObjectMapping *mapping = MAPCLASS(TextareaResponse);
    [mapping addAttributeMappingsFromDictionary:@[@"Response",
                                                  @"IsActive",
                                                  @"TextareaId",
                                                  @"TextareaResponseId",
                                                  @"ThreadId"].camelCaseDict];
    
    return mapping;
}

- (RKObjectMapping*)threadMapping {
    RKObjectMapping *mapping = MAPCLASS(Thread);
    [mapping addAttributeMappingsFromDictionary:@[@"ThreadId",
                                                  @"ActivityId",
                                                  @"IsDraft",
                                                  @"IsActive"].camelCaseDict];
    return mapping;
}

- (RKObjectMapping*)tokenMapping {
    RKObjectMapping *mapping = MAPCLASS(APITokenResponse);
    [mapping addAttributeMappingsFromDictionary:@{@"access_token" : @"accessToken"}];
    return mapping;
}

- (RKObjectMapping*)userInfoMapping {
    RKObjectMapping *mapping = MAPCLASS(UserInfo);
    [mapping addAttributeMappingsFromDictionary:@[@"Id",
                                                  @"Email",
                                                  @"FirstName",
                                                  @"LastName",
                                                  @"IsUserNameSet",
                                                  @"AppUserName",
                                                  @"IsModerator",
                                                  @"DefaultLanguageId",
                                                  @"AvatarFileId",
                                                  @"CurrentProjectId",
                                                  @"AboutMeText",
                                                  @"HasRegistered",
                                                  @"LoginProvider"].camelCaseDict];
    [mapping addPropertyMapping:[RKRelationshipMapping relationshipMappingFromKeyPath:@"AvatarFile" toKeyPath:@"avatarFile" withMapping:[self fileMapping]]];
    
    [mapping addPropertyMapping:[RKRelationshipMapping relationshipMappingFromKeyPath:@"CurrentProject" toKeyPath:@"currentProject" withMapping:[self projectMapping]]];
    
    return mapping;
}

- (RKObjectMapping*)emptyResponseMapping {
    return MAPCLASS(NSNull);
}




@end
