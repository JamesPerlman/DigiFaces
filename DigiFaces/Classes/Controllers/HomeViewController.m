//
//  HomeViewController.m
//  DigiFaces
//
//  Created by Apple on 09/06/2015.
//  Copyright (c) 2015 Usasha studio. All rights reserved.
//
#import <SDWebImage/UIImageView+WebCache.h>

#import "AppDelegate.h"

#import "HomeViewController.h"
#import "HomeRootViewController.h"
#import "ProfilePictureCollectionViewController.h"
#import "DiaryThemeViewController.h"


#import "Utility.h"
#import "Reachability.h"
#import "MBProgressHUD.h"
#import "AFNetworking.h"
#import "UIImageView+AFNetworking.h"

#import "ProfilePicCell.h"
#import "HomeTableViewCell.h"

#import "APIHomeAnnouncementResponse.h"
#import "APIAlertCounts.h"
#import "DiaryTheme.h"
#import "File.h"
#import "Project.h"



@interface HomeViewController ()<ProfilePicCellDelegate, ProfilePictureViewControllerDelegate, NSFetchedResultsControllerDelegate>
{
    ProfilePicCell * picCell;
}
@property (nonatomic) BOOL hasContent;
@property (nonatomic, strong) NSFetchedResultsController *fetchedResultsController;
@property (nonatomic, strong) NSIndexPath *selectedIndexPath;
@end

@implementation HomeViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.fetchedResultsController.delegate = self;
    [self.fetchedResultsController performFetch:nil];
    
    self.selectedIndexPath = nil;
    
    [self.navigationController.navigationBar setBarTintColor:[UIColor blackColor]];
    [self.navigationController.navigationBar
     setTitleTextAttributes:@{NSForegroundColorAttributeName : [UIColor colorWithRed:38/255.0f green:218/255.0f blue:1 alpha:1]}];
    
    
    _imageNames = [[NSArray alloc]initWithObjects:@"home.png",@"diary.png",@"chat.png",@"friedship.png",@"talking.png",@"chat.png", nil];
    
    [self fetchUserInfo];
    // Do any additional setup after loading the view.
    
    if (![[Reachability reachabilityForInternetConnection] isReachable]) {
        AppDelegate * app = [UIApplication sharedApplication].delegate;
        [app showNetworkError];
    }
    
    // Initialize the refresh control.
    self.refreshControl = [[UIRefreshControl alloc] init];
    [self.refreshControl addTarget:self
                            action:@selector(fetchActivites)
                  forControlEvents:UIControlEventValueChanged];
    
    
}


-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    if (self.selectedIndexPath) {
        [self.tableView reloadRowsAtIndexPaths:@[self.selectedIndexPath] withRowAnimation:UITableViewRowAnimationNone];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark - Server Interaction

-(void)fetchDailyDiary:(NSNumber*)diaryId {
    defwself
    [DFClient makeRequest:APIPathGetDailyDiary
                   method:kPOST
                urlParams:@{@"diaryId" : diaryId}
               bodyParams:nil
                  success:^(NSDictionary *response, DailyDiary *result) {
                      LS.myUserInfo.currentProject.dailyDiary = result;
                      defsself
                      [sself.tableView reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:1 inSection:0]] withRowAnimation:UITableViewRowAnimationNone];
                      [sself fetchAlertCounts];
                  }
                  failure:nil];
}

-(void)fetchUserHomeAnnouncements{
    
    [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
    
    defwself
    [DFClient makeRequest:APIPathGetHomeAnnouncement
                   method:kGET
                   params:nil
                  success:^(NSDictionary *response, APIHomeAnnouncementResponse *result) {
                      defsself
                      
                      [MBProgressHUD hideHUDForView:sself.navigationController.view animated:YES];
                  }
                  failure:^(NSError *error) {
                      defsself
                      [MBProgressHUD hideHUDForView:sself.navigationController.view animated:YES];
                  }];
    
}

-(void)fetchActivites{
    
    if (![self diaryThemeCount]) {
        [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
    }
    defwself
    [DFClient makeRequest:APIPathProjectGetActivities
                   method:kPOST
                urlParams:@{@"projectId" : LS.myUserInfo.currentProjectId}
               bodyParams:nil
                  success:^(NSDictionary *response, NSArray *diaryThemes) {
                      defsself
                      //sself.dataArray = diaryThemes;
                      //[sself.tableView reloadData];
                      
                      [MBProgressHUD hideHUDForView:sself.navigationController.view animated:YES];
                      [sself fetchDailyDiary:LS.myUserInfo.currentProject.dailyDiaryList.anyObject];
                      [self.refreshControl endRefreshing];
                  }
                  failure:^(NSError *error) {
                      defsself
                      [MBProgressHUD hideHUDForView:sself.navigationController.view animated:YES];
                      [sself.customAlert showAlertWithMessage:NSLocalizedString(@"error ok/swipe", nil) inView:sself.view withTag:0];
                      [self.refreshControl endRefreshing];
                  }];
}

-(void)fetchUserInfo {
    
    if (!LS.myUserInfo) {
        [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
    }
    defwself
    [DFClient makeRequest:APIPathGetUserInfo
                   method:kGET
                   params:nil
                  success:^(NSDictionary *response, UserInfo *result) {
                      LS.myUserInfo = result;
                      LS[LSMyUserIdKey] = result.id;
                      
                      defsself
                      if (sself) {
                          [MBProgressHUD hideHUDForView:sself.navigationController.view animated:YES];
                          
                          [sself setProfilePicture:LS.myUserInfo.avatarFile.filePath withImage:nil];
                          
                          [sself.tableView reloadData];
                          
                          [sself fetchActivites];
                      }
                  }
                  failure:^(NSError *error) {
                      defsself
                      [MBProgressHUD hideHUDForView:sself.navigationController.view animated:YES];
                  }];
}

- (void)fetchProjects {
    defwself
    [DFClient makeRequest:APIPathGetProjects
                   method:kGET
                urlParams:@{@"numberOfProjects" : @0}
               bodyParams:nil
                  success:^(NSDictionary *response, id result) {
                      defsself
                      [MBProgressHUD hideHUDForView:sself.view animated:YES];
                      
                  }
                  failure:^(NSError *error) {
                      defsself
                      [MBProgressHUD hideHUDForView:sself.view animated:YES];
                  }];
}

#pragma mark - UI Methods

-(void)setProfilePicture:(NSString*)imageUrl withImage:(UIImage*)image
{
    
    if (image) {
        picCell.profileImage.image = image;
        return;
    }
    [picCell.profileImage sd_setImageWithURL:[NSURL URLWithString:imageUrl]];
}

-(void)updateProfilePicture:(NSDictionary*)profilePicture withImage:(UIImage*)image
{
    File *profilePictureFile = [File fileWithDictionary:profilePicture insertedIntoManagedObjectContext:self.managedObjectContext];
    
    [self setProfilePicture:profilePictureFile.filePath withImage:image];
    
    defwself
    [DFClient makeRequest:APIPathUploadUserCustomAvatar
                   method:kPOST
                   params:profilePicture
                  success:^(NSDictionary *response, id result) {
                      defsself
                      LS.myUserInfo.avatarFile = profilePictureFile;
                      [MBProgressHUD hideHUDForView:sself.navigationController.view animated:YES];
                  }
                  failure:^(NSError *error) {
                      defsself
                      
                      [MBProgressHUD hideHUDForView:sself.navigationController.view animated:YES];
                  }];
    
    [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
}

-(void)cacellButtonTapped{
    
}

-(void)okayButtonTapped{
    
}

#pragma mark - Table View Convenience Methods

-(void)configurePicCell
{
    NSString * userNameSaved = LS.myUserInfo.userName;//[[NSUserDefaults standardUserDefaults]objectForKey:@"userName"]?[[NSUserDefaults standardUserDefaults]objectForKey:@"userName"]:@"";
    
    picCell.delegate = self;
    picCell.lblUserName.text =  userNameSaved;
    picCell.profileImage.contentMode = UIViewContentModeScaleAspectFill;
    picCell.profileImage.clipsToBounds = YES;
    picCell.profileImage.layer.cornerRadius = picCell.profileImage.frame.size.height/2.0f;
    
    [picCell.profileImage sd_setImageWithURL:LS.myUserInfo.avatarFile.filePathURL];
}

- (void)configureCell:(UITableViewCell*)cell atIndexPath:(NSIndexPath*)indexPath {
    
    cell.separatorInset = UIEdgeInsetsZero;
    cell.layoutMargins = UIEdgeInsetsZero;
    cell.preservesSuperviewLayoutMargins = NO;
    
    HomeTableViewCell *homeCell = (HomeTableViewCell*)cell;
    if (indexPath.row == 0) {
        
        // show home item
        homeCell.titleLabel.text = @"Home";
        homeCell.unreadCount = 0;
        homeCell.unreadItemIndicator.hidden = true;
        
        //cell.imageView.image = [UIImage imageNamed:[dict valueForKey:@"Icon"]];
    } else {
        
        NSUInteger indexAdjustment = 1;
        if (LS.myUserInfo.currentProject.hasDailyDiary.boolValue) {
            ++indexAdjustment;
            if (indexPath.row == 1) {
                homeCell.titleLabel.text = @"Diary";
                homeCell.unreadCount = LS.myUserInfo.currentProject.dailyDiary.numberOfUnreadResponses;
                
                return;
            }
        }
        
        DiaryTheme * theme = [self diaryThemeForIndex:indexPath.row-indexAdjustment];
        
        [homeCell.titleLabel setText:theme.activityTitle];
        homeCell.unreadCount = theme.unreadResponses.integerValue;
        homeCell.unreadItemIndicator.hidden = theme.isRead.boolValue;
        //[cell.imageView setImage:[UIImage imageNamed:@"chat.png"]];
        
    }
    
    
}


#pragma mark - UITableViewDelegate

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if(indexPath.row == 0){
        // Project Introduction
        [self performSegueWithIdentifier:@"projectIntroSegue" sender:self];
        self.selectedIndexPath = nil;
    } else {
        self.selectedIndexPath = indexPath;
        
        if (indexPath.row == 1 && LS.myUserInfo.currentProject.hasDailyDiary.boolValue){
            [self performSegueWithIdentifier:@"dailyDiarySegue" sender:self];
        }
        else
        {
            HomeTableViewCell *cell = (HomeTableViewCell*)[tableView cellForRowAtIndexPath:indexPath];
            cell.unreadItemIndicator.hidden = false;
            [self performSegueWithIdentifier:@"diaryTheme" sender:self];
            
        }
    }
}

#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    if (!LS.myUserInfo) return 0;
    return [self diaryThemeCount] + 1 + LS.myUserInfo.currentProject.hasDailyDiary.integerValue;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 166;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 44;
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    picCell = [tableView dequeueReusableCellWithIdentifier:@"picCell"];
    [self configurePicCell];
    return picCell;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    HomeTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
    
    
    
    [self configureCell:cell atIndexPath:indexPath];
    
    return cell;
}



#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    if ([segue.identifier isEqualToString:@"profilePicSegue"]) {
        UINavigationController * navController = [segue destinationViewController];
        ProfilePictureCollectionViewController * profileController = (ProfilePictureCollectionViewController*)[navController topViewController];
        profileController.delegate = self;
    }
    else if ([segue.identifier isEqualToString:@"diaryTheme"]){
        DiaryThemeViewController * themeController = [segue destinationViewController];
        NSIndexPath * indexPath = [self.tableView indexPathForSelectedRow];
        DiaryTheme * theme = [self diaryThemeForIndex:indexPath.row - 1 - LS.myUserInfo.currentProject.hasDailyDiary.integerValue];
        themeController.diaryTheme = theme;
        themeController.navigationItem.title = theme.activityTitle;
    }
}

#pragma mark - ProfilePictureCellDelegate
-(void)cameraClicked
{
    [self performSegueWithIdentifier:@"profilePicSegue" sender:self];
}

#pragma mark - ProfilePictureCollectionViewControllerDelegate
-(void)profilePictureDidSelect:(NSDictionary *)selectedProfile withImage:(UIImage *)image
{
    [self updateProfilePicture:selectedProfile withImage:image];
    
}

#pragma mark - Notifications n stuff

-(void)fetchAlertCounts {
    defwself
    [DFClient makeRequest:APIPathGetAlertCounts
                   method:RKRequestMethodGET
                urlParams:@{@"projectId" : LS.myUserInfo.currentProjectId}
               bodyParams:nil success:^(NSDictionary *response, APIAlertCounts *result) {
                   defsself
                   [sself.homeRootViewController setAlertCounts:result];
               }
                  failure:nil];
}



#pragma mark - Data Source Convenience Methods

- (DiaryTheme*)diaryThemeForIndex:(NSUInteger)index {
    return self.fetchedResultsController.fetchedObjects[index];
}

- (NSUInteger)diaryThemeCount {
    return self.fetchedResultsController.fetchedObjects.count;
}


#pragma mark - Fetched Results Controller

- (NSFetchedResultsController*)fetchedResultsController {
    if (!_fetchedResultsController) {
        
        NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
        
        //fetchRequest.predicate = [NSPredicate predicateWithFormat:@"", ];
        
        fetchRequest.entity = [NSEntityDescription entityForName:@"DiaryTheme" inManagedObjectContext:self.managedObjectContext];
        
        fetchRequest.sortDescriptors = @[[NSSortDescriptor sortDescriptorWithKey:@"activityId" ascending:YES]];
        
        fetchRequest.fetchBatchSize = 20;
        
        
        
        _fetchedResultsController = [[NSFetchedResultsController alloc] initWithFetchRequest:fetchRequest managedObjectContext:self.managedObjectContext sectionNameKeyPath:nil cacheName:nil];
    }
    return _fetchedResultsController;
}


- (void)controllerWillChangeContent:(NSFetchedResultsController *)controller {
    // The fetch controller is about to start sending change notifications, so prepare the table view for updates.
    [self.tableView beginUpdates];
}


- (void)controller:(NSFetchedResultsController *)controller didChangeObject:(id)anObject atIndexPath:(NSIndexPath *)indexPath forChangeType:(NSFetchedResultsChangeType)type newIndexPath:(NSIndexPath *)newIndexPath {
    
    UITableView *tableView = self.tableView;
    
    switch(type) {
            
        case NSFetchedResultsChangeInsert:
            [tableView insertRowsAtIndexPaths:[NSArray arrayWithObject:newIndexPath] withRowAnimation:UITableViewRowAnimationFade];
            break;
            
        case NSFetchedResultsChangeDelete:
            [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
            break;
            
        case NSFetchedResultsChangeUpdate:
            [self configureCell:[tableView cellForRowAtIndexPath:indexPath] atIndexPath:indexPath];
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

#pragma mark - CoreData

- (NSManagedObjectContext*)managedObjectContext {
    return [RKObjectManager sharedManager].managedObjectStore.mainQueueManagedObjectContext;
}
@end
