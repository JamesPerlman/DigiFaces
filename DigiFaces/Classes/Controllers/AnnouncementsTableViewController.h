//
//  AnnouncementsTableViewController.h
//  DigiFaces
//
//  Created by James on 8/4/15.
//  Copyright (c) 2015 INET360. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol AnnouncementsVCDelegate <NSObject>

- (void)setUnreadAnnouncements:(NSNumber*)count;

@end

@interface AnnouncementsTableViewController : UITableViewController

@property (nonatomic, assign) id<AnnouncementsVCDelegate>delegate;

@end
