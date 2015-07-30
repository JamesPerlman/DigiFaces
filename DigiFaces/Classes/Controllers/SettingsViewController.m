//
//  SettingsViewController.m
//  DigiFaces
//
//  Created by Apple on 17/06/2015.
//  Copyright (c) 2015 Usasha studio. All rights reserved.
//

#import "SettingsViewController.h"
#import "MBProgressHUD.h"
#import "AFNetworking.h"
#import "UIImageView+AFNetworking.h"


@interface SettingsViewController ()

@end

@implementation SettingsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return 5;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if(indexPath.row == 0){
        [self performSegueWithIdentifier: @"ToProfile" sender: self];
    }
    else if (indexPath.row == 1){
        [self performSegueWithIdentifier:@"emailTecSupportSegue" sender:self];
    }
    else if (indexPath.row == 2){
        [self performSegueWithIdentifier:@"emailModeratorSegue" sender:self];
    }
    else if (indexPath.row == 3){
        [self performSegueWithIdentifier:@"aboutDigiFacesSegue" sender:self];
    }
    else if (indexPath.row == 4){
        //[self performSegueWithIdentifier:@"versionSegue" sender:self];
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    UITableViewCell * cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    
    if (indexPath.row == 0) {
        cell.textLabel.text = NSLocalizedString(@"MY cell", @"MY PROFILE") ;
    }
    else if (indexPath.row == 1){
        cell.textLabel.text = NSLocalizedString(@"EmailTech cell", @"EMAIL TECH SUPPORT") ;
    }
    else if (indexPath.row == 2){
        cell.textLabel.text = NSLocalizedString(@"Email cell", @"EMAIL THE MODERATOR");
    }
    else if(indexPath.row ==3){
        cell.textLabel.text = NSLocalizedString(@"ABOUT cell", @"ABOUT DIGIFACES") ;
        
    }
    
    else if(indexPath.row ==4){
        cell.textLabel.text = NSLocalizedString(@"VERSION cell", @"VERSION 1.0") ;
        
    }
    
    
    return cell;
}

-(IBAction)gotoback:(id)sender{
    [self.navigationController popViewControllerAnimated:YES];
}

-(IBAction)logout:(id)sender{
    
    
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    defwself
    [DFClient logoutWithSuccess:^(NSDictionary *response, id result) {
        defsself
        
        [MBProgressHUD hideHUDForView:sself.view animated:YES];
        [sself performSegueWithIdentifier:@"logoutSegue" sender:sself];
        
    } failure:^(NSError *error) {
        defsself
        [MBProgressHUD hideHUDForView:sself.view animated:YES];
    }];
    
    
    
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
