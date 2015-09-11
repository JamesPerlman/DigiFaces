//
//  ImageGalleryResponse.h
//  DigiFaces
//
//  Created by James on 7/29/15.
//  Copyright (c) 2015 INET360. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ImageGalleryResponse : NSManagedObject

@property (nonatomic, strong) NSNumber * imageGalleryResponseId;
@property (nonatomic, strong) NSNumber * imageGalleryId;
@property (nonatomic, strong) NSNumber * threadId;
@property (nonatomic, retain) NSString * galleryIds;
@property (nonatomic, retain) NSString * response;
@property (nonatomic, retain) NSString * userId;
@property (nonatomic, strong) NSNumber * isActive;



@property (nonatomic, retain) NSArray * files;

@end
