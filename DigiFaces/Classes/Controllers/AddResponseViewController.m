//
//  AddResponseViewController.m
//  DigiFaces
//
//  Created by confiz on 27/06/2015.
//  Copyright (c) 2015 Usasha studio. All rights reserved.
//

#import "AddResponseViewController.h"
#import "TextFieldCell.h"
#import "TextViewCell.h"
#import <MobileCoreServices/MobileCoreServices.h>
#import "Utility.h"
#import "DiaryInfoViewController.h"
#import "CalendarViewController.h"
#import "UserManagerShared.h"
#import "MBProgressHUD.h"

#import "AFNetworking.h"
#import "UIImageView+AFNetworking.h"
#import "CustomAlertView.h"
#import "ProfilePictureCollectionViewController.h"
#import "DFMediaUploadManager.h"
#import "NSLayoutConstraint+ConvenienceMethods.h"

#import "ImageGallery.h"
#import "Thread.h"
#import "TextareaResponse.h"

@interface AddResponseViewController () < CalendarViewControlerDelegate, UITextViewDelegate, ProfilePictureViewControllerDelegate, DFMediaUploadManagerDelegate>
{
    NSInteger selectedTag;
    UIImagePickerController * imagePicker;
    CalendarViewController * calendarView;
    
    NSDate * selectedDate;
    ProfilePictureCollectionViewController * profileController;
}

@property (nonatomic, retain) NSMutableArray * dataArray;
@property (nonatomic, retain) CustomAlertView * alertView;

@property (nonatomic, strong) Thread *thread;

@end

@implementation AddResponseViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    [_txtResponse becomeFirstResponder];
    [_btnDate setTitle:[Utility stringFromDate:[NSDate date]] forState:UIControlStateNormal];
    selectedDate = [NSDate date];
    
    _alertView = [[CustomAlertView alloc] initWithNibName:@"CustomAlertView" bundle:[NSBundle mainBundle]];
    
    if (_diaryTheme) {
        _constDateHeight.constant = 0;
        _constTitleHeight.constant = 0;
        
        if ([_diaryTheme getModuleWithThemeType:ThemeTypeImageGallery])   {
            
            
            profileController = [self.storyboard instantiateViewControllerWithIdentifier:@"ProfilePictureCollectionViewController"];
            
            profileController.type = ProfilePictureTypeGallery;
            profileController.delegate = self;
            Module * module = [_diaryTheme getModuleWithThemeType:ThemeTypeImageGallery];
            profileController.files = [module.imageGallery files];
            profileController.collectionView.translatesAutoresizingMaskIntoConstraints = NO;
            [self.view addSubview:profileController.collectionView];
            [self.view addConstraints:[NSLayoutConstraint equalSizeAndCentersWithItem:profileController.collectionView toItem:self.imageContainerView]];
            
        }
    }
    
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"diaryInfoSegue"]) {
        DiaryInfoViewController * diaryInfoController = (DiaryInfoViewController*)[(UINavigationController*)segue.destinationViewController topViewController];
        diaryInfoController.isViewOnly = YES;
        diaryInfoController.dailyDiary = self.dailyDiary;
        diaryInfoController.diaryTheme = self.diaryTheme;
    }
    else if ([segue.identifier isEqualToString:@"gallerySegue"]){
        
        /*
         ProfilePictureCollectionViewController * profileController = (ProfilePictureCollectionViewController*)[(UINavigationController*)[segue destinationViewController] topViewController];
         profileController.type = ProfilePictureTypeGallery;
         profileController.delegate = self;
         Module * module = [_diaryTheme getModuleWithThemeType:ThemeTypeImageGallery];
         
         profileController.files = [module.imageGallery files];*/
    }
}

-(void)keyboardWillShow:(NSNotification*)notification
{
    NSDictionary *info = [notification userInfo];
    CGSize kbSize = [[info objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue].size;
    self.constBottomViewHeight.constant = kbSize.height;
}

-(void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)createThreadWithActivityID:(NSInteger)activityId
{
    [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
    
    
    
    NSString * url = [NSString stringWithFormat:@"%@%@", kBaseURL, kUpdateThread];
    
    NSDictionary * params = @{@"ActivityId" : @(activityId),
                              @"ThreadId" : @0,
                              @"IsDraft" : @NO,
                              @"IsActive" : @YES};
    
    defwself
    [DFClient makeRequest:APIPathActivityUpdateThread
                   method:kPOST
                   params:params
                  success:^(NSDictionary *response, Thread *result) {
                      defsself
                      sself.thread = result;
                      
                      if (_dailyDiary) {
                          [sself addEntryWithActivityId:activityId];
                      }
                      else if(_diaryTheme){
                          if ([_diaryTheme getModuleWithThemeType:ThemeTypeImageGallery]) {
                              [sself addImageGalleryResponse];
                          }
                          else
                          {
                              [sself addTextAreaResponseWithActivityId:activityId];
                          }
                      }
                  }
                  failure:^(NSError *error) {
                      defsself
                      [MBProgressHUD hideHUDForView:sself.navigationController.view animated:YES];
                  }];
    
}


-(void)addImageGalleryResponse
{
    [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
    
    NSString *selectedGalleryIds = @"";
    if (profileController.selectedImageFile) {
        selectedGalleryIds = profileController.selectedImageFile.fileId.stringValue;
    }
    Module * imageGalleryModule = [_diaryTheme getModuleWithThemeType:ThemeTypeImageGallery];
    NSDictionary * params = @{@"ImageGalleryResponseId" : @0,
                              @"ThreadId" : self.thread.threadId,
                              @"ImageGalleryId" : imageGalleryModule.imageGallery.imageGalleryId,
                              @"GalleryIds" : selectedGalleryIds,
                              @"UserId" : [[UserManagerShared sharedManager] ID],
                              @"IsActive" : @YES,
                              @"Response" : _txtResponse.text};
    
    
    defwself
    [DFClient makeRequest:APIPathActivityUpdateImageGalleryResponse
                   method:kPOST
                   params:params
                  success:^(NSDictionary *response, ImageGallery *result) {
                      defsself
                      [MBProgressHUD hideAllHUDsForView:sself.navigationController.view animated:YES];
                      [sself dismissViewControllerAnimated:YES completion:nil];
                  }
                  failure:^(NSError *error) {
                      defsself;
                      [MBProgressHUD hideAllHUDsForView:sself.navigationController.view animated:YES];
                  }];
    
    
}

-(void)addTextAreaResponseWithActivityId:(NSInteger)activityId
{
    [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
    
    Module * textAreaModule = [_diaryTheme getModuleWithThemeType:ThemeTypeTextArea];
    
    NSDictionary * params = @{@"TextareaResponseId" : @(0),
                              @"ThreadId" : self.thread.threadId,
                              @"TextareaId" : textAreaModule.textarea.textareaId,
                              @"IsActive" : @YES,
                              @"Response" : _txtResponse.text};
    defwself
    [DFClient makeRequest:APIPathActivityUpdateTextareaResponse
                   method:kPOST
                   params:params
                  success:^(NSDictionary *response, TextareaResponse *result) {
                      defsself
                      [MBProgressHUD hideAllHUDsForView:sself.navigationController.view animated:YES];
                      [sself.mediaUploadManager uploadMediaFiles];
                  }
                  failure:^(NSError *error) {
                      defsself
                      [MBProgressHUD hideHUDForView:sself.navigationController.view animated:YES];
                  }];
}

-(void)addEntryWithActivityId:(NSInteger)activityId
{
    [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
    
    NSString * url = [NSString stringWithFormat:@"%@%@", kBaseURL, kUpdateDailyDiary];
    url = [url stringByReplacingOccurrencesOfString:@"{projectId}" withString:[NSString stringWithFormat:@"%d", (int)[[UserManagerShared sharedManager] currentProjectID]]];
    
    NSDictionary * params = @{@"ActivityId" : @(activityId),
                              @"DailyDiaryResponseId" : @0,
                              @"DailyDiaryId" : _dailyDiary.diaryId,
                              @"ThreadId" : self.thread.threadId,
                              @"Title" : _txtTitle.text,
                              @"IsActive" : @YES,
                              @"Response" : _txtResponse.text,
                              @"DiaryDate" : [Utility stringDateFromDMYDate:selectedDate]};
    
    defwself
    [DFClient makeRequest:APIPathUpdateDailyDiary
                   method:kPOST
                urlParams:@{@"projectId" : @([[UserManagerShared sharedManager] currentProjectID])}
               bodyParams:params
                  success:^(NSDictionary *response, DailyDiary *result) {
                      NSLog(@"Uploading images (if any)");
                      
                      dispatch_async(dispatch_get_main_queue(), ^{
                          defsself
                          [sself.mediaUploadManager uploadMediaFiles];
                      });
                      
                      
                  }
                  failure:^(NSError *error) {
                      defsself
                      
                      [MBProgressHUD hideHUDForView:sself.navigationController.view animated:YES];
                  }];
    
}

-(void)insertThreadFileWithMediaView:(DFMediaUploadView*)mediaUploadView {
    
    NSURL *publicFileURL = [NSURL URLWithString:mediaUploadView.mediaFilePath];
    NSString *fileName = [publicFileURL lastPathComponent];
    NSString *fileExtension = [fileName pathExtension];
    NSMutableDictionary * params = @{@"FileName" : fileName,//fileType: (__bridge NSString*)mimeType,
                                     @"Extension" : fileExtension
                                     }.mutableCopy;
    
    if (mediaUploadView.uploadType == DFMediaUploadTypeVideo) {
        params[@"IsViddlerFile"] = @YES;
        params[@"ViddlerKey"] = mediaUploadView.publicURLString;
        params[@"FileTypeId"] = @2;
        params[@"FileType"] = @"Video";
    } else if (mediaUploadView.uploadType == DFMediaUploadTypeImage) {
        params[@"IsAmazonFile"] = @YES;
        params[@"AmazonKey"] = mediaUploadView.publicURLString;
        params[@"FileTypeId"] = @1;
        params[@"FileType"] = @"Image";
    }
    
    defwself
    [DFClient makeRequest:APIPathActivityInsertThreadFile
                   method:kPOST
                urlParams:@{@"projectId" : self.thread.threadId}
               bodyParams:[NSDictionary dictionaryWithDictionary:params]
                  success:^(NSDictionary *response, id result) {
                      defsself
                      [MBProgressHUD hideHUDForView:sself.navigationController.view animated:YES];
                  }
                  failure:^(NSError *error) {
                      defsself
                      [MBProgressHUD hideHUDForView:sself.navigationController.view animated:YES];
                  }];
    
}


-(void)resignAllResponders
{
    [_txtTitle resignFirstResponder];
    [_txtResponse resignFirstResponder];
}

- (IBAction)postData:(id)sender {
    if (_dailyDiary && [_txtTitle.text isEqualToString:@""]) {
        // Error
        [self resignAllResponders];
        [_alertView showAlertWithMessage:@"Title is required" inView:self.navigationController.view withTag:0];
    }
    else if ([_txtResponse.text isEqualToString:@""]){
        [self resignAllResponders];
        [_alertView showAlertWithMessage:@"Response is required." inView:self.navigationController.view withTag:0];
    }
    else
    {
        [self resignAllResponders];
        if (_diaryTheme.activityId) {
            [self createThreadWithActivityID:_diaryTheme.activityId.integerValue];
        } else {
            [self createThreadWithActivityID:_dailyDiary.activityId.integerValue];
        }
    }
    
}

- (IBAction)closeThis:(id)sender {
    [self resignAllResponders];
    [MBProgressHUD hideAllHUDsForView:self.navigationController.view animated:YES];
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)exitOnEnd:(id)sender {
    [sender resignFirstResponder];
}

- (IBAction)viewQuestion:(id)sender {
    
    [self performSegueWithIdentifier:@"diaryInfoSegue" sender:self];
}

- (IBAction)cameraSwitched:(id)sender {
    [_txtResponse resignFirstResponder];
    [_txtTitle resignFirstResponder];
    
}

- (IBAction)selectDate:(id)sender {
    
    [_txtResponse resignFirstResponder];
    [_txtTitle resignFirstResponder];
    
    calendarView = [self.storyboard instantiateViewControllerWithIdentifier:@"calendarController"];
    calendarView.delegate = self;
    calendarView.endDate = [NSDate date];
    calendarView.startDate = [Utility dateFromString:[[UserManagerShared sharedManager] currentProject].projectStartDate];
    [self.navigationController.view addSubview:calendarView.view];
    
}


-(void)setImageURL:(NSString*)url withImage:(UIImage*)image
{
    DFMediaUploadView *view = self.mediaUploadManager.currentView;
    view.uploadType = DFMediaUploadTypeImage;
    
    view.publicURLString = url;
    if (image) {
        view.image = image;
        return;
    }
    NSURLRequest * request = [NSURLRequest requestWithURL:[NSURL URLWithString:url
                                                           ]];
    [view.imageView setImageWithURLRequest:request placeholderImage:nil success:^(NSURLRequest *request, NSHTTPURLResponse *response, UIImage *image) {
        view.image = image;
    } failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error) {
        NSLog(@"Image Loading Error");
    }];
}





#pragma mark- UITextViewDelegate
-(void)textViewDidChange:(UITextView *)textView
{
    if ([textView.text isEqualToString:@""]) {
        [_lblPlaceholder setHidden:NO];
    }
    else{
        [_lblPlaceholder setHidden:YES];
    }
}

#pragma mark - CalendarViewDelegate
-(void)calendarController:(id)controller didSelectDate:(NSDate *)date
{
    selectedDate = date;
    NSString * strDate = [Utility stringFromDate:date];
    [_btnDate setTitle:strDate forState:UIControlStateNormal];
    [calendarView.view removeFromSuperview];
}

#pragma mark - ProfilePictureDelegate
-(void)profilePictureDidSelect:(File *)selectedProfile withImage:(UIImage *)image
{
    [self setImageURL:[selectedProfile filePathURLString] withImage:image];
}


#pragma mark - DFMediaUploadManagerDelegate


-(void)mediaUploadManager:(DFMediaUploadManager *)mediaUploadManager didFinishUploadingForView:(DFMediaUploadView *)mediaUploadView {
    [self insertThreadFileWithMediaView:mediaUploadView];
}

-(void)mediaUploadManager:(DFMediaUploadManager *)mediaUploadManager didFailToUploadForView:(DFMediaUploadView *)mediaUploadView {
    [MBProgressHUD hideAllHUDsForView:self.navigationController.view animated:YES];
}

-(void)mediaUploadManagerDidFinishAllUploads:(DFMediaUploadManager *)mediaUploadManager {
    [self closeThis:self];
}


- (BOOL)mediaUploadManager:(DFMediaUploadManager*)mediaUploadManager shouldHandleTapForMediaUploadView:(DFMediaUploadView*)mediaUploadView {
    
    return true;
}


@end
