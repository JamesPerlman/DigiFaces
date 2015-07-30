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
    
    [_aboutLabel setFrame:CGRectMake(0, 0, _scrollView.frame.size.width, _scrollView.frame.size.height)];
    
    [self fetchAboutDigifacesText];
    
}


-(void)fetchAboutDigifacesText
{
    [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
    
    [DFClient makeRequest:APIPathGetAbout method:kGET urlParams:@{@"languageCode" : @"en"} bodyParams:nil success:^(NSDictionary *response, About *result) {
        [MBProgressHUD hideHUDForView:self.navigationController.view animated:YES];
        [_aboutLabel setFrame:CGRectMake(10, 0, _scrollView.frame.size.width - 20, _scrollView.frame.size.height)];
        [_aboutLabel setText:result.aboutText];
        [_scrollView setContentSize:_aboutLabel.optimumSize];
    } failure:^(NSError *error) {
        [MBProgressHUD hideHUDForView:self.navigationController.view animated:YES];
    }];
    
}


- (IBAction)closeThis:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}
@end
