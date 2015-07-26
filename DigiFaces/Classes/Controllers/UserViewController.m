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

@interface UserViewController ()

@end

@implementation UserViewController
@synthesize errorMessage = _errorMessage;
- (void)viewDidLoad {
    [super viewDidLoad];
    UIView *paddingView1 = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 5, 20)];
    
        _errorMessage.hidden = YES;
    self.customAlert = [[CustomAlertView alloc]initWithNibName:@"CustomAlertView" bundle:nil];
    [self.customAlert setSingleButton:YES];
    self.customAlert.delegate = self;
    
    _username.leftView = paddingView1;
    _username.leftViewMode = UITextFieldViewModeAlways;
    
    [_username becomeFirstResponder];
    
    // Do any additional setup after loading the view from its nib.
}

-(BOOL)prefersStatusBarHidden{
    return YES;
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(IBAction)check_user_validation:(id)sender{
    
    NSCharacterSet *alphaSet = [NSCharacterSet alphanumericCharacterSet];
    BOOL valid = [[_username.text stringByTrimmingCharactersInSet:alphaSet] isEqualToString:@""];
    
    if ([_username.text isEqualToString:@""] ) {
        
        _errorMessage.text = @"Fields can't be empty";

        [self.customAlert showAlertWithMessage:@"Fields can't be empty" inView:self.view withTag:0];
        
        return;
    }
    else if([_username.text length]<6){
        [self.customAlert showAlertWithMessage:@"Username should be atleast 6 characters long" inView:self.view withTag:0];
        _errorMessage.text = @"Username should be atleast 6 characters long";
        return;

    }
    if (!valid) // found bad characters
    {
        [self.customAlert showAlertWithMessage:@"Special characters are not allowed" inView:self.view withTag:0];
        
        _errorMessage.text = @"Special characters are not allowed";
        return;
        
    }
    [self check_username_availability:_username.text];
    
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

    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    parameters[@"UserNameToCheck"] = username;
    NSString * onlinekey = [[NSUserDefaults standardUserDefaults]objectForKey:@"access_token"];

    NSString *finalyToken = [[NSString alloc]initWithFormat:@"Bearer %@",onlinekey ];

    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    AFHTTPRequestSerializer *requestSerializer = [AFHTTPRequestSerializer serializer];
    
    [requestSerializer setValue:finalyToken forHTTPHeaderField:@"Authorization"];
    [requestSerializer setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
    
    manager.requestSerializer = requestSerializer;
    
    [manager POST:@"http://digifacesservices.focusforums.com/api/Account/IsUserNameAvailable" parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"JSON: %@", responseObject);
        NSString * isAvailable =(NSString*) [responseObject objectForKey:@"IsAvailable"];
        if ([isAvailable boolValue] == YES) {
            [self set_username:username];
        }else{
            _errorMessage.text = @"User name already exists";
            [self.customAlert showAlertWithMessage:@"User name already exists" inView:self.view withTag:0];
            [MBProgressHUD hideHUDForView:self.view animated:YES];

        }
     

    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Error: %@", error);
        [MBProgressHUD hideHUDForView:self.view animated:YES];

    }];
    
}


- (void)set_username:(NSString*)username
{
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    parameters[@"NewUserName"] = username;
    NSString * onlinekey = [[NSUserDefaults standardUserDefaults]objectForKey:@"access_token"];
    
    NSString *finalyToken = [[NSString alloc]initWithFormat:@"Bearer %@",onlinekey ];
    
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    AFHTTPRequestSerializer *requestSerializer = [AFHTTPRequestSerializer serializer];
    
    [requestSerializer setValue:finalyToken forHTTPHeaderField:@"Authorization"];
    [requestSerializer setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
    
    manager.requestSerializer = requestSerializer;
    
    [manager POST:@"http://digifacesservices.focusforums.com/api/Account/SetUserName" parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"JSON: %@", responseObject);
        _errorMessage.textColor = [UIColor greenColor];
        _errorMessage.text = @"User name registered successfully";
        [MBProgressHUD hideHUDForView:self.view animated:YES];

        [[NSUserDefaults standardUserDefaults]setObject:username forKey:@"userName"];
        [[NSUserDefaults standardUserDefaults]synchronize];
        
        [self performSelector:@selector(cancelandpush) withObject:nil afterDelay:2];

        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Error: %@", error);
        _errorMessage.text = @"Server error, try again!";
        [MBProgressHUD hideHUDForView:self.view animated:YES];

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
