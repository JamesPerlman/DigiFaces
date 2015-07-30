//
//  APIHomeAnnouncementResponse.h
//  DigiFaces
//
//  Created by James on 7/29/15.
//  Copyright (c) 2015 INET360. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "File.h"

@interface APIHomeAnnouncementResponse : NSObject

@property (nonatomic, strong) NSNumber * homeAnnouncementId;
@property (nonatomic, retain) NSString * title;
@property (nonatomic, retain) NSString * text;
@property (nonatomic, retain) NSDate * dateCreated;
@property (nonatomic, retain) NSString * dateCreatedFormatted;

@property (nonatomic, strong) File *file;

@end
