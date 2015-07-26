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
#import "UserViewController.h"

@interface LoginTableController() <PopUpDelegate, MessageToViewMain>

@end

@implementation LoginTableController

-(void)viewDidLoad
{
    [super viewDidLoad];
    [self.navigationController setNavigationBarHidden:YES];
    
    self.customAlert = [[CustomAlertView alloc]initWithNibName:@"CustomAlertView" bundle:nil];
    [self.customAlert setSingleButton:YES];
    self.customAlert.delegate = self;
    _errorMessage.hidden = YES;
    
    UIView *paddingView1 = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 10, 20)];
    UIView *paddingView2 = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 10, 20)];
    
    _email.leftView = paddingView1;
    _email.leftViewMode = UITextFieldViewModeAlways;
    
    _password.leftView = paddingView2;
    _password.leftViewMode = UITextFieldViewModeAlways;
    
}

-(BOOL)prefersStatusBarHidden{
    return YES;
}

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
    
    NSString * username = [NSString stringWithString:_email.text ];//@"xxshabanaxx@focusforums.net";
    parameters[@"grant_type"] = @"password";
    parameters[@"username"] = username;// [username stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLHostAllowedCharacterSet]];
    parameters[@"password"] = [NSString stringWithString:_password.text ];
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    AFHTTPRequestSerializer *requestSerializer = [AFHTTPRequestSerializer serializer];
    [requestSerializer setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
    //      [requestSerializer setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    manager.requestSerializer = requestSerializer;
    
    [manager POST:@"http://digifacesservices.focusforums.com/Token" parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"JSON: %@", responseObject);
        [[NSUserDefaults standardUserDefaults]setObject:[responseObject objectForKey:@"access_token"] forKey:@"access_token"];
        [[NSUserDefaults standardUserDefaults]synchronize];
        
        [self check_username_existence];
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Error: %@", error);
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        
        self.customAlert.fromW = @"login";
        [self.customAlert showAlertWithMessage:@"Login failed, please enter correct credentials" inView:self.view withTag:0];
        
        _errorMessage.text = @"Login failed, please enter correct credentials";
        
    }];
}

-(void)check_username_existence{
    
    NSString * onlinekey = [[NSUserDefaults standardUserDefaults]objectForKey:@"access_token"];
    
    NSString *finalyToken = [[NSString alloc]initWithFormat:@"Bearer %@",onlinekey ];
    
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    AFHTTPRequestSerializer *requestSerializer = [AFHTTPRequestSerializer serializer];
    
    [requestSerializer setValue:finalyToken forHTTPHeaderField:@"Authorization"];
    [requestSerializer setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
    
    
    
    manager.requestSerializer = requestSerializer;
    
    
    [manager GET:@"http://digifacesservices.focusforums.com/api/Account/UserInfo" parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"JSON: %@", responseObject);
        
        NSString * usernameFetched = [responseObject objectForKey:@"AppUserName"];
        Boolean  IsUserNameSet= (Boolean)[responseObject objectForKey:@"IsUserNameSet"];
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        
        if (IsUserNameSet) {
            [[NSUserDefaults standardUserDefaults]setObject:usernameFetched forKey:@"userName"];
            [[NSUserDefaults standardUserDefaults]synchronize];
            //             [self moveToUserNameScreen];
            
            [self moveToHomeScreen];
        }
        else{
            [self moveToUserNameScreen];
            
        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Error: %@", error);
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        
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
    [_email resignFirstResponder];
    [_password resignFirstResponder];
}

@end
