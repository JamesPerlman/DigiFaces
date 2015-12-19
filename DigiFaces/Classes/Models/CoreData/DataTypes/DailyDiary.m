//
//  DailyDiary.m
//  
//
//  Created by James on 12/18/15.
//
//

#import "DailyDiary.h"
#import "Diary.h"
#import "File.h"
#import "Project.h"
#import "Comment.h"

@implementation DailyDiary

// Insert code here to add functionality to your managed object subclass

@dynamic diariesDict;
@dynamic diariesDate;

- (void)checkForUnreadComments {
    /* Faizan said the server side still needed some work here - The problem is that each Diary.IsRead = false, even when there are new comments.  This should be removed to save client energy, once that problem is fixed. */
    
    // mark user diaries unread if they have comments that are unread
    for (Diary *diary in self.userDiaries) {
        for (Comment *comment in diary.comments) {
            if (!comment.isRead.boolValue) {
                diary.isRead = @NO;
                break;
            }
        }
    }
}
- (NSInteger)numberOfUnreadResponses {
    [self checkForUnreadComments];
    NSInteger n = 0;
    for (Diary *diary in self.userDiaries) {
        if (!diary.isRead.boolValue) {
            n++;
        }
    }
    return n;
}

- (Diary*)getResponseWithThreadID:(NSNumber *)threadId {
    NSPredicate *searchPredicate = [NSPredicate predicateWithFormat:@"threadId = %@", threadId];
    
    return [self.userDiaries filteredSetUsingPredicate:searchPredicate].anyObject;
}


@end
