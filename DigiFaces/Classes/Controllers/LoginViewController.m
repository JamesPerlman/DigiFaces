//
//  ViewController.m
//  DigiFaces
//
//  Created by Apple on 02/06/2015.
//  Copyright (c) 2015 Usasha studio. All rights reserved.
//

#import "LoginViewController.h"
#import "UserViewController.h"
#import "MBProgressHUD.h"
@interface LoginViewController ()
{
    CGRect previousFrame;
}
@end

@implementation LoginViewController
@synthesize email = _email;
@synthesize password = _password;
@synthesize errorMessage = _errorMessage;

-(void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)viewDidLoad {
    [super viewDidLoad];

    
    self.customAlert = [[CustomAlertView alloc]initWithNibName:@"CustomAlertView" bundle:nil];
    self.customAlert.delegate = self;
    _errorMessage.hidden = YES;
    
    UIView *paddingView1 = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 10, 20)];
    UIView *paddingView2 = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 10, 20)];

    _email.leftView = paddingView1;
    _email.leftViewMode = UITextFieldViewModeAlways;

    _password.leftView = paddingView2;
    _password.leftViewMode = UITextFieldViewModeAlways;
    previousFrame = self.view.frame;
    
    // Do any additional setup after loading the view, typically from a nib.
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillAppear:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:self];
}

-(void)keyboardWillAppear:(NSNotification*)notification
{
    NSDictionary *info = [notification userInfo];
    CGSize kbSize = [[info objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue].size;
    
    CGRect rect = previousFrame;
    rect.origin.y -= kbSize.height;
    [self.view setFrame:rect];
}

-(void)keyboardWillHide:(NSNotification*)notification
{
    NSDictionary *info = [notification userInfo];
    CGSize kbSize = [[info objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue].size;
   
    CGRect rect = previousFrame;
    rect.origin.y += kbSize.height;
    [self.view setFrame:rect];
}


-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES];
}

-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
//    [self.navigationController setNavigationBarHidden:NO];
}

-(void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    [self.navigationController setNavigationBarHidden:NO];
}

-(void)cacellButtonTapped{
    
}

-(void)okayButtonTapped{
    
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



-(IBAction)signInPressed:(id)sender{


    [_email resignFirstResponder];
    [_password resignFirstResponder];
    
    if ([_email.text isEqualToString:@""] || [_password.text isEqualToString:@""] ) {
        
        _errorMessage.text = @"Fields can't be empty";
        
        self.customAlert.fromW = @"login";
        
        [self.customAlert showAlertWithMessage:@"Fields can't be empty" inView:self.view withTag:0];
        
        
        return;
    }
    else if(![self validateEmailWithString:_email.text]){
        _errorMessage.text = @"Enter a valid email address";
        self.customAlert.fromW = @"login";
        [self.customAlert showAlertWithMessage:@"Enter a valid email address" inView:self.view withTag:0];
        
        return;

    }
    
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];


    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    
    NSString * username = [NSString stringWithString:_email.text ];
    
    NSString * password = [NSString stringWithString:_password.text];
    
    defwself
    [DFClient loginWithUsername:username
                       password:password
                        success:^(NSDictionary *response, id result) {
                            defsself
                            [sself check_username_existence];
                        }
                        failure:^(NSError *error) {
                            defsself
                            [MBProgressHUD hideHUDForView:sself.view animated:YES];
                            
                            sself.customAlert.fromW = @"login";
                            [sself.customAlert showAlertWithMessage:@"Login failed.  Invalid username or password." inView:sself.view withTag:0];
                            _errorMessage.text = @"Login failed, please enter correct credentials";
                        }];
}

-(void)check_username_existence{
    defwself
    [DFClient makeRequest:APIPathGetUserInfo
                   method:kGET
               params:nil
                  success:^(NSDictionary *response, UserInfo *result) {
                        defsself
                      
                      NSString * usernameFetched = result.appUserName;
                      
                      [MBProgressHUD hideHUDForView:sself.view animated:YES];
                      
                      if (result.isUserNameSet.boolValue) {
                          [[NSUserDefaults standardUserDefaults]setObject:usernameFetched forKey:@"userName"];
                          [[NSUserDefaults standardUserDefaults]synchronize];
                          //             [self moveToUserNameScreen];
                          
                          [sself moveToHomeScreen];
                      }
                      else{
                          [sself moveToUserNameScreen];
                          
                      }

                  }
                  failure:^(NSError *error) {
                      defsself
                      [MBProgressHUD hideHUDForView:sself.view animated:YES];
                  }];}

-(BOOL)textFieldShouldReturn:(UITextField *)textField{
    [textField resignFirstResponder];

    return YES;
}

-(BOOL)textFieldShouldEndEditing:(UITextField *)textField{
    [textField resignFirstResponder];
    return YES;
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


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
