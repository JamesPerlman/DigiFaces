//
//  AddResponseViewController.h
//  DigiFaces
//
//  Created by confiz on 27/06/2015.
//  Copyright (c) 2015 Usasha studio. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DailyDiary.h"
#import "DiaryTheme.h"
#import "DFMediaUploadManager.h"
#import "AddResponseDelegate.h"
@interface AddResponseViewController : UIViewController

@property (nonatomic, assign) id<AddResponseDelegate> delegate;

@property (nonatomic, retain) DailyDiary * dailyDiary;
@property (nonatomic, retain) DiaryTheme * diaryTheme;

@property (nonatomic, retain) IBOutlet DFMediaUploadManager * mediaUploadManager;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *constTitleHeight;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *constDateHeight;
@property (weak, nonatomic) IBOutlet UILabel *lblPlaceholder;

@property (weak, nonatomic) IBOutlet UITextField *txtTitle;

@property (weak, nonatomic) IBOutlet UITextView *txtResponse;
@property (weak, nonatomic) IBOutlet UIButton *btnDate;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *constBottomViewHeight;
@property (weak, nonatomic) IBOutlet UIButton *btnViewQuestion;
@property (weak, nonatomic) IBOutlet UIView *imageContainerView;

- (IBAction)exitOnEnd:(id)sender;
- (IBAction)viewQuestion:(id)sender;
- (IBAction)cameraSwitched:(id)sender;
- (IBAction)selectDate:(id)sender;
@end
