//
//  imageGallery.h
//  DigiFaces
//
//  Created by confiz on 17/07/2015.
//  Copyright (c) 2015 Usasha studio. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ImageGallery : NSObject

@property (nonatomic, strong) NSNumber * imageGalleryId;
@property (nonatomic, strong) NSNumber * activityId;
@property (nonatomic, strong) NSNumber * userId;
@property (nonatomic, strong) NSString * galleryIds;


@property (nonatomic, retain) NSArray * files;


@end
