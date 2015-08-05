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

#import "UserManagerShared.h"
#import "Notification.h"
#import "NotificationCell.h"
#import <SDWebImage/UIImageView+WebCache.h>
#import "ResponseViewController.h"
#import "UILabel+setHTML.h"

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
}

- (IBAction)closeThis:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
    if ([self.delegate respondsToSelector:@selector(setUnreadNotifications:)]) {
        [self.delegate setUnreadNotifications:@(_arrNotifications.count-[[_arrNotifications valueForKeyPath:@"@sum.isRead"] integerValue])];
    }
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
                      sself.arrNotifications = result.mutableCopy;
                      
                      [sself.tableView reloadData];
                      [MBProgressHUD hideHUDForView:sself.navigationController.view animated:YES];
                  }
                  failure:^(NSError *error) {
                      defsself
                      
                      [MBProgressHUD hideHUDForView:sself.navigationController.view animated:YES];

                  }];
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
    if (notification.isRead.boolValue) {
        [cell setBackgroundColor:[UIColor whiteColor]];
    } else {
        [cell setBackgroundColor:[UIColor lightGrayColor]];
    }
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
    }
    [self markNotificationRead:self.targetNotification];
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
    }
}



@end
