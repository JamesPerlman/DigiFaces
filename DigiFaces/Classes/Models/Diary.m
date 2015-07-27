//
//  Diary.m
//  DigiFaces
//
//  Created by Apple on 16/06/2015.
//  Copyright (c) 2015 Usasha studio. All rights reserved.
//

#import "Diary.h"

@implementation Diary

-(instancetype)initWithDictionary:(NSDictionary *)dict
{
    self = [super init];
    if (self) {
        self.dateCreated = [dict valueForKey:@"DateCreated"];
        self.dateCreatedFormatted =[dict valueForKey:@"DateCreatedFormatted"];
        self.isRead = [[dict valueForKey:@"IsRead"] boolValue];
        self.response = [dict valueForKey:@"Response"];
        self.responseID = [[dict valueForKey:@"ResponseId"] integerValue];
        self.title = [dict valueForKey:@"Title"];
        self.useID = [dict valueForKey:@"UserId"];
        self.threadId = [dict valueForKey:@"ThreadId"];
        
        _userInfo = [[UserInfo alloc] initWithDictioanry:[dict valueForKey:@"UserInfo"]];
        
        _files = [[NSMutableArray alloc] init];
        if ([[dict valueForKey:@"Files"] count]>0) {
            for (NSDictionary * d in [dict valueForKey:@"Files"]) {
                File * f = [[File alloc] initWithDictionary:d];
                [_files addObject:f];
            }
        }
        
        _comments = [[NSMutableArray alloc] init];
        if ([[dict valueForKey:@"Comments"] count]>0) {
            for (NSDictionary * d in [dict valueForKey:@"Comments"]) {
                Comment * c = [[Comment alloc] initWithDictionary:d];
                [_comments addObject:c];
            }
        }
    }
    return self;
}

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
