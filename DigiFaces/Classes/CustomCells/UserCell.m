//
//  UserCell.m
//  DigiFaces
//
//  Created by confiz on 27/06/2015.
//  Copyright (c) 2015 Usasha studio. All rights reserved.
//

#import "UserCell.h"

@implementation UserCell

- (void)awakeFromNib {
    // Initialization code
}

-(void)makeImageCircular
{
    [self.userImage.layer setCornerRadius:self.userImage.frame.size.height/2.0f];
    self.userImage.layer.borderColor = [UIColor lightGrayColor].CGColor;
    self.userImage.layer.borderWidth = 1.0f;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
