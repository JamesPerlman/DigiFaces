//
//  TechSupportController.m
//  DigiFaces
//
//  Created by confiz on 21/06/2015.
//  Copyright (c) 2015 Usasha studio. All rights reserved.
//

#import "TechSupportController.h"
#import "SDConstants.h"
#import "AFHTTPRequestOperationManager.h"
#import "Utility.h"
#import "MBProgressHUD.h"

#define kSuccessTag 2
#define kDiscardTag 1

@implementation TechSupportController

-(void)viewDidLoad
{
    [super viewDidLoad];
    alertView = [[CustomAlertView alloc] initWithNibName:@"CustomAlertView" bundle:nil];
    [alertView setSingleButton:YES];
    alertView.delegate = self;
    [_textArea becomeFirstResponder];
}

- (IBAction)cancelThis:(id)sender {
    if (![_textArea.text isEqualToString:@""] && ![_textArea.text isEqualToString:@"Some Text to Post"]) {
        [self resignAllResponder];
        [alertView setSingleButton:NO];
        [alertView showAlertWithMessage:@"Your changes will be discarded. Do you want to cancel it?" inView:self.navigationController.view withTag:kDiscardTag];
    }
    else{
        [_txtSubject resignFirstResponder];
        [_textArea resignFirstResponder];
        [self dismissViewControllerAnimated:YES completion:nil];
    }
}

-(void)resignAllResponder
{
    [_txtSubject resignFirstResponder];
    [_textArea resignFirstResponder];
}
- (IBAction)send:(id)sender {
    
    if ([_textArea.text isEqualToString:@""]) {
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
    
    [_textArea resignFirstResponder];
    [_txtSubject resignFirstResponder];
    NSString * url = [NSString stringWithFormat:@"%@%@", kBaseURL, kSendHelpMessage];
    
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    AFHTTPRequestSerializer *requestSerializer = [AFHTTPRequestSerializer serializer];
    
    [requestSerializer setValue:[Utility getAuthToken] forHTTPHeaderField:@"Authorization"];
    [requestSerializer setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
    
    manager.requestSerializer = requestSerializer;
    
    NSDictionary * parameters = [NSDictionary dictionaryWithObjectsAndKeys:[Utility getStringForKey:kEmail], @"SenderEmail",_txtSubject.text, @"Subject", _textArea.text, @"Message", nil];
    
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
    if (tag == kSuccessTag) {
        [self dismissViewControllerAnimated:YES completion:nil];
    }
}

-(void)okayButtonTappedWithTag:(NSInteger)tag
{
    if (tag== kSuccessTag || tag == kDiscardTag) {
        [self dismissViewControllerAnimated:YES completion:nil];
    }
    
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
