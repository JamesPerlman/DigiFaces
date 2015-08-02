//
//  DiaryResponseDelegate.h
//  DigiFaces
//
//  Created by James on 8/1/15.
//  Copyright (c) 2015 INET360. All rights reserved.
//

#import <Foundation/Foundation.h>

@class DailyDiary;

@protocol DiaryResponseDelegate <NSObject>

- (void)didSetDailyDiary:(DailyDiary*)dailyDiary;

@end
