//
//  LoginTableController.m
//  DigiFaces
//
//  Created by confiz on 02/07/2015.
//  Copyright (c) 2015 Usasha studio. All rights reserved.
//

#import "LoginTableController.h"
#import "AFNetworking.h"
#import "MBProgressHUD.h"
#import "UserInfo.h"
#import "UserViewController.h"

@interface LoginTableController() <PopUpDelegate, MessageToViewMain>
@property (weak, nonatomic) IBOutlet UILabel *signInLabel;
@property (weak, nonatomic) IBOutlet UILabel *loginMessageLabel;
@property (weak, nonatomic) IBOutlet UITextField *emailTextField;
@property (weak, nonatomic) IBOutlet UITextField *passwordTextField;
@property (weak, nonatomic) IBOutlet UILabel *errorMessageLabel;
@property (weak, nonatomic) IBOutlet UIButton *signInButton;
@property (weak, nonatomic) IBOutlet UIButton *forgotPasswordButton;

@end

@implementation LoginTableController

-(void)viewDidLoad
{
    [super viewDidLoad];
    [self.navigationController setNavigationBarHidden:YES];
    
    self.customAlert = [[CustomAlertView alloc]initWithNibName:@"CustomAlertView" bundle:nil];
    [self.customAlert setSingleButton:YES];
    self.customAlert.delegate = self;
    _errorMessageLabel.hidden = YES;
    
    UIView *paddingView1 = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 10, 20)];
    UIView *paddingView2 = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 10, 20)];
    
    _emailTextField.leftView = paddingView1;
    _emailTextField.leftViewMode = UITextFieldViewModeAlways;
    
    _passwordTextField.leftView = paddingView2;
    _passwordTextField.leftViewMode = UITextFieldViewModeAlways;
    [self localizeUI];
}

- (void)localizeUI {
    
    self.signInLabel.text = DFLocalizedString(@"view.login.header1", nil);
    
    self.loginMessageLabel.text = DFLocalizedString(@"view.login.header2", nil);
    
    self.emailTextField.placeholder = DFLocalizedString(@"view.login.input.email.placeholder", nil);
    
    self.passwordTextField.placeholder = DFLocalizedString(@"view.login.input.password.placeholder", nil);
    
    [self.signInButton setTitle:DFLocalizedString(@"view.login.button.sign_in", nil) forState:UIControlStateNormal];
    
    [self.forgotPasswordButton setTitle:DFLocalizedString(@"view.login.button.forgot_password", nil) forState:UIControlStateNormal];
}

/*
-(BOOL)prefersStatusBarHidden{
    return YES;
}*/

- (BOOL)validateEmailWithString:(NSString*)email
{
    NSString *emailRegex = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}";
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
    return [emailTest evaluateWithObject:email];
}

-(void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (IBAction)forgotPasswordPressed:(id)sender {
}

- (IBAction)exitOnEnd:(id)sender {
    [sender resignFirstResponder];
}

- (IBAction)signInPressed:(id)sender {
    [_emailTextField resignFirstResponder];
    [_passwordTextField resignFirstResponder];
    
    if ([_emailTextField.text isEqualToString:@""] || [_passwordTextField.text isEqualToString:@""] ) {
        
        NSString *errorMessage = DFLocalizedString(@"view.login.error.empty_fields", nil);
        _errorMessageLabel.text = errorMessage;
        
        self.customAlert.fromW = @"login";
        
        [self.customAlert showAlertWithMessage:errorMessage inView:self.view withTag:0];
        
        
        return;
    }
    else if(![self validateEmailWithString:_emailTextField.text]){
        NSString *errorMessage = DFLocalizedString(@"view.login.error.invalid_email", nil);
        _errorMessageLabel.text = errorMessage;
        self.customAlert.fromW = @"login";
        [self.customAlert showAlertWithMessage:errorMessage inView:self.view withTag:0];
        
        return;
        
    }
    
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    
    
    
    NSString * username = [NSString stringWithString:_emailTextField.text ];//@"xxshabanaxx@focusforums.net";
   // parameters[@"grant_type"] = @"password";
    //parameters[@"username"] = username;// [username stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLHostAllowedCharacterSet]];
    NSString * password = [NSString stringWithString:_passwordTextField.text ];
    defwself
    [DFClient loginWithUsername:username password:password success:^(NSDictionary *response, id result) {
        defsself
        [sself successfulLogin];
    } failure:^(NSError *error) {
        defsself
        [MBProgressHUD hideHUDForView:sself.view animated:YES];
        
        sself.customAlert.fromW = @"login";
        
        
        NSString *errorMessage = DFLocalizedString(@"view.login.error.login_failed", nil);
        
        [sself.customAlert showAlertWithMessage:errorMessage inView:sself.view withTag:0];
        
        sself.errorMessageLabel.text = errorMessage;
    }];
}

- (void)successfulLogin {
    
    [self check_username_existence];
}

-(void)check_username_existence{
    
    defwself
    
    [DFClient makeRequest:APIPathGetUserInfo method:kGET params:nil success:^(NSDictionary *response, UserInfo *userInfo) {
        defsself
        
        [MBProgressHUD hideHUDForView:sself.view animated:YES];
        
        userInfo.userId = userInfo.id;
        [userInfo.managedObjectContext save:nil];
        LS.myUserInfo = userInfo;
        
        if (userInfo.isUserNameSet.boolValue) {
            [sself moveToHomeScreen];
        } else {
            [sself moveToUserNameScreen];
        }
        
    } failure:^(NSError *error) {
        defsself
        [MBProgressHUD hideHUDForView:sself.view animated:YES];
    }];
}

-(void)moveToUserNameScreen{
    
    [self performSegueWithIdentifier: @"ToUserViewController" sender: self];
}

-(void)moveToHomeScreen{
    
    [self performSegueWithIdentifier: @"loginSegue" sender: self];
}


-(void)pushControl{
    [self moveToHomeScreen];
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    if ([segue.identifier isEqualToString:@"ToUserViewController"]) {
        UserViewController * user =    segue.destinationViewController;
        user.delegate = self;
    }
}


-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [_emailTextField resignFirstResponder];
    [_passwordTextField resignFirstResponder];
}

@end
