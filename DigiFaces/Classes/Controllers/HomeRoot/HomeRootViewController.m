//
//  HomeRootViewController.m
//  DigiFaces
//
//  Created by James on 8/5/15.
//  Copyright (c) 2015 INET360. All rights reserved.
//

#import "HomeRootViewController.h"

static NSString *kHomeToAnnouncementsSegueID = @"toAnnouncements";
static NSString *kHomeToConversationsSegueID = @"toConversations";
static NSString *kHomeToNotificationsSegueID = @"toNotifications";
static NSString *kHomeToSettingsSegueID = @"toSettings";

@interface HomeRootViewController ()
@property (strong, nonatomic) IBOutlet UIBarButtonItem *homeBarButtonItem;
@property (strong, nonatomic) UIBarButtonItem *sideMenuRevealButtonItem;
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

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    [self addRevealControls];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [self removeRevealControls];
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
    NSString *segueID = [segue identifier];
    id destVC = [segue destinationViewController];
    
    if ([segueID isEqualToString:@"sw_front"]) {
        [self addRevealControls];
        [self setViewController:destVC animated:true];
    } else {
        [self removeRevealControls];
        self.navigationItem.leftBarButtonItem = self.homeBarButtonItem;
        if ([segueID isEqualToString:kHomeToConversationsSegueID]
            || [segueID isEqualToString:kHomeToAnnouncementsSegueID]
            || [segueID isEqualToString:kHomeToNotificationsSegueID]
            || [segueID isEqualToString:kHomeToSettingsSegueID]) {
            [self setViewController:destVC animated:true];
        }
    }
    
    if ([destVC respondsToSelector:@selector(setDelegate:)]) {
        [destVC setDelegate:self];
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
    [self performSegueWithIdentifier:kHomeToAnnouncementsSegueID sender:nil];
    [self.popover dismissPopoverAnimated:YES];
}

- (void)didTapConversations {
    [self performSegueWithIdentifier:kHomeToConversationsSegueID sender:nil];
    [self.popover dismissPopoverAnimated:YES];
}

- (void)didTapNotifications {
    [self performSegueWithIdentifier:kHomeToNotificationsSegueID sender:nil];
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

#pragma mark - Side Menu Reveal Bar Button Item

- (UIBarButtonItem*)sideMenuRevealButtonItem {
    if (!_sideMenuRevealButtonItem) {
        _sideMenuRevealButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"dashes"] style:UIBarButtonItemStylePlain target:self action:@selector(revealToggle:)];
    }
    return _sideMenuRevealButtonItem;
}

- (void)addRevealControls {
    if (self.navigationItem.leftBarButtonItem != self.sideMenuRevealButtonItem) {
        self.navigationItem.leftBarButtonItem = self.sideMenuRevealButtonItem;
        [self.navigationController.navigationBar addGestureRecognizer:self.navBarPanGestureRecognizer];
        [self.navigationController.navigationBar addGestureRecognizer:self.navBarTapGestureRecognizer];
    }
}

- (void)removeRevealControls {
    if (self.navigationItem.leftBarButtonItem == self.sideMenuRevealButtonItem) {
        self.navigationItem.leftBarButtonItem = nil;
        [self.navigationController.navigationBar removeGestureRecognizer:self.navBarPanGestureRecognizer];
        [self.navigationController.navigationBar removeGestureRecognizer:self.navBarTapGestureRecognizer];
    }
}

@end


@implementation UIViewController (HomeRootViewController)

- (HomeRootViewController*)homeRootViewController {
    return (HomeRootViewController*)self.revealViewController;
}

@end