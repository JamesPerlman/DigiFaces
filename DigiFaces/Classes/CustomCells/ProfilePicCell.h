//
//  ProfilePicCell.h
//  DigiFaces
//
//  Created by confiz on 20/06/2015.
//  Copyright (c) 2015 Usasha studio. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol ProfilePicCellDelegate <NSObject>

@optional
-(void)cameraClicked;

@end

@interface ProfilePicCell : UITableViewCell
@property (nonatomic, assign) id<ProfilePicCellDelegate> delegate;
@property (weak, nonatomic) IBOutlet UIImageView *profileImage;

@property (weak, nonatomic) IBOutlet UILabel *lblUserName;
@property (weak, nonatomic) IBOutlet UIButton *editProfileButton;

- (IBAction)cameraClicked:(id)sender;
@end
