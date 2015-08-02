//
//  DailyDiaryResponse.h
//  DigiFaces
//
//  Created by James on 8/1/15.
//  Copyright (c) 2015 INET360. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DailyDiaryResponse : NSObject

@property (nonatomic, strong) NSNumber *dailyDiaryResponseId;
@property (nonatomic, strong) NSNumber *dailyDiaryId;
@property (nonatomic, strong) NSNumber *threadId;
@property (nonatomic, strong) NSString *title;
@property (nonatomic, strong) NSString *response;
@property (nonatomic, strong) NSDate   *diaryDate;
@property (nonatomic, strong) NSNumber *isActive;

@end
