//
//  Response.h
//  DigiFaces
//
//  Created by confiz on 27/06/2015.
//  Copyright (c) 2015 Usasha studio. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "UserInfo.h"

@interface Response : NSObject

@property (nonatomic, assign) NSInteger activityID;
@property (nonatomic, assign) NSInteger threadId;
@property (nonatomic, retain) NSString * dateCreated;
@property (nonatomic, retain) NSString * dateCreatedFormated;
@property (nonatomic, assign) BOOL hasImageGalleryResponse;
@property (nonatomic, assign) BOOL hasTextAreaResponse;
@property (nonatomic, retain) NSString * imageGalleryResponse;
@property (nonatomic, assign) BOOL isActive;
@property (nonatomic, assign) BOOL isDraft;
@property (nonatomic, assign) BOOL isRead;

@property (nonatomic, retain) UserInfo * userInfo;

@property (nonatomic, retain) NSMutableArray * researcherComments;
@property (nonatomic, retain) NSMutableArray * tags;
@property (nonatomic, retain) NSMutableArray * internalComments;
@property (nonatomic, retain) NSMutableArray * files;
@property (nonatomic, retain) NSMutableArray * comments;
@property (nonatomic, retain) NSMutableArray * textAreaResponse;

-(instancetype) initWithDictionary:(NSDictionary*)dict;

@end
