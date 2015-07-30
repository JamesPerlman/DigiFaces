//
//  DailyDiaryViewController.m
//  DigiFaces
//
//  Created by confiz on 27/06/2015.
//  Copyright (c) 2015 Usasha studio. All rights reserved.
//

#import "DailyDiaryViewController.h"
#import "MBProgressHUD.h"
#import "AFNetworking.h"

#import "Utility.h"
#import "UserManagerShared.h"
#import "DailyDiary.h"
#import "DiaryInfoViewController.h"
#import "Diary.h"
#import "ImageCell.h"
#import "VideoCell.h"
#import "UIImageView+AFNetworking.h"
#import "WebViewController.h"
#import "DefaultCell.h"
#import "DiaryThemeViewController.h"
#import "AddResponseViewController.h"
#import "ResponseViewController.h"
#import "RTCell.h"
#import "DiaryEntryTableViewCell.h"
#import "NSArray+orderedDistinctUnionOfObjects.h"

@interface DailyDiaryViewController ()
{
    UIButton * btnEdit;
    RTCell * infoCel;
}
@property (nonatomic, retain) DailyDiary * dailyDiary;
@property (nonatomic, retain) NSArray *diariesByDateIndex;
@property (nonatomic, retain) NSArray *diaryDates;

@end

@implementation DailyDiaryViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.tableView.separatorInset = UIEdgeInsetsZero;
    self.tableView.layoutMargins = UIEdgeInsetsZero;
    
    [self addEditButton];
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    NSNumber *diaryID = LS.myUserInfo.currentProject.dailyDiaryList[0];
    [self fetchDailyDiaryWithDiaryID:diaryID];
}

-(void)addEditButton
{
    btnEdit = [[UIButton alloc] initWithFrame:CGRectMake(0, self.view.frame.size.height - 100, 50, 50)];
    [btnEdit setBackgroundImage:[UIImage imageNamed:@"pencil"] forState:UIControlStateNormal];
    [btnEdit addTarget:self action:@selector(editClicked:) forControlEvents:UIControlEventTouchUpInside];
    
    [self.view addSubview:btnEdit];
}

-(void)editClicked:(id)sender
{
    NSLog(@"Edit clicked");
    [self performSegueWithIdentifier:@"addResponseSegue" sender:self];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (void)setDailyDiary:(DailyDiary *)dailyDiary {
    _dailyDiary = dailyDiary;
    
    NSSortDescriptor *dateSortDescriptor = [NSSortDescriptor sortDescriptorWithKey:@"dateCreated" ascending:NO];
    NSArray *sortedDiaries = [dailyDiary.userDiaries sortedArrayUsingDescriptors:@[dateSortDescriptor]];
    
    self.diaryDates = [sortedDiaries valueForKeyPath:@"@orderedDistinctUnionOfStrings.dateCreated"];
    
    NSMutableArray *remainingDiaries = sortedDiaries.mutableCopy;
    
    NSMutableArray *tmpDiariesByDateIndex = [NSMutableArray array];
    
    for (NSString *dateFormatted in self.diaryDates) {
        NSPredicate *predicate = [NSPredicate predicateWithFormat:@"dateCreated = %@", dateFormatted];
        NSArray *filteredDiaries = [remainingDiaries filteredArrayUsingPredicate:predicate];
        [remainingDiaries removeObjectsInArray:filteredDiaries];
        [tmpDiariesByDateIndex addObject:filteredDiaries];
    }
    
    self.diariesByDateIndex = [NSArray arrayWithArray:tmpDiariesByDateIndex];
}

#pragma mark - API Methods
-(void)fetchDailyDiaryWithDiaryID:(NSNumber*)diaryID
{
    [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
    defwself
    [DFClient makeRequest:APIPathGetDailyDiary
                   method:kPOST
                urlParams:@{@"diaryId" : diaryID}
               bodyParams:nil
                  success:^(NSDictionary *response, DailyDiary *result) {
                      defsself
                      sself.dailyDiary = result;
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
    if (!_dailyDiary) {
        return 0;
    }
    return 1 + self.diaryDates.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
    if (!_dailyDiary) {
        return 0;
    }
    if (section == 0) {
        if (self.diaryDates.count == 0) {
            return 2;
        }
        return 3;
    }
    else{
        
        return [self.diariesByDateIndex[section-1] count];
    }
    return 0;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        if (indexPath.row == 0) {
            return 160;
        }
        else if (indexPath.row == 1) {
            
            return infoCel.titleLabel.optimumSize.height + 20;
        }
        else if (indexPath.row == 2){
            return 40;
        }
    }
    else{
        return 44;
    }
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UITableViewCell *cell = nil;
    if (indexPath.section == 0) {
        if (indexPath.row == 0) {
            if (_dailyDiary.file && [_dailyDiary.file.fileType isEqualToString:@"Image"]) {
                ImageCell * imgCell = [tableView dequeueReusableCellWithIdentifier:@"imageCell"];
                NSURLRequest *req = [NSURLRequest requestWithURL:[NSURL URLWithString:_dailyDiary.file.filePathURLString]];
                [imgCell.image setImageWithURLRequest:req placeholderImage:[UIImage imageNamed:@"blank"] success:^(NSURLRequest *request, NSHTTPURLResponse *response, UIImage *image) {
                    imgCell.image.image = image;
                } failure:nil];
                cell = imgCell;
            }
            else{
                VideoCell * vidCell = [tableView dequeueReusableCellWithIdentifier:@"videoCell"];
                [vidCell.imageView setImageWithURL:[NSURL URLWithString:_dailyDiary.file.getVideoThumbURL] placeholderImage:[UIImage imageNamed:@"blank"]];
                vidCell.moviePlayerController.contentURL = [NSURL URLWithString:_dailyDiary.file.filePath];
                vidCell.moviePlayerController.view.hidden = true;
                cell = vidCell;
            }
        }
        else if (indexPath.row == 1) {
            infoCel = [tableView dequeueReusableCellWithIdentifier:@"textCell" forIndexPath:indexPath];
            if (![_dailyDiary.diaryQuestion isEqual:[NSNull null]]) {
                [infoCel.titleLabel setText:_dailyDiary.diaryQuestion];
            }
            
            cell = infoCel;
        }
        else if (indexPath.row == 2){
            DefaultCell * headerCell = [tableView dequeueReusableCellWithIdentifier:@"noResponseHeaderCell" forIndexPath:indexPath];
            [headerCell.label setText:[NSString stringWithFormat:@"%lu Entries", (unsigned long)[_dailyDiary.userDiaries count]]];
            cell = headerCell;
        }
    }
    else{
        DiaryEntryTableViewCell *dcell = [tableView dequeueReusableCellWithIdentifier:@"diaryCell" forIndexPath:indexPath];
        Diary * diary = self.diariesByDateIndex[indexPath.section-1][indexPath.row];
        
        if (diary)
            [dcell.titleLabel setText:[diary title]];
        dcell.commentCount = diary.comments.count;
        dcell.pictureCount = diary.picturesCount;
        dcell.videoCount = diary.videosCount;
        if (diary.isRead) {
            dcell.accessoryView = nil;
        } else {
            dcell.accessoryView = dcell.unreadIndicator;
        }
        cell = dcell;
        // [cell.detailTextLabel setText:[NSString stringWithFormat:@"By %@",[diary userInfo].appUserName]];
    }
    
    cell.separatorInset = UIEdgeInsetsZero;
    cell.layoutMargins = UIEdgeInsetsZero;
    cell.preservesSuperviewLayoutMargins = NO;
    return cell;
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    if (section > 0) {
        DefaultCell * headerCell = [tableView dequeueReusableCellWithIdentifier:@"dateHeaderCell"];

        NSString * date = self.diaryDates[section-1];;
        [headerCell.label setText:[Utility getMonDayYearDateFromString:date]];
        [headerCell setBackgroundColor:[UIColor whiteColor]];
        return headerCell;
    }
    else{
        return nil;
    }
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (section>0) {
        return 40;
    }
    return 0;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        if (indexPath.row == 0 && _dailyDiary.file && [_dailyDiary.file.fileType isEqualToString:@"Video"]) {
            VideoCell *cell = (VideoCell*)[tableView cellForRowAtIndexPath:indexPath];
            cell.moviePlayerController.view.hidden = false;
            [cell.moviePlayerController play];
        }
        else if (indexPath.row == 1  && self.diaryDates.count>0) {
            [self performSegueWithIdentifier:@"diaryInfoSegue" sender:self];
        }
    }
    else{
        
        [self performSegueWithIdentifier:@"diaryEntryDetailSegue" sender:self];
    }
    
}


#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    if ([segue.identifier isEqualToString:@"diaryInfoSegue"]) {
        DiaryInfoViewController * diaryInfoController = (DiaryInfoViewController*)[(UINavigationController*)segue.destinationViewController topViewController];
        diaryInfoController.dailyDiary = self.dailyDiary;
    }
    else if ([segue.identifier isEqualToString:@"webViewSegue"]){
        WebViewController * webController = (WebViewController*)[(UINavigationController*)[segue destinationViewController] topViewController];
        webController.url = [_dailyDiary.file filePath];
    }
    else if ([segue.identifier isEqualToString:@"themeSegue"]){
        DiaryThemeViewController * themeController = [segue destinationViewController];
        themeController.dailyDiary = self.dailyDiary;
    }
    else if ([segue.identifier isEqualToString:@"addResponseSegue"]){
        AddResponseViewController * responseController = (AddResponseViewController*)[(UINavigationController*)[segue destinationViewController] topViewController];
        responseController.dailyDiary = self.dailyDiary;
    }
    else if ([segue.identifier isEqualToString:@"diaryEntryDetailSegue"]){
        NSIndexPath * indexPath = [self.tableView indexPathForSelectedRow];
        Diary * diary = self.diariesByDateIndex[indexPath.section-1][indexPath.row];
        ResponseViewController * responseController = [segue destinationViewController];
        responseController.diary = diary;
        responseController.responseType = ResponseControllerTypeDiaryResponse;
    }
}

- (IBAction)closeThis:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    CGRect frame = btnEdit.frame;
    frame.origin.y = scrollView.contentOffset.y + self.tableView.frame.size.height - btnEdit.frame.size.height - 10;
    frame.origin.x = self.view.frame.size.width - frame.size.width - 10;
    btnEdit.frame = frame;
    
    [self.view bringSubviewToFront:btnEdit];
}

@end
