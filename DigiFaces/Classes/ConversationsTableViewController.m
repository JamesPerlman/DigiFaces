//
//  ConversationsTableViewController.m
//  DigiFaces
//
//  Created by James on 8/4/15.
//  Copyright (c) 2015 INET360. All rights reserved.
//

#import "ConversationsTableViewController.h"
#import "ConversationDetailViewController.h"
#import "MBProgressHUD.h"
#import "CustomAlertView.h"
#import "NotificationCell.h"
#import "Message.h"
#import "UserInfo.h"
#import "File.h"

#import <SDWebImage/UIImageView+WebCache.h>

static NSString *messageCellID = @"conversationCell";

@interface ConversationsTableViewController ()<PopUpDelegate, ConversationDetailDelegate> {
    CustomAlertView *customAlert;
}

@property (nonatomic, strong) NSArray *conversations;
@property (nonatomic, strong) Message *selectedMessage;

@property (nonatomic, strong) NSMutableSet *addedMessages;
@end

@implementation ConversationsTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    customAlert = [[CustomAlertView alloc] initWithNibName:@"CustomAlertView" bundle:nil];
    customAlert.delegate = self;
    self.addedMessages = [NSMutableSet set];
    self.refreshControl = [[UIRefreshControl alloc] init];
    [self.refreshControl addTarget:self
                            action:@selector(loadConversations)
                  forControlEvents:UIControlEventValueChanged];
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
    NSURL *avatarURL = message.fromUserInfo.avatarFile.filePathURL;
    if (avatarURL) {
        [cell.userImage sd_setImageWithURL:avatarURL];
    } else {
        [cell.userImage sd_setImageWithURL:[NSURL URLWithString:DFAvatarGenericImageURLKey] placeholderImage:[UIImage imageNamed:@"genericavatar" ]];
    }
    cell.lblDate.text = message.dateCreatedFormatted;
    cell.lblUserName.text = message.fromUserInfo.appUserName;
    cell.contentLabel.text = message.subject;
    cell.userImage.layer.cornerRadius = cell.userImage.bounds.size.height/2.0;
    cell.userImage.clipsToBounds = YES;
    
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
        cdvc.delegate = self;
    }
}

#pragma mark - Server Interaction

- (void)loadConversations {
    [self removeAddedMessages];
    defwself
    [DFClient makeRequest:APIPathGetMessages
                   method:RKRequestMethodGET
                urlParams:@{@"projectId" : LS.myUserInfo.currentProjectId}
               bodyParams:nil
                  success:^(NSDictionary *response, id result) {
                      defsself
                      [sself.refreshControl endRefreshing];
                      if ([result isKindOfClass:[NSArray class]]) {
                          if ([result count] == 0) {
                              [sself showEmptyTableMessage];
                          } else {
                              sself.conversations = result;
                          }
                      } else if (result != nil) {
                          sself.conversations = @[result];
                      } else {
                          [sself showEmptyTableMessage];
                      }
                      [sself.tableView reloadData];
                  }
                  failure:^(NSError *error) {
                      defsself
                      [sself.refreshControl endRefreshing];
                      [customAlert showAlertWithMessage:DFLocalizedString(@"view.conversations.error.load_failure", nil) inView:sself.view withTag:0];
                  }];
    [self localizeUI];
}

- (void)localizeUI {
    self.navigationItem.title = DFLocalizedString(@"view.conversations.navbar.title", nil);
}

- (void)showEmptyTableMessage {
    UILabel *labelNotFound = [[UILabel alloc] init];
    labelNotFound.numberOfLines = 0;
    labelNotFound.text = DFLocalizedString(@"view.conversations.alert.empty_table", nil);
    labelNotFound.textAlignment = NSTextAlignmentCenter;
    self.tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    self.tableView.scrollEnabled = false;
    [self.tableView setBackgroundView:labelNotFound];
}

#pragma mark - PopUpDelegate

- (void)okayButtonTappedWithTag:(NSInteger)tag {
    [self loadConversations];
}

#pragma mark - ConversationDetailDelegate

- (void)didAddMessages:(NSSet *)messages {
    [self.addedMessages addObjectsFromArray:[messages allObjects]];
}

- (void)removeAddedMessages {
    for (Message *message in self.addedMessages) {
        [message.managedObjectContext deleteObject:message];
    }
    [self.addedMessages removeAllObjects];
}

@end
