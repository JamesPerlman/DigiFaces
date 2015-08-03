//
//  ResponseViewController.m
//  DigiFaces
//
//  Created by confiz on 27/06/2015.
//  Copyright (c) 2015 Usasha studio. All rights reserved.
//

#import "ResponseViewController.h"
#import "MBProgressHUD.h"
#import "AFNetworking.h"
#import "Utility.h"

#import "Response.h"
#import "UserCell.h"
#import "ImagesCell.h"
#import "NotificationCell.h"
#import "Comment.h"
#import "UIImageView+AFNetworking.h"
#import "TextAreaResponse.h"
#import "CommentCell.h"
#import "Utility.h"
#import "CustomAlertView.h"
#import "RTCell.h"
#import "DailyDiary.h"
#import "CarouselViewController.h"
#import "UserManagerShared.h"
#import "NSString+StripHTML.h"

#import <SDWebImage/UIImageView+WebCache.h>

typedef enum {
    CellTypeUser,
    CellTypeTitle,
    CellTypeIntro,
    CellTypeImages,
    CellTypeHeader,
    CellTypeComment
}CellType;

@interface ResponseViewController () <CommentCellDelegate, ImageCellDelegate>
{
    NSInteger contentHeight;
    RTCell *infoCell;
    NSInteger selectedIndex;
}

@property (nonatomic, retain) NSMutableArray * cellsArray;

@property (nonatomic, retain) CustomAlertView * customAlert;
@property (nonatomic, retain) NSMutableArray * arrResponses;
@property (nonatomic, retain) NSMutableArray * heightArray;
@property (nonatomic, strong) DailyDiary *dailyDiary;

@end

@implementation ResponseViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    if (self.diary) {
        self.navigationItem.title = self.diary.title;
    }
    
    _heightArray = [[NSMutableArray alloc] init];
    
    self.customAlert = [[CustomAlertView alloc]initWithNibName:@"CustomAlertView" bundle:nil];
    [self.customAlert setSingleButton:YES];
    
    _arrResponses = [[NSMutableArray alloc] init];
    if (_responseType == ResponseControllerTypeNotification) {
        [self getResponsesWithActivityId:_currentNotification.activityId.integerValue];
    }
    
    [Utility addPadding:5 toTextField:_txtResposne];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    
    contentHeight = self.contentView.frame.size.height;
    
    _cellsArray = [[NSMutableArray alloc] init];
    // User Cell
    [_cellsArray addObject:@(CellTypeUser)];
    [_heightArray addObject:@75];
    // Title Cell
    /*if (_diary) {
     [_cellsArray addObject:@(CellTypeTitle)];
     [_heightArray addObject:@44];
     }*/
    // Intro Cell
    [_cellsArray addObject:@(CellTypeIntro)];
    [_heightArray addObject:@90];
    // Image Cell
    if (_diary.files.count>0) {
        [_cellsArray addObject:@(CellTypeImages)];
        [_heightArray addObject:@85];
    }
    // Header Cell
    [_cellsArray addObject:@(CellTypeHeader)];
    [_heightArray addObject:@44];
    // Comment Cell
    if (_responseType == ResponseControllerTypeDiaryResponse) {
        for (int i=0;i<_diary.comments.count;i++) {
            [_cellsArray addObject:@(CellTypeComment)];
            [_heightArray addObject:@110];
        }
    }
    else if (_responseType == ResponseControllerTypeDiaryTheme || _responseType == ResponseControllerTypeNotification){
        for (int i=0;i<_response.comments.count; i++) {
            [_cellsArray addObject:@(CellTypeComment)];
            [_heightArray addObject:@110];
        }
    }
    
    self.tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    [self organizeData];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
    BOOL allRead = true;
    for (Comment *comment in self.diary.comments) {
        if (!comment.isRead.boolValue) {
            allRead = false;
            break;
        }
    }
    if (allRead) self.diary.isRead = @YES;
    
    if ([self.delegate respondsToSelector:@selector(didSetDailyDiary:)]) {
        [self.delegate didSetDailyDiary:self.dailyDiary];
    }
}

- (void)organizeData {
    
    NSSortDescriptor *sortDescriptor = [NSSortDescriptor sortDescriptorWithKey:@"commentId" ascending:NO];
    
    if (self.response) {
        self.response.comments = [self.response.comments sortedArrayUsingDescriptors:@[sortDescriptor]];
    }
    if (self.diary) {
        self.diary.comments = [self.diary.comments sortedArrayUsingDescriptors:@[sortDescriptor]];
    }
    
    
}
- (IBAction)cancelThis:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    if (_diary) {
        [self updateDiaryInfo];
    }
}

-(void)updateDiaryInfo
{
    NSInteger diaryID = [LS.myUserInfo.currentProject.dailyDiaryList.firstObject integerValue];
    [self fetchDailyDiaryWithDiaryID:diaryID];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

#pragma mark - API Methods
-(void)fetchDailyDiaryWithDiaryID:(NSInteger)diaryID
{
    [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
    
    defwself
    [DFClient makeRequest:APIPathGetDailyDiary
                   method:kPOST
                urlParams:@{@"diaryId" : @(diaryID)}
               bodyParams:nil
                  success:^(NSDictionary *response, DailyDiary *dailyDiary) {
                      LS.myUserInfo.currentProject.dailyDiary = dailyDiary;
                      defsself
                      for (Diary * d in dailyDiary.userDiaries) {
                          if ([d.threadId isEqualToNumber:_diary.threadId]) {
                              sself.diary = d;
                              break;
                          }
                      }
                      sself.dailyDiary = dailyDiary;
                      [sself.tableView reloadData];
                      [MBProgressHUD hideHUDForView:sself.navigationController.view animated:YES];
                  }
                  failure:^(NSError *error) {
                      defsself
                      [MBProgressHUD hideHUDForView:sself.navigationController.view animated:YES];
                  }];
}

-(void)getResponsesWithActivityId:(NSInteger)activityId
{
    [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
    
    defwself
    [DFClient makeRequest:APIPathActivityGetResponses
                   method:kPOST
                urlParams:@{@"activityId" : @(activityId)}
               bodyParams:nil
                  success:^(NSDictionary *response, NSArray *result) {
                      defsself
                      sself.response = [[Response alloc] initWithDictionary:result.firstObject];
                      [sself organizeData];
                      [sself.tableView reloadData];
                      [MBProgressHUD hideHUDForView:sself.navigationController.view animated:YES];
                  }
                  failure:^(NSError *error) {
                      defsself
                      
                      [MBProgressHUD hideHUDForView:sself.navigationController.view animated:YES];
                  }];
}

-(void)addComment:(NSString*)comment withThreadId:(NSInteger)threadId
{
    
    NSDictionary * params = @{@"CommentId" : @0,
                              @"ThreadId" : @(threadId),
                              @"Response" : comment,
                              @"IsActive" : @YES};
    
    defwself
    [DFClient makeJSONRequest:APIPathActivityUpdateComment
                       method:kPOST
                       params:params
                      success:^(NSDictionary *response, Comment *result) {
                          defsself
                          [MBProgressHUD hideHUDForView:sself.navigationController.view animated:YES];
                          [sself addCommentToDataModel:result];
                          sself.txtResposne.text = @"";
                          [sself.tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0] atScrollPosition:UITableViewScrollPositionTop animated:YES];
                      }
                      failure:^(NSError *error) {
                          defsself
                          [MBProgressHUD hideHUDForView:sself.navigationController.view animated:YES];
                      }];
    
    [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
}

- (void)addCommentToDataModel:(Comment*)comment {
    comment.userInfo = LS.myUserInfo;
    if (self.response) {
    self.response.comments = [self.response.comments arrayByAddingObject:comment];
    }
    if (self.diary) {
        self.diary.comments = [self.diary.comments arrayByAddingObject:comment];

    }
    [self organizeData];
    [_cellsArray addObject:@(CellTypeComment)];
    [_heightArray addObject:@110];
    [self.tableView reloadData];
}

-(void)keyboardWillShow:(NSNotification*)notification
{
    NSDictionary* keyboardInfo = [notification userInfo];
    NSValue* keyboardFrameBegin = [keyboardInfo valueForKey:UIKeyboardFrameEndUserInfoKey];
    CGSize keyboardSize = [keyboardFrameBegin CGRectValue].size;
    
    float duration = [[keyboardInfo valueForKey:UIKeyboardAnimationDurationUserInfoKey] floatValue];
    self.constBottomSpace.constant = 0;
    self.constBottomSpace.constant = keyboardSize.height;
    [UIView animateWithDuration:duration
                     animations:^{
                         [self.view layoutIfNeeded];
                     }];
}

-(void)keyboardWillHide:(NSNotification*)notification
{
    NSDictionary* keyboardInfo = [notification userInfo];
    
    float duration = [[keyboardInfo valueForKey:UIKeyboardAnimationDurationUserInfoKey] floatValue];
    
    
    self.constBottomSpace.constant = 0;
    [UIView animateWithDuration:duration
                     animations:^{
                         [self.view layoutIfNeeded];
                     }];
}

#pragma mark - Table view data source
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    return 1;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return [[_heightArray objectAtIndex:indexPath.row] integerValue];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _cellsArray.count;
}

-(void)configureUserCell:(UserCell*)cell
{
    id target;
    if (_responseType == ResponseControllerTypeNotification || _responseType == ResponseControllerTypeDiaryTheme) {
        target = _response;
    }
    else{
        target = _diary;
    }
    
    [cell.lblTime setText:[target dateCreatedFormatted]];
    [cell.userImage sd_setImageWithURL:[[target userInfo] avatarFile].filePathURL placeholderImage:[UIImage imageNamed:@"dummy_avatar"]];
    [cell.lblUsername setText:[[target userInfo] appUserName]];
    [cell makeImageCircular];
}

-(UITableViewCell*)getCellForType:(CellType)type forIndexPath:(NSIndexPath*)indexPath
{
    if (type == CellTypeUser) {
        UserCell * cell = [self.tableView dequeueReusableCellWithIdentifier:@"userCell" forIndexPath:indexPath];
        [self configureUserCell:cell];
        return cell;
    }
    else if (type == CellTypeIntro){
        infoCell = [self.tableView dequeueReusableCellWithIdentifier:@"textCell" forIndexPath:indexPath];
        if (_responseType == ResponseControllerTypeNotification || _responseType == ResponseControllerTypeDiaryTheme) {
            if (_response.textareaResponses.count>0) {
                TextareaResponse * textResponse = [_response.textareaResponses objectAtIndex:0];
                [infoCell.bodyLabel setText:[textResponse.response stripHTML]];
            } else {
                [infoCell.bodyLabel setText:@""];
            }
        }
        else if (_responseType == ResponseControllerTypeDiaryResponse){
            [infoCell.bodyLabel setText:[_diary.response stripHTML]];
        }
        
        [_heightArray replaceObjectAtIndex:indexPath.row withObject:@(infoCell.fullHeight+32.f)];
        
        return infoCell;
    }
    else if (type == CellTypeImages){
        ImagesCell * cell = [self.tableView dequeueReusableCellWithIdentifier:@"imagesScrollCell"];
        cell.viewController = self;
        NSArray * files;
        if (_responseType == ResponseControllerTypeNotification || _responseType == ResponseControllerTypeDiaryTheme) {
            files = _response.files;
        }
        else if (_responseType == ResponseControllerTypeDiaryResponse){
            files = _diary.files;
        }
        [cell setImagesFiles:files];
        
        return cell;
    }
    else if (type == CellTypeHeader){
        UITableViewCell *cell = [self.tableView dequeueReusableCellWithIdentifier:@"noResponseHeaderCell" forIndexPath:indexPath];
        [cell setBackgroundColor:[UIColor whiteColor]];
        NSInteger counts = 0;
        if (_responseType == ResponseControllerTypeNotification || _responseType == ResponseControllerTypeDiaryTheme) {
            counts = _response.comments.count;
        }
        else if (_responseType == ResponseControllerTypeDiaryResponse){
            counts = _diary.comments.count;
        }
        [cell.textLabel setText:[NSString stringWithFormat:@"%ld Comment%@", (long)counts, (counts==1)?@"" : @"s"]];
        return cell;
    }
    else if (type == CellTypeTitle){
        UITableViewCell *cell = [self.tableView dequeueReusableCellWithIdentifier:@"noResponseHeaderCell" forIndexPath:indexPath];
        [cell.textLabel setTextColor:[UIColor blackColor]];
        [cell setBackgroundColor:[UIColor whiteColor]];
        [cell.textLabel setText:_diary.title];
        [cell.textLabel setFont:[UIFont systemFontOfSize:14 weight:1]];
        return cell;
    }
    
    else if (type == CellTypeComment){
        Comment * comment;
        if(_responseType == ResponseControllerTypeDiaryResponse){
            NSInteger count= _cellsArray.count - _diary.comments.count;
            comment = [_diary.comments objectAtIndex:indexPath.row - count];
        }
        else if ((_responseType == ResponseControllerTypeDiaryTheme || _responseType == ResponseControllerTypeNotification))
        {
            NSInteger count = _cellsArray.count - _response.comments.count;
            NSLog(@"%d", (int)(indexPath.row - count));
            comment = [_response.comments objectAtIndex:indexPath.row - count];
        }
        
        if (comment && !comment.isRead.boolValue) {
            // mark comment read
            [self markCommentRead:comment];
        }
        
        NotificationCell *cell = [self.tableView dequeueReusableCellWithIdentifier:@"userCommentCell" forIndexPath:indexPath];
        
        [cell.lblDate setText:comment.dateCreatedFormatted];
        [cell.lblUserName setText:comment.userInfo.appUserName];
        [cell.userImage sd_setImageWithURL:comment.userInfo.avatarFile.filePathURL placeholderImage:[UIImage imageNamed:@"dummy_avatar"]];
        [cell.contentLabel setText:[comment.response stripHTML]];
        
        NSInteger height = 75;
        CGRect boundingRect = [comment.response boundingRectWithSize:CGSizeMake(self.view.frame.size.width, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:13]} context:nil];
        height += boundingRect.size.height + 10;
        
        [_heightArray replaceObjectAtIndex:indexPath.row withObject:@(height)];
        
        [cell makeImageCircular];
        return cell;
    }
    
    return nil;
}

- (void)markCommentRead:(Comment*)comment {
    [DFClient makeRequest:APIPathActivityMarkCommentRead
                   method:kPOST
                urlParams:@{@"commentId" : comment.commentId}
               bodyParams:nil
                  success:nil
                  failure:^(NSError *error) {
                      comment.isRead = @NO;
                  }];
    comment.isRead = @YES;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    CellType type = [[_cellsArray objectAtIndex:indexPath.row] integerValue];
    UITableViewCell *cell = [self getCellForType:type forIndexPath:indexPath];
    if (type != CellTypeUser && type != CellTypeIntro) {
        
        cell.separatorInset = UIEdgeInsetsZero;
        cell.layoutMargins = UIEdgeInsetsZero;
        cell.preservesSuperviewLayoutMargins = NO;
    } else {
        cell.separatorInset = UIEdgeInsetsMake(0, cell.bounds.size.width, 0, 0);
    }
    return cell;
}

#pragma mark - CommentCellDelegate
-(void)commentCell:(id)cell didSendText:(NSString *)text
{
    NSInteger threadId;
    if (_responseType == ResponseControllerTypeDiaryResponse) {
        threadId = [_diary.threadId integerValue];
    }
    else if (_responseType == ResponseControllerTypeDiaryTheme || _responseType == ResponseControllerTypeNotification){
        threadId = _response.activityId.integerValue;
    }
    [self addComment:text withThreadId:threadId];
}


- (IBAction)sendComment:(id)sender {
    if ([_txtResposne.text isEqualToString:@""]) {
        return;
    }
    [_txtResposne resignFirstResponder];
    NSInteger threadId;
    if (_responseType == ResponseControllerTypeDiaryResponse) {
        threadId = [_diary.threadId integerValue];
    }
    else if (_responseType == ResponseControllerTypeDiaryTheme || _responseType == ResponseControllerTypeNotification){
        threadId = _response.threadId.integerValue;
    }
    
    [self addComment:_txtResposne.text withThreadId:threadId];
}
- (IBAction)exitOnend:(id)sender {
    [sender resignFirstResponder];
}

#pragma mark - ImagesCellDelegate
-(void)imageCell:(id)cell didClickOnButton:(id)button atIndex:(NSInteger)index atFile:(File *)file
{
    selectedIndex = index;
    [self performSegueWithIdentifier:@"carosulSegue" sender:self];
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"carosulSegue"]){
        CarouselViewController * carouselController = [segue destinationViewController];
        carouselController.selectedIndex = selectedIndex;
        carouselController.files = _diary.files;
    }
}

@end
