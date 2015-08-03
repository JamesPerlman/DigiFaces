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
#import "ImageGalleryResponse.h"
#import "Thread.h"
#import "Diary.h"
#import "DiaryTheme.h"
#import "DailyDiaryResponse.h"
#import "TextareaResponse.h"
#import "Response.h"

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

@property (nonatomic, strong) Response *createdResponse;
@property (nonatomic, strong) Diary *createdDiary;

@end

@implementation AddResponseViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //self.txtTitle.attributedPlaceholder = [[NSAttributedString alloc] initWithString:self.txtTitle.placeholder attributes:@{NSForegroundColorAttributeName : [UIColor colorWithRed:24.0f/255.0f green:186.0f/255.0f blue:252.0f/255.0f alpha:1.0f]}];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
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
        [self.txtResponse becomeFirstResponder];
    } else {
        
        [self.txtTitle becomeFirstResponder];
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

- (void)showAlertWithMessage:(NSString*)message {
    [_alertView showAlertWithMessage:message inView:self.navigationController.view withTag:0];
}

-(void)createThreadWithActivityID:(NSInteger)activityId
{
    if ([_diaryTheme getModuleWithThemeType:ThemeTypeImageGallery] && !profileController.selectedImageFile) {
        
        [self showAlertWithMessage:@"You must select an image before posting a response."];
        return;
    }
    [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
    
    
    
    
    NSDictionary * params = @{@"ActivityId" : @(activityId),
                              @"ThreadId" : @0,
                              @"IsDraft" : @NO,
                              @"IsActive" : @YES};
    
    defwself
    [DFClient makeJSONRequest:APIPathActivityUpdateThread
                   method:kPOST
                   params:params
                  success:^(NSDictionary *response, Thread *result) {
                      defsself
                      sself.thread = result;
                      
                      if (_dailyDiary) {
                          sself.createdDiary = [[Diary alloc] init];
                          NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
                          formatter.dateFormat = @"yyyy-MM-dd'T'hh:mm:ss";
                          sself.createdDiary.dateCreatedFormatted = @"Today";//[formatter stringFromDate:[NSDate date]];
                          sself.createdDiary.dateCreated = [formatter stringFromDate:[NSDate date]];
                          sself.createdDiary.isRead = @YES;
                          sself.createdDiary.threadId = result.threadId;
                          sself.createdDiary.userInfo = LS.myUserInfo;
                          sself.createdDiary.comments = @[];
                          sself.createdDiary.files = @[];
                          sself.dailyDiary.userDiaries = [@[sself.createdDiary] arrayByAddingObjectsFromArray:sself.dailyDiary.userDiaries];
                          
                          [sself addEntryWithActivityId:activityId];
                      }
                      else if(_diaryTheme){
                          sself.createdResponse = [[Response alloc] init];
                          sself.createdResponse.threadId = result.threadId;
                          sself.createdResponse.dateCreatedFormatted = @"Just now";
                          sself.createdResponse.files = @[];
                          sself.createdResponse.comments = @[];
                          sself.createdResponse.userInfo = LS.myUserInfo;
                          sself.diaryTheme.responses = [@[sself.createdResponse] arrayByAddingObjectsFromArray:sself.diaryTheme.responses];
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
                              @"UserId" : LS.myUserInfo.id,
                              @"IsActive" : @YES,
                              @"Response" : _txtResponse.text};
    
    
    defwself
    [DFClient makeJSONRequest:APIPathActivityUpdateImageGalleryResponse
                   method:kPOST
                   params:params
                  success:^(NSDictionary *response, ImageGalleryResponse *result) {
                      defsself
                      sself.createdResponse.imageGalleryResponses = @[result];
                      sself.createdResponse.files = @[profileController.selectedImageFile];
                      [sself closeThis:nil];
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
    [DFClient makeJSONRequest:APIPathActivityUpdateTextareaResponse
                   method:kPOST
                   params:params
                  success:^(NSDictionary *response, TextareaResponse *result) {
                      defsself
                      [MBProgressHUD hideAllHUDsForView:sself.navigationController.view animated:YES];
                      [sself.mediaUploadManager uploadMediaFiles];
                      
                      sself.createdResponse.textareaResponses = @[result];
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
    [DFClient makeJSONRequest:APIPathUpdateDailyDiary
                   method:kPOST
                urlParams:@{@"projectId" : @([[UserManagerShared sharedManager] currentProjectID])}
               bodyParams:params
                  success:^(NSDictionary *response, DailyDiaryResponse *result) {
                      NSLog(@"Uploading images (if any)");
                      
                      dispatch_async(dispatch_get_main_queue(), ^{
                          defsself
                          sself.createdDiary.response = result.response;
                          sself.createdDiary.title = result.title;
                          [sself.mediaUploadManager uploadMediaFiles];
                      });
                      
                  }
                  failure:^(NSError *error) {
                      defsself
                      
                      [MBProgressHUD hideHUDForView:sself.navigationController.view animated:YES];
                  }];
    
}

-(void)insertThreadFileWithMediaView:(DFMediaUploadView*)mediaUploadView {
    
    [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
    NSURL *publicFileURL = [NSURL URLWithString:mediaUploadView.mediaFilePath];
    NSString *fileName = [publicFileURL lastPathComponent];
    NSString *fileExtension = [fileName pathExtension];
    NSMutableDictionary * params = @{@"FileName" : fileName,//fileType: (__bridge NSString*)mimeType,
                                     @"Extension" : fileExtension
                                     }.mutableCopy;
    
    if (mediaUploadView.uploadType == DFMediaUploadTypeVideo) {
        params[@"IsViddlerFile"] = @YES;
        params[@"ViddlerKey"] = mediaUploadView.resourceKey;
        params[@"FileTypeId"] = @2;
        params[@"FileType"] = @"Video";
    } else if (mediaUploadView.uploadType == DFMediaUploadTypeImage) {
        params[@"IsAmazonFile"] = @YES;
        params[@"AmazonKey"] = mediaUploadView.publicURLString;
        params[@"FileTypeId"] = @1;
        params[@"FileType"] = @"Image";
    }
    
    defwself
    [DFClient makeJSONRequest:APIPathActivityInsertThreadFile
                   method:kPOST
                urlParams:@{@"projectId" : self.thread.threadId}
               bodyParams:[NSDictionary dictionaryWithDictionary:params]
                  success:^(NSDictionary *response, File *result) {
                      defsself
                      [MBProgressHUD hideHUDForView:sself.navigationController.view animated:YES];
                      [sself addFileToWhateverObjectIsCreated:result];
                  }
                  failure:^(NSError *error) {
                      defsself
                      [MBProgressHUD hideHUDForView:sself.navigationController.view animated:YES];
                  }];
    
}


- (void)addFileToWhateverObjectIsCreated:(File*)file {
    if (self.createdDiary) {
        self.createdDiary.files = [self.createdDiary.files arrayByAddingObject:file];
    }
    if (self.createdResponse) {
        self.createdResponse.files = [self.createdResponse.files arrayByAddingObject:file];
    }
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
        [self showAlertWithMessage:@"Title is required."];
    }
    else if ([_txtResponse.text isEqualToString:@""]){
        [self resignAllResponders];
        [self showAlertWithMessage:@"Response is required."];
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
    if (self.diaryTheme) {
        if ([self.delegate respondsToSelector:@selector(didAddDiaryThemeResponse:)]) {
            [self.delegate didAddDiaryThemeResponse:self.createdResponse];
        }
    }
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
    [self setImageURL:[selectedProfile filePath] withImage:image];
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
