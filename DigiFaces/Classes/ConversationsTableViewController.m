//
//  ConversationsTableViewController.m
//  DigiFaces
//
//  Created by James on 8/4/15.
//  Copyright (c) 2015 INET360. All rights reserved.
//

#import "ConversationsTableViewController.h"
#import "MBProgressHUD.h"
#import "CustomAlertView.h"
#import "NotificationCell.h"
#import "Message.h"
#import "UserInfo.h"
#import "ConversationDetailViewController.h"
#import <SDWebImage/UIImageView+WebCache.h>

static NSString *messageCellID = @"conversationCell";

@interface ConversationsTableViewController ()<PopUpDelegate> {
    CustomAlertView *customAlert;
}

@property (nonatomic, strong) NSArray *conversations;
@property (nonatomic, strong) Message *selectedMessage;

@end

@implementation ConversationsTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    customAlert = [[CustomAlertView alloc] initWithNibName:@"CustomAlertView" bundle:nil];
    customAlert.delegate = self;
    [self loadConversations];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 100.0f;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
    return self.conversations.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NotificationCell *cell = (NotificationCell*)[tableView dequeueReusableCellWithIdentifier:messageCellID forIndexPath:indexPath];
    
    Message *message = [self messageForIndex:indexPath.row];
    
    // Configure the cell...
    
    [cell.userImage sd_setImageWithURL:message.fromUserInfo.avatarFile.filePathURL];
    cell.lblDate.text = message.dateCreatedFormatted;
    cell.lblUserName.text = message.fromUserInfo.appUserName;
    cell.contentLabel.text = message.subject;
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    self.selectedMessage = self.conversations[indexPath.row];
    
    [self performSegueWithIdentifier:@"toConversation" sender:nil];
}

- (Message*)messageForIndex:(NSInteger)index {
    return self.conversations[index];
}

- (void)configureCellText:(NotificationCell*)cell withMessage:(Message*)message {
}

#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    if ([[segue identifier] isEqualToString:@"toConversation"]) {
        ConversationDetailViewController *cdvc = [segue destinationViewController];
        cdvc.message = self.selectedMessage;
    }
}

#pragma mark - Server Interaction

- (void)loadConversations {
    defwself
    [DFClient makeRequest:APIPathGetMessages
                   method:RKRequestMethodGET
                urlParams:@{@"projectId" : LS.myUserInfo.currentProjectId}
               bodyParams:nil
                  success:^(NSDictionary *response, id result) {
                      defsself
                      if ([result isKindOfClass:[NSArray class]]) {
                          sself.conversations = result;
                      } else {
                          sself.conversations = @[result];
                      }
                      [sself.tableView reloadData];
                  }
                  failure:^(NSError *error) {
                      defsself
                      [customAlert showAlertWithMessage:NSLocalizedString(@"Could not load conversations.  Try again?", nil) inView:sself.view withTag:0];
                  }];
}

#pragma mark - PopUpDelegate

- (void)okayButtonTappedWithTag:(NSInteger)tag {
    [self loadConversations];
}

@end
