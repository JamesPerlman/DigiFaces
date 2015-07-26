//
//  EmailModeratorController.m
//  DigiFaces
//
//  Created by confiz on 21/06/2015.
//  Copyright (c) 2015 Usasha studio. All rights reserved.
//

#import "EmailModeratorController.h"
#import "MBProgressHUD.h"
#import "SDConstants.h"
#import "Utility.h"
#import "AFHTTPRequestOperationManager.h"

#define kSuccessTag 2

@implementation EmailModeratorController


-(void)viewDidLoad
{
    [super viewDidLoad];
    alertView = [[CustomAlertView alloc] initWithNibName:@"CustomAlertView" bundle:nil];
    alertView.delegate = self;
    [_textview becomeFirstResponder];
}

- (IBAction)cancelThis:(id)sender {
    if (![_textview.text isEqualToString:@""] && ![_textview.text isEqualToString:@"Some Text to Post"]) {
        [_textview resignFirstResponder];
        [alertView setSingleButton:NO];
        [alertView showAlertWithMessage:@"Your changes will be discarded. Do you want to cancel it?" inView:self.navigationController.view withTag:0];
    }
    else{
        [_txtSubject resignFirstResponder];
        [_textview resignFirstResponder];
        [self dismissViewControllerAnimated:YES completion:nil];
    }
}

-(void)resignAllResponder
{
    [_txtSubject resignFirstResponder];
    [_textview resignFirstResponder];
}
- (IBAction)sendEmail:(id)sender {
    if ([_textview.text isEqualToString:@""]) {
        [self resignAllResponder];
        [alertView setSingleButton:YES];
        [alertView showAlertWithMessage:@"Subject and message are required." inView:self.navigationController.view withTag:0];
        return;
    }
    else if ([_txtSubject.text isEqualToString:@""]){
        [self resignAllResponder];
        [alertView setSingleButton:YES];
        [alertView showAlertWithMessage:@"Subject and message are required." inView:self.navigationController.view withTag:0];
        return;
    }
    
    [self resignAllResponder];
    NSString * url = [NSString stringWithFormat:@"%@%@", kBaseURL, kModeratorMessage];
    url = [url stringByReplacingOccurrencesOfString:@"{projectId}" withString:[Utility getStringForKey:kCurrentPorjectID]];
    url = [url stringByReplacingOccurrencesOfString:@"{parentMessageId}" withString:@"0"];
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    AFHTTPRequestSerializer *requestSerializer = [AFHTTPRequestSerializer serializer];
    
    [requestSerializer setValue:[Utility getAuthToken] forHTTPHeaderField:@"Authorization"];
    [requestSerializer setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
    
    manager.requestSerializer = requestSerializer;
    
    NSDictionary * parameters = [NSDictionary dictionaryWithObjectsAndKeys:_txtSubject.text, @"Subject", _textview.text, @"Response", nil];
    
    [manager POST:url parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        [MBProgressHUD hideHUDForView:self.navigationController.view animated:YES];
        [alertView setSingleButton:YES];
        [alertView showAlertWithMessage:@"Your message posted successfully" inView:self.navigationController.view withTag:kSuccessTag];
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Error: %@", error);
        [MBProgressHUD hideHUDForView:self.navigationController.view animated:YES];
    }];
    
    [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
    
}

#pragma mark - Popup dlegate
-(void)cacellButtonTappedWithTag:(NSInteger)tag
{
    
}

-(void)okayButtonTappedWithTag:(NSInteger)tag
{
    //if (tag == kSuccessTag) {
        [self dismissViewControllerAnimated:YES completion:nil];
    //}
}

-(void)textViewDidChange:(UITextView *)textView
{
    if ([textView.text isEqualToString:@""]) {
        [_lblPlaceholder setHidden:NO];
    }
    else{
        [_lblPlaceholder setHidden:YES];
    }
}

@end
