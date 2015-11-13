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
#import "ProjectIntroViewController.h"

@interface AnnouncementsTableViewController () {
    CustomAlertView *customAlert;
}

@property (nonatomic, strong) NSArray *announcements;
@property (nonatomic, strong) Announcement *announcement;
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
    [self getAnnouncements];
    [self localizeUI];
}

- (void)localizeUI {
    self.navigationItem.title = DFLocalizedString(@"view.announcements.navbar.title", nil);
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
                urlParams:@{@"projectId" : LS.myUserInfo.currentProjectId}
               bodyParams:nil
                  success:^(NSDictionary *response, id result) {
                      defsself
                      
                      [MBProgressHUD hideHUDForView:sself.view animated:YES];
                      if ([result isKindOfClass:[NSArray class]]) {
                          if ([result count] == 0) {
                              [sself showEmptyTableMessage];
                          } else {
                              sself.announcements = result;
                          }
                      } else if ([result isKindOfClass:[Announcement class]]) {
                          sself.announcements = @[result];
                      } else {
                          [sself showEmptyTableMessage];
                      }
                      [sself.tableView reloadData];
                      
                  }
                  failure:^(NSError *error) {
                      defsself
                      [MBProgressHUD hideHUDForView:sself.view animated:YES];
                  }];
    
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
}

- (void)showEmptyTableMessage {
    UILabel *labelNotFound = [[UILabel alloc] init];
    labelNotFound.numberOfLines = 0;
    labelNotFound.text = DFLocalizedString(@"view.announcements.alert.empty_table", nil);
    labelNotFound.textAlignment = NSTextAlignmentCenter;
    self.tableView.scrollEnabled = false;
    self.tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    [self.tableView setBackgroundView:labelNotFound];
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

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    self.announcement = _announcements[indexPath.row];
    [self performSegueWithIdentifier:@"toAnnouncement" sender:nil];
}


#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    
    if ([[segue identifier] isEqualToString:@"toAnnouncement"]) {
        ProjectIntroViewController *pivc = (ProjectIntroViewController*)[segue destinationViewController];
        pivc.announcement = self.announcement;
    }
    
}

@end
