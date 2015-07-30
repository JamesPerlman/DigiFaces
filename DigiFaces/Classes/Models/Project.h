//
//  Project.h
//  DigiFaces
//
//  Created by Apple on 16/06/2015.
//  Copyright (c) 2015 Usasha studio. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Company.h"

@interface Project : NSObject

@property (nonatomic, strong) NSNumber * projectID;
@property (nonatomic, strong) NSNumber * companyID;
@property (nonatomic, strong) NSNumber * regionID;
@property (nonatomic, retain) NSString * projectInternalName;
@property (nonatomic, retain) NSString * projectName;
@property (nonatomic, retain) NSString * projectStartDate;
@property (nonatomic, retain) NSString * projectEndDate;
@property (nonatomic, strong) NSNumber * languageId;
@property (nonatomic, strong) NSNumber * allowProfilePicUpload;
@property (nonatomic, strong) NSNumber * enableAvatarLibrary;
@property (nonatomic, strong) NSNumber * hasDailyDiary;
@property (nonatomic, strong) NSNumber * isTrial;
@property (nonatomic, strong) NSNumber * isActive;

@property (nonatomic, retain) NSArray  * dailyDiaryList;

@property (nonatomic, retain) Company * company;


@end
