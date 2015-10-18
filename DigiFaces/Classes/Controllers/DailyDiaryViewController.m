//
//  DailyDiaryViewController.m
//  DigiFaces
//
//  Created by confiz on 27/06/2015.
//  Copyright (c) 2015 Usasha studio. All rights reserved.
//

#import <SDWebImage/UIImageView+WebCache.h>

#import "DailyDiaryViewController.h"
#import "AddResponseViewController.h"
#import "DiaryThemeViewController.h"
#import "DiaryInfoViewController.h"
#import "ResponseViewController.h"
#import "WebViewController.h"

#import "MBProgressHUD.h"
#import "CustomAlertView.h"
#import "AFNetworking.h"
#import "Utility.h"
#import "NSArray+orderedDistinctUnionOfObjects.h"
#import "NSArray+Reverse.h"

#import "RTCell.h"
#import "ImageCell.h"
#import "VideoCell.h"
#import "DefaultCell.h"
#import "DiaryEntryTableViewCell.h"

#import "DailyDiary.h"
#import "Diary.h"
#import "Project.h"
#import "Integer.h"
#import "File.h"

#import "DiaryResponseDelegate.h"
static NSString *infoCellReuseIdentifier = @"textCell";
@interface DailyDiaryViewController ()<ExpandableTextCellDelegate, DiaryResponseDelegate, PopUpDelegate>
{
    UIButton * btnEdit;
    RTCell * infoCell;
    NSIndexPath *_selectedDiaryEntryIndexPath;
    CustomAlertView *_alertView;
    NSNumber *_diaryID;
    
}
@property (nonatomic, strong) DailyDiary * dailyDiary;
@property (nonatomic, retain) NSArray *diariesByDateIndex;
@property (nonatomic, retain) NSArray *diaryDates;
@property (nonatomic, strong) NSFetchedResultsController *fetchedResultsController;

@end

@implementation DailyDiaryViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.tableView.separatorInset = UIEdgeInsetsZero;
    self.tableView.layoutMargins = UIEdgeInsetsZero;
    
    // check if user has enough permissions to see edit button (projectRoleId != 1 and projectRoleId != 3 or 4)
    if ([LS.myUserInfo canReplyToDiaries]) {
        [self addEditButton];
    }
    
    _diaryID = [(Integer*)[LS.myUserInfo.currentProject.dailyDiaryList anyObject] value];
    
    _alertView = [[CustomAlertView alloc] init];
    _alertView.delegate = self;
    
    [self fetchDailyDiaryFromCoreData];
    [self fetchDailyDiaryFromServer];
    
    // Initialize the refresh control.
    self.refreshControl = [[UIRefreshControl alloc] init];
    [self.refreshControl addTarget:self
                            action:@selector(fetchDailyDiaryFromServer)
                  forControlEvents:UIControlEventValueChanged];
}

- (void)localizeUI {
    self.navigationItem.title = DFLocalizedString(@"view.diary.navbar.title", nil);
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    if (self.dailyDiary) {
        [self.dailyDiary checkForUnreadComments];
        [self setupDateSortedDataArrays];
        [self.tableView reloadData];
    } else {
        if (_selectedDiaryEntryIndexPath) {
            [self.tableView reloadRowsAtIndexPaths:@[_selectedDiaryEntryIndexPath] withRowAnimation:UITableViewRowAnimationNone];
        }
    }
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


- (void)setupDateSortedDataArrays {
    NSSortDescriptor *idSortDescriptor = [NSSortDescriptor sortDescriptorWithKey:@"threadId" ascending:NO];
    NSArray *sortedDiaries = [self.dailyDiary.userDiaries sortedArrayUsingDescriptors:@[idSortDescriptor]];
    
    
    NSMutableArray *mutableDates = [NSMutableArray arrayWithArray:[sortedDiaries valueForKeyPath:@"dateCreated"]];
    //NSLog(@"%@", mutableDates);
    for (NSInteger i = 0, n = mutableDates.count; i < n; ++i) {
        mutableDates[i] = [mutableDates[i] substringToIndex:10];
    }
    //NSLog(@"%@", mutableDates);
    
    self.diaryDates = [[[mutableDates valueForKeyPath:@"@orderedDistinctUnionOfStrings.self"] sortedArrayUsingSelector:@selector(caseInsensitiveCompare:)] reversedArray];
    
    //NSLog(@"%@", self.diaryDates);
    
    // now index the dates
    
    NSMutableArray *remainingDiaries = sortedDiaries.mutableCopy;
    
    NSMutableArray *tmpDiariesByDateIndex = [NSMutableArray array];
    
    for (NSString *dateCreated in self.diaryDates) {
        NSPredicate *predicate = [NSPredicate predicateWithFormat:@"dateCreated BEGINSWITH %@", dateCreated];
        NSArray *filteredDiaries = [remainingDiaries filteredArrayUsingPredicate:predicate];
        [remainingDiaries removeObjectsInArray:filteredDiaries];
        [tmpDiariesByDateIndex addObject:filteredDiaries];
    }
    
    self.diariesByDateIndex = [NSArray arrayWithArray:tmpDiariesByDateIndex];
}

#pragma mark - API Methods
-(void)fetchDailyDiaryFromServer
{
    if (!self.dailyDiary) {
        [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
    }
    defwself
    [DFClient makeRequest:APIPathGetDailyDiary
                   method:kPOST
                urlParams:@{@"diaryId" : _diaryID}
               bodyParams:nil
                  success:^(NSDictionary *response, DailyDiary *result) {
                      defsself
                      [sself reloadDataWithDailyDiary:result];
                      [MBProgressHUD hideHUDForView:sself.navigationController.view animated:YES];
                      [sself.refreshControl endRefreshing];
                  }
                  failure:^(NSError *error) {
                      defsself
                      [MBProgressHUD hideHUDForView:sself.navigationController.view animated:YES];
                      
                      [_alertView showAlertWithMessage:DFLocalizedString(@"view.diary.alert.load_error", nil) inView:sself.view withTag:0];
                      [sself.refreshControl endRefreshing];
                      
                  }];
}

#pragma mark - CustomAlertView delegate
- (void)okayButtonTappedWithTag:(NSInteger)tag {
    [self fetchDailyDiaryFromServer];
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

-(void)textCellDidTapMore:(RTCell *)cell {
    [self performSegueWithIdentifier:@"diaryInfoSegue" sender:self];
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        if (indexPath.row == 0) {
            return 160;
        }
        else if (indexPath.row == 1) {
            // if there are responses, show the more/less button
            if (!infoCell) {
                infoCell = [self.tableView dequeueReusableCellWithIdentifier:infoCellReuseIdentifier];
                [infoCell setText:_dailyDiary.diaryQuestion];
            }
            if (self.dailyDiary.userDiaries.count) {
                NSLog(@"%f", infoCell.height);
                return infoCell.height;
            } else {
                return infoCell.fullHeight;
            }
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
                [imgCell.image sd_setImageWithURL:_dailyDiary.file.filePathURL];
                
                cell = imgCell;
            }
            else{
                VideoCell * vidCell = [tableView dequeueReusableCellWithIdentifier:@"videoCell"];
                [vidCell.videoImageView sd_setImageWithURL:[NSURL URLWithString:_dailyDiary.file.getVideoThumbURL]];
                vidCell.moviePlayerController.contentURL = [NSURL URLWithString:_dailyDiary.file.filePath];
                vidCell.moviePlayerController.view.hidden = true;
                cell = vidCell;
            }
        }
        else if (indexPath.row == 1) {
            infoCell = [tableView dequeueReusableCellWithIdentifier:infoCellReuseIdentifier forIndexPath:indexPath];
            infoCell.delegate = self;
            [infoCell setText:_dailyDiary.diaryQuestion];
            cell = infoCell;
        }
        else if (indexPath.row == 2){
            DefaultCell * headerCell = [tableView dequeueReusableCellWithIdentifier:@"noResponseHeaderCell" forIndexPath:indexPath];
            NSUInteger numEntries = [_dailyDiary.userDiaries count];
            NSString *entriesString;
            if (numEntries == 1) {
                entriesString = DFLocalizedString(@"view.diary.text.1_entry", nil);
            } else {
                entriesString = [NSString stringWithFormat:DFLocalizedString(@"view.diary.text.n_entries", nil), numEntries];
            }
            [headerCell.label setText:entriesString];
            cell = headerCell;
        }
    }
    else{
        DiaryEntryTableViewCell *dcell = [tableView dequeueReusableCellWithIdentifier:@"diaryCell" forIndexPath:indexPath];
        [self configureDiaryCell:dcell atIndexPath:indexPath];
        cell = dcell;
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
        
        NSString * date = self.diaryDates[section-1];
        [headerCell.label setText:[Utility getMonDayYearDateFromString:date]];
        [headerCell.contentView setBackgroundColor:[UIColor whiteColor]];
        return headerCell.contentView;
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
        if (indexPath.row == 0 && _dailyDiary.file) {
            if ([_dailyDiary.file.fileType isEqualToString:@"Video"]) {
                VideoCell *cell = (VideoCell*)[tableView cellForRowAtIndexPath:indexPath];
                cell.moviePlayerController.view.hidden = false;
                [cell.moviePlayerController play];
            } else {
                [self performSegueWithIdentifier:@"webViewSegue" sender:nil];
            }
        }
        else if (indexPath.row == 1  && self.diaryDates.count>0) {
            [self textCellDidTapMore:nil];
        }
    }
    else{
        _selectedDiaryEntryIndexPath = indexPath;
        [self performSegueWithIdentifier:@"diaryEntryDetailSegue" sender:self];
    }
    
}

#pragma mark - TableView Convenience Methods

- (void)configureDiaryCell:(DiaryEntryTableViewCell*)cell atIndexPath:(NSIndexPath*)indexPath {
    Diary * diary = [self diaryForIndexPath:indexPath];
    if (diary)
        [cell.titleLabel setText:[diary title]];
    cell.commentCount = diary.comments.count;
    cell.pictureCount = diary.picturesCount;
    cell.videoCount = diary.videosCount;
    if (diary.isRead.boolValue) {
        cell.accessoryView = nil;
    } else {
        cell.accessoryView = cell.unreadIndicator;
    }
    
}

- (Diary*)diaryForIndexPath:(NSIndexPath*)indexPath {
    return self.diariesByDateIndex[indexPath.section-1][indexPath.row];
}

#pragma mark - Model Management

- (void)fetchDailyDiaryFromCoreData {
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"DailyDiary" inManagedObjectContext:self.managedObjectContext];
    [fetchRequest setEntity:entity];
    // Specify criteria for filtering which objects to fetch
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"diaryId = %@", _diaryID];
    [fetchRequest setPredicate:predicate];
    // Specify how the fetched objects should be sorted
    NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"diaryId"  ascending:YES];
    [fetchRequest setSortDescriptors:[NSArray arrayWithObjects:sortDescriptor, nil]];
    
    NSError *error = nil;
    NSArray *fetchedObjects = [self.managedObjectContext executeFetchRequest:fetchRequest error:&error];
    if (fetchedObjects != nil) {
        [self reloadDataWithDailyDiary:fetchedObjects.firstObject];
    }
}

- (void)reloadDataWithDailyDiary:(DailyDiary*)dailyDiary {
    LS.myUserInfo.currentProject.dailyDiary = dailyDiary;
    self.dailyDiary = dailyDiary;
#warning This is a patch.  Revise if necessary. Go to -checkForUnreadComments for more info
    [dailyDiary checkForUnreadComments];
    [self setupDateSortedDataArrays];
    
    [self.tableView reloadData];
    [self.view bringSubviewToFront:btnEdit];
    infoCell = [self.tableView dequeueReusableCellWithIdentifier:infoCellReuseIdentifier];
    if (dailyDiary.userDiaries.count) {
        [infoCell minimize];
    } else {
        [infoCell maximize];
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
        webController.navigationItem.title = self.navigationItem.title;
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
        Diary * diary = [self diaryForIndexPath:indexPath];
        ResponseViewController * responseController = [segue destinationViewController];
        responseController.diary = diary;
        responseController.responseType = ResponseControllerTypeDiaryResponse;
        responseController.delegate = self;
        
    }
}

- (void)didSetDailyDiary:(DailyDiary *)dailyDiary {
    self.dailyDiary = dailyDiary;
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

#pragma mark - NSFetchedResultsController methods

- (NSFetchedResultsController*)fetchedResultsController {
    if (!_fetchedResultsController) {
        NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
        
        fetchRequest.predicate = [NSPredicate predicateWithFormat:@"activityId = %@", self.dailyDiary.activityId];
        
        fetchRequest.entity = [NSEntityDescription entityForName:@"Diary" inManagedObjectContext:self.managedObjectContext];
        
        fetchRequest.sortDescriptors = @[[NSSortDescriptor sortDescriptorWithKey:@"activityId" ascending:YES]];
        
        fetchRequest.fetchBatchSize = 20;
        
        _fetchedResultsController = [[NSFetchedResultsController alloc] initWithFetchRequest:fetchRequest managedObjectContext:self.managedObjectContext sectionNameKeyPath:nil cacheName:nil];
    }
    
    return _fetchedResultsController;
}



- (void)controllerWillChangeContent:(NSFetchedResultsController *)controller {
    // The fetch controller is about to start sending change notifications, so prepare the table view for updates.
    [MBProgressHUD hideHUDForView:self.navigationController.view animated:YES];
    [self.tableView beginUpdates];
}


- (void)controller:(NSFetchedResultsController *)controller didChangeObject:(id)anObject atIndexPath:(NSIndexPath *)indexPath forChangeType:(NSFetchedResultsChangeType)type newIndexPath:(NSIndexPath *)newIndexPath {
    
    UITableView *tableView = self.tableView;
    NSIndexPath *adjustedIndexPath = [NSIndexPath indexPathForRow:indexPath.row+3 inSection:indexPath.section];
    
    switch(type) {
            
        case NSFetchedResultsChangeInsert:
            [tableView insertRowsAtIndexPaths:[NSArray arrayWithObject:newIndexPath] withRowAnimation:UITableViewRowAnimationFade];
            break;
            
        case NSFetchedResultsChangeDelete:
            [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
            break;
            
        case NSFetchedResultsChangeUpdate:
            [self configureDiaryCell:[tableView cellForRowAtIndexPath:adjustedIndexPath] atIndexPath:indexPath];
            break;
            
        case NSFetchedResultsChangeMove:
            [tableView deleteRowsAtIndexPaths:[NSArray
                                               arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
            [tableView insertRowsAtIndexPaths:[NSArray
                                               arrayWithObject:newIndexPath] withRowAnimation:UITableViewRowAnimationFade];
            break;
    }
}

- (void)controllerDidChangeContent:(NSFetchedResultsController *)controller {
    // The fetch controller has sent all current change notifications, so tell the table view to process all updates.
    [self.tableView endUpdates];
}



- (NSManagedObjectContext*)managedObjectContext  {
    return [RKObjectManager sharedManager].managedObjectStore.mainQueueManagedObjectContext;
}

@end
