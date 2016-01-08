//
//  ProfilePicCell.m
//  DigiFaces
//
//  Created by confiz on 20/06/2015.
//  Copyright (c) 2015 Usasha studio. All rights reserved.
//

#import "ProfilePicCell.h"

@implementation ProfilePicCell

- (void)awakeFromNib {
    // Initialization code
    [self localizeUI];
}

- (void)localizeUI {
    [self.editProfileButton setTitle:DFLocalizedString(@"view.home.button.edit_profile", nil) forState:UIControlStateNormal];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (IBAction)cameraClicked:(id)sender {
    if ([_delegate respondsToSelector:@selector(cameraClicked)]) {
        [_delegate cameraClicked];
    }
}
@end
