//
//  GalleryCell.m
//  DigiFaces
//
//  Created by confiz on 21/07/2015.
//  Copyright (c) 2015 Usasha studio. All rights reserved.
//

#import "GalleryCell.h"
#import "File.h"

#import "GalleryImageCollectionViewCell.h"

#import <SDWebImage/UIImageView+WebCache.h>

#import <MHVideoPhotoGallery/MHGallery.h>

@interface GalleryCell ()
@property (nonatomic, strong) UICollectionViewController *collectionViewController;
@end

@implementation GalleryCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
}

- (void)setFiles:(NSArray *)files {
    _files = files;
    [self.collectionView reloadData];
}

-(void) indexTapped:(NSIndexPath*)index
{
    NSMutableArray *galleryDataMutable = [NSMutableArray array];
    
    for (File *f in self.files) {
        MHGalleryType galleryType;
        MHGalleryItem *item;
        if ([f.fileType isEqualToString:@"Video"]) {
            galleryType = MHGalleryTypeVideo;
            item = [MHGalleryItem itemWithURL:f.filePath galleryType:galleryType];
        } else {
            galleryType = MHGalleryTypeImage;
            item = [MHGalleryItem itemWithURL:f.filePath galleryType:galleryType];
        }
        [galleryDataMutable addObject:item];
    }
    
    
    MHGalleryController *gallery = [MHGalleryController galleryWithPresentationStyle:MHGalleryViewModeImageViewerNavigationBarHidden];
    gallery.galleryItems = [NSArray arrayWithArray:galleryDataMutable];
    gallery.presentationIndex = index.item;
    
    __weak MHGalleryController *blockGallery = gallery;
    
    defwself

    gallery.finishedCallback = ^(NSInteger currentIndex,UIImage *image,MHTransitionDismissMHGallery *interactiveTransition, MHGalleryViewMode viewMode){
        
        defsself
        
        
        dispatch_async(dispatch_get_main_queue(), ^{
            //[sself.scrollView scrollRectToVisible:CGRectMake(self.frame.size.width*(CGFloat)currentIndex, 0, self.frame.size.width, self.frame.size.height) animated:NO];
            [blockGallery dismissViewControllerAnimated:YES dismissImageView:nil completion:nil];
            [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
        });
        
    };
    [self.viewController presentMHGalleryController:gallery animated:YES completion:nil];
}

#pragma mark - Collection View Data Source

- (File*)fileForIndexPath:(NSIndexPath*)indexPath {
    return [self.files objectAtIndex:indexPath.item];
}


- (void)configureCell:(UICollectionViewCell*)cell forItemAtIndexPath:(NSIndexPath*)indexPath {
    GalleryImageCollectionViewCell *galleryImageCell = (GalleryImageCollectionViewCell*)cell;
    File *file = [self fileForIndexPath:indexPath];
    
    NSString *url;
    if ([file.fileType isEqualToString:@"Image"]) {
        url = file.filePath;
    }
    else{
        url = file.getVideoThumbURL;
    }
    if (!url && [file.fileType isEqualToString:@"Video"]) {
        [galleryImageCell.imageView setImage:[UIImage imageNamed:@"genericvid"]];
    } else {
        [galleryImageCell.imageView sd_setImageWithURL:[NSURL URLWithString:url]];
    }

}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.files.count;
}

- (UICollectionViewCell*)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"galleryCollectionCell" forIndexPath:indexPath];
    [self configureCell:cell forItemAtIndexPath:indexPath];
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    
}


@end
