//
//  DiaryThemeViewController.m
//  DigiFaces
//
//  Created by confiz on 28/06/2015.
//  Copyright (c) 2015 Usasha studio. All rights reserved.
//

#import "DiaryThemeViewController.h"
#import "ImageCell.h"
#import "UIImageView+AFNetworking.h"
#import "DefaultCell.h"
#import "ResponseViewCell.h"
#import "Diary.h"
#import "DiaryInfoViewController.h"
#import "VideoCell.h"
#import "WebViewController.h"
#import "ResponseViewController.h"
#import "Module.h"
#import "RTCell.h"
#import "GalleryCell.h"
#import "MBProgressHUD.h"
#import "SDConstants.h"
#import "AFNetworking.h"
#import "Response.h"
#import "Utility.h"
#import "ResponseViewCell.h"
#import "TextAreaResponse.h"
#import "AddResponseViewController.h"
#import "CarouselViewController.h"

@interface DiaryThemeViewController () <GalleryCellDelegate>
{
    UIButton * btnEdit;
    NSInteger galleryItemIndex;
}
@property (nonatomic, retain) NSMutableArray * cellsArray;
@property (nonatomic, retain) NSMutableArray * heightArray;
@end

@implementation DiaryThemeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    _cellsArray = [[NSMutableArray alloc] init];
    _heightArray = [[NSMutableArray alloc] init];
    
    Module * markup = [self getModuleWithThemeType:ThemeTypeMarkup];
    if (!markup) {
        [self addEditButton];
    }
    
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [_cellsArray removeAllObjects];
    [_heightArray removeAllObjects];
    
    Module * markup = [self getModuleWithThemeType:ThemeTypeMarkup];
    if (markup) {
        [_cellsArray addObject:markup];
        [_heightArray addObject:@150];
        
    }
    else{
        Module * image = [self getModuleWithThemeType:ThemeTypeDisplayImage];
        if (image) {
            [_cellsArray addObject:image];
            [_heightArray addObject:@160];
        }
        else{
            Module * gallary = [self getModuleWithThemeType:ThemeTypeImageGallery];
            if (gallary) {
                [_cellsArray addObject:gallary];
                [_heightArray addObject:@160];
            }
        }
        
        Module * text = [self getModuleWithThemeType:ThemeTypeDisplayText];
        if (text) {
            [_cellsArray addObject:text];
            [_heightArray addObject:@44];
        }
        [self getResponses];
    }
}

-(void)addEditButton
{
    btnEdit = [[UIButton alloc] initWithFrame:CGRectMake(0, self.view.frame.size.height - 100, 50, 50)];
    [btnEdit setBackgroundImage:[UIImage imageNamed:@"pencil"] forState:UIControlStateNormal];
    [btnEdit addTarget:self action:@selector(editClicked:) forControlEvents:UIControlEventTouchUpInside];
    
    [self.view addSubview:btnEdit];
}

-(void)editClicked:(id)sender
{
    NSLog(@"Edit clicked");
    [self performSegueWithIdentifier:@"addThemeEntrySegue" sender:self];
}

-(Module*)getModuleWithThemeType:(ThemeType)type
{
    for (Module * m in _diaryTheme.modules) {
        if ([m themeType] == type){
            return m;
        }
    }
    return nil;
}

-(void)getResponses
{
    [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
    
    NSString * url = [NSString stringWithFormat:@"%@%@", kBaseURL, kGetResponses];
    url = [url stringByReplacingOccurrencesOfString:@"{activityId}" withString:[NSString stringWithFormat:@"%ld", (long)_diaryTheme.activityId]];
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    AFHTTPRequestSerializer *requestSerializer = [AFHTTPRequestSerializer serializer];
    
    [requestSerializer setValue:[Utility getAuthToken] forHTTPHeaderField:@"Authorization"];
    [requestSerializer setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
    
    manager.requestSerializer = requestSerializer;
    
    
    [manager POST:url parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        NSLog(@"Response : %@", responseObject);
        if ([responseObject count]>0) {
            [_cellsArray addObject:[NSString stringWithFormat:@"%d Responses", [responseObject count]]];
            [_heightArray addObject:@40];
        }
        for (NSDictionary * dict in responseObject) {
            Response * response = [[Response alloc] initWithDictionary:dict];
            [_cellsArray addObject:response];
            [_heightArray addObject:@160];
        }
        [self.tableView reloadData];
        [MBProgressHUD hideHUDForView:self.navigationController.view animated:YES];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Error: %@", error);
        [MBProgressHUD hideHUDForView:self.navigationController.view animated:YES];
    }];
}

- (IBAction)closeThis:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
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

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return _cellsArray.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UITableViewCell *cell;
    
    if ([[_cellsArray objectAtIndex:indexPath.row] isKindOfClass:[Module class]]) {
        Module * module = [_cellsArray objectAtIndex:indexPath.row];
        if ([module themeType] == ThemeTypeDisplayImage) {
            if (module.displayFile.file && [module.displayFile.file.fileType isEqualToString:@"Image"]) {
                ImageCell * imgCell = [tableView dequeueReusableCellWithIdentifier:@"imageCell"];
                NSURLRequest * request = [NSURLRequest requestWithURL:[NSURL URLWithString:module.displayFile.file.filePath]];
                [imgCell.image setImageWithURLRequest:request placeholderImage:nil success:^(NSURLRequest *request, NSHTTPURLResponse *response, UIImage *image) {
                    [imgCell.image setImage:image];
                } failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error) {
                    NSLog(@"Error");
                }];
                //[imgCell.image setImageWithURL:[NSURL URLWithString:module.displayFile.file.filePath]];
                cell = imgCell;
            }
            else{
                VideoCell * vidCell = [tableView dequeueReusableCellWithIdentifier:@"videoCell"];
                [vidCell.imageView setImageWithURL:[NSURL URLWithString:module.displayFile.file.getVideoThumbURL]];
                cell = vidCell;
            }
        }
        else if ([module themeType] == ThemeTypeDisplayText){
        
            RTCell * textCell = [tableView dequeueReusableCellWithIdentifier:@"textCell" forIndexPath:indexPath];
            
            [textCell.titleLabel setText:module.displayText.text];
            if (_heightArray.count>2) {
                [_heightArray replaceObjectAtIndex:indexPath.row withObject:@(MIN(textCell.titleLabel.optimumSize.height, 90))];
            }
            else{
                [_heightArray replaceObjectAtIndex:indexPath.row withObject:@(textCell.titleLabel.optimumSize.height + 20)];
            }
            cell = textCell;
        }
        else if ([module themeType] == ThemeTypeImageGallery){
            
            GalleryCell * galleryCell = [tableView dequeueReusableCellWithIdentifier:@"galleryCell" forIndexPath:indexPath];
            galleryCell.files = module.imageGallary.files;
            [galleryCell reloadGallery];
            cell = galleryCell;
        }
        else if ([module themeType] == ThemeTypeMarkup){
            
            cell = [tableView dequeueReusableCellWithIdentifier:@"textCell" forIndexPath:indexPath];
            
            [cell.textLabel setText:@"You must use your computer to complete this theme"];
            [cell.textLabel setTextAlignment:NSTextAlignmentCenter];
            [cell.textLabel setNumberOfLines:0];
        }
    }
    else if ([[_cellsArray objectAtIndex:indexPath.row] isKindOfClass:[NSString class]]){
        DefaultCell * defaultCell = [tableView dequeueReusableCellWithIdentifier:@"noResponseHeaderCell"];
        [defaultCell.label setText:[_cellsArray objectAtIndex:indexPath.row]];
        cell = defaultCell;
    }
    else{
        Response * response = [_cellsArray objectAtIndex:indexPath.row];
        
        ResponseViewCell * responseCell = [tableView dequeueReusableCellWithIdentifier:@"responseCell" forIndexPath:indexPath];
        
        NSURLRequest * request = [NSURLRequest requestWithURL:[NSURL URLWithString:response.userInfo.avatarFile.filePath]];
        [responseCell.userImage setImageWithURLRequest:request placeholderImage:nil success:^(NSURLRequest *request, NSHTTPURLResponse *response, UIImage *image) {
            [responseCell.userImage setImage:image];
        } failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error) {
            NSLog(@"Image download error");
        }];
        [responseCell.lblName setText:response.userInfo.appUserName];
        [responseCell.lblTime setText:response.dateCreatedFormated];
        [responseCell setImageCircular];
        [responseCell.btnComments setTitle:[NSString stringWithFormat:@"%d Comments", response.comments.count] forState:UIControlStateNormal];
        CGSize size;
        if (response.textAreaResponse.count>0) {
            TextAreaResponse * textResponse = [response.textAreaResponse objectAtIndex:0];
            [responseCell.lblResponse setText:textResponse.response];
            
            CGRect rect = [textResponse.response boundingRectWithSize:CGSizeMake(self.view.frame.size.width, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:13]} context:nil];
            size = rect.size;
            responseCell.responseHeightConst.constant = MIN(size.height + 5, 50);
        }
        
        [responseCell setFiles:response.files];
        
        NSInteger height = 105 + MIN(size.height + 5, 50);
        
        if (response.files.count>0) {
            height += 55;
        }
        [_heightArray replaceObjectAtIndex:indexPath.row withObject:@(height)];
        
        cell = responseCell;
    }
    
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return [[_heightArray objectAtIndex:indexPath.row] integerValue];
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    id object = [_cellsArray objectAtIndex:indexPath.row];
    if ([object isKindOfClass:[Module class]]) {
        Module * module = (Module*)object;
        if ([module themeType] == ThemeTypeDisplayImage) {
            [self performSegueWithIdentifier:@"webViewSegue" sender:self];
        }
        else if ([module themeType] == ThemeTypeDisplayText){
            [self performSegueWithIdentifier:@"diaryInfoSegue" sender:self];
        }
    }
    else if ([object isKindOfClass:[Response class]]){
        [self performSegueWithIdentifier:@"responseSegue" sender:self];
    }
}

-(CGFloat)heightForComment:(NSString*)comment
{
    NSAttributedString *attributedText =
    [[NSAttributedString alloc] initWithString:comment attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:15.0f]}];
    
    CGRect rect = [attributedText boundingRectWithSize:(CGSize){self.view.frame.size.width, CGFLOAT_MAX} options:NSStringDrawingUsesLineFragmentOrigin context:nil];
    
    CGSize size = rect.size;
    
    return size.height + 20;
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"diaryInfoSegue"]) {
        DiaryInfoViewController * diaryInfoController = (DiaryInfoViewController*)[(UINavigationController*)[segue destinationViewController] topViewController];
        diaryInfoController.diaryTheme = _diaryTheme;
    }
    else if ([segue.identifier isEqualToString:@"webViewSegue"]){
        Module * module = [_cellsArray objectAtIndex:0];
        WebViewController * webController = (WebViewController*)[(UINavigationController*)[segue destinationViewController] topViewController];
        webController.url = [module.displayFile.file filePath];
    }
    else if ([segue.identifier isEqualToString:@"responseSegue"]){
        NSInteger index = [self.tableView indexPathForSelectedRow].row;
        Response * response = [_cellsArray objectAtIndex:index];
        ResponseViewController * responseController = [segue destinationViewController];
        responseController.responseType = ResponseControllerTypeDiaryTheme;
        responseController.response = response;
    }
    else if ([segue.identifier isEqualToString:@"addThemeEntrySegue"]){
        AddResponseViewController * addResponseController = (AddResponseViewController*)[(UINavigationController*)[segue destinationViewController] topViewController];
        addResponseController.diaryTheme = _diaryTheme;
    }
    else if ([segue.identifier isEqualToString:@"gallerySegue"]){
        Module * module = [self getModuleWithThemeType:ThemeTypeImageGallery];
        CarouselViewController * carouselController = [segue destinationViewController];
        carouselController.files = module.imageGallary.files;
        carouselController.selectedIndex = galleryItemIndex;
    }
}

-(void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    CGRect frame = btnEdit.frame;
    frame.origin.y = scrollView.contentOffset.y + self.tableView.frame.size.height - btnEdit.frame.size.height - 10;
    frame.origin.x = self.view.frame.size.width - frame.size.width - 10;
    btnEdit.frame = frame;
    
    [self.view bringSubviewToFront:btnEdit];
}

#pragma mark - GalleryCellDelegate
-(void)galleryCell:(id)cel didClickOnIndex:(NSInteger)index
{
    galleryItemIndex = index;
    [self performSegueWithIdentifier:@"gallerySegue" sender:self];
}

@end
