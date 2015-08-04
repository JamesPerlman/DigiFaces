//
//  Announcement.h
//  DigiFaces
//
//  Created by James on 8/4/15.
//  Copyright (c) 2015 INET360. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Announcement : NSObject
@property (nonatomic, strong) NSNumber *announcementId;
@property (nonatomic, strong) NSString *title;
@property (nonatomic, strong) NSString *text;
@property (nonatomic, strong) NSString *dateCreated;
@property (nonatomic, strong) NSString *dateCreatedFormatted;
@property (nonatomic, strong) NSNumber *isRead;
@property (nonatomic, strong) NSArray  *files;
@end
