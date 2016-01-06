//
//  HomeRootViewController.m
//  DigiFaces
//
//  Created by James on 8/5/15.
//  Copyright (c) 2015 INET360. All rights reserved.
//

#import "HomeRootViewController.h"
#import "HomeViewController.h"
#import "NSArray+Search.h"

static NSString * const kHomeToAnnouncementsSegueID = @"toAnnouncements";
static NSString * const kHomeToConversationsSegueID = @"toConversations";
static NSString * const kHomeToNotificationsSegueID = @"toNotifications";
static NSString * const kHomeToHelpSegueID = @"toSettings";

static NSString * const kMyProfileViewControllerID = @"MyProfileViewController";

static NSString * const kHelpViewControllerID = @"SettingsViewController";

@interface HomeRootViewController () <UIGestureRecognizerDelegate, HelpPopoverDelegate>

// Keep this strong - because we remove it and readd it
@property (strong, nonatomic) IBOutlet UIBarButtonItem *homeBarButtonItem;
@property (strong, nonatomic) UIBarButtonItem *sideMenuRevealButtonItem;

@property (strong, nonatomic) IBOutlet UIView *rightBarButtonItemsContainerView;
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
    
    self.helpVC = (SettingsViewController*)[[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:kHelpViewControllerID];
    self.helpVC.delegate = self;
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    if (LS.myUserInfo.projects.count > 1 && self.navigationItem.leftBarButtonItem == nil) {
        [self addRevealControls];
    }
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
    } else if (![segueID isEqualToString:kHomeToHelpSegueID]) {
        [self removeRevealControls];
        self.navigationItem.leftBarButtonItem = self.homeBarButtonItem;
        if ([segueID isEqualToString:kHomeToConversationsSegueID]
            || [segueID isEqualToString:kHomeToAnnouncementsSegueID]
            || [segueID isEqualToString:kHomeToNotificationsSegueID]) {
            [self setViewController:destVC animated:true];
        }
    }
    
    if ([destVC respondsToSelector:@selector(setDelegate:)]) {
        [destVC setDelegate:self];
    }
}

- (void)setViewController:(UIViewController *)viewController animated:(BOOL)animated {
    if ([viewController isKindOfClass:[HomeViewController class]]) {
        [self addRevealControls];
    } else {
        [self removeRevealControls];
        self.navigationItem.leftBarButtonItem = self.homeBarButtonItem;
    }
    // set right bar button item based on content view controller
    if ([viewController respondsToSelector:@selector(rightBarButtonItem)]) {
        self.navigationItem.rightBarButtonItem = [(id)viewController rightBarButtonItem];
    } else {
        self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:self.rightBarButtonItemsContainerView];
    }
    [super setViewController:viewController animated:animated];
}

#pragma mark - Popovers

- (WYPopoverController*)alertsPopover {
    if (!_alertsPopover) {
        _alertsPopover = [[WYPopoverController alloc] initWithContentViewController:self.messagesVC];
        _alertsPopover.popoverContentSize = CGSizeMake([UIScreen mainScreen].bounds.size.width-40.0f, 40.0f * [self.messagesVC tableView:self.messagesVC.tableView numberOfRowsInSection:0]);
        _alertsPopover.passthroughViews = @[self.rightBarButtonItemsContainerView];
    }
    return _alertsPopover;
}

- (WYPopoverController*)helpPopover {
    if (!_helpPopover) {
        _helpPopover = [[WYPopoverController alloc] initWithContentViewController:self.helpVC];
        _helpPopover.popoverContentSize = CGSizeMake([UIScreen mainScreen].bounds.size.width-40.0f, 40.0f * ([self.helpVC tableView:self.helpVC.tableView numberOfRowsInSection:0] + 2));
        _helpPopover.passthroughViews = @[self.rightBarButtonItemsContainerView];
        
    }
    return _helpPopover;
}
#pragma mark - Alert actions
- (void)didTapAnnouncements {
    [self performSegueWithIdentifier:kHomeToAnnouncementsSegueID sender:nil];
    [self.alertsPopover dismissPopoverAnimated:YES];
}

- (void)didTapConversations {
    [self performSegueWithIdentifier:kHomeToConversationsSegueID sender:nil];
    [self.alertsPopover dismissPopoverAnimated:YES];
}

- (void)didTapNotifications {
    [self performSegueWithIdentifier:kHomeToNotificationsSegueID sender:nil];
    [self.alertsPopover dismissPopoverAnimated:YES];
}

#pragma mark - IBActions
- (IBAction)didTapAlerts:(id)sender {
    if (self.alertsPopover.popoverVisible) {
        [self.alertsPopover dismissPopoverAnimated:YES];
    } else {
        [self.alertsPopover presentPopoverFromRect:[self.view convertRect:self.messagesButton.bounds fromView:self.messagesButton]
                                            inView:self.view
                          permittedArrowDirections:WYPopoverArrowDirectionUp animated:YES];
        if (self.helpPopover.popoverVisible) {
            [self.helpPopover dismissPopoverAnimated:YES];
        }
    }
    
}

- (IBAction)didTapHelp:(id)sender {
    if (self.helpPopover.popoverVisible) {
        [self.helpPopover dismissPopoverAnimated:YES];
    } else {
        [self.helpPopover presentPopoverFromRect:[self.view convertRect:self.helpButton.bounds fromView:self.helpButton]
                                          inView:self.view
                        permittedArrowDirections:WYPopoverArrowDirectionUp
                                        animated:true];
        if (self.alertsPopover.popoverVisible) {
            [self.alertsPopover dismissPopoverAnimated:YES];
        }
    }
}

- (void)didTapEditProfile:(id)sender {
    [self setViewControllerWithID:kMyProfileViewControllerID];
}

- (void)hideHelpPopover {
    [self.helpPopover dismissPopoverAnimated:YES];
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
    return (HomeRootViewController*)self.multiDisplayViewController;
}

@end