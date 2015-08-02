//
//  AddResponseDelegate.h
//  DigiFaces
//
//  Created by James on 8/1/15.
//  Copyright (c) 2015 INET360. All rights reserved.
//

#import <Foundation/Foundation.h>
@class Response, Diary;
@protocol AddResponseDelegate <NSObject>
@optional

- (void)didAddDiaryThemeResponse:(Response*)response;
- (void)didAddDiary:(Diary*)diary;

@end
