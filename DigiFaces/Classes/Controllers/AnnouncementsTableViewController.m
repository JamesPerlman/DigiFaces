//
//  AnnouncementsTableViewController.m
//  DigiFaces
//
//  Created by James on 8/4/15.
//  Copyright (c) 2015 INET360. All rights reserved.
//

#import "AnnouncementsTableViewController.h"
#import "CustomAlertView.h"
#import "MBProgressHUD.h"
#import "Announcement.h"
#import "AnnouncementCell.h"
#import "UILabel+setHTML.h"

@interface AnnouncementsTableViewController () {
    CustomAlertView *customAlert;
}

@property (nonatomic, strong) NSArray *announcements;

@end


static NSString *announcementCellReuseIdentifier = @"announcementCell";

@implementation AnnouncementsTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    customAlert = [[CustomAlertView alloc] initWithNibName:@"CustomAlertView" bundle:nil];
    [customAlert setSingleButton:YES];
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Server interaction

- (void)getAnnouncements {
    defwself
    [DFClient makeRequest:APIPathProjectGetAnnouncements
                   method:kGET
                   params:@{@"projectId" : LS.myUserInfo.currentProjectId}
                  success:^(NSDictionary *response, id result) {
                      defsself
                      
                      [MBProgressHUD hideHUDForView:sself.view animated:YES];
                      if ([result isKindOfClass:[NSArray class]]) {
                          sself.announcements = result;
                      } else if ([result isKindOfClass:[Announcement class]]) {
                          sself.announcements = @[result];
                      }
                      [sself.tableView reloadData];
                      
                  }
                  failure:^(NSError *error) {
                      defsself
                      [MBProgressHUD hideHUDForView:sself.view animated:YES];
                  }];
    
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
    return _announcements.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    AnnouncementCell *cell = [tableView dequeueReusableCellWithIdentifier:announcementCellReuseIdentifier forIndexPath:indexPath];
    
    // Configure the cell...
    Announcement *announcement = _announcements[indexPath.row];
    cell.dateLabel.text = announcement.dateCreatedFormatted;
    cell.titleLabel.text = announcement.title;
    [cell.detailsLabel setHTML:announcement.text];
    
    return cell;
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

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
