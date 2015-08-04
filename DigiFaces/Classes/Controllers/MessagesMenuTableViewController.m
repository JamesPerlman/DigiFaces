//
//  MessagesMenuTableViewController.m
//  DigiFaces
//
//  Created by James on 8/4/15.
//  Copyright (c) 2015 INET360. All rights reserved.
//

#import "MessagesMenuTableViewController.h"
#import "APIAlertCounts.h"
@interface MessagesMenuTableViewController ()

@end

@implementation MessagesMenuTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    self.tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    self.tableView.scrollEnabled = false;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)setAlertCounts:(APIAlertCounts *)alertCounts {
    _alertCounts = alertCounts;
    [self.tableView reloadData];
}

#pragma mark - Table view data source

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 40.0f;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
    return 3;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"notificationMenuItemCell"];
    
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"notificationMenuItemCell"];
    }
    // Configure the cell...
    NSInteger i = indexPath.row;
    if (i == 0) {
        cell.textLabel.text = @"Notifications";
        [self configureCell:cell withCount:self.alertCounts.notificationsUnreadCount];
    } else if (i == 1) {
        cell.textLabel.text = @"Announcements";
        [self configureCell:cell withCount:self.alertCounts.announcementUnreadCount];
    } else if (i == 2) {
        cell.textLabel.text = @"Conversations";
        [self configureCell:cell withCount:self.alertCounts.messagesUnreadCount];
    }
    
    
    return cell;
}
#pragma mark - TableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    NSInteger i = indexPath.row;
    if (i == 0) {
        if ([self.delegate respondsToSelector:@selector(didTapNotifications)]) {
            [self.delegate didTapNotifications];
        }
    } else if (i == 1) {
        if ([self.delegate respondsToSelector:@selector(didTapAnnouncements)]) {
            [self.delegate didTapAnnouncements];
        }
    } else if (i == 2) {
        if ([self.delegate respondsToSelector:@selector(didTapConversations)]) {
            [self.delegate didTapConversations];
        }
    }
}
    
- (void)configureCell:(UITableViewCell*)cell withCount:(NSNumber*)count {
    NSInteger n = count.integerValue;
    UIView *av = nil;
    if (n) {
        UILabel *label = (UILabel*)(cell.accessoryView);
        
        if (label == nil) {
            label = [[UILabel alloc] init];
            label.backgroundColor = [UIColor orangeColor];
            label.textColor = [UIColor whiteColor];
            label.text = @"0";
            cell.accessoryView = label;
            [label sizeToFit];
            label.layer.cornerRadius = label.bounds.size.height/2.0f;
            label.clipsToBounds = true;
        }
        
        label.text = [NSString stringWithFormat:@" %@ ", count];
        [label sizeToFit];
        av = label;
    }
    
    cell.accessoryView = av;
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
