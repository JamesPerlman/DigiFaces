//
//  ImagesCell.m
//  DigiFaces
//
//  Created by confiz on 27/06/2015.
//  Copyright (c) 2015 Usasha studio. All rights reserved.
//

#import "ImagesCell.h"
#import "File.h"
#import <SDWebImage/UIImageView+WebCache.h>
#import <MHVideoPhotoGallery/MHGallery.h>
@interface ImagesCell() {
    NSMapTable *imageViewsForGestureRecognizers;
}

@property (nonatomic, retain) NSArray* imagesArray;

@end

@implementation ImagesCell

- (void)awakeFromNib {
    // Initialization code
    imageViewsForGestureRecognizers = [NSMapTable weakToWeakObjectsMapTable];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(void)setImagesFiles:(NSArray*)files
{
    self.imagesArray = files;
    int xOffset = 5;
    int tagIndex = 0;
    for (File * file in files) {
        UIImageView * iv = [[UIImageView alloc] initWithFrame:CGRectMake(xOffset, 5, self.frame.size.height-10, self.frame.size.height -10)];
        iv.contentMode = UIViewContentModeScaleAspectFill;
        iv.tag = tagIndex++;
        [iv setBackgroundColor:[UIColor lightGrayColor]];
        
        UITapGestureRecognizer *tapGR = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(imageViewTapped:)];
        tapGR.numberOfTouchesRequired = 1;
        [iv addGestureRecognizer:tapGR];
        iv.userInteractionEnabled = true;
        
        [imageViewsForGestureRecognizers setObject:iv forKey:tapGR];
        
        if ([file.fileType isEqualToString:@"Image"]) {
            [iv sd_setImageWithURL:file.filePathURL];
        } else if ([file.fileType isEqualToString:@"Video"]) {
            [iv sd_setImageWithURL:[NSURL URLWithString:[file getVideoThumbURL]]];
        }
        [self.contentView addSubview:iv];
        xOffset += self.frame.size.height - 5;
    }
    
}
-(void)imageViewTapped:(UITapGestureRecognizer*)gr
{
    UIImageView *iv = [imageViewsForGestureRecognizers objectForKey:gr];
   // File * file = [_imagesArray objectAtIndex:iv.tag];
    NSInteger index = iv.tag;
    /*
    if ([_delegate respondsToSelector:@selector(imageCell:didClickOnButton:atIndex:atFile:)]) {
        [_delegate imageCell:self didClickOnButton:iv atIndex:iv.tag atFile:file];
    }*/
    
    
    NSMutableArray *galleryDataMutable = [NSMutableArray array];
    
    for (File *f in self.imagesArray) {
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
    gallery.presentationIndex = index;
    
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


@end
