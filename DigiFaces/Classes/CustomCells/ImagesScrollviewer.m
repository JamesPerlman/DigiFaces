//
//  ImagesScrollviewer.m
//  DigiFaces
//
//  Created by confiz on 28/06/2015.
//  Copyright (c) 2015 Usasha studio. All rights reserved.
//

#import "ImagesScrollviewer.h"
#import "File.h"
#import "UIImageView+AFNetworking.h"

@implementation ImagesScrollviewer

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

-(void)reloadData
{
    for (UIView * vu in self.subviews) {
        [vu removeFromSuperview];
    }
    
    NSInteger xOffset = 0;
    for (File * file in _filesArray) {
        
        UIImageView * imageview = [self createImageForFile:file];
        
        CGRect rect = imageview.frame;
        rect.origin.x = xOffset + _padding.left;
        [imageview setFrame:rect];
        
        [self addSubview:imageview];
        
        xOffset += rect.size.width + _padding.left + _padding.right;
    }
}

-(UIImageView*)createImageForFile:(File*)file
{
    UIImageView * imageView = [[UIImageView alloc] init];
    [imageView setBackgroundColor:[UIColor grayColor]];
    [imageView setFrame:CGRectMake(0, 0, _itemSize.width - _padding.left - _padding.right, _itemSize.height - _padding.top - _padding.left)];
    
    if ([file.fileType isEqualToString:@"Image"]) {
        [imageView setImageWithURL:[NSURL URLWithString:file.filePath]];
    }
    
    return imageView;
}

@end
