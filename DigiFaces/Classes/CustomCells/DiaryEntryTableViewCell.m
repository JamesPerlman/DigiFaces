//
//  DiaryEntryTableViewCell.m
//  DigiFaces
//
//  Created by James on 7/26/15.
//  Copyright (c) 2015 Usasha studio. All rights reserved.
//

#import "DiaryEntryTableViewCell.h"
#import "NSString+FontAwesome.h"

@implementation DiaryEntryTableViewCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    [self updateCountLabel];
}

- (void)updateCountLabel {
    NSMutableArray *labelItems = [NSMutableArray array];
    if (self.commentCount) {
        [labelItems addObject:[NSString stringWithFormat:@"\uf0e5 %d", (int)self.commentCount]];
    }
    if (self.pictureCount) {
        [labelItems addObject:[NSString stringWithFormat:@"\uf03e %d", (int)self.pictureCount]];
    }

    if (self.videoCount) {
        [labelItems addObject:[NSString stringWithFormat:@"\uf03d %d", (int)self.videoCount]];
    }
    self.countInfoLabel.text = [[labelItems componentsJoinedByString:@" "] stringByAppendingString:@" "];
    
}

- (UIView*)unreadIndicator {
    if (!_unreadIndicator) {
        _unreadIndicator = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 16, 16)];
        _unreadIndicator.layer.cornerRadius = 8;
        _unreadIndicator.clipsToBounds = true;
        _unreadIndicator.backgroundColor = [UIColor orangeColor];
    }
    return _unreadIndicator;
}

@end
