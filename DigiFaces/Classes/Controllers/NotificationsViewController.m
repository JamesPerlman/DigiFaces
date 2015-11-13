//
//  NotificationsViewController.m
//  DigiFaces
//
//  Created by confiz on 27/06/2015.
//  Copyright (c) 2015 Usasha studio. All rights reserved.
//

#import "NotificationsViewController.h"
#import "MBProgressHUD.h"
#import "AFNetworking.h"
#import "Utility.h"

#import "Notification.h"
#import "NotificationCell.h"
#import <SDWebImage/UIImageView+WebCache.h>
#import "ResponseViewController.h"
#import "ConversationDetailViewController.h"
#import "UILabel+setHTML.h"

#import "File.h"

@interface NotificationsViewController () {
}

@property (nonatomic, strong) Notification *targetNotification;
@property (nonatomic, retain) NSMutableArray * arrNotifications;

@property (nonatomic, strong) NSDictionary *notificationMessages;
@end

@implementation NotificationsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    _arrNotifications = [[NSMutableArray alloc] init];
    [self getNotifications];
    [self localizeUI];
}

- (void)localizeUI {
    self.navigationItem.title = DFLocalizedString(@"view.notifications.navbar.title", nil);
}

- (IBAction)closeThis:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - API Methods
-(void)getNotifications
{
    [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
    
    defwself
    [DFClient makeRequest:APIPathGetNotifications
                   method:kGET
                urlParams:@{@"projectId" : LS.myUserInfo.currentProjectId}
               bodyParams:nil
                  success:^(NSDictionary *response, NSArray *result) {
                      defsself
                      
                      if ([result isKindOfClass:[NSArray class]]) {
                          if ([result count] == 0) {
                              [sself showEmptyTableMessage];
                          } else {
                              sself.arrNotifications = result.mutableCopy;
                          }
                      } else if ([result isKindOfClass:[Notification class]]) {
                          sself.arrNotifications = @[result].mutableCopy;
                      } else {
                          [sself showEmptyTableMessage];
                      }
                      
                      [sself.tableView reloadData];
                      [MBProgressHUD hideHUDForView:sself.navigationController.view animated:YES];
                  }
                  failure:^(NSError *error) {
                      defsself
                      
                      [MBProgressHUD hideHUDForView:sself.navigationController.view animated:YES];
                      
                  }];
}

- (void)showEmptyTableMessage {
    UILabel *labelNotFound = [[UILabel alloc] init];
    labelNotFound.numberOfLines = 0;
    labelNotFound.text = DFLocalizedString(@"view.notifications.alert.empty_table", nil);
    labelNotFound.textAlignment = NSTextAlignmentCenter;
    self.tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    [self.tableView setBackgroundView:labelNotFound];
    self.tableView.scrollEnabled = false;
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
    return _arrNotifications.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NotificationCell *cell = [tableView dequeueReusableCellWithIdentifier:@"notificationCell" forIndexPath:indexPath];
    
    Notification * notification = [_arrNotifications objectAtIndex:indexPath.row];
    [cell.userImage sd_setImageWithURL:[NSURL URLWithString:notification.commenterUserInfo.avatarFile.filePath]];
    [cell.lblUserName setText:notification.commenterUserInfo.appUserName];
    [cell.lblDate setText:notification.dateCreatedFormatted];
    [cell.lblInfo setText:notification.usefulMessage];
    // Configure the cell...
    [cell makeImageCircular];
    cell.unreadIndicator.hidden = notification.isRead.boolValue;
    
    cell.separatorInset = UIEdgeInsetsZero;
    cell.layoutMargins = UIEdgeInsetsZero;
    cell.preservesSuperviewLayoutMargins = NO;
    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    self.targetNotification = _arrNotifications[indexPath.row];
    if (self.targetNotification.type == NotificationTypeThreadComment) {
        [self performSegueWithIdentifier:@"responseSegue" sender:self];
    } else if (self.targetNotification.type == NotificationTypeModeratorMessage) {
        [self performSegueWithIdentifier:@"messageSegue" sender:self];
    }
    [self markNotificationRead:self.targetNotification];
    NotificationCell *cell = (NotificationCell*)[tableView cellForRowAtIndexPath:indexPath];
    cell.unreadIndicator.hidden = true;
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

- (void)markNotificationRead:(Notification*)notification {
    defwself
    [DFClient makeRequest:APIPathMarkNotificationRead
                   method:kPOST
                urlParams:@{@"notificationId" : notification.notificationId}
               bodyParams:nil
                  success:^(NSDictionary *response, id result) {
                      defsself
                      notification.isRead = @YES;
                      if ([sself.delegate respondsToSelector:@selector(setUnreadNotifications:)]) {
                          [sself.delegate setUnreadNotifications:@(_arrNotifications.count-[[_arrNotifications valueForKeyPath:@"@sum.isRead"] integerValue])];
                      }
                      [sself.tableView reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:[_arrNotifications indexOfObject:notification] inSection:0]] withRowAnimation:UITableViewRowAnimationNone];
                      /*
                       [sself.tableView beginUpdates];
                       [sself.tableView deleteRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:[_arrNotifications indexOfObject:notification] inSection:0]] withRowAnimation:UITableViewRowAnimationAutomatic];
                       [_arrNotifications removeObject:notification];
                       [sself.tableView endUpdates];*/
                  } failure:nil];
    
    
    
    
}
/*
 // Override to support conditional editing of the table view.
 - (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
 // Return NO if you do not want the specified item to be editable.
 return YES;
 }
 */

/*
 // Override to support editing the table view.
 - (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
 if (editingStyle == UITableViewCellEditingStyleDelete) {
 // Delete the row from the data source
 [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
 } else if (editingStyle == UITableViewCellEditingStyleInsert) {
 // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
 }
 }
 */

/*
 // Override to support rearranging the table view.
 - (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
 }
 */

/*
 // Override to support conditional rearranging of the table view.
 - (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
 // Return NO if you do not want the item to be re-orderable.
 return YES;
 }
 */

#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    if ([segue.identifier isEqualToString:@"responseSegue"]) {
        ResponseViewController * responseController = [segue destinationViewController];
        [responseController setNotification:self.targetNotification];
    } else if ([segue.identifier isEqualToString:@"messageSegue"]) {
        ConversationDetailViewController *convoController = [segue destinationViewController];
        [convoController setNotification:self.targetNotification];
    }
}



@end
