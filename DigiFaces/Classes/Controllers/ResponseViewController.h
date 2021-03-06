//
//  ResponseViewController.h
//  DigiFaces
//
//  Created by confiz on 27/06/2015.
//  Copyright (c) 2015 Usasha studio. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Notification.h"
#import "DailyDiary.h"
#import "Diary.h"
#import "Response.h"
#import "HPGrowingTextView.h"

#import "DiaryResponseDelegate.h"
typedef enum {
    ResponseControllerTypeNotification,
    ResponseControllerTypeDiaryResponse,
    ResponseControllerTypeDiaryTheme
}ResponseControllerType;

@interface ResponseViewController : UIViewController
@property (nonatomic, assign) id<DiaryResponseDelegate>delegate;

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UIView *contentView;
@property (weak, nonatomic) IBOutlet UIView *messageTextView;
@property (nonatomic ,retain) Notification * notification;
@property (nonatomic, assign) ResponseControllerType responseType;
@property (nonatomic, retain) Diary * diary;
@property (nonatomic, retain) Response * response;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *constBottomSpace;
- (IBAction)sendComment:(id)sender;
@property (weak, nonatomic) IBOutlet HPGrowingTextView *txtResposne;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *responseHeight;
- (IBAction)exitOnend:(id)sender;

- (void)setThreadId:(NSNumber*)threadId commentId:(NSNumber*)commentId isDiary:(BOOL)isDiary;

@end
