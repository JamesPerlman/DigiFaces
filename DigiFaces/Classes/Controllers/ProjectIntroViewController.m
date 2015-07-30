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
#import "UIImageView+AFNetworking.h"
#import "NSString+HTML.h"
#import "WebViewController.h"
#import "VideoCell.h"
#import "RTCell.h"
#import <MediaPlayer/MediaPlayer.h>
#import "NSLayoutConstraint+ConvenienceMethods.h"
#import "APIHomeAnnouncementResponse.h"

@interface ProjectIntroViewController ()
{
    RTCell * introCell;
}
@property (nonatomic, retain) NSMutableArray * dataAray;

@property (nonatomic, strong) APIHomeAnnouncementResponse *announcement;
@end

@implementation ProjectIntroViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    _dataAray = [[NSMutableArray alloc] init];
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    [self fetchProjectAnnouncements:[Utility getStringForKey:kCurrentPorjectID]];
}

-(void)fetchProjectAnnouncements:(NSString*)projectId
{
    NSString * url = [NSString stringWithFormat:@"%@%@", kBaseURL, kGetHomeAnnouncements];
    url = [url stringByReplacingOccurrencesOfString:@"{projectId}" withString:projectId];
    
    defwself
    [DFClient makeRequest:APIPathGetHomeAnnouncement
                   method:kGET
                urlParams:@{@"projectId" : projectId}
               bodyParams:nil
                  success:^(NSDictionary *response, APIHomeAnnouncementResponse *result) {
                      defsself
                      
                      [MBProgressHUD hideHUDForView:sself.navigationController.view animated:YES];
                      sself.announcement = result;
                      
                      [_dataAray removeAllObjects];
                      [_dataAray addObject:result.file];
                      [_dataAray addObject:result.title];
                      [_dataAray addObject:[result.text stringByConvertingHTMLToPlainText]];
                      
                      [self.tableView reloadData];
                  }
                  failure:^(NSError *error) {
                      defsself
                      [MBProgressHUD hideHUDForView:sself.navigationController.view animated:YES];
                  }];
    
    [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
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
    if (indexPath.row == 0) {
        return 170;
    }
    else if (indexPath.row ==1){
        return 44;
    }
    else if (indexPath.row == 2){
        NSAttributedString *attributedText =
        [[NSAttributedString alloc]
         initWithString:self.announcement.text
         attributes:@{
         NSFontAttributeName: [UIFont systemFontOfSize:16.0f]
         }];
        CGRect rect = [attributedText boundingRectWithSize:(CGSize){self.view.frame.size.width, CGFLOAT_MAX}
                                                   options:NSStringDrawingUsesLineFragmentOrigin
                                                   context:nil];
        //CGSize size = rect.size;
        
        
        return introCell.titleLabel.optimumSize.height + 50;
    }
    
    return 0;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
    return _dataAray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.row == 0) {
        File *attachment = self.announcement.file;
        if ([attachment.fileType isEqualToString:@"Image"]) {
            ImageCell * cell = [tableView dequeueReusableCellWithIdentifier:@"imageCell"];
            NSURL * url = [NSURL URLWithString:attachment.filePath];
            [cell.image setImageWithURL:url placeholderImage:[UIImage imageNamed:@"blank"]];
            return cell;
        }
        else if([attachment.fileType isEqualToString:@"Video"]){
            VideoCell * cell = [tableView dequeueReusableCellWithIdentifier:@"videoCell"];
            cell.moviePlayerController.contentURL = [NSURL URLWithString:attachment.filePath];
            cell.moviePlayerController.view.hidden = true;
            [cell.imageView setImageWithURL:[NSURL URLWithString:[attachment getVideoThumbURL]] placeholderImage:[UIImage imageNamed:@"blank"]];
            return cell;
        }
    }
    
    if (indexPath.row == 1) {
        // Title
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
        [cell.textLabel setText:self.announcement.title];
        return cell;
    }
    else{
        introCell = [tableView dequeueReusableCellWithIdentifier:@"textCell" forIndexPath:indexPath];
        [introCell.titleLabel setText:self.announcement.text];
        return introCell;
    }
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 0) {
        VideoCell *cell = (VideoCell*)[tableView cellForRowAtIndexPath:indexPath];
        [cell.moviePlayerController setFullscreen:YES animated:YES];
        cell.moviePlayerController.view.hidden = false;
        [cell.moviePlayerController play];
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
        webController.url = self.announcement.file.filePath;
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
