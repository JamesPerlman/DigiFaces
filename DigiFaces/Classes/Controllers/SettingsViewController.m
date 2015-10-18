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


@interface SettingsViewController () {
    BOOL canEmailMod;
}
@property (weak, nonatomic) IBOutlet UIButton *logoutButton;

@end

@implementation SettingsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    canEmailMod = [LS.myUserInfo canEmailMods];
    // Do any additional setup after loading the view.
}

- (void)localizeUI {
    [self.logoutButton setTitle:DFLocalizedString(@"view.settings.button.log_out", nil) forState:UIControlStateNormal];
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
    else if (indexPath.row == 2 && canEmailMod){
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
        cell.textLabel.text = DFLocalizedString(@"view.settings.button.profile", nil);
    }
    else if (indexPath.row == 1){
        cell.textLabel.text = DFLocalizedString(@"view.settings.button.email_support", nil);
    }
    else if (indexPath.row == 2){
        cell.textLabel.text = DFLocalizedString(@"view.settings.button.email_mod", nil);
        if (!canEmailMod) {
            cell.textLabel.textColor = [UIColor lightGrayColor];
        }
    }
    else if(indexPath.row ==3){
        cell.textLabel.text = DFLocalizedString(@"view.settings.button.about", nil);
        
    }
    
    else if(indexPath.row ==4){
        cell.textLabel.text = [NSString stringWithFormat:DFLocalizedString(@"view.settings.button.version", nil), [[NSBundle mainBundle] objectForInfoDictionaryKey: @"CFBundleShortVersionString"]];
        
    }
    
    
    return cell;
}

- (BOOL)tableView:(UITableView *)tableView shouldHighlightRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == 2 && !canEmailMod) {
        return false;
    } else return true;
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
