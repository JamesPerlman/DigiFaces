//
//  ForgotPasswordViewController.m
//  DigiFaces
//
//  Created by Apple on 05/06/2015.
//  Copyright (c) 2015 Usasha studio. All rights reserved.
//

#import "ForgotPasswordViewController.h"
#import "MBProgressHUD.h"

@interface ForgotPasswordViewController () <PopUpDelegate>
@property (weak, nonatomic) IBOutlet UILabel *header1Label;
@property (weak, nonatomic) IBOutlet UILabel *header2Label;

@property (nonatomic,weak)IBOutlet UITextField * emailTextField;
@property (nonatomic,weak)IBOutlet UILabel * errorMessageLabel;
@property (weak, nonatomic) IBOutlet UIButton *submitButton;
@end

@implementation ForgotPasswordViewController
@synthesize emailTextField = _emailTextField;
@synthesize errorMessageLabel = _errorMessageLabel;

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    
    self.customAlert = [[CustomAlertView alloc]initWithNibName:@"CustomAlertView" bundle:nil];
    [self.customAlert setSingleButton:YES];
    self.customAlert.delegate = self;

    _errorMessageLabel.hidden = YES;
    
    
    [_emailTextField becomeFirstResponder];
    // Do any additional setup after loading the view.
    
    [self.navigationController.navigationBar setBarTintColor:[UIColor blackColor]];
    [self localizeUI];
}

- (void)localizeUI {
    self.header1Label.text = DFLocalizedString(@"view.forgot_pass.header1", nil);
    self.header2Label.text = DFLocalizedString(@"view.forgot_pass.header2", nil);
    self.emailTextField.placeholder = DFLocalizedString(@"view.forgot_pass.input.email.placeholder", nil);
    [self.submitButton setTitle:DFLocalizedString(@"view.forgot_pass.button.submit", nil) forState:UIControlStateNormal];
}
/*
-(BOOL)prefersStatusBarHidden{
    return YES;
}*/


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (BOOL)validateEmailWithString:(NSString*)email
{
    NSString *emailRegex = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}";
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
    return [emailTest evaluateWithObject:email];
}
-(void)cacellButtonTapped{
    
}

-(void)okayButtonTapped{
    
}


-(IBAction)recoverPassword:(id)sender{

    [_emailTextField resignFirstResponder];
    if ([_emailTextField.text isEqualToString:@""] ) {
        
        NSString *errorMessage = DFLocalizedString(@"view.forgot_pass.error.empty_fields", nil);
        
        _errorMessageLabel.text = errorMessage;
        [_customAlert showAlertWithMessage:errorMessage inView:self.view withTag:0];
        
        return;
    }
    else if(![self validateEmailWithString:_emailTextField.text]){
        NSString *errorMessage = DFLocalizedString(@"view.forgot_pass.error.invalid_email", nil);
        
        _errorMessageLabel.text = errorMessage;
        [_customAlert showAlertWithMessage:errorMessage inView:self.view withTag:0];
        
        return;
        
    }
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    NSString * email = [NSString stringWithString:_emailTextField.text];
    parameters[@"Email"] = email;
    
    
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];

    defwself
    
    [DFClient makeRequest:APIPathForgotPassword
                   method:kPOST
                   params:@{@"Email" : email}
                  success:^(NSDictionary *response, id result) {
                      defsself
                      NSString *alertMessage = DFLocalizedString(@"view.forgot_pass.alert.success", nil);
                      _errorMessageLabel.textColor = [UIColor greenColor];
                      _errorMessageLabel.text = alertMessage;
                      
                      [_customAlert showAlertWithMessage:alertMessage inView:sself.view withTag:0];
                      
                      [MBProgressHUD hideHUDForView:sself.view animated:YES];
                      
                      [sself performSelector:@selector(cancelThis:) withObject:nil afterDelay:2];
                  }
                  failure:^(NSError *error) {
                      
                      defsself
                      NSString *errorMessage = DFLocalizedString(@"view.forgot_pass.alert.failure", nil);
                      _errorMessageLabel.text = errorMessage;
                      
                      [_customAlert showAlertWithMessage:errorMessage inView:sself.view withTag:0];
                      
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


-(IBAction)cancelThis:(id)sender{
    [self dismissViewControllerAnimated:YES completion:nil];
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
