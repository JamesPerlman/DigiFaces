//
//  HomeRootViewController.m
//  DigiFaces
//
//  Created by James on 8/5/15.
//  Copyright (c) 2015 INET360. All rights reserved.
//

#import "HomeRootViewController.h"

@interface HomeRootViewController ()
@property (strong, nonatomic) IBOutlet UIBarButtonItem *homeBarButtonItem;

@end

@implementation HomeRootViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.navigationItem.leftBarButtonItem = nil;
    
    self.alertCountLabel.layer.cornerRadius = self.alertCountLabel.frame.size.height/2.0f;
    self.alertCountLabel.clipsToBounds = true;
    self.alertCountLabel.hidden = true;
    
    
    self.messagesVC = [[MessagesMenuTableViewController alloc] init];
    self.messagesVC.delegate = self;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    if ([[segue identifier] isEqualToString:@"init"]) {
        self.navigationItem.leftBarButtonItem = nil;
    } else {
        self.navigationItem.leftBarButtonItem = self.homeBarButtonItem;
    }
    
    if ([[segue destinationViewController] respondsToSelector:@selector(setDelegate:)]) {
        [[segue destinationViewController] setDelegate:self];
    }
}

#pragma mark - Popover

- (WYPopoverController*)popover {
    if (!_popover) {
        _popover = [[WYPopoverController alloc] initWithContentViewController:self.messagesVC];
        _popover.popoverContentSize = CGSizeMake([UIScreen mainScreen].bounds.size.width-40.0f, 40.0f * [self.messagesVC tableView:self.messagesVC.tableView numberOfRowsInSection:0]);
        
    }
    return _popover;
}

- (IBAction)didTapAlerts:(id)sender {
        [self.popover presentPopoverFromRect:[self.view convertRect:self.messagesButton.bounds fromView:self.messagesButton]
                                      inView:self.view
                    permittedArrowDirections:WYPopoverArrowDirectionUp animated:YES];
    
}

- (void)didTapAnnouncements {
    [self performSegueWithIdentifier:@"toAnnouncements" sender:nil];
    [self.popover dismissPopoverAnimated:YES];
}

- (void)didTapConversations {
    [self performSegueWithIdentifier:@"toConversations" sender:nil];
    [self.popover dismissPopoverAnimated:YES];
}

- (void)didTapNotifications {
    [self performSegueWithIdentifier:@"toNotifications" sender:nil];
    [self.popover dismissPopoverAnimated:YES];
}

#pragma mark - messages delegate callbacks
- (void)setUnreadNotifications:(NSNumber *)count {
    self.messagesVC.alertCounts.notificationsUnreadCount = count;
    [self refreshAlertCounts];
}

- (void)setUnreadAnnouncements:(NSNumber *)count {
    self.messagesVC.alertCounts.announcementUnreadCount = count;
    [self refreshAlertCounts];
}

- (void)setAlertCounts:(APIAlertCounts*)alertCounts {
    
    [self.messagesVC setAlertCounts:alertCounts];
    [self refreshAlertCounts];
}

- (void)refreshAlertCounts {
    APIAlertCounts *ac = self.messagesVC.alertCounts;
    self.alertCountLabel.hidden = !(ac.totalUnreadCount.boolValue);
    ac.totalUnreadCount = @(ac.notificationsUnreadCount.intValue + ac.messagesUnreadCount.intValue + ac.announcementUnreadCount.intValue);
    self.alertCountLabel.text = [NSString stringWithFormat:@" %@ ", ac.totalUnreadCount];
    [self.messagesVC.tableView reloadData];
}
@end


@implementation UIViewController (HomeRootViewController)

- (HomeRootViewController*)homeRootViewController {
    return (HomeRootViewController*)self.multiDisplayViewController;
}

@end