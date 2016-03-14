//
//  DiaryInfoViewController.m
//  DigiFaces
//
//  Created by confiz on 27/06/2015.
//  Copyright (c) 2015 Usasha studio. All rights reserved.
//

#import "DiaryInfoViewController.h"
#import "ImageCell.h"
#import "UIImageView+AFNetworking.h"
#import "WebViewController.h"
#import "VideoCell.h"
#import "AddResponseViewController.h"
#import "RTCell.h"
#import "Module.h"
#import "GalleryCell.h"
#import "CarouselViewController.h"
#import "NSString+StripHTML.h"
#import "File.h"
#import "DisplayFile.h"
#import "DisplayText.h"
#import "ImageGallery.h"

typedef enum {
    CellsTypeImage,
    CellsTypeVideo,
    CellsTypeGalary,
    CellsTypeText
}CellsType;

@interface DiaryInfoViewController ()
{
    UIButton * btnEdit;
    RTCell * infoCell;
    NSInteger galleryItemIndex;
}

@property (nonatomic, retain) NSMutableArray * cellsArray;
@end

@implementation DiaryInfoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    _cellsArray = [[NSMutableArray alloc] init];
    
    if (_dailyDiary) {
        self.navigationItem.title = DFLocalizedString(@"view.entry_info.navbar.title", nil);
        if ([_dailyDiary.file.fileType isEqualToString:@"Image"]) {
            [_cellsArray addObject:@(CellsTypeImage)];
        }
        else {
            [_cellsArray addObject:@(CellsTypeVideo)];
        }
        
        [_cellsArray addObject:@(CellsTypeText)];
    }
    else if (_diaryTheme){
        self.navigationItem.title = _diaryTheme.activityTitle;
        Module * m = [self getModuleForThemeType:ThemeTypeDisplayImage];
        if (m) {
            if ([m.displayFile.file.fileType isEqualToString:@"Image"]) {
                [_cellsArray addObject:@(CellsTypeImage)];
            }
            else{
                [_cellsArray addObject:@(CellsTypeVideo)];
            }
        }
        else{
            Module * gal = [self getModuleForThemeType:ThemeTypeImageGallery];
            if (gal) {
                [_cellsArray addObject:@(CellsTypeGalary)];
            }
        }
        
        Module * mText = [self getModuleForThemeType:ThemeTypeDisplayText];
        if (mText) {
            [_cellsArray addObject:@(CellsTypeText)];
        }
    }
    
    if (!_isViewOnly && [LS.myUserPermissions canAddResponses]) {
        [self addEditButton];
    }
    
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
}


-(Module*)getModuleForThemeType:(ThemeType)type
{
    for (Module * m in _diaryTheme.modules) {
        if ([m themeType] == type) {
            return m;
        }
    }
    return nil;
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
    [self performSegueWithIdentifier:@"addResponseSegue" sender:self];
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
    // Return the number of rows in the section.
    return [_cellsArray count];
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    if (indexPath.row == 1 || CellsTypeText == (CellsType)[_cellsArray[indexPath.row] integerValue]) {
        infoCell = [tableView dequeueReusableCellWithIdentifier:@"textCell"];
        if (_dailyDiary) {
            [infoCell setText:_dailyDiary.diaryQuestion];
        }
        else{
            Module * module = [self getModuleForThemeType:ThemeTypeDisplayText];
            [infoCell setText:module.displayText.text];
        }
        return infoCell.fullHeight;
    } else {
        if ((_dailyDiary && _dailyDiary.file) || (_diaryTheme && [self getModuleForThemeType:ThemeTypeDisplayImage].displayFile) ) {
            return 160;
        } else {
            return 0;
        }
    }
    return 0;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UITableViewCell *cell;
    
    CellsType type = (CellsType)[_cellsArray[indexPath.row] integerValue];
    
    switch (type) {
        case CellsTypeImage:
        {
            File * file;
            if (_dailyDiary) {
                file = _dailyDiary.file;
            }
            else{
                Module * module = [self getModuleForThemeType:ThemeTypeDisplayImage];
                file = module.displayFile.file;
            }
            
            ImageCell * imgCell = [tableView dequeueReusableCellWithIdentifier:@"imageCell"];
            [imgCell.image setImageWithURL:file.filePathURL];
            cell = imgCell;
        }
            break;
        case CellsTypeVideo:
        {
            File * file;
            if (_dailyDiary) {
                file = _dailyDiary.file;
            }
            else{
                Module * module = [self getModuleForThemeType:ThemeTypeDisplayImage];
                file = module.displayFile.file;
            }
            
            VideoCell * vidCell = [tableView dequeueReusableCellWithIdentifier:@"videoCell"];
            [vidCell setImageWithURL:file.getVideoThumbURL];
            cell = vidCell;
        }
            break;
        case CellsTypeText:
        {
            infoCell = [tableView dequeueReusableCellWithIdentifier:@"textCell" forIndexPath:indexPath];
            if (_dailyDiary) {
                [infoCell setText:_dailyDiary.diaryQuestion];
            }
            else{
                Module * module = [self getModuleForThemeType:ThemeTypeDisplayText];
                [infoCell setText:module.displayText.text];
            }
            cell = infoCell;
        }
            break;
        case CellsTypeGalary:
        {
            Module * module = [self getModuleForThemeType:ThemeTypeImageGallery];
            GalleryCell * galleryCell = [tableView dequeueReusableCellWithIdentifier:@"galleryCell" forIndexPath:indexPath];
            
            galleryCell.files = [module.imageGallery.files allObjects];
            //[galleryCell reloadGallery];
            cell = galleryCell;
            
        }
            break;
        default:
            break;
    }
    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 0) {
        [self performSegueWithIdentifier:@"webViewSegue" sender:self];
    }
}


#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"webViewSegue"]){
        WebViewController * webController = (WebViewController*)[(UINavigationController*)[segue destinationViewController] topViewController];
        File * file;
        if (_dailyDiary) {
            file = _dailyDiary.file;
        }
        else{
            Module * module = [self getModuleForThemeType:ThemeTypeDisplayImage];
            file = module.displayFile.file;
        }
        webController.url = [file filePath];
    }
    else if ([segue.identifier isEqualToString:@"addResponseSegue"]){
        AddResponseViewController * responseController = (AddResponseViewController*)[(UINavigationController*)[segue destinationViewController] topViewController];
        if (_dailyDiary) {
            responseController.dailyDiary = self.dailyDiary;
        }
        else{
            responseController.diaryTheme = self.diaryTheme;
        }
    }
    else if ([segue.identifier isEqualToString:@"gallerySegue"]){
        Module * module = [self getModuleForThemeType:ThemeTypeImageGallery];
        CarouselViewController * carouselController = [segue destinationViewController];
        carouselController.files = [module.imageGallery.files allObjects];
        carouselController.selectedIndex = galleryItemIndex;
    }
}


- (IBAction)closeThis:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
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
