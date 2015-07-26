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
    ProfilePicutreTypeDefault,
    ProfilePicutreTypeGallery
}ProfilePicutreType;

@protocol ProfilePictureViewControllerDelegate <NSObject>

-(void)profilePicutreDidSelect:(id)selectedProfile;

@end

@class DFMediaUploadView, DFMediaUploadManager;

@interface ProfilePictureCollectionViewController : UICollectionViewController

@property (nonatomic, assign) id<ProfilePictureViewControllerDelegate> delegate;
@property (nonatomic, assign) ProfilePicutreType type;
@property (nonatomic, retain) NSArray * files;
@property (nonatomic, retain) IBOutlet DFMediaUploadManager *mediaUploadManager;

@end
