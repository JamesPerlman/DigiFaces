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
#import "SettingsViewController.h"
#import <WYPopoverController/WYPopoverController.h>

@interface HomeRootViewController : MultiDisplayMenuViewController<MessagesMenuDelegate, NotificationVCDelegate, AnnouncementsVCDelegate>

@property (nonatomic, weak) IBOutlet UILabel * alertCountLabel;

@property (nonatomic, strong) MessagesMenuTableViewController *messagesVC;

@property (nonatomic, strong) SettingsViewController *helpVC;

@property (nonatomic, weak) IBOutlet UIButton *messagesButton;

@property (nonatomic, weak) IBOutlet UIButton *helpButton;



@property (nonatomic, strong) WYPopoverController *alertsPopover;

@property (nonatomic, strong) WYPopoverController *helpPopover;

- (void)setAlertCounts:(APIAlertCounts*)alertCounts;

- (void)addRevealControls;

- (void)removeRevealControls;

- (void)hideHelpPopover;

@end

@interface UIViewController (HomeRootViewController)

- (HomeRootViewController*)homeRootViewController;

@end