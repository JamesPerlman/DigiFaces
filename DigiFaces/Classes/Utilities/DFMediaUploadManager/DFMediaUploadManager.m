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

#import <QBImagePickerController/QBImagePickerController.h>

@interface DFMediaUploadManager ()<QBImagePickerControllerDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UIActionSheetDelegate, DFMediaUploadViewDelegate> {
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
        
        self.maximumNumberOfSelection = 1;
        
    }
    return self;
}

- (void)presentMediaSelectionDialog {
    UIActionSheet * actionSheet = [[UIActionSheet alloc] initWithTitle:DFLocalizedString(@"view.misc.photo_uploader.select_image", nil) delegate:self cancelButtonTitle:DFLocalizedString(@"view.misc.photo_uploader.cancel", nil) destructiveButtonTitle:nil otherButtonTitles:DFLocalizedString(@"view.misc.photo_uploader.camera", nil), DFLocalizedString(@"view.misc.photo_uploader.library", nil), nil];
    [actionSheet showInView:((UIViewController*)self.viewController).view];
}

- (void)monitorAppState {
    [self stopMonitoringAppState];
    
    NSNotificationCenter *NC = [NSNotificationCenter defaultCenter];
    [NC addObserver:self selector:@selector(applicationDidEnterForeground) name:UIApplicationDidBecomeActiveNotification object:nil];
    [NC addObserver:self selector:@selector(applicationWillEnterBackground) name:UIApplicationWillResignActiveNotification object:nil];
}

- (void)stopMonitoringAppState {
    NSNotificationCenter *NC = [NSNotificationCenter defaultCenter];
    [NC removeObserver:self name:UIApplicationDidBecomeActiveNotification object:nil];
    [NC removeObserver:self name:UIApplicationWillResignActiveNotification object:nil];
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
    } else if (!view.hasMedia) {
        [self presentMediaSelectionDialog];
    }
}
#pragma mark - UIActionSheetDelegate
-(void)actionSheet:(UIActionSheet *)actionSheet didDismissWithButtonIndex:(NSInteger)buttonIndex
{
    if (!self.currentView) {
        for (DFMediaUploadView *view in self.mediaUploadViews) {
            if (!view.hidden) {
                self.currentView = view;
                break;
            }
        }
    }
    if (buttonIndex == 0 && [UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
        // Camera
        [self initializeCameraImagePicker];
    }
    else if (buttonIndex == 1 && [UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypePhotoLibrary]){
        // Library
//        [self initializeQBImagePicker];
        [self initializeImagePickerWithSourceType:UIImagePickerControllerSourceTypePhotoLibrary];
    }
    else{
        return;
    }
    //    [self initializeImagePickerWithSourceType:type];
}

#pragma mark - ImagePicker initialization

-(void)initializeQBImagePicker
{
    _qbImagePickerController = nil;
    NSArray *mediaTypes = @[];
    if (self.currentView.allowsVideo) {
        mediaTypes = @[@(PHAssetCollectionSubtypeSmartAlbumVideos)];
    }
    
    if (self.currentView.allowsPhoto) {
        mediaTypes = [mediaTypes arrayByAddingObject:@(PHAssetCollectionSubtypeSmartAlbumUserLibrary)];
    }
    
    if (mediaTypes.count) {
        self.qbImagePickerController.assetCollectionSubtypes = mediaTypes;
        [self.viewController presentViewController:self.qbImagePickerController animated:YES completion:nil];
    }
    
    self.qbImagePickerController.maximumNumberOfSelection = self.maximumNumberOfSelection;
    
}

- (void)initializeImagePickerWithSourceType:(UIImagePickerControllerSourceType)sourceType {
    self.imagePickerController.sourceType = sourceType;
    self.imagePickerController.allowsEditing = YES;
    NSArray *mediaTypes = @[];
    if (self.currentView.allowsVideo) {
        mediaTypes = @[(NSString*)kUTTypeMovie];
    }
    
    if (self.currentView.allowsPhoto) {
        mediaTypes = [mediaTypes arrayByAddingObject:(NSString*)kUTTypeImage];
    }
    
    if (mediaTypes.count) {
        self.imagePickerController.mediaTypes = mediaTypes;
        [self.viewController presentViewController:self.imagePickerController animated:YES completion:nil];
    }

}
-(void)initializeCameraImagePicker
{
    [self initializeImagePickerWithSourceType:UIImagePickerControllerSourceTypeCamera];
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


- (void)updateMediaView:(DFMediaUploadView*)mediaView withImage:(UIImage*)image {
    [self updateMediaView:mediaView withImage:image data:nil type:DFMediaUploadTypeImage];
}

- (void)updateMediaView:(DFMediaUploadView*)mediaView withImage:(UIImage*)image data:(NSData*)data type:(DFMediaUploadType)mediaType {
    
    // delete old file
    if (mediaView.hasMedia && mediaView.mediaFilePath) {
        NSFileManager *mgr = [NSFileManager defaultManager];
        if ([mgr fileExistsAtPath:mediaView.mediaFilePath]) {
            [mgr removeItemAtPath:mediaView.mediaFilePath error:nil];
        }
    }
    
    NSString * fileName = [Utility getUniqueId];
    NSString * filePath = [NSTemporaryDirectory() stringByAppendingPathComponent:fileName];
    
    NSData *mediaData = data;
    
    if (mediaType == DFMediaUploadTypeImage) {
        mediaData = UIImageJPEGRepresentation(image, 0.9f);
    }
    
    
    if ([mediaData writeToFile:filePath atomically:YES]) {
        mediaView.image = image;
        mediaView.hasMedia = true;
        mediaView.mediaFilePath = filePath;
        mediaView.uploadType = mediaType;
    } else {
        // handle error
        mediaView.hasMedia = false;
        mediaView.image = nil;
    }
    
    if ([self.delegate respondsToSelector:@selector(mediaUploadManager:didSelectMediaForView:)]) {
        [self.delegate mediaUploadManager:self didSelectMediaForView:mediaView];
    }
    
}


- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    
    NSString *mediaType = [info objectForKey:UIImagePickerControllerMediaType];
    
    UIImage *image = info[UIImagePickerControllerEditedImage];
    
    
    if ([mediaType isEqualToString:(NSString*)kUTTypeImage]){
        
        [self updateMediaView:self.currentView withImage:image];
        
        // save photo to phone
        
        if (picker.sourceType == UIImagePickerControllerSourceTypeCamera) {
            UIImageWriteToSavedPhotosAlbum(image, nil, nil, nil);
        }
    }
    
    else if ([mediaType isEqualToString:(NSString*)kUTTypeMovie]){
        
        NSURL *videoURL = [info objectForKey:UIImagePickerControllerMediaURL];
        
        NSData *mediaData = [NSData dataWithContentsOfURL:videoURL];
        
        // get video preview
        AVURLAsset *asset = [[AVURLAsset alloc] initWithURL:videoURL options:nil];
        image = [self imageForAVURLAsset:asset];
        
        [self updateMediaView:self.currentView withImage:image data:mediaData type:DFMediaUploadTypeVideo];
        
        // save video to phone
        if (picker.sourceType == UIImagePickerControllerSourceTypeCamera && UIVideoAtPathIsCompatibleWithSavedPhotosAlbum([videoURL path])) {
            UISaveVideoAtPathToSavedPhotosAlbum([videoURL path], nil, nil, nil);
        }
        
    } else return;
    
    
    [picker dismissViewControllerAnimated:YES completion:nil];
    
    self.currentView = nil;
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker{
    [picker dismissViewControllerAnimated:YES completion:nil];
    self.currentView = nil;
}

#pragma mark - QBImagePickerController


- (QBImagePickerController*)qbImagePickerController {
    if (!_qbImagePickerController) {
        _qbImagePickerController = [[QBImagePickerController alloc] init];
        _qbImagePickerController.delegate = self;
        _qbImagePickerController.allowsMultipleSelection = true;
        _qbImagePickerController.showsNumberOfSelectedAssets = true;
        _qbImagePickerController.mediaType = QBImagePickerMediaTypeAny;
    }
    
    return _qbImagePickerController;
}

- (void)qb_imagePickerController:(QBImagePickerController *)imagePickerController didFinishPickingAssets:(NSArray *)assets {
    
    PHImageManager *imageManager = [PHImageManager defaultManager];
    for (PHAsset *asset in assets) {
        
        // get next available media view
        DFMediaUploadView *targetView = nil;
        for (DFMediaUploadView *mediaUploadView in self.mediaUploadViews) {
            if (!mediaUploadView.hasMedia && !mediaUploadView.hidden) {
                targetView = mediaUploadView;
                break;
            }
        }
        
        if (targetView) {
            CGSize assetSize = CGSizeMake((CGFloat)asset.pixelWidth, (CGFloat)asset.pixelHeight);
            
            // if it's a photo...
            if (asset.mediaType == PHAssetMediaTypeImage) {
                targetView.hasMedia = true;
                // request UIImage for PHAsset
                
                PHImageRequestOptions *options = [[PHImageRequestOptions alloc]init];
                options.synchronous  = YES;
                defwself
                [imageManager requestImageForAsset:asset
                                        targetSize:assetSize
                                       contentMode:PHImageContentModeDefault
                                           options:options
                                     resultHandler:^(UIImage *result, NSDictionary *info) {
                                         dispatch_async(dispatch_get_main_queue(), ^{
                                             defsself
                                             if (sself) {
                                                 [sself updateMediaView:targetView withImage:result];
                                             }
                                         });
                                     }];
                
            }
            // if it's a video...
            else if (asset.mediaType == PHAssetMediaTypeVideo) {
                targetView.hasMedia = true;
                // request AVAsset for PHAsset
                
                PHVideoRequestOptions *options = [[PHVideoRequestOptions alloc]init];
                options.deliveryMode = PHVideoRequestOptionsDeliveryModeFastFormat;
                defwself
                [imageManager requestAVAssetForVideo:asset
                                             options:options
                                       resultHandler:^(AVAsset *asset, AVAudioMix *audioMix, NSDictionary *info) {
                                           dispatch_async(dispatch_get_main_queue(), ^{
                                               defsself
                                               if (sself) {
                                                   [sself cropAndScaleAsset:asset toWidth:360 height:640 completion:^(AVURLAsset *urlAsset) {
                                                       __strong __typeof(wself) ssself = wself;
                                                       if (ssself) {
                                                           UIImage *image = [sself imageForAVURLAsset:urlAsset];
                                                           NSData *mediaData = [NSData dataWithContentsOfURL:urlAsset.URL];
                                                           [ssself updateMediaView:targetView withImage:image data:mediaData type:DFMediaUploadTypeVideo];
                                                       }
                                                   }];
                                               }
                                           });
                                       }];
            }
        }
    }
    [imagePickerController dismissViewControllerAnimated:YES completion:nil];
}
- (void)qb_imagePickerControllerDidCancel:(QBImagePickerController *)imagePickerController {
    [imagePickerController dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - Media Uploading

- (void)uploadMediaFiles {
    [self monitorAppState];
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
    [self didFinishUploading];
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
        } /* else if (mediaUploadView.uploadType == DFMediaUploadTypeNone) {
           [self handleOtherTypeForMediaView:mediaUploadView];
           return true;
           }*/
    }
    return false;
}

- (BOOL)isUploadingDone {
    int i = 0;
    int n = 0;
    for (DFMediaUploadView *view in self.mediaUploadViews) {
        if (view.uploaded) {
            i++;
        }
        if (view.hasMedia) {
            n++;
        }
    }
    return i==n;
}

- (void)didFinishUploading {
    if ([self.delegate respondsToSelector:@selector(mediaUploadManagerDidFinishAllUploads:)]) {
        [self.delegate mediaUploadManagerDidFinishAllUploads:self];
    }
    [self stopMonitoringAppState];
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
    
    NSString *imageURLString = [NSString stringWithFormat:@"https://%@.amazonaws.com/%@/%@", kS3URLSubdomain, kS3BucketName, resourceKey];
    
    mediaUploadView.publicURLString = imageURLString;
    mediaUploadView.resourceKey = resourceKey;
    
    
    
    
    id (^uploadBlock)(AWSTask *task) = [self getAWSUploadBlockForMediaView:mediaUploadView];
    
    [[transferManager upload:uploadRequest] continueWithBlock:uploadBlock];
    
    [uploadRequest setUploadProgress:^(int64_t bytesSent, int64_t totalBytesSent, int64_t totalBytesExpectedToSend) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [mediaUploadView.progressView setProgress:(float)((double)totalBytesSent / (double)totalBytesExpectedToSend)];
        });
    }];
    
}

- (void)applicationWillEnterBackground {
    NSLog(@"Application is entering background.");
}

- (void)applicationDidEnterForeground {
    NSLog(@"Application entered foreground.");
}

- (id (^)(AWSTask *task))getAWSUploadBlockForMediaView:(DFMediaUploadView*)mediaUploadView {
    __weak DFMediaUploadManager *weakSelf = self;
    return ^id(AWSTask *task) {
        dispatch_async(dispatch_get_main_queue(), ^{
            if (task.error) {
                DFMediaUploadManager *strongSelf = weakSelf;
                [strongSelf handleUploadError:task.error forMediaUploadView:mediaUploadView];
            } else if (task.result) {
                DFMediaUploadManager *strongSelf = weakSelf;
                [strongSelf handleUploadSuccessResult:nil forMediaUploadView:mediaUploadView];
            }
        });
        
        return nil;
    };
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
        NSError* error;
        
        NSDictionary *response = [NSJSONSerialization JSONObjectWithData:responseObject options:kNilOptions error:&error];
        // NSString *tags = [NSString stringWithFormat:@"GROUP_%@_Thread_%@_Author_%@", sself.groupName, sself.threadID, sself.authorID];
        NSString *description = @"UploadedFile";
        //http://api.viddler.com/api/v2/viddler.videos.upload.json?key=[key]&sessionid=[sessionid]&title=[title]&description=[description]&tags=[tags]&make_public=0
        NSString* url = [response[@"url"] stringByReplacingOccurrencesOfString:@"xml" withString:@"json"];
        // NSString *path = [NSString stringWithFormat:@"%@?key=%@&sessionid=%@&title=%@&description=%@&tags=%@&make_public=0", url, response[@"key"], response[@"sessionid"], title, description, tags];
        NSString *path = [NSString stringWithFormat:@"%@?key=%@&sessionid=%@&title=%@&description=%@&make_public=0", url, response[@"key"], response[@"sessionid"], fileName, description];
        
        
        AFHTTPClient *uploadClient = [[AFHTTPClient alloc] initWithBaseURL:[NSURL URLWithString:kViddlerAPIURL]];
        
        
        
        //path = @"http://192.168.0.2/~home/DigiFaces/upload.php";
        NSMutableURLRequest *urlRequest = [uploadClient multipartFormRequestWithMethod:@"POST" path:path parameters:nil constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
            [formData appendPartWithFileData:videoData
                                        name:@"file"
                                    fileName:fileName
                                    mimeType:@"multipart/form-data"];
        }];
        
        AFHTTPRequestOperation *uploadOperation = [[AFHTTPRequestOperation alloc] initWithRequest:urlRequest];
        
        
        [uploadOperation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
            __typeof(self) strongSelf = wself;
            dispatch_async(dispatch_get_main_queue(), ^{
                
                NSError* error;
                
                NSDictionary *response = [NSJSONSerialization JSONObjectWithData:responseObject options:kNilOptions error:&error];
                id errorObj;
                if (error) {
                    errorObj = error.description;
                } else {
                    errorObj = response[@"error"];
                }
                if (errorObj == nil)
                {
                    
                    
                    mediaUploadView.publicURLString = response[@"video"][@"url"];
                    mediaUploadView.resourceKey = response[@"video"][@"id"];
                    [strongSelf handleUploadSuccessResult:response[@"video"] forMediaUploadView:mediaUploadView];
                }
                else
                {
                    NSError *error;
                    if ([errorObj isKindOfClass:[NSDictionary class]]) {
                        NSDictionary *userInfo = errorObj;
                        error = [[NSError alloc] initWithDomain:errorObj code:[userInfo[@"code"] integerValue] userInfo:userInfo];
                    } else {
                        NSString *errorString = [NSString stringWithFormat:@"%@", errorObj];
                        error = [[NSError alloc] initWithDomain:@"Unknown" code:0 userInfo:@{NSLocalizedDescriptionKey : errorString}];
                    }
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
        
        [uploadOperation setShouldExecuteAsBackgroundTaskWithExpirationHandler:nil];
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
    NSLog(@"%@", error);
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
    
    // delete the file for this view
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSString *filePath = mediaUploadView.mediaFilePath;
    if ([fileManager fileExistsAtPath:filePath]) {
        [fileManager removeItemAtPath:filePath error:nil];
    }
    
    [self uploadNextMediaFile];
}


#pragma mark - Helper Methods

- (UIImage*)imageForAVURLAsset:(AVURLAsset*)asset {
    AVAssetImageGenerator *gen = [[AVAssetImageGenerator alloc] initWithAsset:asset];
    gen.appliesPreferredTrackTransform = YES;
    CMTime time = CMTimeMakeWithSeconds(0.0, 600);
    NSError *error = nil;
    CMTime actualTime;
    
    CGImageRef cgImage = [gen copyCGImageAtTime:time actualTime:&actualTime error:&error];
    UIImage *image = [[UIImage alloc] initWithCGImage:cgImage];
    CGImageRelease(cgImage);
    
    return image;
}

- (NSInteger)numberOfUnusedMediaViews {
    NSInteger n = 0;
    for (DFMediaUploadView *view in self.mediaUploadViews) {
        if (!view.hasMedia && !view.hidden) {
            ++n;
        }
    }
    
    return n;
}

- (void)cropAndScaleAsset:(AVAsset*)asset toWidth:(CGFloat)desiredWidth height:(CGFloat)desiredHeight completion:(void(^)(AVURLAsset* urlAsset))completionHandler {
    
    
    //create an avassetrack with our asset
    AVAssetTrack *clipVideoTrack = [[asset tracksWithMediaType:AVMediaTypeVideo] objectAtIndex:0];
    
    //create a video composition and preset some settings
    AVMutableVideoComposition* videoComposition = [AVMutableVideoComposition videoComposition];
    videoComposition.frameDuration = CMTimeMake(1, 30);
    
    //here we are setting its render size to its height x height (Square)
    CGFloat originalWidth = clipVideoTrack.naturalSize.width;
    CGFloat originalHeight = clipVideoTrack.naturalSize.height;
    CGFloat cropToWidth, cropToHeight;
    
    
    if (desiredHeight > desiredWidth) {
        if (desiredHeight > originalHeight) {
            // use original height
            cropToHeight = originalHeight;
        } else { // desiredHeight <= originalHeight
            // use desired height
            cropToHeight = desiredHeight;
        }
        cropToWidth = desiredWidth / desiredHeight * cropToHeight;
    } else { // desiredWidth >= desiredHeight
        if (originalWidth > desiredWidth) {
            cropToWidth = originalWidth;
        } else { // originalWidth <= desiredWidth
            cropToWidth = desiredWidth;
        }
        cropToHeight = desiredHeight / desiredWidth * cropToWidth;
    }
    
    CGFloat scale = cropToWidth / originalWidth;
    
    videoComposition.renderSize = CGSizeMake(desiredWidth, desiredHeight);
    
    //create a video instruction
    AVMutableVideoCompositionInstruction *instruction = [AVMutableVideoCompositionInstruction videoCompositionInstruction];
    instruction.timeRange = CMTimeRangeMake(kCMTimeZero, CMTimeMakeWithSeconds(60, 30));
    
    AVMutableVideoCompositionLayerInstruction* transformer = [AVMutableVideoCompositionLayerInstruction videoCompositionLayerInstructionWithAssetTrack:clipVideoTrack];
    
    //Here we shift the viewing square up to the TOP of the video so we only see the top
    //CGAffineTransform t1 = CGAffineTransformMakeTranslation(clipVideoTrack.naturalSize.height, 0 );
    
    CGAffineTransform t = CGAffineTransformMakeScale(scale, scale);
    
    //Use this code if you want the viewing square to be in the middle of the video
    CGAffineTransform t1 = CGAffineTransformTranslate(t, originalHeight, -(originalWidth - originalHeight) /2 );
    
    //Make sure the square is portrait
    CGAffineTransform t2 = CGAffineTransformRotate(t1, M_PI_2);
    
    // scale?
    CGAffineTransform t3 = CGAffineTransformScale(t2, scale, scale);
    
    CGAffineTransform finalTransform = t;
    [transformer setTransform:finalTransform atTime:kCMTimeZero];
    
    //add the transformer layer instructions, then add to video composition
    instruction.layerInstructions = [NSArray arrayWithObject:transformer];
    videoComposition.instructions = [NSArray arrayWithObject: instruction];
    
    //Create an Export Path to store the cropped video
    NSString * documentsPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    NSString *exportPath = [documentsPath stringByAppendingFormat:@"/CroppedVideo.mov"];
    NSURL *exportUrl = [NSURL fileURLWithPath:exportPath];
    
    //Remove any prevouis videos at that path
    [[NSFileManager defaultManager]  removeItemAtURL:exportUrl error:nil];
    
    //Export
    AVAssetExportSession *session = [[AVAssetExportSession alloc] initWithAsset:asset presetName:AVAssetExportPresetHighestQuality] ;
    session.videoComposition = videoComposition;
    session.outputURL = exportUrl;
    session.outputFileType = AVFileTypeQuickTimeMovie;
    
    [session exportAsynchronouslyWithCompletionHandler:^
     {
         if (completionHandler) {
             dispatch_async(dispatch_get_main_queue(), ^{
                 //Call when finished
                 //Play the New Cropped video
                 NSURL *outputURL = session.outputURL;
                 AVURLAsset* asset = [AVURLAsset URLAssetWithURL:outputURL options:nil];
                 completionHandler(asset);
             });
         }
     }];
}

@end
