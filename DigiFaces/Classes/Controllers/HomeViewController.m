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
#import "SDConstants.h"
#import "Utility.h"
#import "ProfilePictureCollectionViewController.h"
#import "Reachability.h"
#import "AppDelegate.h"
#import "DiaryTheme.h"
#import "DiaryThemeViewController.h"

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

    NSString * onlinekey = [[NSUserDefaults standardUserDefaults]objectForKey:@"access_token"];
    
    NSString *finalyToken = [[NSString alloc]initWithFormat:@"Bearer %@",onlinekey ];
    
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    AFHTTPRequestSerializer *requestSerializer = [AFHTTPRequestSerializer serializer];
    
    [requestSerializer setValue:finalyToken forHTTPHeaderField:@"Authorization"];
    [requestSerializer setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
    
    
    
    manager.requestSerializer = requestSerializer;
    
    
    [manager GET:@"http://digifacesservices.focusforums.com/api/Project/GetHomeAnnouncement/{projectId}" parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        NSLog(@"User JSON: %@", responseObject);
       
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Error: %@", error);
        [MBProgressHUD hideHUDForView:self.navigationController.view animated:YES]; 
    }];
}

-(void)fetchActivites{
    
    [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    AFHTTPRequestSerializer *requestSerializer = [AFHTTPRequestSerializer serializer];
    
    [requestSerializer setValue:[Utility getAuthToken] forHTTPHeaderField:@"Authorization"];
    [requestSerializer setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
    
    NSString * url = [NSString stringWithFormat:@"%@%@", kBaseURL, kGetActivties];
    url = [url stringByReplacingOccurrencesOfString:@"{projectId}" withString:[NSString stringWithFormat:@"%d",[[UserManagerShared sharedManager] currentProjectID]]];
    
    manager.requestSerializer = requestSerializer;
    
    [manager POST:url parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"User JSON: %@", responseObject);
        
        for (NSDictionary * dict in responseObject) {
            DiaryTheme * theme = [[DiaryTheme alloc] initWithDictionary:dict];
            [_dataArray addObject:theme];
        }
        [self.tableView reloadData];
        
        [MBProgressHUD hideHUDForView:self.navigationController.view animated:YES];
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Error: %@", error);
        [MBProgressHUD hideHUDForView:self.navigationController.view animated:YES];
        
    }];
}

-(void)fetchUserInfo{
    
    [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    AFHTTPRequestSerializer *requestSerializer = [AFHTTPRequestSerializer serializer];
    
    [requestSerializer setValue:[Utility getAuthToken] forHTTPHeaderField:@"Authorization"];
    [requestSerializer setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
    
    manager.requestSerializer = requestSerializer;
    
    [manager GET:@"http://digifacesservices.focusforums.com/api/Account/UserInfo" parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"User JSON: %@", responseObject);
        
        NSDictionary * avatarDic = [responseObject objectForKey:@"AvatarFile"];
        File * avatarFileObj = [[File alloc]init];
        NSString * imageUrl = [avatarFileObj returnFilePathFromFileObject:avatarDic];
        [Utility saveString:imageUrl forKey:kImageURL];
        NSString * currentProjectID = [responseObject valueForKey:kCurrentPorjectID];
        NSString * email = [responseObject valueForKey:kEmail];
        [Utility saveString:currentProjectID forKey:kCurrentPorjectID];
        [Utility saveString:[responseObject valueForKey:kAboutMeText] forKey:kAboutMeText];
        [Utility saveString:email forKey:kEmail];
        
        [[UserManagerShared sharedManager] setUserInfoDictionary:responseObject];
        

        [MBProgressHUD hideHUDForView:self.navigationController.view animated:YES];
        
        [self setProfilePicuture:[[UserManagerShared sharedManager] avatarFile].filePath];
        
        [[UserManagerShared sharedManager] setFirstName:[responseObject objectForKey:@"FirstName"]];
        [[UserManagerShared sharedManager] setLastName:[responseObject objectForKey:@"LastName"]];
        [[UserManagerShared sharedManager] setAboutMeText:[responseObject objectForKey:@"AboutMeText"]];

        [self fetchActivites];
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Error: %@", error);
        [MBProgressHUD hideHUDForView:self.navigationController.view animated:YES];
        
    }];
}


-(void)setProfilePicuture:(NSString*)imageUrl
{
    
    NSURLRequest * requestN = [NSURLRequest requestWithURL:[NSURL URLWithString:imageUrl]];
    [picCell.profileImage setImageWithURLRequest:requestN placeholderImage:[UIImage imageNamed:@"dummy_avatar.png"] success:^(NSURLRequest *request, NSHTTPURLResponse *response, UIImage *image) {
        
        [[UserManagerShared sharedManager] setProfilePic:[Utility resizeImage:image imageSize:CGSizeMake(100, 120)]];
        
    } failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error) {
        NSLog(@"Image download failed");
    }];
}

-(void)updateProfilePicture:(NSDictionary*)profilePicture
{
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    AFJSONRequestSerializer *requestSerializer = [AFJSONRequestSerializer serializer];
    
    [requestSerializer setValue:[Utility getAuthToken] forHTTPHeaderField:@"Authorization"];
    
    [requestSerializer setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    [requestSerializer setValue:@"application/json" forHTTPHeaderField:@"Accept"];
    
    manager.requestSerializer = requestSerializer;
    
    NSString * url = [NSString stringWithFormat:@"%@%@", kBaseURL, kUpdateAvagar];
    
    [manager POST:url parameters:profilePicture success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"JSON: %@", responseObject);
        
        [[UserManagerShared sharedManager] setProfilePicDict:profilePicture];
        
        [self setProfilePicuture:[[UserManagerShared sharedManager] avatarFile].filePath];
        
        [MBProgressHUD hideHUDForView:self.navigationController.view animated:YES];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Error: %@", error);
        
        [MBProgressHUD hideHUDForView:self.navigationController.view animated:YES];
        
    }];
    [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
}

-(void)configurePicCell
{
    NSString * userNameSaved = [[NSUserDefaults standardUserDefaults]objectForKey:@"userName"]?[[NSUserDefaults standardUserDefaults]objectForKey:@"userName"]:@"";
    
    picCell.delegate = self;
    picCell.lblUserName.text =  userNameSaved;
    picCell.profileImage.contentMode = UIViewContentModeScaleToFill;
    picCell.profileImage.clipsToBounds = YES;
    picCell.profileImage.layer.cornerRadius = 47.0;
    
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
    
    if (indexPath.row == 0 || indexPath.row == 1) {
        NSDictionary * dict = [_dataArray objectAtIndex:indexPath.row];
        UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
        cell.textLabel.text = NSLocalizedString([dict objectForKey:@"Title"], [dict objectForKey:@"Title"]);
        cell.imageView.image = [UIImage imageNamed:[dict valueForKey:@"Icon"]];
        return cell;
    }
    else{
        UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
        
        DiaryTheme * theme = [_dataArray objectAtIndex:indexPath.row];
        [cell.textLabel setText:theme.activityTitle];
        [cell.imageView setImage:[UIImage imageNamed:@"chat.png"]];
        return cell;
    }
    
    return nil;
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
    }
}

#pragma mark - ProfilePictureCellDelegate
-(void)cameraClicked
{
    [self performSegueWithIdentifier:@"profilePicSegue" sender:self];
}

#pragma mark - ProfilePictureCollectionViewControllerDelegate
-(void)profilePicutreDidSelect:(NSDictionary *)selectedProfile
{
    [self updateProfilePicture:selectedProfile];
    
}

@end
