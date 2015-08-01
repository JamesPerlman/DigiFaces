//
//  DailyDiary.m
//  DigiFaces
//
//  Created by confiz on 27/06/2015.
//  Copyright (c) 2015 Usasha studio. All rights reserved.
//

#import "DailyDiary.h"
#import "Diary.h"

@implementation DailyDiary

- (void)checkForUnreadComments {
    /* Faizan said the server side still needed some work here - The problem is that each Diary.IsRead = false, even when there are new comments.  This should be removed to save client energy, once that problem is fixed. */
    
    // mark user diaries unread if they have comments that are unread
    for (Diary *diary in self.userDiaries) {
        for (Comment *comment in diary.comments) {
            if (!comment.isRead.boolValue) {
                diary.isRead = false;
                break;
            }
        }
    }
}
/*
 
-(instancetype)initWithDictionary:(NSDictionary *)dict
{
    self = [super init];
    if (self) {
        self.diaryID = [[dict valueForKey:@"DiaryId"] integerValue];
        self.activityId = [[dict valueForKey:@"ActivityId"] integerValue];
        if ([dict valueForKey:@"DiaryQuestion"]) {
            self.diaryQuestion = [dict valueForKey:@"DiaryQuestion"];
        }
        
        _file = [[File alloc] initWithDictionary:[dict valueForKey:@"File"]];
        
        _userDiaries = [[NSMutableArray alloc] init];
        if ([[dict valueForKey:@"UserDiaries"] count]>0) {
            for (NSDictionary * d in [dict valueForKey:@"UserDiaries"]) {
                
                Diary * diary = [[Diary alloc] initWithDictionary:d];
                [_userDiaries addObject:diary];
                // Add user diaries here
            }
        }
        [self extractDiariesBasedOnDate];
    }
    return self;
}
*/

/*
-(void)extractDiariesBasedOnDate
{
    _diariesDict = [[NSMutableDictionary alloc] init];
    _diariesDate = [[NSMutableArray alloc] init];
    
    for (Diary* d in _userDiaries) {
        NSString * dDate = [[d.dateCreated componentsSeparatedByString:@"T"] firstObject];
        if ([_diariesDict valueForKey:dDate]) {
            NSMutableArray * arrDiary = [_diariesDict objectForKey:dDate]
            ;
            [arrDiary addObject:d];
        }
        else{
            NSMutableArray * arrDiary = [[NSMutableArray alloc] init];
            [arrDiary addObject:d];
            [_diariesDict setObject:arrDiary forKey:dDate];
            [_diariesDate addObject:dDate];
        }
    }
}
*/
@end
