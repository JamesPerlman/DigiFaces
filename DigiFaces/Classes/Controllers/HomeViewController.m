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
#import "APIProjectActivitiesResponse.h"

@interface HomeViewController ()<ProfilePicCellDelegate, ProfilePictureViewControllerDelegate>
{
    ProfilePicCell * picCell;
}
@property (nonatomic ,retain) NSMutableArray * dataArray;

@end

@implementation HomeViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.navigationController.navigationBar setBarTintColor:[UIColor blackColor]];
    [self.navigationController.navigationBar
     setTitleTextAttributes:@{NSForegroundColorAttributeName : [UIColor colorWithRed:38/255.0f green:218/255.0f blue:1 alpha:1]}];
    
    _dataArray = [[NSMutableArray alloc] init];
    [_dataArray addObject:@{@"Title" : @"home", @"Icon" : @"home.png"}];
    [_dataArray addObject:@{@"Title" : @"diary", @"Icon" : @"diary.png"}];
    
    _imageNames = [[NSArray alloc]initWithObjects:@"home.png",@"diary.png",@"chat.png",@"friedship.png",@"talking.png",@"chat.png", nil];
    
    [self fetchUserInfo];
    // Do any additional setup after loading the view.
    
    if (![[Reachability reachabilityForInternetConnection] isReachable]) {
        AppDelegate * app = [UIApplication sharedApplication].delegate;
        [app showNetworkError];
    }
    
    
}

-(void)viewDidAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.tableView reloadData];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)cacellButtonTapped{
    
}

-(void)okayButtonTapped{
    
}

-(void)fetchUserHomeAnnouncements{
    
    [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
    
    defwself
    [DFClient makeRequest:APIPathGetHomeAnnouncement
                   method:kGET
                   params:nil
                  success:^(NSDictionary *response, id result) {
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
                urlParams:@{@"projectId" : @([[UserManagerShared sharedManager] currentProjectID])}
               bodyParams:nil
                  success:^(NSDictionary *response, APIProjectActivitiesResponse *result) {
                      defsself
                      [sself.dataArray addObjectsFromArray:result.diaryThemes];
                      [sself.tableView reloadData];
                      
                      [MBProgressHUD hideHUDForView:sself.navigationController.view animated:YES];
                  }
                  failure:^(NSError *error) {
                      defsself
                      [MBProgressHUD hideHUDForView:sself.navigationController.view animated:YES];
                  }];
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
                      [MBProgressHUD hideHUDForView:sself.navigationController.view animated:YES];
                      
                      [sself setProfilePicture:[[UserManagerShared sharedManager] avatarFile].filePath withImage:nil];
                      
                      [sself fetchActivites];
                  }
                  failure:^(NSError *error) {
                      defsself
                      [MBProgressHUD hideHUDForView:sself.navigationController.view animated:YES];
                  }];
    }


-(void)setProfilePicture:(NSString*)imageUrl withImage:(UIImage*)image
{
    if (image) {
        [[UserManagerShared sharedManager] setProfilePic:image];
        picCell.profileImage.image = image;
        return;
    }
    NSURLRequest * requestN = [NSURLRequest requestWithURL:[NSURL URLWithString:imageUrl]];
    [picCell.profileImage setImageWithURLRequest:requestN placeholderImage:[UIImage imageNamed:@"dummy_avatar.png"] success:^(NSURLRequest *request, NSHTTPURLResponse *response, UIImage *image) {
        
        [[UserManagerShared sharedManager] setProfilePic:[Utility resizeImage:image imageSize:CGSizeMake(100, 120)]];
        
    } failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error) {
        NSLog(@"Image download failed");
    }];
}

-(void)updateProfilePicture:(NSDictionary*)profilePicture withImage:(UIImage*)image
{
    [self setProfilePicture:LS.myUserInfo.avatarFile.filePath withImage:image];
    
    defwself
    [DFClient makeRequest:APIPathUploadUserCustomAvatar
                   method:kPOST
                   params:profilePicture
                  success:^(NSDictionary *response, id result) {
                      
                      [[UserManagerShared sharedManager] setProfilePicDict:profilePicture];
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
    
    if ([[UserManagerShared sharedManager] profilePic]) {
        [picCell.profileImage setImage:[[UserManagerShared sharedManager] profilePic]];
    }
}

#pragma mark - UITableViewDeleagate

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return _dataArray.count;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if(indexPath.row == 0){
        // Project Introduction
        [self performSegueWithIdentifier:@"projectIntroSegue" sender:self];
    }
    else if (indexPath.row == 1){
        [self performSegueWithIdentifier:@"dailyDiarySegue" sender:self];
    }
    else
    {
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
    if (indexPath.row == 0 || indexPath.row == 1) {
        NSDictionary * dict = [_dataArray objectAtIndex:indexPath.row];
        cell.titleLabel.text = NSLocalizedString([dict objectForKey:@"Title"], [dict objectForKey:@"Title"]);
        cell.unreadCount = 0;
        //cell.imageView.image = [UIImage imageNamed:[dict valueForKey:@"Icon"]];
    }
    else{
        
        
        DiaryTheme * theme = [_dataArray objectAtIndex:indexPath.row];
        
        [cell.titleLabel setText:theme.activityTitle];
        
        cell.unreadCount = theme.unreadResponses;
        
        //[cell.imageView setImage:[UIImage imageNamed:@"chat.png"]];
    }
    cell.separatorInset = UIEdgeInsetsZero;
    cell.layoutMargins = UIEdgeInsetsZero;
    cell.preservesSuperviewLayoutMargins = NO;
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
        DiaryTheme * theme = [_dataArray objectAtIndex:indexPath.row];
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

@end
