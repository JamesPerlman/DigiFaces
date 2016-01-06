//
//  TechSupportController.m
//  DigiFaces
//
//  Created by confiz on 21/06/2015.
//  Copyright (c) 2015 Usasha studio. All rights reserved.
//

#import "TechSupportController.h"

#import "Utility.h"
#import "MBProgressHUD.h"

#define kSuccessTag 2
#define kDiscardTag 1
@interface TechSupportController ()

@property (weak, nonatomic) IBOutlet UITextField *txtSubject;

@property (weak, nonatomic) IBOutlet UITextView *textArea;
@property (weak, nonatomic) IBOutlet UILabel *lblPlaceholder;

@end

@implementation TechSupportController

-(void)viewDidLoad
{
    [super viewDidLoad];
    alertView = [[CustomAlertView alloc] initWithNibName:@"CustomAlertView" bundle:nil];
    [alertView setSingleButton:YES];
    alertView.delegate = self;
    [self.txtSubject becomeFirstResponder];
    [self localizeUI];
}

- (void)localizeUI {
    self.navigationItem.title = DFLocalizedString(@"view.email_support.navbar.title", nil);
    self.lblPlaceholder.text = DFLocalizedString(@"view.email_support.input.message.placeholder", nil);
    self.txtSubject.placeholder = DFLocalizedString(@"view.email_support.input.subject.placeholder", nil);
}

- (UIBarButtonItem*)rightBarButtonItem {
    return [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"check-white-30px"] style:UIBarButtonItemStylePlain target:self action:@selector(send:)];
}

- (IBAction)cancelThis:(id)sender {
    if (![_textArea.text isEqualToString:@""]) {
        [self resignAllResponder];
        [alertView setSingleButton:NO];
        [alertView showAlertWithMessage:DFLocalizedString(@"view.email_support.alert.confirm_discard", nil) inView:self.navigationController.view withTag:kDiscardTag];
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
        [alertView showAlertWithMessage:DFLocalizedString(@"view.email_support.error.empty_message", nil) inView:self.navigationController.view withTag:0];
        return;
    }
    else if ([_txtSubject.text isEqualToString:@""]){
        [self resignAllResponder];
        [alertView setSingleButton:YES];
        [alertView showAlertWithMessage:DFLocalizedString(@"view.email_support.error.empty_subject", nil) inView:self.navigationController.view withTag:0];
        return;
    }
    
    [_textArea resignFirstResponder];
    [_txtSubject resignFirstResponder];

    defwself
    
    NSDictionary * params = @{@"SenderEmail" : LS.myUserInfo.email,
                              @"Subject" : _txtSubject.text,
                              @"Message" : _textArea.text};
    
    [DFClient makeRequest:APIPathSendHelpMessage
                   method:kPOST
                   params:params
                  success:^(NSDictionary *response, id result) {
                      defsself
                      [MBProgressHUD hideHUDForView:sself.navigationController.view animated:YES];
                      [alertView setSingleButton:YES];
                      [alertView showAlertWithMessage:DFLocalizedString(@"view.email_support.alert.success", nil) inView:sself.navigationController.view withTag:kSuccessTag];
                  }
                  failure:^(NSError *error) {
                      defsself
                      [alertView showAlertWithMessage:DFLocalizedString(@"view.email_support.alert.failure", nil) inView:sself.navigationController.view withTag:0];
                      [MBProgressHUD hideHUDForView:sself.navigationController.view animated:YES];
                  }];
       [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
    
}


#pragma mark - Popup dlegate
-(void)cancelButtonTappedWithTag:(NSInteger)tag
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
