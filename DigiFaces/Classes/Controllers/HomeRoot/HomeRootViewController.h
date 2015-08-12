//
//  HomeRootViewController.h
//  DigiFaces
//
//  Created by James on 8/5/15.
//  Copyright (c) 2015 INET360. All rights reserved.
//

#import "MultiDisplayMenuViewController.h"
#import "APIAlertCounts.h"
#import "MessagesMenuTableViewController.h"
#import "NotificationsViewController.h"
#import "AnnouncementsTableViewController.h"
#import <WYPopoverController/WYPopoverController.h>

@interface HomeRootViewController : MultiDisplayMenuViewController<MessagesMenuDelegate, NotificationVCDelegate, AnnouncementsVCDelegate>

@property (nonatomic,strong)IBOutlet UILabel * alertCountLabel;

@property (nonatomic, strong) MessagesMenuTableViewController *messagesVC;

@property (nonatomic, weak) IBOutlet UIButton *messagesButton;



@property (nonatomic, strong) WYPopoverController *popover;

- (void)setAlertCounts:(APIAlertCounts*)alertCounts;

@end

@interface UIViewController (HomeRootViewController)

- (HomeRootViewController*)homeRootViewController;

@end