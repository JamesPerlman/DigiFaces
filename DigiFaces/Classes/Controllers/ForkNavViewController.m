//
//  ForkNavViewController.m
//  DigiFaces
//
//  Created by James on 8/4/15.
//  Copyright (c) 2015 INET360. All rights reserved.
//

#import "ForkNavViewController.h"
#import "MBProgressHUD.h"
#import "CustomAlertView.h"

@interface ForkNavViewController ()<PopUpDelegate> {
    CustomAlertView *customAlert;
}
@end

@implementation ForkNavViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    customAlert = [[CustomAlertView alloc]initWithNibName:@"CustomAlertView" bundle:nil];
    customAlert.delegate = self;
    [self tryAutoLogin];
}
- (void)tryAutoLogin {
    if (LS.loginUsername && LS.loginPassword) {
        defwself
        [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        [DFClient loginWithUsername:LS.loginUsername
                           password:LS.loginPassword
                            success:^(NSDictionary *response, id result) {
                                defsself
                                [sself moveToHomeScreen];
                                [MBProgressHUD hideHUDForView:sself.view animated:YES];
                            } failure:^(NSError *error) {
                                defsself
                                [MBProgressHUD hideHUDForView:sself.view animated:YES];
                                [customAlert showAlertWithMessage:NSLocalizedString(@"Login failed for some reason.  Try again?", nil) inView:sself.view withTag:0];
                            }];
    } else {
        [self performSegueWithIdentifier:@"toLogin" sender:nil];
    }
}
- (void)cacellButtonTappedWithTag:(NSInteger)tag {
    [self performSegueWithIdentifier:@"toLogin" sender:nil];
}

- (void)okayButtonTappedWithTag:(NSInteger)tag {
    [self tryAutoLogin];
}

-(void)check_username_existence{
    
    defwself
    
    [DFClient makeRequest:APIPathGetUserInfo method:kGET params:nil success:^(NSDictionary *response, UserInfo *userInfo) {
        defsself
        
        [MBProgressHUD hideHUDForView:sself.view animated:YES];
        
        LS.myUserInfo = userInfo;
        
        [sself moveToHomeScreen];
        /*
        if (userInfo.isUserNameSet.boolValue) {
         
         [sself moveToHomeScreen];
         } else {
            [sself moveToUserNameScreen];
        }*/
        
    } failure:^(NSError *error) {
        defsself
        [MBProgressHUD hideHUDForView:sself.view animated:YES];
    }];
}



-(void)moveToHomeScreen{
    
    [self performSegueWithIdentifier: @"toHome" sender: self];
}

@end
