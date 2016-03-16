//
//  Diary.m
//  
//
//  Created by James on 9/11/15.
//
//

#import "Diary.h"
#import "Comment.h"
#import "File.h"
#import "UserInfo.h"


@implementation Diary

@dynamic dateCreated;
@dynamic dateCreatedFormatted;
@dynamic isRead;
@dynamic response;
@dynamic responseId;
@dynamic threadId;
@dynamic title;
@dynamic userId;
@dynamic userInfo;
@dynamic files;
@dynamic comments;
@dynamic internalComments;
@dynamic researcherComments;

@end

@implementation Diary (DynamicMethods)

- (NSInteger)picturesCount {
    NSInteger x = 0;
    for (File *f in self.files) {
        if ([f.fileType isEqualToString:@"Image"]) {
            x++;
        }
    }
    return x;
}

- (NSInteger)videosCount {
    NSInteger x = 0;
    for (File *f in self.files) {
        if ([f.fileType isEqualToString:@"Video"]) {
            x++;
        }
    }
    return x;
}

@end
