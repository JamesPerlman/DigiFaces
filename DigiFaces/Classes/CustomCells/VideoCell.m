//
//  VideoCell.m
//  DigiFaces
//
//  Created by confiz on 02/07/2015.
//  Copyright (c) 2015 Usasha studio. All rights reserved.
//

#import "VideoCell.h"
#import "NSLayoutConstraint+ConvenienceMethods.h"

@implementation VideoCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
    MPMoviePlayerController *mpc = [[MPMoviePlayerController alloc] init];
    [self addSubview:mpc.view];
    mpc.view.translatesAutoresizingMaskIntoConstraints = NO;
    [self addConstraints:[NSLayoutConstraint equalSizeAndCentersWithItem:mpc.view toItem:self]];
    [mpc setShouldAutoplay:NO];
    self.moviePlayerController = mpc;
}

- (void)dealloc {
    [self.moviePlayerController stop];
    [self.moviePlayerController.view removeFromSuperview];
    self.moviePlayerController = nil;
}

@end
