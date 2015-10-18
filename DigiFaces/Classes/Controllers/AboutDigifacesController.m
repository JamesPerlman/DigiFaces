//
//  AboutDigifacesController.m
//  DigiFaces
//
//  Created by confiz on 21/06/2015.
//  Copyright (c) 2015 Usasha studio. All rights reserved.
//

#import "AboutDigifacesController.h"
#import "MBProgressHUD.h"
#import "Utility.h"
#import "About.h"
#import "NSString+HTML.h"

@implementation AboutDigifacesController

-(void)viewDidLoad
{
    [super viewDidLoad];
    
    
    [self fetchAboutDigifacesText];
    [self localizeUI];
}

- (void)localizeUI {
    self.navigationItem.title = DFLocalizedString(@"view.about_df.navbar.default_title", nil);
}


-(void)fetchAboutDigifacesText
{
    [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
    
    defwself
    [DFClient makeRequest:APIPathGetAbout method:kGET urlParams:@{@"languageCode" : @"en"} bodyParams:nil success:^(NSDictionary *response, About *result) {
        defsself
        [MBProgressHUD hideHUDForView:sself.navigationController.view animated:YES];
        [sself.webView loadHTMLString:result.aboutText baseURL:nil];
        if (result.aboutTitle.length) {
            sself.navigationItem.title = result.aboutTitle;
        }
    } failure:^(NSError *error) {
        defsself
        [MBProgressHUD hideHUDForView:sself.navigationController.view animated:YES];
    }];
    
}


- (IBAction)closeThis:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}
@end
