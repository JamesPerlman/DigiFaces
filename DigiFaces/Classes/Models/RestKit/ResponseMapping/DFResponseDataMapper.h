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
- (RKObjectMapping*)tokenMapping;
- (RKObjectMapping*)userInfoMapping;
- (RKObjectMapping*)aboutMapping;
- (RKObjectMapping*)aboutMeMapping;
- (RKObjectMapping*)alertCountsMapping;
- (RKObjectMapping*)fileMapping;
- (RKObjectMapping*)projectMapping;
- (RKObjectMapping*)notificationMapping;
- (RKObjectMapping*)homeAnnouncementMapping;
- (RKObjectMapping*)dailyDiaryMapping;
- (RKObjectMapping*)dailyDiaryResponseMapping;
- (RKObjectMapping*)diaryMapping;
- (RKObjectMapping*)commentMapping;
- (RKObjectMapping*)activityResponseMapping;
- (RKObjectMapping*)textareaResponseMapping;
- (RKObjectMapping*)imageGalleryResponseMapping;
- (RKObjectMapping*)imageGalleryMapping;
- (RKObjectMapping*)diaryThemeMapping;
- (RKObjectMapping*)moduleMapping;
- (RKObjectMapping*)displayTextMapping;
- (RKObjectMapping*)displayFileMapping;
- (RKObjectMapping*)textareaMapping;
- (RKObjectMapping*)markUpMapping;
- (RKObjectMapping*)isUserNameAvailableResponseMapping;
- (RKObjectMapping*)setUserNameResponseMapping;
- (RKObjectMapping*)threadMapping;
- (RKObjectMapping*)emptyResponseMapping;
@end
