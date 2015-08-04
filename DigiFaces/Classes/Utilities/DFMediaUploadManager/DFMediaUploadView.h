//
//  DFMediaUploadView.h
//  DigiFaces
//
//  Created by James on 7/21/15.
//  Copyright (c) 2015 Usasha studio. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DFMediaUploadViewDelegate.h"

typedef enum : NSUInteger {
    DFMediaUploadTypeVideo,
    DFMediaUploadTypeImage,
    DFMediaUploadTypeNone
} DFMediaUploadType;

@class DFMediaUploadManager;

IB_DESIGNABLE @interface DFMediaUploadView : UIView

@property (nonatomic, assign) IBOutlet DFMediaUploadManager *delegate;

@property (nonatomic, assign) BOOL hasMedia;

@property (nonatomic, assign) BOOL uploaded;

@property (nonatomic, assign) BOOL uploading;

@property (nonatomic, assign) BOOL error;

@property (nonatomic, copy) NSString *mediaFilePath;

@property (nonatomic, assign) IBInspectable BOOL allowsVideo;
@property (nonatomic, assign) IBInspectable BOOL allowsPhoto;

@property (nonatomic, readonly) NSData* media;

@property (nonatomic, readwrite) UIImage *image;
@property (weak, nonatomic) IBOutlet UIImageView *imageView;

@property (nonatomic, assign) DFMediaUploadType uploadType;

@property (weak, nonatomic) IBOutlet UIProgressView *progressView;

@property (nonatomic, copy) NSString *publicURLString;

@property (nonatomic, copy) NSString *resourceKey;

@end
