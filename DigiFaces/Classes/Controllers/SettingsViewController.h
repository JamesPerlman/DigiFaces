//
//  SettingsViewController.h
//  DigiFaces
//
//  Created by Apple on 17/06/2015.
//  Copyright (c) 2015 Usasha studio. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol HelpPopoverDelegate <NSObject>

- (void)setViewController:(UIViewController*)viewController animated:(BOOL)animated;
- (void)setViewControllerWithID:(NSString*)VCID;

- (void)hideHelpPopover;

@end

@interface SettingsViewController : UIViewController<UITableViewDataSource,UITableViewDelegate>{
}

@property (nonatomic, assign) UIViewController<HelpPopoverDelegate>*delegate;

@property (nonatomic, weak) IBOutlet UITableView *tableView;


@end
