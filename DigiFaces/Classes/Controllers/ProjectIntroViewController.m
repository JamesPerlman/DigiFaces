//
//  ProjectIntroViewController.m
//  DigiFaces
//
//  Created by confiz on 20/06/2015.
//  Copyright (c) 2015 Usasha studio. All rights reserved.
//

#import "ProjectIntroViewController.h"

#import "Utility.h"
#import "MBProgressHUD.h"
#import "File.h"
#import "ImageCell.h"
#import <SDWebImage/UIImageView+WebCache.h>
#import "NSString+HTML.h"
#import "WebViewController.h"
#import "VideoCell.h"
#import "RTCell.h"
#import <MediaPlayer/MediaPlayer.h>
#import "NSLayoutConstraint+ConvenienceMethods.h"
#import "APIHomeAnnouncementResponse.h"
#import "Announcement.h"
#import "UILabel+setHTML.h"

@interface ProjectIntroViewController ()
{
}
@property (nonatomic, strong) RTCell *introCell;
@property (nonatomic, retain) NSMutableArray * dataAray;
@property (nonatomic, strong) NSMutableArray * heightArray;
@property (nonatomic, strong) APIHomeAnnouncementResponse *homeAnnouncement;
@end

@implementation ProjectIntroViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    _dataAray = [[NSMutableArray alloc] init];
    self.heightArray = [[NSMutableArray alloc] init];
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    if (!self.announcement) {
        [self fetchProjectAnnouncements:LS.myUserInfo.currentProjectId];
    } else {
        [self generateDataArraysFromAnnouncement:self.announcement];
    }
    [self localizeUI];
}

- (void)localizeUI {
    self.navigationItem.title = DFLocalizedString(@"view.proj_intro.navbar.title", nil);
}

-(void)fetchProjectAnnouncements:(NSNumber*)projectId
{
    [_dataAray removeAllObjects];
    [_heightArray removeAllObjects];
    defwself
    [DFClient makeRequest:APIPathGetHomeAnnouncement
                   method:kGET
                urlParams:@{@"projectId" : projectId}
               bodyParams:nil
                  success:^(NSDictionary *response, APIHomeAnnouncementResponse *result) {
                      defsself
                      
                      [MBProgressHUD hideHUDForView:sself.navigationController.view animated:YES];
                      sself.homeAnnouncement = result;
                      [sself generateDataArraysFromAnnouncement:result];
                  }
                  failure:^(NSError *error) {
                      defsself
                      [MBProgressHUD hideHUDForView:sself.navigationController.view animated:YES];
                  }];
    
    [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
}

- (void)generateDataArraysFromAnnouncement:(id)announcement {
    
    [self.dataAray removeAllObjects];
    if ([announcement respondsToSelector:@selector(file)]) {
        if ([announcement file]) {
            [self.dataAray addObject:[announcement file]];
            [self.heightArray addObject:@170];
        }
    } else if ([announcement respondsToSelector:@selector(files)]) {
        if ([[announcement files] count]) {
            [self.dataAray addObject:[[announcement files] anyObject]];
            [self.heightArray addObject:@170];
        }
    }
    if ([announcement title]) {
        [self.dataAray addObject:[announcement title]];
        RTCell *cell = [self.tableView dequeueReusableCellWithIdentifier:@"textCell"];
        [cell setText:[announcement title]];
        [self.heightArray addObject:@(cell.fullHeight)];
    }
    if ([announcement text]) {
        [self.dataAray addObject:[announcement text]];
        
        RTCell *cell = [self.tableView dequeueReusableCellWithIdentifier:@"textCell"];
        [cell setText:[announcement text]];
        [self.heightArray addObject:@(cell.fullHeight)];
    }
    
    [self.tableView reloadData];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    return 1;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return [self.heightArray[indexPath.row] floatValue];
    /*
     if (indexPath.row == 0) {
     return 170;
     }
     else if (indexPath.row ==1){
     / *NSAttributedString *attributedText =
     [[NSAttributedString alloc]
     initWithString:self.homeAnnouncement.text
     attributes:@{
     NSFontAttributeName: [UIFont systemFontOfSize:16.0f]
     }];
     // CGRect rect = [attributedText boundingRectWithSize:(CGSize){self.view.frame.size.width, CGFLOAT_MAX}
     //                                           options:NSStringDrawingUsesLineFragmentOrigin
     //                                         context:nil];
     //CGSize size = rect.size;
     * /
     
     return self.introCell.fullHeight + 30;
     }
     
     return 0;*/
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
    return _dataAray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    id item = _dataAray[indexPath.row];
    if ([item isKindOfClass:[File class]]) {
        File *attachment = item;
        if ([attachment.fileType isEqualToString:@"Image"]) {
            ImageCell * cell = [tableView dequeueReusableCellWithIdentifier:@"imageCell"];
            [cell.image sd_setImageWithURL:attachment.filePathURL placeholderImage:[UIImage imageNamed:@"blank"] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
                
            }];
            return cell;
        }
        else if([attachment.fileType isEqualToString:@"Video"]){
            VideoCell * cell = [tableView dequeueReusableCellWithIdentifier:@"videoCell"];
            cell.moviePlayerController.contentURL = [NSURL URLWithString:attachment.filePath];
            cell.moviePlayerController.view.hidden = true;
            [cell.imageView sd_setImageWithURL:[NSURL URLWithString:[attachment getVideoThumbURL]] placeholderImage:[UIImage imageNamed:@"blank"]];
            return cell;
        }
    }
    
    if ([item isKindOfClass:[NSString class]]) {
        // Title
        RTCell *cell = [tableView dequeueReusableCellWithIdentifier:@"textCell" forIndexPath:indexPath];
        [cell setText:item];
        return cell;
    }
    else{
        self.introCell = [tableView dequeueReusableCellWithIdentifier:@"textCell" forIndexPath:indexPath];
        [self.introCell setText:item];
        return self.introCell;
    }
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    if (indexPath.row == 0 && [cell isKindOfClass:[VideoCell class]] ) {
        VideoCell *vcell = (VideoCell*)cell;
        [vcell.moviePlayerController setFullscreen:YES animated:YES];
        vcell.moviePlayerController.view.hidden = false;
        [vcell.moviePlayerController play];
    }
}


/*
 // Override to support conditional editing of the table view.
 - (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
 // Return NO if you do not want the specified item to be editable.
 return YES;
 }
 */

/*
 // Override to support editing the table view.
 - (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
 if (editingStyle == UITableViewCellEditingStyleDelete) {
 // Delete the row from the data source
 [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
 } else if (editingStyle == UITableViewCellEditingStyleInsert) {
 // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
 }
 }
 */

/*
 // Override to support rearranging the table view.
 - (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
 }
 */

/*
 // Override to support conditional rearranging of the table view.
 - (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
 // Return NO if you do not want the item to be re-orderable.
 return YES;
 }
 */

#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    if ([segue.identifier isEqualToString:@"webViewSegue"]) {
        WebViewController * webController = (WebViewController*)[(UINavigationController*)[segue destinationViewController] topViewController];
        webController.url = self.homeAnnouncement.file.filePath;
    }
}

- (IBAction)goBack:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)dealloc
{
    NSLog(@"LOL");
}
@end
