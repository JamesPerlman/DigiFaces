//
//  Response.m
//  DigiFaces
//
//  Created by confiz on 27/06/2015.
//  Copyright (c) 2015 Usasha studio. All rights reserved.
//

#import "Response.h"
#import "Comment.h"
#import "TextAreaResponse.h"

@implementation Response
/*
-(instancetype)initWithDictionary:(NSDictionary *)dict
{
    self = [super init];
    if (self) {
        
        self.activityID = [[dict valueForKey:@"ActivityId"] integerValue];
        self.threadId = [[dict valueForKey:@"ThreadId"] integerValue];
        self.dateCreated = [dict valueForKey:@"DateCreated"];
        self.dateCreatedFormated = [dict valueForKey:@"DateCreatedFormatted"];
        self.hasImageGalleryResponse = [[dict valueForKey:@"HasImageGalleryResponses"] boolValue];
        self.hasTextAreaResponse = [[dict valueForKey:@"HasTextareaResponses"] boolValue];
        self.imageGalleryResponse = [dict valueForKey:@"ImageGalleryResponse"];
        self.isActive = [[dict valueForKey:@"IsActive"] boolValue];
        self.isRead = [[dict valueForKey:@"IsRead"] boolValue];
        
        _userInfo = [[UserInfo alloc] initWithDictioanry:[dict valueForKey:@"UserInfo"]];
        
        _textAreaResponse = [[NSMutableArray alloc] init];
        if ([dict valueForKey:@"TextareaResponse"]) {
            for (NSDictionary * d in [dict valueForKey:@"TextareaResponse"]) {
                TextAreaResponse * t = [[TextAreaResponse alloc] initWithDictionary:d];
                [_textAreaResponse addObject:t];
            }
        }
        
        _comments = [[NSMutableArray alloc] init];
        if ([dict valueForKey:@"Comments"]) {
            for (NSDictionary * d in [dict valueForKey:@"Comments"]) {
                Comment * c = [[Comment alloc] initWithDictionary:d];
                [_comments addObject:c];
            }
        }
        
    }
    return self;
}*/

@end
