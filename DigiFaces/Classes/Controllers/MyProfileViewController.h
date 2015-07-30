//
//  MyProfileViewController.h
//  DigiFaces
//
//  Created by Apple on 17/06/2015.
//  Copyright (c) 2015 Usasha studio. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MyProfileViewController : UIViewController<UITextViewDelegate>

@property(nonatomic,strong)IBOutlet UILabel * titleName;
@property(nonatomic,strong)IBOutlet UITextView * aboutMeTextView;
@property(nonatomic,strong)IBOutlet UIImageView * profilePicView;
@end
