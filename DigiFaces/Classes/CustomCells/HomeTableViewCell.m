//
//  HomeTableViewCell.m
//  DigiFaces
//
//  Created by James on 7/27/15.
//  Copyright (c) 2015 Usasha studio. All rights reserved.
//

#import "HomeTableViewCell.h"

@implementation HomeTableViewCell

- (void)awakeFromNib {
    // Initialization code
    self.unreadItemLabel.layer.cornerRadius = self.unreadItemLabel.frame.size.height/2.0f;
    self.unreadItemLabel.clipsToBounds = true;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}

- (void)setUnreadCount:(NSInteger)unreadCount {
    if (unreadCount) {
        self.unreadItemLabel.text = [NSString stringWithFormat:@"%@", @(unreadCount)];
        self.unreadItemLabel.hidden = false;
    } else {
        self.unreadItemLabel.hidden = true;
    }
}

@end
