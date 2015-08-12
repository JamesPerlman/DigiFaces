//
//  ConversationDetailViewController.m
//  DigiFaces
//
//  Created by James on 8/12/15.
//  Copyright (c) 2015 INET360. All rights reserved.
//

#import "ConversationDetailViewController.h"
#import "Message.h"
#import "NotificationCell.h"
#import <SDWebImage/UIImageView+WebCache.h>

static NSString *rightCellID = @"rightSideComment";
static NSString *leftCellID = @"leftSideComment";


@interface ConversationDetailViewController () {
    NSMutableArray *_cellHeights;
}
@end

@implementation ConversationDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.navigationItem.title = self.message.subject;
    [self calculateHeightsForTableViewRows];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)calculateHeightsForTableViewRows {
    _cellHeights = [NSMutableArray array];
    NotificationCell *leftCell = [self.tableView dequeueReusableCellWithIdentifier:leftCellID];
    
    NotificationCell *rightCell = [self.tableView dequeueReusableCellWithIdentifier:rightCellID];
    
    
    for (NSInteger i = 0, n = self.message.childMessages.count+1; i<n; ++i) {
        Message *message = [self messageForIndex:i];
        NotificationCell *cell = nil;
        if ([message.fromUser isEqualToString:LS.myUserInfo.userId]) {
            cell = rightCell;
        } else {
            cell = leftCell;
        }
        [self configureCell:cell withMessage:message];
        
        CGFloat height = 8 + cell.userImage.frame.size.height + 8;
        height += 8 + [cell.contentLabel sizeThatFits:CGSizeMake(cell.contentLabel.frame.size.width, CGFLOAT_MAX)].height + 8;
        
        [_cellHeights addObject:@(height)];
    }
}

#pragma mark - UITableViewDataSource

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return (CGFloat)[_cellHeights[indexPath.row] floatValue];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.message.childMessages.count + 1;
}

- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    NSString *identifier;
    
    Message *message = [self messageForIndex:indexPath.row];
    
    if ([message.fromUser isEqualToString:LS.myUserInfo.id]) {
        identifier = rightCellID;
    } else {
        identifier = leftCellID;
    }
    
    
    NotificationCell *cell = (NotificationCell*)[tableView dequeueReusableCellWithIdentifier:identifier forIndexPath:indexPath];
    [cell.userImage sd_setImageWithURL:message.fromUserInfo.avatarFile.filePathURL];
    [self configureCell:cell withMessage:message];
    
    return cell;
}

- (void)configureCell:(NotificationCell*)cell withMessage:(Message*)message {
    cell.lblUserName.text = message.fromUserInfo.appUserName;
    cell.lblDate.text = message.dateCreatedFormatted;
    cell.lblInfo.text = message.subject;
    cell.contentLabel.text = message.response;
}

- (Message*)messageForIndex:(NSInteger)index {
    if (index == 0) {
        return self.message;
    } else {
        return self.message.childMessages[index-1];
    }
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

@end
