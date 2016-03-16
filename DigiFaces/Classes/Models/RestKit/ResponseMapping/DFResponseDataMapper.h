//
//  DFResponseDataMapper.h
//  DigiFaces
//
//  Created by James on 7/28/15.
//  Copyright (c) 2015 INET360. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DFResponseDataMapper : NSObject

+ (instancetype)sharedInstance;

@end

@interface DFResponseDataMapper (EntityMapping)

- (RKEntityMapping*)aboutMapping;
- (RKEntityMapping*)aboutMeMapping;
- (RKEntityMapping*)activityResponseMapping;
- (RKEntityMapping*)announcementMapping;
- (RKEntityMapping*)commentMapping;
- (RKEntityMapping*)dailyDiaryMapping;
- (RKEntityMapping*)dailyDiaryResponseMapping;
- (RKEntityMapping*)diaryMapping;
- (RKEntityMapping*)diaryThemeMapping;
- (RKEntityMapping*)displayTextMapping;
- (RKEntityMapping*)displayFileMapping;
- (RKEntityMapping*)fileMapping;
- (RKEntityMapping*)imageGalleryResponseMapping;
- (RKEntityMapping*)imageGalleryMapping;
- (RKEntityMapping*)internalCommentMapping;
- (RKEntityMapping*)markUpMapping;
- (RKEntityMapping*)messageMapping;
- (RKEntityMapping*)messageMappingRecursive;
- (RKEntityMapping*)moduleMapping;
- (RKEntityMapping*)notificationMapping;
- (RKEntityMapping*)projectMapping;
- (RKEntityMapping*)researcherCommentMapping;
- (RKEntityMapping*)textareaMapping;
- (RKEntityMapping*)textareaResponseMapping;
- (RKEntityMapping*)threadMapping;
- (RKEntityMapping*)userInfoMapping;

@end

@interface DFResponseDataMapper (ObjectMapping)

- (RKObjectMapping*)alertCountsMapping;
- (RKObjectMapping*)emptyResponseMapping;
- (RKObjectMapping*)homeAnnouncementMapping;
- (RKObjectMapping*)isUserNameAvailableResponseMapping;
- (RKObjectMapping*)languageMapping;
- (RKObjectMapping*)setUserNameResponseMapping;
- (RKObjectMapping*)tokenMapping;

@end
