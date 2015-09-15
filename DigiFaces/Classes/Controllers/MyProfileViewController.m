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
#import "Utility.h"
#import "AboutMe.h"
#import "File.h"
#import <SDWebImage/UIImageView+WebCache.h>

#import "CustomAlertView.h"
#import "ProfilePictureCollectionViewController.h"

#define kTagDiscardChanges  100

@interface MyProfileViewController () <PopUpDelegate, ProfilePictureViewControllerDelegate>
{
    CustomAlertView * alertview;
    NSDictionary * selctedProfile;
    BOOL isTextChanged;
}
@property (nonatomic, strong) AboutMe *aboutMe;
@end

@implementation MyProfileViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self getAboutMeInfo];
    
    [self.profilePicView sd_setImageWithURL:LS.myUserInfo.avatarFile.filePathURL];
    
    self.aboutMeTextView.text = @"";
    self.titleName.text = [NSString stringWithFormat:@"%@ %@",LS.myUserInfo.firstName,LS.myUserInfo.lastName];
    
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
    
    NSString * aboutMe = LS.myUserInfo.aboutMeText;
    
    if (![_aboutMeTextView.text isEqualToString:@""] && ![_aboutMeTextView.text isEqualToString:aboutMe]) {
        [_aboutMeTextView resignFirstResponder];
        [alertview showAlertWithMessage:@"Your changes will be discarded. Do you want to descard changes?" inView:self.navigationController.view withTag:kTagDiscardChanges];
    }
    else{
        [_aboutMeTextView resignFirstResponder];
        [self dismissViewControllerAnimated:YES completion:nil];
    }
}

-(void)getAboutMeInfo {
    defwself
    
    [DFClient makeRequest:APIPathGetAboutMe
                   method:kGET
                urlParams:@{@"projectId" : LS.myUserInfo.currentProjectId}
               bodyParams:nil
                  success:^(NSDictionary *response, AboutMe *result) {
                      defsself
                      
                      [sself.aboutMeTextView setText:result.aboutMeText];
                      [sself.aboutMeTextView becomeFirstResponder];
                      sself.aboutMe = result;
                      [MBProgressHUD hideHUDForView:self.navigationController.view animated:YES];
                      LS.myUserInfo.aboutMeText = _aboutMeTextView.text;
                      
                  } failure:^(NSError *error) {
                      
                      [alertview showAlertWithMessage:@"There was an error.  Please verify that your email is correct." inView:self.view withTag:0];
                      
                      [MBProgressHUD hideHUDForView:self.navigationController.view animated:YES];
                  }];
    [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
}

-(IBAction)postpressed:(id)sender{
    NSLog(@"Posted");
    [_aboutMeTextView resignFirstResponder];
    if ([_aboutMeTextView.text isEqualToString:@""]) {
        [alertview showAlertWithMessage:@"Please enter something about yourself." inView:self.navigationController.view withTag:0];
        return;
    }
    
    NSDictionary * params = @{@"AboutMeId" : self.aboutMe.aboutMeId,
                              @"ProjectId" : [Utility getStringForKey:kCurrentPorjectID],
                              @"UserId" : LS.myUserInfo.id,
                              @"AboutMeText" : _aboutMeTextView.text};
    defwself
    [DFClient makeRequest:APIPathUpdateAboutMe
                   method:kPOST
                   params:params
                  success:^(NSDictionary *response, id result) {
                      defsself
                      [Utility saveString:_aboutMeTextView.text forKey:kAboutMeText];
                      [MBProgressHUD hideHUDForView:self.navigationController.view animated:YES];
                      
                      LS.myUserInfo.aboutMeText = _aboutMeTextView.text;                      [sself dismissViewControllerAnimated:YES completion:nil];
                  } failure:^(NSError *error) {
                      defsself
                      [alertview showAlertWithMessage:@"An error in request, verify that your email is correct" inView:sself.view withTag:0];
                      
                      [MBProgressHUD hideHUDForView:sself.navigationController.view animated:YES];
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

-(void)updateProfilePicture:(NSDictionary*)profilePicture withImage:(UIImage*)image
{
    
    defwself
    [DFClient makeRequest:APIPathUploadUserCustomAvatar
                   method:kPOST
                   params:profilePicture
                  success:^(NSDictionary *response, File *result) {
                      defsself
                      LS.myUserInfo.avatarFile = result;
//                      [[UserManagerShared sharedManager] setProfilePicDict:profilePicture];
                      
                      dispatch_async(dispatch_get_main_queue(), ^{
                          [sself setProfilePicture:LS.myUserInfo.avatarFile.filePath withImage:image];
                      });
                      
                      [MBProgressHUD hideHUDForView:sself.navigationController.view animated:YES];
                  }
                  failure:^(NSError *error) {
                      defsself
                      [alertview showAlertWithMessage:@"An error occurred.  Please verify that your email is correct." inView:sself.view withTag:0];
                      
                      [MBProgressHUD hideHUDForView:sself.navigationController.view animated:YES];
                  }];
    [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
}

-(void)setProfilePicture:(NSString*)imageUrl withImage:(UIImage*)image
{
    if (image) {
        self.profilePicView.image = image;
        return;
    }
    
    [self.profilePicView sd_setImageWithURL:[NSURL URLWithString:imageUrl] placeholderImage:[UIImage imageNamed:@"dummy_avatar.png"]];
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
-(void)profilePictureDidSelect:(NSDictionary *)selectedProfile withImage:(UIImage*)image
{
    selectedProfile = selectedProfile;
    [self updateProfilePicture:selectedProfile withImage:image];
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
