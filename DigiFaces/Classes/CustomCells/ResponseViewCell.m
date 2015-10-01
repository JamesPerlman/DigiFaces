//
//  ResponseViewCell.m
//  DigiFaces
//
//  Created by confiz on 28/06/2015.
//  Copyright (c) 2015 Usasha studio. All rights reserved.
//

#import "ResponseViewCell.h"
#import "File.h"
#import <SDWebImage/UIImageView+WebCache.h>
#import "DFCollectionViewImageCell.h"

#import <MHVideoPhotoGallery/MHGallery.h>

#import "UILabel+setHTML.h"

@implementation ResponseViewCell

- (void)awakeFromNib {
    // Initialization code
    self.unreadIndicator.layer.cornerRadius = self.unreadIndicator.frame.size.height/2.0f;
    self.unreadIndicator.clipsToBounds = true;
    
}

-(void)setFiles:(NSArray *)files
{
    _collectionView.delegate = self;
    _collectionView.dataSource = self;
    _files = files;
    
    [self.collectionView.collectionViewLayout invalidateLayout];
    if (files != nil) {
        [self.collectionView reloadData];
    }
}

-(void)setImageCircular
{
    [_userImage.layer setCornerRadius:_userImage.frame.size.height/2];
}

-(void)reloadFiles
{
    NSInteger xOffset= 0;
    for (int i = 0; i<self.files.count; ++i) {//(File * file in _files) {
        UIImageView * iv = [[UIImageView alloc] initWithFrame:CGRectMake(xOffset, 0, _scrollView.frame.size.height, _scrollView.frame.size.height)];
        iv.clipsToBounds = true;
        [_scrollView addSubview:iv];
        xOffset += _scrollView.frame.size.height;
    }
    [_scrollView setContentSize:CGSizeMake(xOffset, _scrollView.frame.size.height)];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}

- (IBAction)commentClicked:(id)sender {
}

#pragma mark - UICollectionViewDataSource

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    if (_files) {
        return _files.count;
    } else {
        return 0;
    }
}

- (UICollectionViewCell*)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    DFCollectionViewImageCell *cell = (DFCollectionViewImageCell*)[collectionView dequeueReusableCellWithReuseIdentifier:@"ImageViewCell" forIndexPath:indexPath];
    
    File *file = _files[indexPath.row];
    if ([file.fileType isEqualToString:@"Video"]) {
        cell.videoIndicatorView.hidden = false;
        [cell.imageView sd_setImageWithURL:[NSURL URLWithString:[file getVideoThumbURL]]];
    } else {
        [cell.imageView sd_setImageWithURL:file.filePathURL];
        cell.videoIndicatorView.hidden = true;
    }
    
    return cell;
}

#pragma mark - UICollectionViewDelegate
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    //DFCollectionViewImageCell *cell = (DFCollectionViewImageCell*)[collectionView cellForItemAtIndexPath:indexPath];
    
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
    gallery.preferredStatusBarStyleMH = UIStatusBarStyleLightContent;
    gallery.galleryItems = [NSArray arrayWithArray:galleryDataMutable];
    gallery.presentationIndex = indexPath.item;
    
    __weak MHGalleryController *blockGallery = gallery;
    
    defwself
    gallery.finishedCallback = ^(NSInteger currentIndex,UIImage *image,MHTransitionDismissMHGallery *interactiveTransition, MHGalleryViewMode viewMode){
        
        defsself
        NSIndexPath *newIndex = [NSIndexPath indexPathForItem:currentIndex inSection:0];
        
        [sself.collectionView scrollToItemAtIndexPath:newIndex atScrollPosition:UICollectionViewScrollPositionCenteredHorizontally animated:NO];
        
        dispatch_async(dispatch_get_main_queue(), ^{
//            UIImageView *imageView = [(DFCollectionViewImageCell*)[sself.collectionView cellForItemAtIndexPath:newIndex] imageView];
            [blockGallery dismissViewControllerAnimated:YES dismissImageView:nil completion:nil];
            [interactiveTransition.moviePlayer stop];
            
        });
        
    };
    [self.viewController presentMHGalleryController:gallery animated:YES completion:nil];
}


- (void)setResponseText:(NSString *)text {
    [self.lblResponse setHTML:text];
}

@end
