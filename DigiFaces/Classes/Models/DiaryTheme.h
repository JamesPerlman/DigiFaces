//
//  DiaryTheme.h
//  DigiFaces
//
//  Created by confiz on 17/07/2015.
//  Copyright (c) 2015 Usasha studio. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Module.h"


@interface DiaryTheme : NSObject

@property (nonatomic, strong) NSNumber * activityId;
@property (nonatomic, strong) NSNumber * activityTypeId;
@property (nonatomic, strong) NSNumber * parentActivityId;
@property (nonatomic, retain) NSString * activityTitle;
@property (nonatomic, retain) NSString * activityDesc;
@property (nonatomic, strong) NSNumber * isActive;
@property (nonatomic, strong) NSNumber * isRead;
@property (nonatomic, strong) NSNumber * unreadResponses;

@property (nonatomic, strong) NSArray  * responses;

@property (nonatomic, retain) NSArray * modules;

-(Module*)getModuleWithThemeType:(ThemeType)type;

- (void)reorganizeResponses;
@end
