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

@end

@implementation ForgotPasswordViewController
@synthesize email = _email;
@synthesize errorMessage = _errorMessage;

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    
    self.customAlert = [[CustomAlertView alloc]initWithNibName:@"CustomAlertView" bundle:nil];
    [self.customAlert setSingleButton:YES];
    self.customAlert.delegate = self;

    _errorMessage.hidden = YES;
    
    
    [_email becomeFirstResponder];
    // Do any additional setup after loading the view.
    
    [self.navigationController.navigationBar setBarTintColor:[UIColor blackColor]];
}
-(BOOL)prefersStatusBarHidden{
    return YES;
}


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

    [_email resignFirstResponder];
    if ([_email.text isEqualToString:@""] ) {
        
        _errorMessage.text = @"Fields can't be empty";
        [_customAlert showAlertWithMessage:@"Fields can't be empty" inView:self.view withTag:0];
        
        return;
    }
    else if(![self validateEmailWithString:_email.text]){
        
        _errorMessage.text = @"Enter a valid email address";
        [_customAlert showAlertWithMessage:@"Enter a valid email address" inView:self.view withTag:0];
        
        return;
        
    }
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    NSString * email = [NSString stringWithString:_email.text];
    parameters[@"Email"] = email;
    
    
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];

    defwself
    
    [DFClient makeRequest:APIPathForgotPassword
                   method:kPOST
                   params:@{@"Email" : email}
                  success:^(NSDictionary *response, id result) {
                      defsself
                      _errorMessage.textColor = [UIColor greenColor];
                      _errorMessage.text = @"Please check your inbox, password sent";
                      
                      [_customAlert showAlertWithMessage:@"Please check your inbox, password sent" inView:sself.view withTag:0];
                      
                      [MBProgressHUD hideHUDForView:sself.view animated:YES];
                      
                      [sself performSelector:@selector(cancelThis:) withObject:nil afterDelay:2];
                  }
                  failure:^(NSError *error) {
                      
                      defsself
                      
                      _errorMessage.text = @"An error in request, verify that your email is correct";
                      
                      [_customAlert showAlertWithMessage:@"An error in request, verify that your email is correct" inView:sself.view withTag:0];
                      
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
