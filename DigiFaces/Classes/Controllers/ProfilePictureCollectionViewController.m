//
//  ProfilePictureCollectionViewController.m
//  DigiFaces
//
//  Created by confiz on 22/06/2015.
//  Copyright (c) 2015 Usasha studio. All rights reserved.
//

#import "ProfilePictureCollectionViewController.h"
#import "MBProgressHUD.h"
#import "File.h"
#import "UIImageView+AFNetworking.h"
#import "ImageCollectionCell.h"
#import "CustomAlertView.h"

#import "Utility.h"
#import "DFMediaUploadManager.h"

#import <SDWebImage/UIImageView+WebCache.h>

@interface ProfilePictureCollectionViewController() <DFMediaUploadManagerDelegate, UICollectionViewDelegateFlowLayout>
{
    CustomAlertView * alertView;
    UIImagePickerController * imagePicker;
    BOOL requestFailed;
    CGSize _collectionViewItemSize;
}
@property (nonatomic, retain) NSString * amazonFileURL;
@property (nonatomic, retain) NSArray *avatarsArray;


@end

@implementation ProfilePictureCollectionViewController

-(void)viewDidLoad
{
    [super viewDidLoad];
    alertView = [[CustomAlertView alloc] init];
    if (_type == ProfilePictureTypeDefault) {
        [self fetchAvatarFiles];
    }
    else if(_type == ProfilePictureTypeGallery){
        self.title = @"GALLERY";
        self.avatarsArray = self.files;
    }
    CGFloat _collectionViewItemPadding = ((UICollectionViewFlowLayout*)self.collectionView.collectionViewLayout).minimumInteritemSpacing;
    CGFloat _collectionViewItemSideLength = ([UIScreen mainScreen].bounds.size.width/4.0f-_collectionViewItemPadding);
    _collectionViewItemSize = CGSizeMake(_collectionViewItemSideLength, _collectionViewItemSideLength);
    [self localizeUI];
    
}

- (void)localizeUI {
    self.navigationItem.title = DFLocalizedString(@"view.profile_pic.navbar.title", nil);
    //self.navigationItem.rightBarButtonItem.title = DFLocalizedString(@"view.profile_pic.button.done", nil);
}

- (void)fetchAvatarFiles{
    
    [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
    defwself
    [DFClient makeRequest:APIPathGetAvatarFiles
                   method:kGET
                   params:nil
                  success:^(NSDictionary *response, NSArray *result) {
                      defsself
                      [MBProgressHUD hideHUDForView:sself.navigationController.view animated:YES];
                      
                      sself.avatarsArray = result;
                      
                      [sself.collectionView reloadData];
                  }
                  failure:^(NSError *error) {
                      defsself
                      [MBProgressHUD hideHUDForView:sself.navigationController.view animated:YES];
                  }];
        
}

#pragma mark - UICollectionViewDelegateFlowLayout
-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    return _collectionViewItemSize;
    
}

#pragma mark - UICollectionViewDataSource
-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    if (_type == ProfilePictureTypeDefault && indexPath.row == 0) {
        UICollectionViewCell * cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"cameraCell" forIndexPath:indexPath];
        return cell;
    }
    
    ImageCollectionCell * cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"collectionCell" forIndexPath:indexPath];
    
    File * file = nil;
    if (_type == ProfilePictureTypeDefault) {
        file = [_avatarsArray objectAtIndex:indexPath.row-1];
    }
    else if(_type == ProfilePictureTypeGallery){
        file = [_avatarsArray objectAtIndex:indexPath.row];
    }
    
    
    [cell.imgPicture sd_setImageWithURL:file.filePathURL placeholderImage:nil];
    return cell;
}

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return _avatarsArray.count;
}


-(void)collectionView:(UICollectionView *)collectionView didDeselectItemAtIndexPath:(NSIndexPath *)indexPath
{
    self.selectedImageFile = nil;
}

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    if (_type == ProfilePictureTypeDefault && indexPath.row == 0) {
        // Let DFMediaUploadManager deal with the Tap gesture on the DFMediaUploadView
    }
    else{
        self.selectedImageFile = [_avatarsArray objectAtIndex:indexPath.row-1];
        ImageCollectionCell *cell = (ImageCollectionCell*)[collectionView cellForItemAtIndexPath:indexPath];
        self.selectedImage = cell.imgPicture.image;
    }
}

- (IBAction)cancelThis:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}
- (IBAction)doneClicked:(id)sender {
    if (self.selectedImageFile == nil) {
        [alertView showAlertWithMessage:DFLocalizedString(@"view.profile_pic.error.missing_picture", nil) inView:self.navigationController.view withTag:0];
        
    }
    else{
        if ([_delegate respondsToSelector:@selector(profilePictureDidSelect:withImage:)]) {
            [_delegate profilePictureDidSelect:self.selectedImageFile.dictionary withImage:self.selectedImage];
        }
        [self dismissViewControllerAnimated:YES completion:nil];
    }
}

#pragma mark - DFMediaUploadManagerDelegate

-(NSString*)resourceKeyForMediaUploadView:(DFMediaUploadView *)mediaUploadView inMediaUploadManager:(DFMediaUploadManager *)mediaUploadManager {
    NSString * imageKey = [NSString stringWithFormat:@"Avatars/%@-%@.png", [Utility getStringForKey:kEmail], [Utility getUniqueId]];
    return imageKey;
}

-(void)mediaUploadManager:(DFMediaUploadManager *)mediaUploadManager didFailToUploadForView:(DFMediaUploadView *)mediaUploadView {
    
    [MBProgressHUD hideAllHUDsForView:self.navigationController.view animated:YES];
}

-(void)mediaUploadManager:(DFMediaUploadManager *)mediaUploadManager didSelectMediaForView:(DFMediaUploadView *)mediaUploadView {
    [self.mediaUploadManager uploadMediaFileForView:mediaUploadView];
    [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
}

-(void)mediaUploadManager:(DFMediaUploadManager *)mediaUploadManager didFinishUploadingForView:(DFMediaUploadView *)mediaUploadView {
    [MBProgressHUD hideAllHUDsForView:self.navigationController.view animated:YES];
    if (requestFailed) {
        [alertView showAlertWithMessage:DFLocalizedString(@"view.profile_pic.alert.upload_failure", nil) inView:self.navigationController.view withTag:0];
    }
    else{
        NSDictionary * parameters = @{@"FileId" : @"",
                                      @"FileName" : @"",
                                      @"FileTypeId" : @"1",
                                      @"FileType" : @"Picture",
                                      @"Extension" : @"png",
                                      @"IsAmazonFile" : @YES,
                                      @"AmazonKey" : mediaUploadView.publicURLString,
                                      @"IsViddlerFile" : @"0",
                                      @"ViddlerKey" : @"",
                                      @"IsCameraTagFile" : @"0",
                                      @"CameraTagKey" : @"",
                                      @"PositionId" : @"0",
                                      @"Position" : @"",
                                      @"PublicFileUrl" : @""
                                      };
        
        if ([_delegate respondsToSelector:@selector(profilePictureDidSelect:withImage:)]) {
            [_delegate profilePictureDidSelect:parameters withImage:mediaUploadView.image];
        }
        [self dismissViewControllerAnimated:YES completion:nil];
    }
}


@end