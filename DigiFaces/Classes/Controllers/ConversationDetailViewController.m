//
//  ConversationDetailViewController.m
//  DigiFaces
//
//  Created by James on 8/12/15.
//  Copyright (c) 2015 INET360. All rights reserved.
//

#import "ConversationDetailViewController.h"

#import "NotificationCell.h"

#import "CustomAlertView.h"

#import <SDWebImage/UIImageView+WebCache.h>
#import <HPGrowingTextView/HPGrowingTextView.h>
#import "MBProgressHUD.h"

#import "Message.h"
#import "UserInfo.h"
#import "File.h"

static NSString *leftCellID = @"leftSideComment";


@interface ConversationDetailViewController ()<HPGrowingTextViewDelegate, UITableViewDataSource, UITableViewDelegate> {

}
@property (nonatomic, weak) IBOutlet HPGrowingTextView *messageTextView;
@property (nonatomic, weak) IBOutlet UIButton *submitButton;
@property (nonatomic, weak) IBOutlet UITableView *tableView;

@property (nonatomic, strong) CustomAlertView *alertView;
@property (nonatomic, strong) NSMutableSet *addedMessages;
@property (nonatomic, strong) NSMutableArray *cellHeights;
@end

@implementation ConversationDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.cellHeights = [NSMutableArray array];
    self.addedMessages = [NSMutableSet set];
    // Do any additional setup after loading the view.
    self.navigationItem.title = self.message.subject;
    [self calculateHeightsForTableViewRows];
    
    self.messageTextView.layer.cornerRadius = 4.0f;
    self.messageTextView.clipsToBounds = true;
    self.messageTextView.delegate = self;
    
    self.alertView = [[CustomAlertView alloc] initWithNibName:@"CustomAlertView" bundle:[NSBundle mainBundle]];
    [self localizeUI];
}

- (void)localizeUI {
    self.messageTextView.placeholder = DFLocalizedString(@"view.conversation.input.reply", nil);
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [self removeNewMessages];
}

- (void)removeNewMessages {
    /*for (Message *message in self.addedMessages) {
        [self.managedObjectContext deleteObject:message];
    }
    */
    if ([self.delegate respondsToSelector:@selector(didAddMessages:)]) {
        [self.delegate didAddMessages:[NSSet setWithSet:self.addedMessages]];
    }

    [self.addedMessages removeAllObjects];
    //[self.managedObjectContext save:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)calculateHeightsForTableViewRows {
    [self.cellHeights removeAllObjects];
    NotificationCell *cell = [self.tableView dequeueReusableCellWithIdentifier:leftCellID];
    
    
    for (NSInteger i = 0, n = self.messages.count; i<n; ++i) {
        Message *message = self.messages[i];
        [self configureCell:cell withMessage:message];
        
        CGFloat height = 8 + cell.userImage.frame.size.height + 8;
        height += 8 + [cell.contentLabel sizeThatFits:CGSizeMake(cell.contentLabel.frame.size.width, CGFLOAT_MAX)].height + 8;
        
        [_cellHeights addObject:@(height)];
    }
}

#pragma mark - UITableViewDataSource

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return (CGFloat)[self.cellHeights[indexPath.row] floatValue];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.message.childMessages.count + 1;
}

- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    
    Message *message = self.messages[indexPath.row];

    NotificationCell *cell = (NotificationCell*)[tableView dequeueReusableCellWithIdentifier:leftCellID forIndexPath:indexPath];
    [cell.userImage sd_setImageWithURL:message.fromUserInfo.avatarFile.filePathURL];
    cell.userImage.layer.cornerRadius = cell.userImage.bounds.size.width/2.0;
    cell.userImage.clipsToBounds = YES;
    [self configureCell:cell withMessage:message];
    
    return cell;
}

- (void)configureCell:(NotificationCell*)cell withMessage:(Message*)message {
    cell.lblUserName.text = message.fromUserInfo.appUserName;
    cell.lblDate.text = message.dateCreatedFormatted;
    cell.lblInfo.text = message.subject;
    cell.contentLabel.text = message.response.length ? message.response : DFLocalizedString(@"app.misc.text.no_content", nil);
}


/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */

- (IBAction)goBack:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}
#pragma mark - Server Interaction

- (IBAction)sendMessage:(id)sender {
    NSString *responseText = self.messageTextView.text;
    if (!responseText.length) {
        return;
    }
    [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
    defwself
    [DFClient makeJSONRequest:APIPathReplyFromModerator
                       method:RKRequestMethodPOST
                    urlParams:@{@"projectId" : LS.myUserInfo.currentProjectId,
                                @"parentMessageId" : self.message.messageId}
                   bodyParams:@{@"Response" : responseText}
                      success:^(NSDictionary *response, id result) {
                          defsself
                          
                          [MBProgressHUD hideHUDForView:sself.navigationController.view animated:YES];
                          [sself addNewMessageWithContent:responseText];
                          [sself.messageTextView setText:nil];
                      }
                      failure:^(NSError *error) {
                          defsself
                          NSLog(@"Error replying to conversation: %@", error);
                          
                          [sself.alertView showAlertWithMessage:DFLocalizedString(@"view.conversation.error.post_reply_failure", nil) inView:sself.view withTag:0];
                          [MBProgressHUD hideHUDForView:sself.navigationController.view animated:YES];
                      }];
}

#pragma mark - Text View Delegate
- (void)growingTextViewDidEndEditing:(HPGrowingTextView *)growingTextView {
    [self sendMessage:nil];
}

#pragma mark - Property Accessors

- (void)setMessage:(Message *)message {
    _message = message;
    [self orderMessages];
}

- (void)orderMessages {
    NSSortDescriptor *sortDesc = [NSSortDescriptor sortDescriptorWithKey:@"messageId" ascending:YES];
    NSArray *orderedMessages = [self.message.childMessages sortedArrayUsingDescriptors:@[sortDesc]];
    self.messages = [@[self.message] arrayByAddingObjectsFromArray:orderedMessages];
}


#pragma mark - CoreData

- (void)addNewMessageWithContent:(NSString*)content {
    Message *message = [NSEntityDescription insertNewObjectForEntityForName:@"Message" inManagedObjectContext:self.managedObjectContext];
    message.response = content;
    message.messageId = @((NSInteger)[[NSDate date] timeIntervalSince1970]);
    message.fromUserInfo = LS.myUserInfo;
    [self.message addChildMessagesObject:message];
    [self.addedMessages addObject:message];
    [self.managedObjectContext save:nil];
    [self orderMessages];
    [self calculateHeightsForTableViewRows];
    [self.tableView reloadData];
    [self.tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:[self.tableView numberOfRowsInSection:0]-1 inSection:0] atScrollPosition:UITableViewScrollPositionBottom animated:YES];
}

- (NSManagedObjectContext*)managedObjectContext {
    return [RKObjectManager sharedManager].managedObjectStore.mainQueueManagedObjectContext;
}
@end

