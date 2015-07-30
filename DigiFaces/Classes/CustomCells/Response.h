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

@property (nonatomic, strong) NSNumber * activityId;
@property (nonatomic, strong) NSNumber * threadId;
@property (nonatomic, retain) NSString * dateCreated;
@property (nonatomic, retain) NSString * dateCreatedFormatted;
@property (nonatomic, strong) NSNumber * hasImageGalleryResponse;
@property (nonatomic, strong) NSNumber * hasTextareaResponse;
@property (nonatomic, strong) NSNumber * isActive;
@property (nonatomic, strong) NSNumber * isDraft;
@property (nonatomic, strong) NSNumber * isRead;

@property (nonatomic, retain) UserInfo * userInfo;

//@property (nonatomic, retain) NSArray * researcherComments;
@property (nonatomic, retain) NSArray * tags;
//@property (nonatomic, retain) NSArray * internalComments;
@property (nonatomic, retain) NSArray * files;
@property (nonatomic, retain) NSArray * comments;
@property (nonatomic, retain) NSArray * textareaResponses;
@property (nonatomic, retain) NSArray * imageGalleryResponses;

-(instancetype) initWithDictionary:(NSDictionary*)dict;

@end
