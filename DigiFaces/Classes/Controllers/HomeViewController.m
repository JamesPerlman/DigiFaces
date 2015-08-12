//
//  HomeViewController.m
//  DigiFaces
//
//  Created by Apple on 09/06/2015.
//  Copyright (c) 2015 Usasha studio. All rights reserved.
//

#import "HomeViewController.h"
#import "MBProgressHUD.h"
#import "AFNetworking.h"
#import "UIImageView+AFNetworking.h"
#import "UserManagerShared.h"
#import "File.h"
#import "ProfilePicCell.h"

#import "Utility.h"
#import "ProfilePictureCollectionViewController.h"
#import "Reachability.h"
#import "AppDelegate.h"
#import "DiaryTheme.h"
#import "DiaryThemeViewController.h"
#import "HomeTableViewCell.h"
#import "APIHomeAnnouncementResponse.h"
#import "APIAlertCounts.h"
#import "HomeRootViewController.h"

#import <SDWebImage/UIImageView+WebCache.h>


@interface HomeViewController ()<ProfilePicCellDelegate, ProfilePictureViewControllerDelegate>
{
    ProfilePicCell * picCell;
    __block BOOL loaded;
}
@property (nonatomic ,retain) NSArray * dataArray;
@end

@implementation HomeViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.tableView.delegate = nil;
    self.tableView.dataSource = nil;
    
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
    //[self.tableView reloadData];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)cacellButtonTapped{
    
}

-(void)okayButtonTapped{
    
}

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
    
    [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
    defwself
    [DFClient makeRequest:APIPathProjectGetActivities
                   method:kPOST
                urlParams:@{@"projectId" : LS.myUserInfo.currentProjectId}
               bodyParams:nil
                  success:^(NSDictionary *response, NSArray *diaryThemes) {
                      defsself
                      sself.dataArray = diaryThemes;
                      [sself.tableView reloadData];
                      
                      [MBProgressHUD hideHUDForView:sself.navigationController.view animated:YES];
                      [sself fetchDailyDiary:LS.myUserInfo.currentProject.dailyDiaryList.firstObject];
                  }
                  failure:^(NSError *error) {
                      defsself
                      [MBProgressHUD hideHUDForView:sself.navigationController.view animated:YES];
                      [sself.customAlert showAlertWithMessage:NSLocalizedString(@"Something went wrong when loading your activities.  Pull down to refresh the data.", nil) inView:sself.view withTag:0];
                  }];
    [self.refreshControl endRefreshing];
}

-(void)fetchUserInfo{
    
    [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
    
    defwself
    [DFClient makeRequest:APIPathGetUserInfo
                   method:kGET
                   params:nil
                  success:^(NSDictionary *response, UserInfo *result) {
                      LS.myUserInfo = result;
                      defsself
                      loaded = true;
                      
                      self.tableView.delegate = self;
                      self.tableView.dataSource = self;
                      [MBProgressHUD hideHUDForView:sself.navigationController.view animated:YES];
                      
                      [sself setProfilePicture:LS.myUserInfo.avatarFile.filePath withImage:nil];
                      
                      [sself fetchActivites];
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
    File *profilePictureFile = [[File alloc] initWithDictionary:profilePicture];
    
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

-(void)configurePicCell
{
    NSString * userNameSaved = [[NSUserDefaults standardUserDefaults]objectForKey:@"userName"]?[[NSUserDefaults standardUserDefaults]objectForKey:@"userName"]:@"";
    
    picCell.delegate = self;
    picCell.lblUserName.text =  userNameSaved;
    picCell.profileImage.contentMode = UIViewContentModeScaleAspectFill;
    picCell.profileImage.clipsToBounds = YES;
    picCell.profileImage.layer.cornerRadius = picCell.profileImage.frame.size.height/2.0f;
    
    [picCell.profileImage sd_setImageWithURL:LS.myUserInfo.avatarFile.filePathURL];
}

#pragma mark - UITableViewDeleagate

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    if (!loaded) return 0;
    
    return _dataArray.count + 1 + LS.myUserInfo.currentProject.hasDailyDiary.integerValue;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if(indexPath.row == 0){
        // Project Introduction
        [self performSegueWithIdentifier:@"projectIntroSegue" sender:self];
    }
    else if (indexPath.row == 1 && LS.myUserInfo.currentProject.hasDailyDiary.boolValue){
        [self performSegueWithIdentifier:@"dailyDiarySegue" sender:self];
    }
    else
    {
        HomeTableViewCell *cell = (HomeTableViewCell*)[tableView cellForRowAtIndexPath:indexPath];
        cell.unreadItemIndicator.hidden = false;
        [self performSegueWithIdentifier:@"diaryTheme" sender:self];
        
    }
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
    
    cell.separatorInset = UIEdgeInsetsZero;
    cell.layoutMargins = UIEdgeInsetsZero;
    cell.preservesSuperviewLayoutMargins = NO;
    
    if (indexPath.row == 0) {
        
        // show home item
        cell.titleLabel.text = @"Home";
        cell.unreadCount = 0;
        cell.unreadItemIndicator.hidden = true;
        
        //cell.imageView.image = [UIImage imageNamed:[dict valueForKey:@"Icon"]];
    } else {
        
        NSUInteger indexAdjustment = 1;
        if (LS.myUserInfo.currentProject.hasDailyDiary.boolValue) {
            ++indexAdjustment;
            if (indexPath.row == 1) {
                cell.titleLabel.text = @"Diary";
                cell.unreadCount = LS.myUserInfo.currentProject.dailyDiary.numberOfUnreadResponses;
                
                return cell;
            }
        }
        
        
        DiaryTheme * theme = [_dataArray objectAtIndex:indexPath.row-indexAdjustment];
        
        [cell.titleLabel setText:theme.activityTitle];
        
        cell.unreadCount = theme.unreadResponses.integerValue;
        cell.unreadItemIndicator.hidden = theme.isRead.boolValue;
        //[cell.imageView setImage:[UIImage imageNamed:@"chat.png"]];
    }
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
        DiaryTheme * theme = [_dataArray objectAtIndex:indexPath.row - 1 - LS.myUserInfo.currentProject.hasDailyDiary.integerValue];
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

@end
