//
//  Diary.h
//  DigiFaces
//
//  Created by Apple on 16/06/2015.
//  Copyright (c) 2015 Usasha studio. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Comment.h"

@interface Diary : NSObject

@property (nonatomic, retain) NSString * dateCreated;
@property (nonatomic, retain) NSString * dateCreatedFormatted;
@property (nonatomic, assign) BOOL isRead;
@property (nonatomic, retain) NSString * response;
@property (nonatomic, assign) NSInteger responseID;
@property (nonatomic, retain) NSString * title;
@property (nonatomic, retain) NSString * useID;
@property (nonatomic, retain) NSString * threadId;


@property (nonatomic, retain) UserInfo * userInfo;

@property (nonatomic, retain) NSMutableArray * files;
@property (nonatomic, retain) NSMutableArray * comments;
-(NSInteger)picturesCount;
-(NSInteger)videosCount;
-(instancetype) initWithDictionary:(NSDictionary*)dict;

@end
