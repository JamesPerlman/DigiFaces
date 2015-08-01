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
    File * file = [_imagesArray objectAtIndex:iv.tag];
    if ([_delegate respondsToSelector:@selector(imageCell:didClickOnButton:atIndex:atFile:)]) {
        [_delegate imageCell:self didClickOnButton:iv atIndex:iv.tag atFile:file];
    }
}

@end
