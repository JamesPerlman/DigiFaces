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

static NSString * const kDFAboutDFVCID = @"AboutDigiFacesViewController";
static NSString * const kDFEmailTechSupportVCID = @"EmailTechSupportViewController";
static NSString * const kDFEmailModeratorVCID = @"EmailModeratorViewController";
static NSString * const kDFVersionVCID = @"VersionViewController";
static NSString * const kDFMyProfileVCID = @"MyProfileViewController";

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
    [self localizeUI];
}

- (void)localizeUI {
    self.navigationItem.title = DFLocalizedString(@"view.settings.navbar.title", nil);
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
        //[self performSegue:@"ToProfile"];
        [self goToVC:kDFMyProfileVCID];
    }
    else if (indexPath.row == 1){
        
        //[self performSegue:@"emailTecSupportSegue"];
        [self goToVC:kDFEmailTechSupportVCID];
    }
    else if (indexPath.row == 2 && canEmailMod){
        
        //[self performSegue:@"emailModeratorSegue"];
        [self goToVC:kDFEmailModeratorVCID];
    }
    else if (indexPath.row == 3){
        //[self performSegue:@"aboutDigiFacesSegue"];
        [self goToVC:kDFAboutDFVCID];
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
        if (!canEmailMod || [LS.myUserInfo.isModerator boolValue]) {
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
        [sself.delegate performSegueWithIdentifier:@"logoutSegue" sender:sself];
        [sself.delegate hideHelpPopover];
        
    } failure:^(NSError *error) {
        defsself
        [MBProgressHUD hideHUDForView:sself.view animated:YES];
    }];
    
    
    
}

- (BOOL)shouldPerformSegueWithIdentifier:(NSString *)identifier sender:(id)sender {
    return NO; // no segues.  Let delegate take care of them in -prepareForSegue
}
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    UIViewController *destVC = [segue destinationViewController];
    [self.delegate setViewController:destVC animated:YES];
}

- (void)performSegue:(NSString*)segueID {
    [self performSegueWithIdentifier:segueID sender:self];
}

- (void)goToVC:(NSString*)VCID {
    id vc = [[self storyboard] instantiateViewControllerWithIdentifier:VCID];
    [self.delegate setViewController:vc animated:YES];
    [self.delegate hideHelpPopover];
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
