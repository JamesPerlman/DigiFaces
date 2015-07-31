//
//  DFMediaUploadManager.m
//  DigiFaces
//
//  Created by James on 7/21/15.
//  Copyright (c) 2015 Usasha studio. All rights reserved.
//



#import "DFMediaUploadManager.h"

#import "AFNetworking.h"
#import "Utility.h"

#import <MobileCoreServices/UTCoreTypes.h>
#import <AWSS3/AWSS3.h>
#import <AWSCore/AWSCore.h>
#import <AVFoundation/AVFoundation.h>

@interface DFMediaUploadManager ()<UIImagePickerControllerDelegate,  UINavigationControllerDelegate, UIActionSheetDelegate, DFMediaUploadViewDelegate> {
    void (^_uploadCompletionBlock)(BOOL success);
    BOOL _uploading;
}

@property (nonatomic, copy) NSNumber *authorID;
@property (nonatomic, copy) NSString *groupName;
@property (nonatomic, copy) NSNumber *threadID;

@end

@implementation DFMediaUploadManager

- (instancetype)init
{
    self = [super init];
    if (self) {
        AWSCognitoCredentialsProvider *credentialsProvider = [[AWSCognitoCredentialsProvider alloc] initWithRegionType:kCognitoRegionType
                                                                                                        identityPoolId:kCognitoIdentityPoolId];
        AWSServiceConfiguration *configuration = [[AWSServiceConfiguration alloc] initWithRegion:kS3DefaultServiceRegionType
                                                                             credentialsProvider:credentialsProvider];
        AWSServiceManager.defaultServiceManager.defaultServiceConfiguration = configuration;
    }
    return self;
}

#pragma mark - DFMediaUploadViewDelegate
- (void)didTapMediaUploadView:(DFMediaUploadView *)view {
    if ([self.delegate respondsToSelector:@selector(mediaUploadManager:shouldHandleTapForMediaUploadView:)]) {
        
        if (![self.delegate mediaUploadManager:self shouldHandleTapForMediaUploadView:view]) {
            
            return;
        }
    }
    
    self.currentView = view;
    if (view.error) {
        [self uploadMediaFileForView:view];
        view.error = false;
    } else {
        UIActionSheet * actionSheet = [[UIActionSheet alloc] initWithTitle:@"Select Image" delegate:self cancelButtonTitle:@"Cancel" destructiveButtonTitle:nil otherButtonTitles:@"Camera",@"Photo Library", nil];
        [actionSheet showInView:((UIViewController*)self.viewController).view];
    }
}
#pragma mark - UIActionSheetDelegate
-(void)actionSheet:(UIActionSheet *)actionSheet didDismissWithButtonIndex:(NSInteger)buttonIndex
{
    UIImagePickerControllerSourceType type;
    if (buttonIndex == 0 && [UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
        // Camera
        type = UIImagePickerControllerSourceTypeCamera;
    }
    else if (buttonIndex == 1){
        // Library
        type = UIImagePickerControllerSourceTypePhotoLibrary;
    }
    else{
        return;
    }
    [self initializeImagePickerWithSourceType:type];
}
-(void)initializeImagePickerWithSourceType:(UIImagePickerControllerSourceType)type
{
    
    self.imagePickerController.sourceType = type;
    self.imagePickerController.allowsEditing = YES;
    NSLog(@"%d", self.currentView.allowsVideo);
    if (self.currentView.allowsVideo) {
        self.imagePickerController.mediaTypes = @[(NSString*)kUTTypeMovie, (NSString*)kUTTypeImage];
    } else {
        self.imagePickerController.mediaTypes = @[(NSString*)kUTTypeImage];
    }
    
    [self.viewController presentViewController:self.imagePickerController animated:YES completion:nil];
}
#pragma mark - UIImagePickerController
- (UIImagePickerController*)imagePickerController {
    if (!_imagePickerController) {
        
        // set up the picker
        _imagePickerController = [[UIImagePickerController alloc] init];
        _imagePickerController.delegate = self;
    }
    return _imagePickerController;
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    
    NSString *mediaType = [info objectForKey:UIImagePickerControllerMediaType];
    
    UIImage *image = info[UIImagePickerControllerEditedImage];
    
    NSData *mediaData;
    
    NSString * filePath = NSTemporaryDirectory();
    
    DFMediaUploadType uploadType;
    
    // delete old file
    if (self.currentView.hasMedia) {
        [[NSFileManager defaultManager] removeItemAtPath:self.currentView.mediaFilePath error:nil];
    }
    
    if ([mediaType isEqualToString:(NSString*)kUTTypeImage]){
        uploadType = DFMediaUploadTypeImage;
        
        mediaData = UIImageJPEGRepresentation(image, 0.9f);
        filePath = [filePath stringByAppendingPathComponent:[Utility getUniqueId]];
        filePath = [filePath stringByAppendingPathExtension:@"jpg"];
        NSLog(@"found a photo.  saving to: %@", filePath);
    }
    
    else if ([mediaType isEqualToString:(NSString*)kUTTypeMovie]){
        uploadType = DFMediaUploadTypeVideo;
        
        NSURL *videoURL = [info objectForKey:UIImagePickerControllerMediaURL];
        
        NSLog(@"found a video.  saving to: %@", videoURL);
        
        mediaData = [NSData dataWithContentsOfURL:videoURL];
        
        filePath = [filePath stringByAppendingPathComponent:[Utility getUniqueId]];
        filePath = [filePath stringByAppendingPathExtension:videoURL.pathExtension];
        
        // get video preview
        AVURLAsset *asset = [[AVURLAsset alloc] initWithURL:videoURL options:nil];
        AVAssetImageGenerator *gen = [[AVAssetImageGenerator alloc] initWithAsset:asset];
        gen.appliesPreferredTrackTransform = YES;
        CMTime time = CMTimeMakeWithSeconds(0.0, 600);
        NSError *error = nil;
        CMTime actualTime;
        
        CGImageRef cgImage = [gen copyCGImageAtTime:time actualTime:&actualTime error:&error];
        image = [[UIImage alloc] initWithCGImage:cgImage];
        CGImageRelease(cgImage);
        
    } else return;
    
    
    if ([mediaData writeToFile:filePath atomically:YES]) {
        self.currentView.image = image;
        self.currentView.hasMedia = true;
        self.currentView.mediaFilePath = filePath;
        self.currentView.uploadType = uploadType;
    } else {
        // handle error
        self.currentView.hasMedia = false;
    }
    
    if ([self.delegate respondsToSelector:@selector(mediaUploadManager:didSelectMediaForView:)]) {
        [self.delegate mediaUploadManager:self didSelectMediaForView:self.currentView];
    }
    
    [picker dismissViewControllerAnimated:YES completion:nil];
    
    self.currentView = nil;
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker{
    [picker dismissViewControllerAnimated:YES completion:nil];
    self.currentView = nil;
}
#pragma mark - Media Uploading

- (void)uploadMediaFiles {
    [self uploadNextMediaFile];
}

- (BOOL)hasMedia {
    for (DFMediaUploadView *view in self.mediaUploadViews) {
        if (view.hasMedia) {
            return true;
        }
    }
    return false;
}

- (void)uploadNextMediaFile {
    // upload next image
    for (DFMediaUploadView *nextView in self.mediaUploadViews) {
        if ([self uploadMediaFileForView:nextView]) return;
    }
    // if the code has gotten this far, it means all uploads are done.
    
    if ([self.delegate respondsToSelector:@selector(mediaUploadManagerDidFinishAllUploads:)]) {
        [self.delegate mediaUploadManagerDidFinishAllUploads:self];
    }
}

- (BOOL)uploadMediaFileForView:(DFMediaUploadView*)mediaUploadView {
    if (mediaUploadView.hasMedia && !mediaUploadView.uploaded) {
        if (mediaUploadView.uploadType == DFMediaUploadTypeImage) {
            [self uploadImageFileForMediaView:mediaUploadView];
            return true;
        } else if (mediaUploadView.uploadType == DFMediaUploadTypeVideo) {
            // enqueue video upload with completion block
            [self uploadVideoFileForMediaView:mediaUploadView];
            return true;
        } else if (mediaUploadView.uploadType == DFMediaUploadTypeNone) {
            [self handleOtherTypeForMediaView:mediaUploadView];
            return true;
        }
    }
    return false;
}
- (void)checkIfUploadingIsDone {
    int i = 0;
    for (DFMediaUploadView *view in self.mediaUploadViews) {
        if (view.uploaded) {
            i++;
        }
    }
    if (i == self.mediaUploadViews.count) {
        // yes!
        if ([self.delegate respondsToSelector:@selector(mediaUploadManagerDidFinishAllUploads:)]) {
            [self.delegate mediaUploadManagerDidFinishAllUploads:self];
        }
    }
}

#pragma mark - AWS
// Uploads an image file to AWS

- (void)uploadImageFileForMediaView:(DFMediaUploadView*)mediaUploadView {
    
    NSURL *fileURL =[NSURL fileURLWithPath:mediaUploadView.mediaFilePath];
    NSString *fileName = fileURL.lastPathComponent;
    //NSData *imageData = [NSData dataWithContentsOfURL:fileURL];
    NSString *resourceKey;
    if ([self.delegate respondsToSelector:@selector(resourceKeyForMediaUploadView:inMediaUploadManager:)]) {
        resourceKey = [self.delegate resourceKeyForMediaUploadView:mediaUploadView inMediaUploadManager:self] ?: fileName;
    } else {
        resourceKey = fileName;
        NSLog(@"No resource name was given by the delegate because it does not implement the appropriate method.  Implement -resourceKeyForMediaUploadView: to fix this.  Using resource key %@.", resourceKey);
    }
    
    AWSS3TransferManagerUploadRequest *uploadRequest = [AWSS3TransferManagerUploadRequest new];
    uploadRequest.body = fileURL;
    uploadRequest.key = resourceKey;
    uploadRequest.bucket = kS3BucketName;
    uploadRequest.contentType = @"image/jpeg";
    
    AWSS3TransferManager *transferManager = [AWSS3TransferManager defaultS3TransferManager];
    
    mediaUploadView.uploading = true;
    mediaUploadView.progressView.progress = 0.0f;
    
    __weak DFMediaUploadManager *weakSelf = self;
    [[transferManager upload:uploadRequest] continueWithBlock:^id(AWSTask *task) {
        if (task.error) {
            dispatch_async(dispatch_get_main_queue(), ^{
                DFMediaUploadManager *strongSelf = weakSelf;
                [strongSelf handleUploadError:task.error forMediaUploadView:mediaUploadView];
            });
        }
        
        if (task.result) {
            dispatch_async(dispatch_get_main_queue(), ^{
                DFMediaUploadManager *strongSelf = weakSelf;
                NSString *imageURLString = [NSString stringWithFormat:@"https://%@.amazonaws.com/%@/%@", kS3URLSubdomain, kS3BucketName, resourceKey];
                
                mediaUploadView.publicURLString = imageURLString;
                mediaUploadView.resourceKey = resourceKey;
                
                [strongSelf handleUploadSuccessResult:nil forMediaUploadView:mediaUploadView];
            });
        }
        
        return nil;
    }];
    [uploadRequest setUploadProgress:^(int64_t bytesSent, int64_t totalBytesSent, int64_t totalBytesExpectedToSend) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [mediaUploadView.progressView setProgress:(float)((double)totalBytesSent / (double)totalBytesExpectedToSend)];
        });
    }];
    
}

#pragma mark - Viddler
// Uploads a video to viddler
- (void)uploadVideoFileForMediaView:(DFMediaUploadView*)mediaUploadView {
    // Use Viddler to upload video data
    NSURL *fileURL = [NSURL URLWithString:mediaUploadView.mediaFilePath];
    NSString *fileName = fileURL.lastPathComponent;
    
    NSData *videoData = [NSData dataWithContentsOfFile:mediaUploadView.mediaFilePath];
    
    if (videoData == nil) {
        return; // something went wrong!
    }
    
    mediaUploadView.uploading = true;
    
    // adapted from FocusForums app (below)
    
    __weak __typeof(self) wself = self;
    
    AFHTTPClient *authClient = [[AFHTTPClient alloc] initWithBaseURL:[NSURL URLWithString:kFFGetViddlerCredentialsURL]];
    
    authClient.parameterEncoding = AFJSONParameterEncoding;
    
    
    [authClient postPath:@"" parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        
        __typeof__(wself) sself = wself;
        if (!sself) { return; }
        
        NSDictionary *response = responseObject;
        // NSString *tags = [NSString stringWithFormat:@"GROUP_%@_Thread_%@_Author_%@", sself.groupName, sself.threadID, sself.authorID];
        NSString *description = @"UploadedFile";
        //http://api.viddler.com/api/v2/viddler.videos.upload.json?key=[key]&sessionid=[sessionid]&title=[title]&description=[description]&tags=[tags]&make_public=0
        NSString* url = [response[@"url"] stringByReplacingOccurrencesOfString:@"xml" withString:@"json"];
        // NSString *path = [NSString stringWithFormat:@"%@?key=%@&sessionid=%@&title=%@&description=%@&tags=%@&make_public=0", url, response[@"key"], response[@"sessionid"], title, description, tags];
        NSString *path = [NSString stringWithFormat:@"%@?key=%@&sessionid=%@&title=%@&description=%@&make_public=0", url, response[@"key"], response[@"sessionid"], fileName, description];
        
        
        AFHTTPClient *uploadClient = [[AFHTTPClient alloc] initWithBaseURL:[NSURL URLWithString:kViddlerAPIURL]];
        
        
        
        
        NSMutableURLRequest *urlRequest = [uploadClient multipartFormRequestWithMethod:@"POST" path:path parameters:nil constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
            [formData appendPartWithFileData:videoData
                                        name:@"file"
                                    fileName:fileName
                                    mimeType:@"multipart/form-data"];
        }];
        
        AFHTTPRequestOperation *uploadOperation = [[AFHTTPRequestOperation alloc] initWithRequest:urlRequest];
        
        
        [uploadOperation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id response) {
            __typeof(self) strongSelf = wself;
            dispatch_async(dispatch_get_main_queue(), ^{
                id errorObj = response[@"error"];
                if (errorObj == nil)
                {
                    
                    
                    mediaUploadView.publicURLString = response[@"video"][@"url"];
                    mediaUploadView.resourceKey = response[@"video"][@"id"];
                    [strongSelf handleUploadSuccessResult:response[@"video"] forMediaUploadView:mediaUploadView];
                }
                else
                {
                    NSDictionary *userInfo = errorObj;
                    NSError *error = [[NSError alloc] initWithDomain:errorObj code:[userInfo[@"code"] integerValue] userInfo:userInfo];
                    [strongSelf handleUploadError:error forMediaUploadView:mediaUploadView];
                }
                
            });
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            dispatch_async(dispatch_get_main_queue(), ^{
                __typeof(self) strongSelf = wself;
                [strongSelf handleUploadError:error forMediaUploadView:mediaUploadView];
            });
        }];
        
        [uploadOperation setUploadProgressBlock:^(NSUInteger bytesWritten, long long totalBytesWritten, long long totalBytesExpectedToWrite) {
            dispatch_async(dispatch_get_main_queue(), ^{
                mediaUploadView.progressView.progress = (float)((double)totalBytesWritten / (double)totalBytesExpectedToWrite);
            });
        }];
        [uploadClient enqueueHTTPRequestOperation:uploadOperation];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        dispatch_async(dispatch_get_main_queue(), ^{
            __typeof(self) strongSelf = wself;
            [strongSelf handleUploadError:error forMediaUploadView:mediaUploadView];
        });
    }];
}

#pragma mark - Other filetypes

- (void)handleOtherTypeForMediaView:(DFMediaUploadView*)mediaUploadView {
    
    if (mediaUploadView.publicURLString) {
        [self handleUploadSuccessResult:nil forMediaUploadView:mediaUploadView];
    } else {
        [self handleUploadError:nil forMediaUploadView:mediaUploadView];
    }
}

#pragma mark - Errors and Successes

- (void)handleUploadError:(NSError*)error forMediaUploadView:(DFMediaUploadView*)mediaUploadView {
    
    mediaUploadView.uploading = false;
    mediaUploadView.error = true;
    if ([self.delegate respondsToSelector:@selector(mediaUploadManager:didFailToUploadForView:)]) {
        [self.delegate mediaUploadManager:self didFailToUploadForView:mediaUploadView];
    }
}

- (void)handleUploadSuccessResult:(NSDictionary*)result forMediaUploadView:(DFMediaUploadView*)mediaUploadView {
    
    if ([self.delegate respondsToSelector:@selector(mediaUploadManager:didFinishUploadingForView:)]) {
        [self.delegate mediaUploadManager:self didFinishUploadingForView:mediaUploadView];
    }
    mediaUploadView.uploaded = true;
    mediaUploadView.uploading = false;
    
    [self uploadNextMediaFile];
}

@end
