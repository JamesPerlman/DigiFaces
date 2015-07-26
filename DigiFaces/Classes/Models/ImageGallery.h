//
//  imageGallery.h
//  DigiFaces
//
//  Created by confiz on 17/07/2015.
//  Copyright (c) 2015 Usasha studio. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface imageGallery : NSObject

@property (nonatomic, assign) NSInteger imageGalleryId;
@property (nonatomic, assign) NSInteger activityId;

@property (nonatomic, retain) NSMutableArray * files;

-(instancetype) initWithDictionary:(NSDictionary*)dict;

@end
