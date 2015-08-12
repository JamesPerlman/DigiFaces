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
- (RKObjectMapping*)aboutMapping;
- (RKObjectMapping*)aboutMeMapping;
- (RKObjectMapping*)activityResponseMapping;
- (RKObjectMapping*)alertCountsMapping;
- (RKObjectMapping*)announcementMapping;
- (RKObjectMapping*)dailyDiaryMapping;
- (RKObjectMapping*)dailyDiaryResponseMapping;
- (RKObjectMapping*)diaryMapping;
- (RKObjectMapping*)diaryThemeMapping;
- (RKObjectMapping*)displayTextMapping;
- (RKObjectMapping*)displayFileMapping;
- (RKObjectMapping*)emptyResponseMapping;
- (RKObjectMapping*)fileMapping;
- (RKObjectMapping*)homeAnnouncementMapping;
- (RKObjectMapping*)imageGalleryResponseMapping;
- (RKObjectMapping*)imageGalleryMapping;
- (RKObjectMapping*)isUserNameAvailableResponseMapping;
- (RKObjectMapping*)commentMapping;
- (RKObjectMapping*)markUpMapping;
- (RKObjectMapping*)messageMapping;
- (RKObjectMapping*)messageMappingRecursive;
- (RKObjectMapping*)moduleMapping;
- (RKObjectMapping*)notificationMapping;
- (RKObjectMapping*)projectMapping;
- (RKObjectMapping*)setUserNameResponseMapping;
- (RKObjectMapping*)textareaMapping;
- (RKObjectMapping*)textareaResponseMapping;
- (RKObjectMapping*)threadMapping;
- (RKObjectMapping*)tokenMapping;
- (RKObjectMapping*)userInfoMapping;
@end
