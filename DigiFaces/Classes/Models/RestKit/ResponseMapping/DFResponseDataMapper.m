//
//  DFResponseDataMapper.m
//  DigiFaces
//
//  Created by James on 7/28/15.
//  Copyright (c) 2015 INET360. All rights reserved.
//
#define MAPCLASS(classType) [RKObjectMapping mappingForClass:[classType class]]
#define RKManagedObjectStore [RKObjectManager sharedManager].managedObjectStore
#define MAPENTITY(entityName) [RKEntityMapping mappingForEntityForName:entityName inManagedObjectStore:RKManagedObjectStore]

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

@end

#pragma mark - Entity Mapping

@implementation DFResponseDataMapper (EntityMapping)

- (RKEntityMapping*)aboutMapping {
    RKEntityMapping *mapping = MAPENTITY(@"About");
    
    [mapping setIdentificationAttributes:@[@"aboutId"]];
    
    [mapping addAttributeMappingsFromDictionary:@[@"AboutId",
                                                  @"AboutTitle",
                                                  @"AboutText",
                                                  @"LanguageCode"].camelCaseDict];
    return mapping;
}

- (RKEntityMapping*)aboutMeMapping {
    RKEntityMapping *mapping = MAPENTITY(@"AboutMe");
    
    [mapping setIdentificationAttributes:@[@"aboutMeId"]];
    
    [mapping addAttributeMappingsFromDictionary:@[@"AboutMeId",
                                                  @"ProjectId",
                                                  @"UserId",
                                                  @"AboutMeText"].camelCaseDict];
    return mapping;
}

- (RKEntityMapping*)activityResponseMapping {
    RKEntityMapping *mapping = MAPENTITY(@"Response");
    
    [mapping setIdentificationAttributes:@[@"threadId"]];
    
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

- (RKEntityMapping*)announcementMapping {
    RKEntityMapping *mapping = MAPENTITY(@"Announcement");
    
    [mapping setIdentificationAttributes:@[@"announcementId"]];
    
    [mapping addAttributeMappingsFromDictionary:@[@"AnnouncementId",
                                                  @"Title",
                                                  @"Text",
                                                  @"DateCreated",
                                                  @"DateCreatedFormatted",
                                                  @"IsRead"].camelCaseDict];
    
    [mapping addPropertyMapping:[RKRelationshipMapping relationshipMappingFromKeyPath:@"Files" toKeyPath:@"files" withMapping:[self fileMapping]]];
    return mapping;
}

- (RKEntityMapping*)commentMapping {
    RKEntityMapping *mapping = MAPENTITY(@"Comment");
    
    [mapping setIdentificationAttributes:@[@"commentId"]];
    
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

- (RKEntityMapping*)dailyDiaryMapping {
    RKEntityMapping *mapping = MAPENTITY(@"DailyDiary");
    
    [mapping setIdentificationAttributes:@[@"diaryId"]];
    
    [mapping addAttributeMappingsFromDictionary:@[@"DiaryId",
                                                  @"ActivityId",
                                                  @"DiaryQuestion",
                                                  @"DiaryIntroduction"].camelCaseDict];
    
    [mapping addPropertyMapping:[RKRelationshipMapping relationshipMappingFromKeyPath:@"UserDiaries" toKeyPath:@"userDiaries" withMapping:[self diaryMapping]]];
    
    [mapping addPropertyMapping:[RKRelationshipMapping relationshipMappingFromKeyPath:@"File" toKeyPath:@"file" withMapping:[self fileMapping]]];
    
    
    return mapping;
}

- (RKEntityMapping*)dailyDiaryResponseMapping {
    RKEntityMapping *mapping = MAPENTITY(@"DailyDiaryResponse");
    
    [mapping setIdentificationAttributes:@[@"dailyDiaryResponseId"]];
    
    [mapping addAttributeMappingsFromDictionary:@[@"DailyDiaryResponseId",
                                                  @"DailyDiaryId",
                                                  @"ThreadId",
                                                  @"Title",
                                                  @"Response",
                                                  @"DiaryDate",
                                                  @"IsActive"].camelCaseDict];
    return mapping;
    
    
}

// UserResponseDTO
- (RKEntityMapping*)diaryMapping {
    RKEntityMapping *mapping = MAPENTITY(@"Diary");
    
    [mapping setIdentificationAttributes:@[@"responseId"]];
    
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

- (RKEntityMapping*)diaryThemeMapping {
    RKEntityMapping *mapping = MAPENTITY(@"DiaryTheme");
    
    [mapping setIdentificationAttributes:@[@"activityId"]];
    
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

- (RKEntityMapping*)displayFileMapping {
    RKEntityMapping *mapping = MAPENTITY(@"DisplayFile");
    
    [mapping setIdentificationAttributes:@[@"displayFileId"]];
    
    [mapping addAttributeMappingsFromDictionary:@[@"DisplayFileId",
                                                  @"ActivityId",
                                                  @"FileId"].camelCaseDict];
    
    [mapping addPropertyMapping:[RKRelationshipMapping relationshipMappingFromKeyPath:@"File" toKeyPath:@"file" withMapping:[self fileMapping]]];
    
    return mapping;
}

- (RKEntityMapping*)displayTextMapping {
    RKEntityMapping *mapping = MAPENTITY(@"DisplayText");
    
    [mapping setIdentificationAttributes:@[@"displayTextId"]];
    
    [mapping addAttributeMappingsFromDictionary:@[@"DisplayTextId",
                                                  @"ActivityId",
                                                  @"Text"].camelCaseDict];
    
    return mapping;
}

- (RKEntityMapping*)fileMapping {
    RKEntityMapping *mapping = MAPENTITY(@"File");
    
    [mapping setIdentificationAttributes:@[@"fileId"]];
    
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

- (RKEntityMapping*)imageGalleryResponseMapping {
    RKEntityMapping *mapping = MAPENTITY(@"ImageGalleryResponse");
    
    [mapping setIdentificationAttributes:@[@"imageGalleryResponseId"]];
    
    [mapping addAttributeMappingsFromDictionary:@[@"ImageGalleryResponseId",
                                                  @"ImageGalleryId",
                                                  @"ThreadId",
                                                  @"GalleryIds",
                                                  @"Response",
                                                  @"UserId",
                                                  @"IsActive"].camelCaseDict];
    return mapping;
}

- (RKEntityMapping*)imageGalleryMapping {
    RKEntityMapping *mapping = MAPENTITY(@"ImageGallery");
    
    [mapping setIdentificationAttributes:@[@"imageGalleryId"]];
    
    [mapping addAttributeMappingsFromDictionary:@[@"ImageGalleryId", @"ActivityId"].camelCaseDict];
    
    [mapping addPropertyMapping:[RKRelationshipMapping relationshipMappingFromKeyPath:@"Files" toKeyPath:@"files" withMapping:[self fileMapping]]];
    
    return mapping;
}

- (RKEntityMapping*)integerListMapping {
    RKEntityMapping *integerMapping = MAPENTITY(@"Integer");
    
    [integerMapping setIdentificationAttributes:@[@"value"]];
    
    [integerMapping addPropertyMapping:[RKAttributeMapping attributeMappingFromKeyPath:nil toKeyPath:@"value"]];
    
    return integerMapping;
}

- (RKEntityMapping*)markUpMapping {
    RKEntityMapping *mapping = MAPENTITY(@"MarkUp");
    
    [mapping setIdentificationAttributes:@[@"markupId"]];
    
    [mapping addAttributeMappingsFromDictionary:@[@"MarkupId",
                                                  @"MarkupUrl"].camelCaseDict];
    
    return mapping;
}

- (RKEntityMapping*)messageMappingRecursive {
    RKEntityMapping *mapping = [self messageMapping];
    [mapping addPropertyMapping:[RKRelationshipMapping relationshipMappingFromKeyPath:@"ChildMessages" toKeyPath:@"childMessages" withMapping:[self messageMapping]]];
    return mapping;
}

- (RKEntityMapping*)messageMapping {
    RKEntityMapping *mapping = MAPENTITY(@"Message");
    
    [mapping setIdentificationAttributes:@[@"messageId"]];
    
    [mapping addAttributeMappingsFromDictionary:@[@"MessageId",
                                                  @"ProjectId",
                                                  @"FromUser",
                                                  @"ToUser",
                                                  @"Subject",
                                                  @"Response",
                                                  @"DateCreated",
                                                  @"DateCreatedFormatted",
                                                  @"IsRead"].camelCaseDict];
    [mapping addPropertyMapping:[RKRelationshipMapping relationshipMappingFromKeyPath:@"FromUserInfo" toKeyPath:@"fromUserInfo" withMapping:[self userInfoMapping]]];
    
    [mapping addPropertyMapping:[RKRelationshipMapping relationshipMappingFromKeyPath:@"ToUserInfo" toKeyPath:@"toUserInfo" withMapping:[self userInfoMapping]]];
    
    return mapping;
}

- (RKEntityMapping*)moduleMapping {
    RKEntityMapping *mapping = MAPENTITY(@"Module");
    
    [mapping setIdentificationAttributes:@[@"activityModuleId"]];
    
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


- (RKEntityMapping*)notificationMapping {
    RKEntityMapping *mapping = MAPENTITY(@"Notification");
    
    [mapping setIdentificationAttributes:@[@"notificationId"]];
    
    [mapping addAttributeMappingsFromDictionary:@[@"ActivityId",
                                                  @"DateCreated",
                                                  @"DateCreatedFormatted",
                                                  @"IsDailyDiaryNotification",
                                                  @"IsRead",
                                                  @"NotificationId",
                                                  @"NotificationType",
                                                  @"NotificationTypeId",
                                                  @"ReferenceId",
                                                  @"ReferenceId2",
                                                  @"ProjectId",
                                                  @"UserId"].camelCaseDict];
    
    [mapping addPropertyMapping:[RKRelationshipMapping relationshipMappingFromKeyPath:@"CommenterUserInfo" toKeyPath:@"commenterUserInfo" withMapping:[self userInfoMapping]]];
    
    return mapping;
}

- (RKEntityMapping*)projectMapping {
    RKEntityMapping *mapping = MAPENTITY(@"Project");
    
    [mapping setIdentificationAttributes:@[@"projectId"]];
    
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
                                                  @"IsTrial",
                                                  @"IsActive"].camelCaseDict];
    
    [mapping addPropertyMapping:[RKRelationshipMapping relationshipMappingFromKeyPath:@"DailyDiaryList" toKeyPath:@"dailyDiaryList" withMapping:[self integerListMapping]]];
    
    return mapping;
}

- (RKEntityMapping*)textareaMapping {
    RKEntityMapping *mapping = MAPENTITY(@"Textarea");
    
    [mapping setIdentificationAttributes:@[@"textareaId"]];
    
    [mapping addAttributeMappingsFromDictionary:@[@"TextareaId",
                                                  @"ActivityId",
                                                  @"QuestionText",
                                                  @"PlaceHolder",
                                                  @"MaxCharacters"].camelCaseDict];
    
    return mapping;
}

- (RKEntityMapping*)textareaResponseMapping {
    RKEntityMapping *mapping = MAPENTITY(@"TextareaResponse");
    
    [mapping setIdentificationAttributes:@[@"textareaResponseId"]];
    
    [mapping addAttributeMappingsFromDictionary:@[@"Response",
                                                  @"IsActive",
                                                  @"TextareaId",
                                                  @"TextareaResponseId",
                                                  @"ThreadId"].camelCaseDict];
    
    return mapping;
}

- (RKEntityMapping*)threadMapping {
    RKEntityMapping *mapping = MAPENTITY(@"Thread");
    
    [mapping setIdentificationAttributes:@[@"threadId"]];
    
    [mapping addAttributeMappingsFromDictionary:@[@"ThreadId",
                                                  @"ActivityId",
                                                  @"IsDraft",
                                                  @"IsActive"].camelCaseDict];
    return mapping;
}

- (RKEntityMapping*)userInfoMapping {
    RKEntityMapping *mapping = MAPENTITY(@"UserInfo");
    
    [mapping setIdentificationAttributes:@[@"id", @"userId"]];
    
    [mapping addAttributeMappingsFromDictionary:@[@"Id",
                                                  @"UserId",
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
                                                  @"LoginProvider",
                                                  @"ProjectRoleId"].camelCaseDict];
    
    
    [mapping addPropertyMapping:[RKRelationshipMapping relationshipMappingFromKeyPath:@"AvatarFile" toKeyPath:@"avatarFile" withMapping:[self fileMapping]]];
    
    [mapping addPropertyMapping:[RKRelationshipMapping relationshipMappingFromKeyPath:@"CurrentProject" toKeyPath:@"currentProject" withMapping:[self projectMapping]]];
    
    return mapping;
}

@end

#pragma mark - Object Mapping

@implementation DFResponseDataMapper (ObjectMapping)

- (RKObjectMapping*)alertCountsMapping {
    RKObjectMapping *mapping = MAPCLASS(APIAlertCounts);
    [mapping addAttributeMappingsFromDictionary:@[@"TotalUnreadCount",
                                                  @"AnnouncementUnreadCount",
                                                  @"MessagesUnreadCount",
                                                  @"NotificationsUnreadCount"].camelCaseDict];
    return mapping;
}

- (RKObjectMapping*)emptyResponseMapping {
    return MAPCLASS(NSNull);
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

- (RKObjectMapping*)isUserNameAvailableResponseMapping {
    RKObjectMapping *mapping = MAPCLASS(APIIsUserNameAvailableResponse);
    [mapping addAttributeMappingsFromDictionary:@[@"IsAvailable", @"Error"].camelCaseDict];
    return mapping;
}

- (RKObjectMapping*)setUserNameResponseMapping {
    RKObjectMapping *mapping = MAPCLASS(APISetUserNameResponse);
    [mapping addAttributeMappingsFromDictionary:@{@"NewUserName" : @"userName"}];
    return mapping;
}

- (RKObjectMapping*)tokenMapping {
    RKObjectMapping *mapping = MAPCLASS(APITokenResponse);
    [mapping addAttributeMappingsFromDictionary:@{@"access_token" : @"accessToken"}];
    return mapping;
}

@end
