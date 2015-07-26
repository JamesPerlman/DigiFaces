//
//  ProfilePictureCollectionViewController.h
//  DigiFaces
//
//  Created by confiz on 22/06/2015.
//  Copyright (c) 2015 Usasha studio. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "File.h"

typedef enum {
    ProfilePictureTypeDefault,
    ProfilePictureTypeGallery
}ProfilePictureType;

@protocol ProfilePictureViewControllerDelegate <NSObject>

-(void)profilePictureDidSelect:(id)selectedProfile withImage:(UIImage*)image;

@end

@class DFMediaUploadView, DFMediaUploadManager;

@interface ProfilePictureCollectionViewController : UICollectionViewController

@property (nonatomic, assign) id<ProfilePictureViewControllerDelegate> delegate;
@property (nonatomic, assign) ProfilePictureType type;
@property (nonatomic, retain) NSArray * files;
@property (nonatomic, retain) IBOutlet DFMediaUploadManager *mediaUploadManager;


@property (nonatomic, retain) File * selectedImageFile;
@property (nonatomic, strong) UIImage * selectedImage;

@end
