//
//  EmailModeratorController.m
//  DigiFaces
//
//  Created by confiz on 21/06/2015.
//  Copyright (c) 2015 Usasha studio. All rights reserved.
//

#import "EmailModeratorController.h"
#import "MBProgressHUD.h"

#import "Utility.h"

#define kSuccessTag 2

@implementation EmailModeratorController


-(void)viewDidLoad
{
    [super viewDidLoad];
    alertView = [[CustomAlertView alloc] initWithNibName:@"CustomAlertView" bundle:nil];
    alertView.delegate = self;
    [self.txtSubject becomeFirstResponder];
    [self localizeUI];
}

- (void)localizeUI {
    self.navigationItem.title = DFLocalizedString(@"view.email_mod.navbar.title", nil);
    self.txtSubject.placeholder = DFLocalizedString(@"view.email_mod.input.subject.placeholder", nil);
    self.lblPlaceholder.text = DFLocalizedString(@"view.email_mod.input.message.placeholder", nil);
}

- (IBAction)cancelThis:(id)sender {
    if (![_textview.text isEqualToString:@""]) {
        [_textview resignFirstResponder];
        [alertView setSingleButton:NO];
        [alertView showAlertWithMessage:DFLocalizedString(@"view.email_mod.alert.confirm_discard", nil) inView:self.navigationController.view withTag:0];
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
        [alertView showAlertWithMessage:DFLocalizedString(@"view.email_mod.error.empty_message", nil) inView:self.navigationController.view withTag:0];
        return;
    }
    else if ([_txtSubject.text isEqualToString:@""]){
        [self resignAllResponder];
        [alertView setSingleButton:YES];
        [alertView showAlertWithMessage:DFLocalizedString(@"view.email_mod.error.empty_subject", nil) inView:self.navigationController.view withTag:0];
        return;
    }
    
    
    [self resignAllResponder];
    
    defwself
    
    [DFClient makeRequest:APIPathSendMessageToModerator
                   method:kPOST
                urlParams:@{
                            @"projectId" : [Utility getStringForKey:kCurrentPorjectID],
                            @"parentMessageId" : @0
                            }
               bodyParams:@{
                            @"Subject" : _txtSubject.text,
                            @"Response" : _textview.text
                            }
                  success:^(NSDictionary *response, id result) {
                      defsself
                      [MBProgressHUD hideHUDForView:sself.navigationController.view animated:YES];
                      [alertView setSingleButton:YES];
                      [alertView showAlertWithMessage:DFLocalizedString(@"view.email_mod.alert.success", nil) inView:sself.navigationController.view withTag:kSuccessTag];
                  }
                  failure:^(NSError *error) {
                      defsself
                      [alertView showAlertWithMessage:DFLocalizedString(@"view.email_mod.alert.failure", nil) inView:sself.navigationController.view withTag:0];
                      [MBProgressHUD hideHUDForView:sself.navigationController.view animated:YES];
                  }];
    
    [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
    
}

#pragma mark - Popup dlegate
-(void)cancelButtonTappedWithTag:(NSInteger)tag
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

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [_txtSubject becomeFirstResponder];
    return YES;
}

@end
