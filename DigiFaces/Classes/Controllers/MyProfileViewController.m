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

@property (nonatomic, weak) IBOutlet UIView *profilePicBGView;
@property (nonatomic, weak) IBOutlet UIView *cameraBGView;
@end

@implementation MyProfileViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self getAboutMeInfo];
    
    [self.profilePicView sd_setImageWithURL:LS.myUserInfo.avatarFile.filePathURL];
    
    self.aboutMeTextView.text = @"";
    self.titleName.text = LS.myUserInfo.appUserName;//[NSString stringWithFormat:@"%@ %@",LS.myUserInfo.firstName,LS.myUserInfo.lastName];
    
    
    //    [self.aboutMe becomeFirstResponder];
    
    alertview = [[CustomAlertView alloc]initWithNibName:@"CustomAlertView" bundle:nil];
    alertview.delegate = self;
    
    // Do any additional setup after loading the view.
    [self localizeUI];
    [self setupUI];
    self.navigationItem.rightBarButtonItem.image = [UIImage imageNamed:@"check-white-30px"];
}

- (void)localizeUI {
    self.navigationItem.title = DFLocalizedString(@"view.profile.navbar.title", nil);
    //self.navigationItem.rightBarButtonItem.title = DFLocalizedString(@"view.profile.button.save", nil);
}

- (void)setupUI {
    self.profilePicView.layer.cornerRadius = self.profilePicView.bounds.size.width / 2.0;
    self.profilePicView.clipsToBounds = true;
    
    self.profilePicBGView.layer.cornerRadius = self.profilePicBGView.bounds.size.width / 2.0;
    self.profilePicBGView.clipsToBounds = true;
    
    self.cameraBGView.layer.cornerRadius = 4.0;
    self.cameraBGView.clipsToBounds = true;
}

- (UIBarButtonItem*)rightBarButtonItem {
    return [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"check-white-40px"] style:UIBarButtonItemStylePlain target:self action:@selector(postpressed:)];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(IBAction)cancelThis:(id)sender{
    
    NSString * aboutMe = LS.myUserInfo.aboutMeText;
    
    if (![_aboutMeTextView.text isEqualToString:@""] && ![_aboutMeTextView.text isEqualToString:aboutMe]) {
        [_aboutMeTextView resignFirstResponder];
        [alertview showAlertWithMessage:DFLocalizedString(@"view.profile.alert.confirm_discard", nil) inView:self.navigationController.view withTag:kTagDiscardChanges];
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
                      
                      [alertview showAlertWithMessage:DFLocalizedString(@"view.profile.error.load_failure", nil) inView:self.view withTag:0];
                      
                      [MBProgressHUD hideHUDForView:self.navigationController.view animated:YES];
                  }];
    [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
}

-(IBAction)postpressed:(id)sender{
    NSLog(@"Posted");
    if ([_aboutMeTextView.text isEqualToString:@""]) {
        [alertview showAlertWithMessage:DFLocalizedString(@"view.profile.error.empty_bio", nil) inView:self.navigationController.view withTag:0];
        return;
    }
    
    [_aboutMeTextView resignFirstResponder];
    NSDictionary * params = @{@"AboutMeId" : self.aboutMe.aboutMeId,
                              @"ProjectId" : LS.myUserInfo.currentProjectId,
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
                      [alertview showAlertWithMessage:DFLocalizedString(@"view.profile.alert.save_success", nil) inView:sself.view withTag:0];
                      LS.myUserInfo.aboutMeText = _aboutMeTextView.text;
                      //[sself dismissViewControllerAnimated:YES completion:nil];
                  } failure:^(NSError *error) {
                      defsself
                      [alertview showAlertWithMessage:DFLocalizedString(@"view.profile.alert.save_failure", nil) inView:sself.view withTag:0];
                      
                      [MBProgressHUD hideHUDForView:sself.navigationController.view animated:YES];
                  }];
    [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
}

-(IBAction)changePicture
{
    [self performSegueWithIdentifier:@"profilePicSegue" sender:self];
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
                      [alertview showAlertWithMessage:DFLocalizedString(@"view.profile.alert.photo_upload_failure", nil) inView:sself.view withTag:0];
                      
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
    NSURL *avatarURL = [NSURL URLWithString:imageUrl];
    if (avatarURL) {
        [self.profilePicView sd_setImageWithURL:avatarURL placeholderImage:[UIImage imageNamed:@"genericavatar"]];
    } else {
        [self.profilePicView sd_setImageWithURL:[NSURL URLWithString:DFAvatarGenericImageURLKey] placeholderImage:[UIImage imageNamed:@"genericavatar"]];
    }
}


#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    if ([segue.identifier isEqualToString:@"profilePicSegue"]) {
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
-(void)cancelButtonTappedWithTag:(NSInteger)tag
{
    
}

@end
