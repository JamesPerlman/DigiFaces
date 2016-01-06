//
//  MyProfileViewController.h
//  DigiFaces
//
//  Created by Apple on 17/06/2015.
//  Copyright (c) 2015 Usasha studio. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MyProfileViewController : UIViewController<UITextViewDelegate>

@property(nonatomic, weak)IBOutlet UILabel * titleName;
@property(nonatomic, weak)IBOutlet UITextView * aboutMeTextView;
@property(nonatomic, weak)IBOutlet UIImageView * profilePicView;

- (UIBarButtonItem*)rightBarButtonItem;

@end
