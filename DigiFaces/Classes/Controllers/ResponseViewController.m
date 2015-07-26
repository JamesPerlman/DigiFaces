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
#import "SDConstants.h"
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

@end

@implementation ResponseViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _heightArray = [[NSMutableArray alloc] init];
    
    self.customAlert = [[CustomAlertView alloc]initWithNibName:@"CustomAlertView" bundle:nil];
    [self.customAlert setSingleButton:YES];
    
    _arrResponses = [[NSMutableArray alloc] init];
    if (_responseType == ResponseControllerTypeNotification) {
        [self getResponsesWithActivityId:_currentNotification.activityID];
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
    if (_diary) {
        [_cellsArray addObject:@(CellTypeTitle)];
        [_heightArray addObject:@44];
    }
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
    NSInteger diaryID = [[[[[UserManagerShared sharedManager] currentProject] dailyDiaryList] objectAtIndex:0] integerValue];
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
    
    NSString * url = [NSString stringWithFormat:@"%@%@", kBaseURL, kDailyDiaryInfo];
    url = [url stringByReplacingOccurrencesOfString:@"{diaryId}" withString:[NSString stringWithFormat:@"%d", diaryID]];
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    AFHTTPRequestSerializer *requestSerializer = [AFHTTPRequestSerializer serializer];
    
    [requestSerializer setValue:[Utility getAuthToken] forHTTPHeaderField:@"Authorization"];
    [requestSerializer setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
    
    manager.requestSerializer = requestSerializer;
    
    
    [manager POST:url parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"Data : %@", responseObject);
        DailyDiary * dailyDiary = [[DailyDiary alloc] initWithDictionary:responseObject];
        for (Diary * d in dailyDiary.userDiaries) {
            if (d.responseID == _diary.responseID) {
                _diary = d;
                break;
            }
        }
        [self.tableView reloadData];
        [MBProgressHUD hideHUDForView:self.navigationController.view animated:YES];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Error: %@", error);
        [MBProgressHUD hideHUDForView:self.navigationController.view animated:YES];
    }];
}

-(void)getResponsesWithActivityId:(NSInteger)activityId
{
    [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
    
    NSString * url = [NSString stringWithFormat:@"%@%@", kBaseURL, kGetResponses];
    url = [url stringByReplacingOccurrencesOfString:@"{activityId}" withString:[NSString stringWithFormat:@"%d", activityId]];
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    AFHTTPRequestSerializer *requestSerializer = [AFHTTPRequestSerializer serializer];
    
    [requestSerializer setValue:[Utility getAuthToken] forHTTPHeaderField:@"Authorization"];
    [requestSerializer setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
    
    manager.requestSerializer = requestSerializer;
    
    
    [manager POST:url parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        NSLog(@"Response : %@", responseObject);
        
        _response = [[Response alloc] initWithDictionary:[responseObject firstObject]];
        
        [self.tableView reloadData];
        [MBProgressHUD hideHUDForView:self.navigationController.view animated:YES];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Error: %@", error);
        [MBProgressHUD hideHUDForView:self.navigationController.view animated:YES];
    }];
}

-(void)addComment:(NSString*)comment withThreadId:(NSInteger)threadId
{
    NSString * url = [NSString stringWithFormat:@"%@%@", kBaseURL, kUpdateComments];
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    AFJSONRequestSerializer *requestSerializer = [AFJSONRequestSerializer serializer];
    
    [requestSerializer setValue:[Utility getAuthToken] forHTTPHeaderField:@"Authorization"];
    [requestSerializer setValue:@"text/json" forHTTPHeaderField:@"Content-Type"];
    [requestSerializer setValue:@"application/json" forHTTPHeaderField:@"Accept"];
    
    manager.requestSerializer = requestSerializer;
    
    NSDictionary * params = @{@"CommentId" : @0,
                              @"ThreadId" : @(threadId),
                              @"Response" : comment,
                              @"IsActive" : @YES};
    
    
    NSLog(@"POSTing to %@:\nAuthorization: %@\nParams:\n%@", url, [Utility getAuthToken], params);
    [manager POST:url parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"JSON: %@", responseObject);
        
        [MBProgressHUD hideHUDForView:self.navigationController.view animated:YES];
        
        [self updateDiaryInfo];
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Error: %@", error);
        [MBProgressHUD hideHUDForView:self.navigationController.view animated:YES];
    }];
    [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
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
    if (_responseType == ResponseControllerTypeNotification || _responseType == ResponseControllerTypeDiaryTheme) {
        [cell.lblTime setText:_response.dateCreatedFormated];
        [cell.userImage setImageWithURL:[NSURL URLWithString:_response.userInfo.avatarFile.filePath]];
        [cell.lblUsername setText:_response.userInfo.appUserName];
        [cell makeImageCircular];
    }
    else{
        [cell.lblTime setText:_diary.dateCreatedFormatted];
        [cell.userImage setImageWithURL:[NSURL URLWithString:_diary.userInfo.avatarFile.filePath]];
        [cell.lblUsername setText:_diary.userInfo.appUserName];
        [cell makeImageCircular];
    }
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
            if (_response.textAreaResponse.count>0) {
                TextAreaResponse * textResponse = [_response.textAreaResponse objectAtIndex:0];
                [infoCell.titleLabel setText:textResponse.response];
            }
        }
        else if (_responseType == ResponseControllerTypeDiaryResponse){
            [infoCell.titleLabel setText:_diary.response];
        }
        
        [_heightArray replaceObjectAtIndex:indexPath.row withObject:@(MIN(90, infoCell.titleLabel.optimumSize.height + 20))];
        
        return infoCell;
    }
    else if (type == CellTypeImages){
        ImagesCell * cell = [self.tableView dequeueReusableCellWithIdentifier:@"imagesScrollCell"];
        cell.delegate = self;
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
        [cell.textLabel setText:[NSString stringWithFormat:@"%ld Responses", (long)counts]];
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
        int count = 3;
        Comment * comment;
        if(_responseType == ResponseControllerTypeDiaryResponse){
            count++; // Only diary have title
            if (_diary.files.count>0) {
                count++;
            }
            comment = [_diary.comments objectAtIndex:indexPath.row - count];
        }
        else if ((_responseType == ResponseControllerTypeDiaryTheme || _responseType == ResponseControllerTypeNotification))
        {
            if (_response.files.count>0) {
                count++;
            }
            comment = [_response.comments objectAtIndex:indexPath.row - count];
        }
        
        NotificationCell *cell = [self.tableView dequeueReusableCellWithIdentifier:@"userCommentCell" forIndexPath:indexPath];
        
        [cell.lblDate setText:comment.dateCreatedFormated];
        [cell.lblUserName setText:comment.userInfo.appUserName];
        [cell.userImage setImageWithURL:[NSURL URLWithString:comment.userInfo.avatarFile.filePath]];
        [cell.infoLabel setText:comment.response];
        
        NSInteger height = 75;
        CGRect boundingRect = [comment.response boundingRectWithSize:CGSizeMake(self.view.frame.size.width, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:13]} context:nil];
        height += boundingRect.size.height + 10;
        
        [_heightArray replaceObjectAtIndex:indexPath.row withObject:@(height)];
        
        [cell makeImageCircular];
        return cell;
    }
    
    return nil;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    CellType type = [[_cellsArray objectAtIndex:indexPath.row] integerValue];
    return [self getCellForType:type forIndexPath:indexPath];
}

#pragma mark - CommentCellDelegate
-(void)commentCell:(id)cell didSendText:(NSString *)text
{
    NSInteger threadId;
    if (_responseType == ResponseControllerTypeDiaryResponse) {
        threadId = [_diary.threadId integerValue];
    }
    else if (_responseType == ResponseControllerTypeDiaryTheme || _responseType == ResponseControllerTypeNotification){
        threadId = _response.activityID;
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
        threadId = _response.threadId;
    }
    
    [self addComment:_txtResposne.text withThreadId:threadId];
    _txtResposne.text = @"";
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
