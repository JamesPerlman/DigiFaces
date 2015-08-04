//
//  MessagesMenuTableViewController.h
//  DigiFaces
//
//  Created by James on 8/4/15.
//  Copyright (c) 2015 INET360. All rights reserved.
//

#import <UIKit/UIKit.h>

@class APIAlertCounts;

@protocol MessagesMenuDelegate <NSObject>

- (void)didTapConversations;

- (void)didTapAnnouncements;

- (void)didTapNotifications;

@end

@interface MessagesMenuTableViewController : UITableViewController
@property (nonatomic, strong) APIAlertCounts *alertCounts;
@property (nonatomic, assign) id<MessagesMenuDelegate> delegate;
@end
