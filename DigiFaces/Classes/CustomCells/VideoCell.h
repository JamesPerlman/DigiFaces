//
//  VideoCell.h
//  DigiFaces
//
//  Created by confiz on 02/07/2015.
//  Copyright (c) 2015 Usasha studio. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MediaPlayer/MediaPlayer.h>
@interface VideoCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *videoIndicatorView;
@property (nonatomic, retain) MPMoviePlayerController *moviePlayerController;
@end
