//
//  NotificationsViewController.h
//  DigiFaces
//
//  Created by confiz on 27/06/2015.
//  Copyright (c) 2015 Usasha studio. All rights reserved.
//


#import <UIKit/UIKit.h>

@protocol NotificationVCDelegate <NSObject>

- (void)setUnreadNotifications:(NSNumber*)count;

@end
@interface NotificationsViewController : UITableViewController
@property (nonatomic, assign) id<NotificationVCDelegate>delegate;
@end
