//
//  YouTubeCell.m
//  DigiFaces
//
//  Created by James on 2/21/16.
//  Copyright © 2016 INET360. All rights reserved.
//

#import "YouTubeCell.h"
#import "YTPlayerView.h"
@interface YouTubeCell ()
@property (nonatomic, weak) IBOutlet YTPlayerView *playerView;
@end

@implementation YouTubeCell

- (void)setYoutubeKey:(NSString *)youtubeKey {
    [self.playerView loadWithVideoId:youtubeKey];
}

- (CGFloat)fullHeight {
    return [UIScreen mainScreen].bounds.size.height*.4f + [super fullHeight];

}

- (CGFloat) maxHeight {
    return [UIScreen mainScreen].bounds.size.height*.5f;
}
@end
