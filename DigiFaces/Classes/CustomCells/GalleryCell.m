//
//  GalleryCell.m
//  DigiFaces
//
//  Created by confiz on 21/07/2015.
//  Copyright (c) 2015 Usasha studio. All rights reserved.
//

#import "GalleryCell.h"
#import "File.h"
#import <SDWebImage/UIButton+WebCache.h>

#import <MHVideoPhotoGallery/MHGallery.h>


@implementation GalleryCell

-(void)reloadGallery
{
    [self removeEverything];
    NSInteger xOffset = 0;
    NSInteger tag = 0;
    for (UIView *v in self.scrollView.subviews) {
        [v removeFromSuperview];
    }
    
    self.leftButton.hidden = true;
    if (_files.count < 2) {
        self.rightButton.hidden = true;
    } else {
        self.rightButton.hidden = false;
    }
    for (File * file in _files) {
        UIButton * imageView = [self getImageWithFile:file];
        imageView.tag = tag++;
        imageView.contentMode = UIViewContentModeScaleAspectFill;
        [imageView addTarget:self action:@selector(buttonClicked:) forControlEvents:UIControlEventTouchUpInside];
        
        CGRect rect = imageView.frame;
        rect.origin.x = xOffset;
        xOffset += self.scrollView.frame.size.width;
        [imageView setFrame:rect];
        
        [self.scrollView addSubview:imageView];
    }
    [self.scrollView setContentSize:CGSizeMake(xOffset, self.scrollView.frame.size.height)];
}

-(void) buttonClicked:(UIButton*)sender
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
    gallery.presentationIndex = sender.tag;
    
    __weak MHGalleryController *blockGallery = gallery;
    
    defwself
    gallery.finishedCallback = ^(NSInteger currentIndex,UIImage *image,MHTransitionDismissMHGallery *interactiveTransition, MHGalleryViewMode viewMode){
        
        defsself
        
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [sself.scrollView scrollRectToVisible:CGRectMake(self.frame.size.width*(CGFloat)currentIndex, 0, self.frame.size.width, self.frame.size.height) animated:NO];
            [blockGallery dismissViewControllerAnimated:YES dismissImageView:nil completion:nil];
        });
        
    };
    [self.viewController presentMHGalleryController:gallery animated:YES completion:nil];
}

-(UIButton*)getImageWithFile:(File*)file
{
    UIButton * button = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height)];
    NSString * url;
    if ([file.fileType isEqualToString:@"Image"]) {
        url = file.filePath;
    }
    else{
        url = file.getVideoThumbURL;
    }
    [button sd_setImageWithURL:[NSURL URLWithString:url] forState:UIControlStateNormal];
    
    return button;
}

-(void)removeEverything
{
    for (UIView * vu in self.subviews) {
        if ([vu isKindOfClass:[UIButton class]]) {
            [vu removeFromSuperview];
        }
    }
}

- (IBAction)goLeft:(id)sender {
    CGFloat w = self.scrollView.frame.size.width;
    CGFloat newx = self.scrollView.contentOffset.x-w;
    [self.scrollView scrollRectToVisible:CGRectMake(newx, 0, w, self.scrollView.frame.size.height) animated:YES];
    
    if (roundf(newx/w) == 0) {
        self.leftButton.hidden = true;
    }
    self.rightButton.hidden = false;
}

- (IBAction)goRight:(id)sender {
    CGFloat w = self.scrollView.frame.size.width;
    CGFloat newx=    self.scrollView.contentOffset.x+w;
    [self.scrollView scrollRectToVisible:CGRectMake(newx, 0, w, self.scrollView.frame.size.height) animated:YES];
    
    if (roundf(newx/w) == self.files.count-1) {
        self.rightButton.hidden = true;
    }
    self.leftButton.hidden = false;
}

@end
