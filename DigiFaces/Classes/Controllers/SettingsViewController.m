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

@property (nonatomic, strong) NSArray *topics;

@end

@implementation SettingsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    canEmailMod = [LS.myUserPermissions canEmailMods];
    // Do any additional setup after loading the view.
    [self localizeUI];
}

- (void)localizeUI {
    self.navigationItem.title = DFLocalizedString(@"view.settings.navbar.title", nil);
    [self.logoutButton setTitle:DFLocalizedString(@"view.settings.button.log_out", nil) forState:UIControlStateNormal];
}

- (NSArray*)topics {
    if (!_topics) {
        _topics = @[
                    /*@{@"name" : @"view.settings.button.profile",
                      @"id" : kDFMyProfileVCID},*/
                    @{@"name" : @"view.settings.button.email_support",
                      @"id" : kDFEmailTechSupportVCID},
                    @{@"name" : @"view.settings.button.email_mod",
                      @"id" : kDFEmailModeratorVCID},
                    @{@"name" : @"view.settings.button.about",
                      @"id" : kDFAboutDFVCID},
                    @{@"name" : @"view.settings.button.version",
                      @"id" : kDFVersionVCID}
                    ];
    }
    return _topics;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return [self.topics count];
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    NSString *vcID = self.topics[indexPath.row][@"id"];
    if (vcID != kDFVersionVCID) {
        [self goToVC:vcID];
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    UITableViewCell * cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    
    NSString *localizedName = DFLocalizedString(self.topics[indexPath.row][@"name"], nil);
    NSString *vcID = self.topics[indexPath.row][@"id"];
    // special case for the version cell
    if (vcID == kDFVersionVCID) {
        NSString *version = [[NSBundle mainBundle] objectForInfoDictionaryKey: @"CFBundleShortVersionString"];
        cell.textLabel.text = [NSString stringWithFormat:@"%@ %@",localizedName, version];
        cell.accessoryType = UITableViewCellAccessoryNone;
    } else {
        cell.textLabel.text = DFLocalizedString(localizedName, nil);
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }
    
    // if the user is a mod, or the user can't email the mod, gray out the Email Moderator option
    if (vcID == kDFEmailModeratorVCID
        && (!canEmailMod || [LS.myUserInfo.isModerator boolValue])) {
        cell.textLabel.textColor = [UIColor lightGrayColor];
    }
    
    return cell;
}

- (BOOL)tableView:(UITableView *)tableView shouldHighlightRowAtIndexPath:(NSIndexPath *)indexPath {
    NSString *vcID = self.topics[indexPath.row][@"id"];
    if (vcID == kDFVersionVCID || (vcID == kDFEmailModeratorVCID && !canEmailMod)) {
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
    [self.delegate setViewControllerWithID:VCID];
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
