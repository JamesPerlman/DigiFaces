//
//  UserViewController.m
//  DigiFaces
//
//  Created by Apple on 04/06/2015.
//  Copyright (c) 2015 Usasha studio. All rights reserved.
//

#import "UserViewController.h"
#import "MBProgressHUD.h"
#import "HomeViewController.h"
#import "APIIsUserNameAvailableResponse.h"
#import "APISetUserNameResponse.h"

@interface UserViewController ()
@property (weak, nonatomic) IBOutlet UILabel *header1Label;
@property (weak, nonatomic) IBOutlet UILabel *header2Label;
@property (nonatomic, weak) IBOutlet UITextField * usernameTextField;
@property (nonatomic, weak) IBOutlet UILabel * errorMessageLabel;
@property (weak, nonatomic) IBOutlet UIButton *submitButton;

@end

@implementation UserViewController
@synthesize errorMessageLabel = _errorMessageLabel;
- (void)viewDidLoad {
    [super viewDidLoad];
    UIView *paddingView1 = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 5, 20)];
    
    _errorMessageLabel.hidden = YES;
    self.customAlert = [[CustomAlertView alloc]initWithNibName:@"CustomAlertView" bundle:nil];
    [self.customAlert setSingleButton:YES];
    self.customAlert.delegate = self;
    
    _usernameTextField.leftView = paddingView1;
    _usernameTextField.leftViewMode = UITextFieldViewModeAlways;
    
    [_usernameTextField becomeFirstResponder];
    
    // Do any additional setup after loading the view from its nib.
    [self localizeUI];
}

- (void)localizeUI {
    self.header1Label.text = DFLocalizedString(@"view.select_username.header1", nil);
    self.header2Label.text = DFLocalizedString(@"view.select_username.header2", nil);
    self.usernameTextField.placeholder = DFLocalizedString(@"view.select_username.input.username.placeholder", nil);
    
    [self.submitButton setTitle:DFLocalizedString(@"view.select_username.button.submit", nil) forState:UIControlStateNormal];
    
}
/*
 -(BOOL)prefersStatusBarHidden{
 return YES;
 }*/


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(IBAction)check_user_validation:(id)sender{
    
    NSCharacterSet *alphaSet = [NSCharacterSet alphanumericCharacterSet];
    //BOOL valid = [[_usernameTextField.text stringByTrimmingCharactersInSet:alphaSet] isEqualToString:@""];
    
    NSString *errorMessage = nil;
    
    if ([_usernameTextField.text isEqualToString:@""] ) {
        
        errorMessage = DFLocalizedString(@"view.select_username.error.empty_fields", nil);
        _errorMessageLabel.text = errorMessage;
        
        [self.customAlert showAlertWithMessage:errorMessage inView:self.view withTag:0];
        
        return;
    }
    else if([_usernameTextField.text length]<6){
        errorMessage = DFLocalizedString(@"view.select_username.error.too_short", nil);
        [self.customAlert showAlertWithMessage:errorMessage inView:self.view withTag:0];
        _errorMessageLabel.text = errorMessage;
        return;
        
    }
    /*if (!valid) // found bad characters
    {
        errorMessage = DFLocalizedString(@"view.select_username.error.invalid_characters", nil);
        
        [self.customAlert showAlertWithMessage:errorMessage inView:self.view withTag:0];
        
        _errorMessageLabel.text = errorMessage;
        return;
        
    }*/
    [self check_username_availability:_usernameTextField.text];
    
}


-(void)cacellButtonTapped{
    
}

-(void)okayButtonTapped{
    
}

-(IBAction)cancelThis:(id)sender{
    [self dismissViewControllerAnimated:YES completion:^{
        
    }];
}

-(void)cancelandpush{
    [self dismissViewControllerAnimated:YES completion:^{
        [self moveToHomeScreen];
    }];
}

-(void)moveToHomeScreen{
    
    [self.delegate pushControl];
}

- (void)check_username_availability:(NSString*)username
{
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    
    defwself
    [DFClient makeRequest:APIPathIsUserNameAvailable
                   method:kPOST
                   params:@{@"UserNameToCheck" : username}
                  success:^(NSDictionary *response, APIIsUserNameAvailableResponse *result) {
                      defsself
                      if ([result.isAvailable boolValue] == YES) {
                          [sself set_username:username];
                      } else {
                          NSString *errorMessage = DFLocalizedString(@"view.select_username.error.already_taken", nil);
                          sself.errorMessageLabel.text = errorMessage;
                          [sself.customAlert showAlertWithMessage:errorMessage inView:self.view withTag:0];
                          [MBProgressHUD hideHUDForView:self.view animated:YES];
                          
                      }
                  }
                  failure:^(NSError *error) {
                      defsself
                      [MBProgressHUD hideHUDForView:sself.view animated:YES];
                  }];
    
    
}


- (void)set_username:(NSString*)username
{
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    parameters[@"NewUserName"] = username;
    
    defwself
    [DFClient makeRequest:APIPathSetUserName
                   method:kPOST
                   params:@{@"NewUserName" : username}
                  success:^(NSDictionary *response, APISetUserNameResponse *result) {
                      defsself
                      _errorMessageLabel.textColor = [UIColor greenColor];
                      _errorMessageLabel.text = DFLocalizedString(@"view.select_username.alert.success", nil);
                      [MBProgressHUD hideHUDForView:sself.view animated:YES];
                      
                      [[NSUserDefaults standardUserDefaults]setObject:username forKey:@"userName"];
                      [[NSUserDefaults standardUserDefaults]synchronize];
                      
                      [sself performSelector:@selector(cancelandpush) withObject:nil afterDelay:2];
                  }
                  failure:^(NSError *error) {
                      defsself
                      _errorMessageLabel.text = DFLocalizedString(@"app.error.server_error", nil);
                      [MBProgressHUD hideHUDForView:sself.view animated:YES];
                  }];
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField{
    [textField resignFirstResponder];
    
    return YES;
}

-(BOOL)textFieldShouldEndEditing:(UITextField *)textField{
    [textField resignFirstResponder];
    return YES;
}


/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */

@end
