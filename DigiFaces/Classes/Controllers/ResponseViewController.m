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
#import "NSString+StripHTML.h"
#import "DiaryTheme.h"
#import "ImageGalleryResponse.h"
#import "Integer.h"
#import "Project.h"
#import "File.h"

#import <SDWebImage/UIImageView+WebCache.h>

typedef enum {
    CellTypeUser,
    CellTypeTitle,
    CellTypeIntro,
    CellTypeImages,
    CellTypeHeader,
    CellTypeComment
}CellType;

@interface ResponseViewController () <CommentCellDelegate, ImageCellDelegate, HPGrowingTextViewDelegate, UITableViewDataSource, UITableViewDelegate, UIScrollViewDelegate>
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
@property (nonatomic, strong) NSNumber *threadId;
@property (nonatomic, strong) NSNumber *commentId;

@property (nonatomic, strong) NSString *alertMessageToShow;
@property (nonatomic, strong) NSIndexPath *indexPathToScrollTo;

@property (nonatomic, strong) NSArray *comments;


@end

@implementation ResponseViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    
    if (self.notification) {
        BOOL error = false;
        
        if (self.notification.isDailyDiaryNotification.boolValue) {
            self.dailyDiary =  LS.myUserInfo.currentProject.dailyDiary;
            if (!self.dailyDiary) {
                // attempt to fetch diary
                Integer *diaryId = LS.myUserInfo.currentProject.dailyDiaryList.anyObject;
                if (!diaryId) {
                    error = true;
                    NSLog(@"ResponseViewController setThreadId:commentId: error - User info not loaded.");
                } else {
                    [self fetchDailyDiaryWithDiaryID:diaryId.integerValue];
                }
            } else {
                [self showNotificationContentFromDiary];
            }
        } else {
            // otherwise it's a diary theme.  load the thread.
            
            [self getResponsesWithActivityId:self.notification.activityId.integerValue];
            
        }
        
        if (error) {
            [self.customAlert showAlertWithMessage:NSLocalizedString(@"The content you requested could not be found.", nil) inView:self.navigationController.view withTag:0];
        }
        
    } else
        [self prepareAndLoadData];
    
    
    
    self.tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    
    //  self.txtResposne.layer.borderColor = [UIColor lightGrayColor].CGColor;
    //  self.txtResposne.layer.borderWidth = 1.0f;
    self.txtResposne.layer.cornerRadius = 4.0f;
    self.txtResposne.clipsToBounds = true;
    self.txtResposne.placeholder = NSLocalizedString(@"Leave a comment...", nil);
    self.txtResposne.delegate = self;
    // [self organizeData];
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
    
    // if ([self.delegate respondsToSelector:@selector(didSetDailyDiary:)]) {
    //     [self.delegate didSetDailyDiary:self.dailyDiary];
    // }
}

- (CustomAlertView*)customAlert {
    if (!_customAlert) {
        _customAlert = [[CustomAlertView alloc]initWithNibName:@"CustomAlertView" bundle:nil];
        [_customAlert setSingleButton:YES];
    }
    return _customAlert;
}

- (void)prepareAndLoadData {
    
    NSLog(@"%@", self.heightArray);
    
    [self pullComments];
    
    if (self.diary) {
        self.navigationItem.title = self.diary.title;
    }
    
    _heightArray = [[NSMutableArray alloc] init];
    
    
    _arrResponses = [[NSMutableArray alloc] init];
    //[Utility addPadding:5 toTextField:_txtResposne];
    
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
    
    NotificationCell *cell = [self.tableView dequeueReusableCellWithIdentifier:@"userCommentCell"];
    if (_diary) {
    }
    else if (_response){
        if (_response.files.count) {
            [_cellsArray addObject:@(CellTypeImages)];
            [_heightArray addObject:@85];
        }
    }
    
    for (Comment *comment in self.comments) {
        [_cellsArray addObject:@(CellTypeComment)];
        [self configureCommentCell:cell withComment:comment];
        [_heightArray addObject:@([self heightForCommentCell:cell])];
    }
    
    
    [self.tableView reloadData];
    
}

- (void)pullComments {
    
    NSSortDescriptor *sortDescriptor = [NSSortDescriptor sortDescriptorWithKey:@"commentId" ascending:YES];
    if (self.response) {
        self.comments = [[self.response.comments allObjects] sortedArrayUsingDescriptors:@[sortDescriptor]];
    }
    if (self.diary) {
        self.comments = [[self.diary.comments allObjects] sortedArrayUsingDescriptors:@[sortDescriptor]];
    }
    
    
}

- (void)showNotificationContentFromDiary {
    NSNumber *threadId = self.notification.referenceId;
    NSNumber *commentId = self.notification.referenceId2;
    BOOL error;
    
    self.diary = [self.dailyDiary getResponseWithThreadID:threadId];
    if (!self.diary) {
        error = true;
        NSLog(@"ResponseViewController setThreadId:commentId: error - Couldn't find a diary with thread id %@", threadId);
    } else {
        [self prepareAndLoadData];
        // now scroll to that comment
        for (NSInteger i = 0, n = self.diary.comments.count; i<n; ++i) {
            Comment *comment = self.comments[i];
            if ([comment.commentId isEqualToNumber:commentId]) {
                NSInteger idx = [self.tableView numberOfRowsInSection:0]-n+i;
                NSIndexPath *indexPath = [NSIndexPath indexPathForRow:idx inSection:0];
                [self.tableView scrollToRowAtIndexPath:indexPath atScrollPosition:UITableViewScrollPositionTop animated:YES];
                return;
            }
        }
        // if we made it this far, we couldn't find a comment with that id.
        error = true;
        NSLog(@"ResponseViewController setThreadId:commentId: error - Couldn't find a comment with id %@", commentId);
    }
    if (error) {
        [self.customAlert showAlertWithMessage:NSLocalizedString(@"The content you requested could not be found.", nil) inView:self.navigationController.view withTag:0];
    }
}

- (IBAction)cancelThis:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}

-(void)updateDiaryInfo
{
    NSInteger diaryID = [LS.myUserInfo.currentProject.dailyDiaryList.anyObject integerValue];
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
    NSNumber *threadId = 0;
    if (self.notification) {
        threadId = self.notification.referenceId;
    } else if (self.diary) {
        threadId = self.diary.threadId;
    }
    defwself
    [DFClient makeRequest:APIPathGetDailyDiary
                   method:kPOST
                urlParams:@{@"diaryId" : @(diaryID)}
               bodyParams:nil
                  success:^(NSDictionary *response, DailyDiary *dailyDiary) {
                      defsself
                      [MBProgressHUD hideHUDForView:sself.navigationController.view animated:YES];
                      LS.myUserInfo.currentProject.dailyDiary = dailyDiary;
                      for (Diary * d in dailyDiary.userDiaries) {
                          if ([d.threadId isEqualToNumber:threadId]) {
                              sself.diary = d;
                              break;
                          }
                      }
                      sself.dailyDiary = dailyDiary;
                      
                      if (sself.notification) {
                          if (sself.diary == nil) {
                              [sself.customAlert showAlertWithMessage:NSLocalizedString(@"Unable to load the content you requested.", nil) inView:sself.view withTag:0];
                              return;
                          }
                          [sself prepareAndLoadData];
                          NSInteger idx = [sself.comments indexOfObjectPassingTest:^BOOL(Comment *c, NSUInteger idx, BOOL *stop) {
                              if ([c.commentId isEqualToNumber:sself.notification.referenceId]) {
                                  *stop = true;
                                  return true;
                              }
                              return false;
                          }];
                          NSIndexPath *indexPath = [NSIndexPath indexPathForRow:_cellsArray.count - [sself.diary.comments allObjects].count + idx inSection:0];
                          [sself.tableView scrollToRowAtIndexPath:indexPath atScrollPosition:UITableViewScrollPositionTop animated:YES];
                      } else {
                          
                          [sself.tableView reloadData];
                      }
                  }
                  failure:^(NSError *error) {
                      defsself
                      [MBProgressHUD hideHUDForView:sself.navigationController.view animated:YES];
                  }];
}

/*
 -(void)fetchActivityWithNotification:(Notification*)notification {
 
 [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
 defwself
 [DFClient makeRequest:APIPathProjectGetActivities
 method:kPOST
 urlParams:@{@"projectId" : LS.myUserInfo.currentProjectId,
 @"activityId" : notification.referenceId}
 bodyParams:nil
 success:^(NSDictionary *response, DiaryTheme *diaryTheme) {
 defsself
 BOOL found = false;
 for (NSInteger i = 0, n = diaryTheme.responses.count; i < n; ++i) {
 Response *response = diaryTheme.responses[i];
 if ([response.threadId isEqualToNumber:notification.referenceId2]) {
 found = true;
 sself.response = response;
 [sself prepareAndLoadData];
 break;
 }
 }
 
 [MBProgressHUD hideHUDForView:sself.navigationController.view animated:YES];
 }
 failure:^(NSError *error) {
 defsself
 [MBProgressHUD hideHUDForView:sself.navigationController.view animated:YES];
 [sself.customAlert showAlertWithMessage:NSLocalizedString(@"The content you requested could not be found.", nil) inView:sself.view withTag:0];
 }];
 [self.refreshControl endRefreshing];
 }
 */
-(void)getResponsesWithActivityId:(NSInteger)activityId
{
    [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
    
    defwself
    [DFClient makeRequest:APIPathActivityGetResponses
                   method:kPOST
                urlParams:@{@"activityId" : @(activityId)}
               bodyParams:nil
                  success:^(NSDictionary *response, id result) {
                      defsself
                      if ([result isKindOfClass:[Response class]]) {
                          sself.response = result;
                      } else if ([result isKindOfClass:[NSArray class]]) {
                          if (sself.notification) {
                              for (Response *obj in result) {
                                  if ([sself.notification.referenceId isEqualToNumber:obj.threadId]) {
                                      sself.response = obj;
                                      break;
                                  }
                              }
                          } else {
                              sself.response = result[0];
                          }
                      } else return;
                      // [sself organizeData];
                      for (Comment *comment in [sself.response comments]) {
                          NSLog(@"%@", comment);
                      }
                      if (sself.notification) {
                          [sself prepareAndLoadData];
                          NSInteger idx = [sself.comments indexOfObjectPassingTest:^BOOL(Comment *c, NSUInteger idx, BOOL *stop) {
                              if ([c.commentId isEqualToNumber:sself.notification.referenceId2]) {
                                  *stop = true;
                                  return true;
                              }
                              return false;
                          }];
                          
                          if (idx == NSNotFound) {
                              [sself.customAlert showAlertWithMessage:NSLocalizedString(@"Unable to load the content you requested.", nil) inView:sself.view withTag:0];
                              NSLog(@"Could not find a comment with id %@", sself.notification.referenceId2);
                          } else {
                              NSIndexPath *indexPath = [NSIndexPath indexPathForRow:_cellsArray.count - sself.response.comments.count + idx inSection:0];
                              [sself.tableView scrollToRowAtIndexPath:indexPath atScrollPosition:UITableViewScrollPositionTop animated:YES];
                          }
                      } else {
                          [sself.tableView reloadData];
                      }
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
                              @"Response" : [comment stringByReplacingOccurrencesOfString:@"\n" withString:@"<br/>"],
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
                          /*
                          NSInteger section = [sself numberOfSectionsInTableView:sself.tableView]-1;
                          NSInteger row = [sself tableView:sself.tableView numberOfRowsInSection:section]-1;
                          [sself.tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:row inSection:section] atScrollPosition:UITableViewScrollPositionBottom animated:YES];*/
                           // Not sure why this works.
                          CGFloat scrollY = (CGFloat)[[sself.heightArray valueForKeyPath:@"@sum.self"] doubleValue];
                          CGFloat tblHeight = sself.tableView.bounds.size.height;
                          CGRect rect = CGRectMake(0, scrollY-tblHeight, sself.tableView.bounds.size.width, tblHeight);
                          NSLog(@"%@", NSStringFromCGRect(rect));
                          [sself.tableView scrollRectToVisible:rect animated:YES];
                          //[sself.tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:_cellsArray.count-1 inSection:0] atScrollPosition:UITableViewScrollPositionTop animated:YES];
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
        [self.response addCommentsObject:comment];
    }
    if (self.diary) {
        [self.diary addCommentsObject:comment];
    }
    comment.dateCreatedFormatted = NSLocalizedString(@"Just now", nil);
    [self.managedObjectContext save:nil];
    [self prepareAndLoadData];
    //[self organizeData];
    //[_cellsArray addObject:@(CellTypeComment)];
    //[_heightArray addObject:@110];
    //[self.tableView reloadData];
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
    return [[_heightArray objectAtIndex:indexPath.row] floatValue];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _cellsArray.count;
}

-(void)configureUserCell:(UserCell*)cell
{
    id target;
    if (_response) {
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
        if (_response) {
            if (_response.textareaResponses.count>0) {
                TextareaResponse * textResponse = [_response.textareaResponses anyObject];
                [infoCell setText:textResponse.response];
            } else if (_response.imageGalleryResponses.count>0) {
                ImageGalleryResponse *igr = [_response.imageGalleryResponses anyObject];
                [infoCell setText:igr.response];
            } else {
                [infoCell.bodyLabel setText:@""];
            }
        }
        else if (_diary){
            [infoCell setText:_diary.response];
        }
        
        [_heightArray replaceObjectAtIndex:indexPath.row withObject:@(infoCell.fullHeight)];
        
        return infoCell;
    }
    else if (type == CellTypeImages){
        ImagesCell * cell = [self.tableView dequeueReusableCellWithIdentifier:@"imagesScrollCell"];
        cell.viewController = self;
        NSArray * files;
        if (_response) {
            files = [_response.files allObjects];
        }
        else if (_diary){
            files = [_diary.files allObjects];
        }
        [cell setImagesFiles:files];
        
        return cell;
    }
    else if (type == CellTypeHeader){
        UITableViewCell *cell = [self.tableView dequeueReusableCellWithIdentifier:@"noResponseHeaderCell" forIndexPath:indexPath];
        [cell setBackgroundColor:[UIColor whiteColor]];
        NSInteger counts = 0;
        if (_response) {
            counts = _response.comments.count;
        }
        else if (_diary){
            counts = _diary.comments.count;
        }
        NSString *text;
        if (counts == 1) {
            text = NSLocalizedString(@"1 Comment", nil);
        } else {
            text = [NSString stringWithFormat:NSLocalizedString(@"%lu Comments", nil), (long unsigned)counts];
        }
        [cell.textLabel setText:text];
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
        NSInteger count = 0;
        if(_diary){
            count = _cellsArray.count - _diary.comments.count;
        }
        else if (_response)
        {
            count = _cellsArray.count - _response.comments.count;
        }
        Comment * comment = [self.comments objectAtIndex:indexPath.row - count];
        
        if (comment && !comment.isRead.boolValue) {
            // mark comment read
            [self markCommentRead:comment];
        }
        
        NotificationCell *cell = [self.tableView dequeueReusableCellWithIdentifier:@"userCommentCell" forIndexPath:indexPath];
        
        [self configureCommentCell:cell withComment:comment];
        
        //[_heightArray replaceObjectAtIndex:indexPath.row withObject:@(height)];
        
        [cell makeImageCircular];
        return cell;
    }
    
    return nil;
}

- (void)configureCommentCell:(NotificationCell*)cell withComment:(Comment*)comment {
    [cell.lblDate setText:comment.dateCreatedFormatted];
    [cell.lblUserName setText:comment.userInfo.appUserName];
    [cell.userImage sd_setImageWithURL:comment.userInfo.avatarFile.filePathURL placeholderImage:[UIImage imageNamed:@"dummy_avatar"]];
    [cell setContentText:comment.response];
}

- (CGFloat)heightForCommentCell:(NotificationCell*)cell {
    
    CGFloat height = [cell.contentLabel sizeThatFits:CGSizeMake(cell.contentLabel.frame.size.width, CGFLOAT_MAX)].height;
    height += cell.userImage.frame.size.height + 32;
    
    return height;
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
    
    CellType type = (CellType)[[_cellsArray objectAtIndex:indexPath.row] integerValue];
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
    if (_diary) {
        threadId = [_diary.threadId integerValue];
    }
    else if (_response){
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
    if (_diary) {
        threadId = [_diary.threadId integerValue];
    }
    else if (_response){
        threadId = _response.threadId.integerValue;
    }
    
    [self addComment:_txtResposne.text withThreadId:threadId];
}
-(void)growingTextView:(HPGrowingTextView *)growingTextView willChangeHeight:(float)height {
    self.responseHeight.constant = height;
    [UIView animateWithDuration:self.txtResposne.animationDuration animations:^{
        [self.txtResposne layoutIfNeeded];
    }];
    
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
        carouselController.files = [_diary.files allObjects];
    }
}

#pragma mark - CoreData

- (NSManagedObjectContext*)managedObjectContext {
    return [RKObjectManager sharedManager].managedObjectStore.mainQueueManagedObjectContext;
}

@end
