//
//  NotificationCell.m
//  DigiFaces
//
//  Created by confiz on 27/06/2015.
//  Copyright (c) 2015 Usasha studio. All rights reserved.
//

#import "NotificationCell.h"
#import "UILabel+setHTML.h"

@implementation NotificationCell

- (void)awakeFromNib {
    // Initialization code
    self.unreadIndicator.layer.cornerRadius = self.unreadIndicator.frame.size.height/2.0f;
    self.unreadIndicator.clipsToBounds = true;
}

-(void)makeImageCircular
{
    [self.userImage.layer setCornerRadius:20];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setContentText:(NSString *)text {
    [self.contentLabel setHTML:text];
}

@end
