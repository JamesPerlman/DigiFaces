//
//  VideoCell.m
//  DigiFaces
//
//  Created by confiz on 02/07/2015.
//  Copyright (c) 2015 Usasha studio. All rights reserved.
//

#import "VideoCell.h"
#import "NSLayoutConstraint+ConvenienceMethods.h"
#import <SDWebImage/UIImageView+WebCache.h>

@implementation VideoCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.clipsToBounds = YES;
    MPMoviePlayerController *mpc = [[MPMoviePlayerController alloc] init];
    [self addSubview:mpc.view];
    mpc.view.contentMode = UIViewContentModeScaleAspectFill;
    mpc.view.translatesAutoresizingMaskIntoConstraints = NO;
    [self addConstraints:[NSLayoutConstraint equalSizeAndCentersWithItem:mpc.view toItem:self]];
    [mpc setShouldAutoplay:NO];
    mpc.view.hidden = true;
    self.moviePlayerController = mpc;
}

- (void)setMediaURL:(NSURL*)url {
    self.videoIndicatorView.center = CGPointMake(self.bounds.size.width/2.0, self.bounds.size.height/2.0);
    
}

- (void)setImageWithURL:(NSString *)urlString {
    UIImage *genericImage = [UIImage imageNamed:@"genericvid"];
    if (!urlString) {
        [self.videoImageView setImage:genericImage];
    } else {
        [self.videoImageView sd_setImageWithURL:[NSURL URLWithString:urlString] placeholderImage:genericImage];
    }
}

- (void)playVideo {
    self.moviePlayerController.view.hidden = NO;
    [self.moviePlayerController play];
}
- (void)dealloc {
    [self.moviePlayerController stop];
    [self.moviePlayerController.view removeFromSuperview];
    self.moviePlayerController = nil;
}
@end
