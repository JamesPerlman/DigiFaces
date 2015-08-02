//
//  Comment.h
//  DigiFaces
//
//  Created by confiz on 27/06/2015.
//  Copyright (c) 2015 Usasha studio. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "UserInfo.h"

@interface Comment : NSObject

@property (nonatomic, strong) NSNumber * commentId;
@property (nonatomic, retain) NSString * dateCreated;
@property (nonatomic, retain) NSString * dateCreatedFormatted;
@property (nonatomic, strong) NSNumber * isActive;
@property (nonatomic, strong) NSNumber * isRead;
@property (nonatomic, retain) NSString * response;
@property (nonatomic, strong) NSNumber * threadId;
@property (nonatomic, retain) NSString * userId;

@property (nonatomic, retain) UserInfo * userInfo;

//-(instancetype) initWithDictionary:(NSDictionary*)dict;

@end
