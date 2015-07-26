//
//  MyProfileViewController.m
//  DigiFaces
//
//  Created by Apple on 17/06/2015.
//  Copyright (c) 2015 Usasha studio. All rights reserved.
//

#import "MyProfileViewController.h"
#import "MBProgressHUD.h"
#import "AFNetworking.h"
#import "UIImageView+AFNetworking.h"
#import "UserManagerShared.h"
#import "Utility.h"
#import "SDConstants.h"
#import "CustomAlertView.h"
#import "ProfilePictureCollectionViewController.h"

#define kTagDiscardChanges  100

@interface MyProfileViewController () <PopUpDelegate, ProfilePictureViewControllerDelegate>
{
    CustomAlertView * alertview;
    NSDictionary * selctedProfile;
    BOOL isTextChanged;
    NSDictionary * aboutMeDict;
}
@end

@implementation MyProfileViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self getAboutMeInfo];
    
    self.profilePicView.image = [[UserManagerShared sharedManager]profilePic];
    
    self.aboutMe.text = @"";
    self.titleName.text = [NSString stringWithFormat:@"%@ %@",[[UserManagerShared sharedManager]FirstName],[[UserManagerShared sharedManager]LastName]];
    
    self.profilePicView.layer.cornerRadius = self.profilePicView.frame.size.height /2;
    self.profilePicView.layer.masksToBounds = YES;
    self.profilePicView.layer.borderWidth = 0;
    
//    [self.aboutMe becomeFirstResponder];
    
    alertview = [[CustomAlertView alloc]initWithNibName:@"CustomAlertView" bundle:nil];
    alertview.delegate = self;
    
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(IBAction)cancelThis:(id)sender{
    
    NSString * aboutMe = [[UserManagerShared sharedManager] aboutMeText];
    
    if (![_aboutMe.text isEqualToString:@""] && ![_aboutMe.text isEqualToString:aboutMe]) {
        [_aboutMe resignFirstResponder];
        [alertview showAlertWithMessage:@"Your changes will be discarded. Do you want to descard changes?" inView:self.navigationController.view withTag:kTagDiscardChanges];
    }
    else{
        [_aboutMe resignFirstResponder];
        [self dismissViewControllerAnimated:YES completion:nil];
    }
}

-(void)getAboutMeInfo
{
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    AFHTTPRequestSerializer *requestSerializer = [AFHTTPRequestSerializer serializer];
    
    [requestSerializer setValue:[Utility getAuthToken] forHTTPHeaderField:@"Authorization"];
    
    [requestSerializer setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
    
    manager.requestSerializer = requestSerializer;
    
    NSString * url = [NSString stringWithFormat:@"%@%@", kBaseURL, kGetAboutMe];
    url = [url stringByReplacingOccurrencesOfString:@"{projectId}" withString:[NSString stringWithFormat:@"%d",[[UserManagerShared sharedManager] currentProjectID]]];
    
    
    [manager GET:url parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"JSON: %@", responseObject);
        
        [self.aboutMe setText:[responseObject valueForKey:@"AboutMeText"]];
        [self.aboutMe becomeFirstResponder];
        aboutMeDict = responseObject;
        [MBProgressHUD hideHUDForView:self.navigationController.view animated:YES];
        [[UserManagerShared sharedManager] setAboutMeText:_aboutMe.text];
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Error: %@", error);
        
        
        [alertview showAlertWithMessage:@"An error in request, verify that your email is correct" inView:self.view withTag:0];
        
        [MBProgressHUD hideHUDForView:self.navigationController.view animated:YES];
        
    }];
    [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
}

-(IBAction)postpressed:(id)sender{
    NSLog(@"Posted");
    [_aboutMe resignFirstResponder];
    if ([_aboutMe.text isEqualToString:@""]) {
        [alertview showAlertWithMessage:@"Text is required." inView:self.navigationController.view withTag:0];
        return;
    }
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    AFHTTPRequestSerializer *requestSerializer = [AFHTTPRequestSerializer serializer];
    
     [requestSerializer setValue:[Utility getAuthToken] forHTTPHeaderField:@"Authorization"];

    [requestSerializer setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
    
    NSDictionary * parameters = [NSDictionary dictionaryWithObjectsAndKeys:[aboutMeDict valueForKey:@"AboutMeId"], @"AboutMeId", [Utility getStringForKey:kCurrentPorjectID], @"ProjectId", [[UserManagerShared sharedManager] ID], @"UserId", _aboutMe.text, @"AboutMeText", nil];
    
    manager.requestSerializer = requestSerializer;
    
    NSString * url = [NSString stringWithFormat:@"%@%@", kBaseURL, kAboutMeUpdate];
    
    [manager POST:url parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"JSON: %@", responseObject);
                
        [Utility saveString:_aboutMe.text forKey:kAboutMeText];
        [MBProgressHUD hideHUDForView:self.navigationController.view animated:YES];
        
        [[UserManagerShared sharedManager] setAboutMeText:_aboutMe.text];
        [self dismissViewControllerAnimated:YES completion:nil];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Error: %@", error);
        
        
        [alertview showAlertWithMessage:@"An error in request, verify that your email is correct" inView:self.view withTag:0];
        
        [MBProgressHUD hideHUDForView:self.navigationController.view animated:YES];
        
    }];
    [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
}

-(IBAction)changePicture:(id)sender{
    
}

- (BOOL)textViewShouldBeginEditing:(UITextView *)textView{
 
    return YES;
}
- (BOOL)textViewShouldEndEditing:(UITextView *)textView{
    return YES;
}

-(void)updateProfilePicture:(NSDictionary*)profilePicture
{
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    AFJSONRequestSerializer *requestSerializer = [AFJSONRequestSerializer serializer];
    
    [requestSerializer setValue:[Utility getAuthToken] forHTTPHeaderField:@"Authorization"];
    
    //[requestSerializer setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
    [requestSerializer setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    [requestSerializer setValue:@"application/json" forHTTPHeaderField:@"Accept"];
    
    manager.requestSerializer = requestSerializer;
    
    NSString * url = [NSString stringWithFormat:@"%@%@", kBaseURL, kUpdateAvatar];
    
    [manager POST:url parameters:profilePicture success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"JSON: %@", responseObject);
        
        [[UserManagerShared sharedManager] setProfilePicDict:profilePicture];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [self setProfilePicture:[[UserManagerShared sharedManager] avatarFile].filePath];
        });
        
        [MBProgressHUD hideHUDForView:self.navigationController.view animated:YES];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Error: %@", error);
        
        
        [alertview showAlertWithMessage:@"An error in request, verify that your email is correct" inView:self.view withTag:0];
        
        [MBProgressHUD hideHUDForView:self.navigationController.view animated:YES];
        
    }];
    [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
}

-(void)setProfilePicture:(NSString*)imageUrl
{
    __weak typeof(self)weakSelf = self;
    
    NSURLRequest * requestN = [NSURLRequest requestWithURL:[NSURL URLWithString:imageUrl]];
    [self.profilePicView setImageWithURLRequest:requestN placeholderImage:[UIImage imageNamed:@"dummy_avatar.png"] success:^(NSURLRequest *request, NSHTTPURLResponse *response, UIImage *image) {
        [weakSelf.profilePicView setImage:image];
        [[UserManagerShared sharedManager] setProfilePic:[Utility resizeImage:image imageSize:CGSizeMake(100, 120)]];
        
    } failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error) {
        [MBProgressHUD hideHUDForView:weakSelf.navigationController.view animated:YES];
    }];
}


#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    if ([segue.identifier isEqualToString:@"profilePictureSegue"]) {
        UINavigationController * navController = segue.destinationViewController;
        
        ProfilePictureCollectionViewController * profileController = (ProfilePictureCollectionViewController*)[navController topViewController];
        profileController.delegate = self;
    }
}

#pragma mark - ProfilePictureDelegate
-(void)profilePictureDidSelect:(NSDictionary *)selectedProfile
{
    selectedProfile = selectedProfile;
    [self updateProfilePicture:selectedProfile];
}

#pragma mark - Popup Delegate
-(void)okayButtonTappedWithTag:(NSInteger)tag
{
    if (tag == kTagDiscardChanges) {
        [self dismissViewControllerAnimated:YES completion:nil];
    }
}
-(void)cacellButtonTappedWithTag:(NSInteger)tag
{
    
}

@end
