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

@interface ImagesCell()

@property (nonatomic, retain) NSArray* imagesArray;

@end

@implementation ImagesCell

- (void)awakeFromNib {
    // Initialization code
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
        UIButton * btn = [[UIButton alloc] initWithFrame:CGRectMake(xOffset, 5, self.frame.size.height-10, self.frame.size.height -10)];
        btn.tag = tagIndex++;
        [btn setBackgroundColor:[UIColor lightGrayColor]];
        [btn addTarget:self action:@selector(buttonClicked:) forControlEvents:UIControlEventTouchUpInside];
        if ([file.fileType isEqualToString:@"Image"]) {
            [[btn imageView] sd_setImageWithURL:file.filePathURL];
        }
        [self addSubview:btn];
        xOffset += self.frame.size.height - 5;
    }
    
}

-(void)buttonClicked:(UIButton*)btn
{
    File * file = [_imagesArray objectAtIndex:btn.tag];
    if ([_delegate respondsToSelector:@selector(imageCell:didClickOnButton:atIndex:atFile:)]) {
        [_delegate imageCell:self didClickOnButton:btn atIndex:btn.tag atFile:file];
    }
}

@end
