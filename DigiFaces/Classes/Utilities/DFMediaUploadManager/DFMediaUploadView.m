//
//  DFMediaUploadView.m
//  DigiFaces
//
//  Created by James on 7/21/15.
//  Copyright (c) 2015 Usasha studio. All rights reserved.
//

#import "DFMediaUploadView.h"
#import "DFMediaUploadManager.h"

@interface DFMediaUploadView ()

@property (nonatomic, weak) IBOutlet UIView *containerView;
@property (weak, nonatomic) IBOutlet UIImageView *cameraIconView;
@property (weak, nonatomic) IBOutlet UIImageView *videoIndicatorView;
@property (weak, nonatomic) IBOutlet UIButton *xButton;
@property (strong, nonatomic) IBOutlet UITapGestureRecognizer *tapGestureRecognizer;
@property (weak, nonatomic) IBOutlet UILabel *errorLabel;
@property (weak, nonatomic) IBOutlet UIImageView *checkMarkView;

@end

@implementation DFMediaUploadView

/*
 // Only override drawRect: if you perform custom drawing.
 // An empty implementation adversely affects performance during animation.
 - (void)drawRect:(CGRect)rect {
 // Drawing code
 }
 */

- (instancetype)initWithCoder:(NSCoder *)coder
{
    self = [super initWithCoder:coder];
    if (self) {
        [self initNib];
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self initNib];
    }
    return self;
}

#pragma mark - IBAction
- (IBAction)handleTap:(id)sender {
    [self.delegate didTapMediaUploadView:self];
}

- (IBAction)xButtonPress:(id)sender {
    // cancel upload?
    self.error = false;
    self.xButton.enabled = false;
    [UIView animateWithDuration:0.25 animations:^{
        self.cameraIconView.alpha = 1;
        self.videoIndicatorView.alpha = 0;
        self.imageView.alpha = 0;
        self.xButton.alpha = 0;
        self.progressView.alpha = 0;
    } completion:^(BOOL finished) {
        self.imageView.image = nil;
        self.imageView.alpha = 1;
        self.xButton.hidden = true;
        self.xButton.alpha = 1;
        self.xButton.enabled = true;
    }];
    if (self.hasMedia) {
        [[NSFileManager defaultManager] removeItemAtPath:self.mediaFilePath error:nil];
    }
    self.hasMedia = false;
}

#pragma mark - Property Accessors
- (void)setImage:(UIImage *)image {
    self.imageView.image = image;
}

- (UIImage*)image {
    return self.imageView.image;
}

- (NSData*)media {
    if (self.hasMedia && self.mediaFilePath) {
        return [NSData dataWithContentsOfFile:self.mediaFilePath];
    } else {
        return nil;
    }
}

- (void)setUploadType:(DFMediaUploadType)uploadType {
    if (uploadType == DFMediaUploadTypeImage) {
        self.cameraIconView.alpha = 0;
        self.videoIndicatorView.alpha = 0;
    } else if (uploadType == DFMediaUploadTypeVideo) {
        self.videoIndicatorView.alpha = 1;
        self.cameraIconView.alpha = 0;
    } else {
        return;
    }
    self.xButton.hidden = false;
    _uploadType = uploadType;
    
}

- (void)setUploading:(BOOL)uploading {
    _uploading = uploading;
    self.tapGestureRecognizer.enabled = !uploading;
    if (uploading) {
        self.xButton.enabled = false;
        [UIView animateWithDuration:0.25 animations:^{
            self.xButton.alpha = 0;
            self.progressView.alpha = 1;
            
        }];
    }
}

- (void)setUploaded:(BOOL)uploaded {
    _uploaded = uploaded;
    if (uploaded) {
        self.xButton.enabled = false;
        [UIView animateWithDuration:0.25 animations:^{
            self.xButton.alpha = 0;
            self.videoIndicatorView.alpha = 0;
            self.checkMarkView.alpha = 1;
        }];
    }
}

- (void)setError:(BOOL)error {
    _error = error;
    self.xButton.enabled = true;
    [UIView animateWithDuration:0.25 animations:^{
        self.xButton.alpha = 1;
        self.errorLabel.alpha = error ? 1.0f : 0.0f;
    }];
}


#pragma mark - Nib

- (void)initNib {
    
    [[NSBundle bundleForClass:[self class]] loadNibNamed:@"DFMediaUploadView" owner:self options:nil];
    [self addSubview: self.containerView];
    self.containerView.translatesAutoresizingMaskIntoConstraints = false;
    self.translatesAutoresizingMaskIntoConstraints = false;
    //[self addConstraints:[NSLayoutConstraint equalSizeAndCentersWithItem:self.containerView toItem:self]];
    NSDictionary *views = @{@"nib" : self.containerView};
    NSArray *v, *h;
    v = [NSLayoutConstraint constraintsWithVisualFormat:@"V:|[nib]|" options:0 metrics:nil views:views];
    h = [NSLayoutConstraint constraintsWithVisualFormat:@"H:|[nib]|" options:0 metrics:nil views:views];
    [self addConstraints:[v arrayByAddingObjectsFromArray:h]];
    
    self.progressView.layer.shadowRadius = 2.0f;
    self.progressView.layer.shadowColor = [UIColor whiteColor].CGColor;
    self.progressView.layer.shadowOffset = CGSizeZero;
    self.progressView.layer.shadowOpacity = 1.0f;
    
    self.xButton.layer.shadowRadius = 1.0f;
    self.xButton.layer.shadowColor = [UIColor blackColor].CGColor;
    self.xButton.layer.shadowOffset = CGSizeZero;
    self.xButton.layer.shadowOpacity = 1.0f;
    
    self.errorLabel.layer.cornerRadius = self.errorLabel.bounds.size.height/2.0f;
    self.errorLabel.clipsToBounds = true;
    
    
    self.checkMarkView.layer.shadowColor = [UIColor blackColor].CGColor;
    self.checkMarkView.layer.shadowOffset = CGSizeZero;
    self.checkMarkView.layer.shadowOpacity = 1.0f;
    self.checkMarkView.layer.shadowRadius = 1.0f;
    
    self.videoIndicatorView.layer.shadowColor = [UIColor blackColor].CGColor;
    self.videoIndicatorView.layer.shadowOffset = CGSizeZero;
    self.videoIndicatorView.layer.shadowOpacity = 1.0f;
    self.videoIndicatorView.layer.shadowRadius = 1.0f;
    
}

@end
