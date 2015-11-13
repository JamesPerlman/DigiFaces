//
//  ConversationDetailViewController.h
//  DigiFaces
//
//  Created by James on 8/12/15.
//  Copyright (c) 2015 INET360. All rights reserved.
//

#import <UIKit/UIKit.h>
@class Message;
@class Notification;

@protocol ConversationDetailDelegate <NSObject>

- (void)didAddMessages:(NSSet*)messages;

@end

@interface ConversationDetailViewController : UIViewController

@property (nonatomic, strong) Message *message;

@property (nonatomic, strong) NSArray *messages;

@property (nonatomic, assign) id<ConversationDetailDelegate> delegate;

@property (nonatomic, strong) Notification *notification;

@end
