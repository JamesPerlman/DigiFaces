//
//  DFResponseDescriptorProvider.m
//  DigiFaces
//
//  Created by James on 7/28/15.
//  Copyright (c) 2015 INET360. All rights reserved.
//

// vvv Super duper convenient
#define DESCRIPTOR(pathString, requestMethod, mappingSelector) [RKResponseDescriptor responseDescriptorWithMapping:[MAPPER mappingSelector] method:requestMethod pathPattern:pathString keyPath:nil statusCodes:RKStatusCodeIndexSetForClass(RKStatusCodeClassSuccessful)]


#import "DFResponseDescriptorsProvider.h"


#define MAPPER [DFResponseDataMapper sharedInstance]


#import "DFResponseDataMapper.h"
#import "DFConstants.h"

@implementation DFResponseDescriptorsProvider


+ (instancetype)sharedInstance
{
    static DFResponseDescriptorsProvider *_sharedInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _sharedInstance = [[DFResponseDescriptorsProvider alloc] init];
    });
    
    
    return _sharedInstance;
}


- (NSArray*)responseDescriptors {
    return @[DESCRIPTOR(APIPathActivityGetResponses,                kPOST, activityResponseMapping),
             DESCRIPTOR(APIPathActivityUpdateThread,                kPOST, threadMapping),
             DESCRIPTOR(APIPathActivityInsertThreadFile,            kPOST, fileMapping),
             DESCRIPTOR(APIPathActivityUpdateComment,               kPOST, commentMapping),
             DESCRIPTOR(APIPathActivityUpdateImageGalleryResponse,  kPOST, imageGalleryResponseMapping),
             DESCRIPTOR(APIPathActivityUpdateTextareaResponse,      kPOST, textareaResponseMapping),
             DESCRIPTOR(APIPathActivityMarkThreadRead,              kPOST, emptyResponseMapping),
             DESCRIPTOR(APIPathActivityMarkCommentRead,             kPOST, emptyResponseMapping),
             DESCRIPTOR(APIPathForgotPassword,                      kPOST, emptyResponseMapping),
             DESCRIPTOR(APIPathGetAbout,                            kGET,  aboutMapping),
             DESCRIPTOR(APIPathGetAboutMe,                          kGET,  aboutMeMapping),
             DESCRIPTOR(APIPathGetAlertCounts,                      kGET,  alertCountsMapping),
             DESCRIPTOR(APIPathGetAvatarFiles,                      kGET,  fileMapping),
             DESCRIPTOR(APIPathGetDailyDiary,                       kPOST, dailyDiaryMapping),
             DESCRIPTOR(APIPathGetHomeAnnouncement,                 kGET,  homeAnnouncementMapping),
             DESCRIPTOR(APIPathGetMessages,                         kGET,  messageMappingRecursive),
             DESCRIPTOR(APIPathGetNotifications,                    kGET,  notificationMapping),
             DESCRIPTOR(APIPathGetProjects,                         kGET,  projectMapping),
             DESCRIPTOR(APIPathGetToken,                            kPOST, tokenMapping),
             DESCRIPTOR(APIPathGetUserInfo,                         kGET,  userInfoMapping),
             DESCRIPTOR(APIPathIsUserNameAvailable,                 kPOST, isUserNameAvailableResponseMapping),
             DESCRIPTOR(APIPathLogout,                              kPOST, emptyResponseMapping),
             DESCRIPTOR(APIPathMarkMessageRead,                     kPOST, emptyResponseMapping),
             DESCRIPTOR(APIPathMarkNotificationRead,                kPOST, emptyResponseMapping),
             DESCRIPTOR(APIPathProjectGetActivities,                kPOST, diaryThemeMapping),
             DESCRIPTOR(APIPathProjectMarkActivityRead,             kPOST, emptyResponseMapping),
             DESCRIPTOR(APIPathProjectMarkAnnouncementRead,         kPOST, emptyResponseMapping),
             DESCRIPTOR(APIPathProjectGetAnnouncements,             kGET,  announcementMapping),
             DESCRIPTOR(APIPathReplyFromModerator,                  kPOST, emptyResponseMapping),
             DESCRIPTOR(APIPathSendHelpMessage,                     kPOST, emptyResponseMapping),
             DESCRIPTOR(APIPathSendMessageToModerator,              kPOST, emptyResponseMapping),
             DESCRIPTOR(APIPathSetUserName,                         kPOST, setUserNameResponseMapping),
             DESCRIPTOR(APIPathUpdateAboutMe,                       kPOST, emptyResponseMapping),
             DESCRIPTOR(APIPathUpdateDailyDiary,                    kPOST, dailyDiaryResponseMapping),
             DESCRIPTOR(APIPathUploadUserCustomAvatar,              kPOST, emptyResponseMapping)
             ];
}

@end
