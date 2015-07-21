//
//  GalleryCell.m
//  DigiFaces
//
//  Created by confiz on 21/07/2015.
//  Copyright (c) 2015 Usasha studio. All rights reserved.
//

#import "GalleryCell.h"
#import "File.h"
#import "UIImageView+AFNetworking.h"

@implementation GalleryCell

-(void)reloadGallery
{
    [self removeEverything];
    NSInteger xOffset = 0;
    for (File * file in _files) {
        UIButton * imageView = [self getImageWithFile:file];
        
        CGRect rect = imageView.frame;
        rect.origin.x = xOffset;
        xOffset += self.scrollView.frame.size.width;
        [imageView setFrame:rect];
        
        [self.scrollView addSubview:imageView];
    }
    [self.scrollView setContentSize:CGSizeMake(xOffset, 160)];
}

-(UIButton*)getImageWithFile:(File*)file
{
    UIButton * imageView = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 200, 160)];
    [imageView setBackgroundColor:[UIColor redColor]];
    NSString * url;
    if ([file.fileType isEqualToString:@"Image"]) {
        url = file.filePath;
    }
    else{
        url = file.getVideoThumbURL;
    }
    NSURLRequest * request = [NSURLRequest requestWithURL:[NSURL URLWithString:url]];
    __weak typeof(imageView) weakImage = imageView;
    [imageView.imageView setImageWithURLRequest:request placeholderImage:nil success:^(NSURLRequest *request, NSHTTPURLResponse *response, UIImage *image) {
        [weakImage setImage:image forState:UIControlStateNormal];
    } failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error) {
        NSLog(@"Faile to download Image");
    }];
    
    return imageView;
}

-(void)removeEverything
{
    for (UIView * vu in self.subviews) {
        [vu removeFromSuperview];
    }
}

@end
