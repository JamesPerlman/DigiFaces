//
//  DiaryThemeViewController.h
//  DigiFaces
//
//  Created by confiz on 28/06/2015.
//  Copyright (c) 2015 Usasha studio. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DailyDiary.h"
#import "DiaryTheme.h"
#import "AddResponseDelegate.h"
@interface DiaryThemeViewController : UITableViewController<AddResponseDelegate>

@property (nonatomic, retain) DailyDiary * dailyDiary;
@property (nonatomic, retain) DiaryTheme * diaryTheme;

@end
