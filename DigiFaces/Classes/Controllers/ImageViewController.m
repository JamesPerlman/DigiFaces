//
//  ImageViewController.m
//  DigiFaces
//
//  Created by confiz on 16/07/2015.
//  Copyright (c) 2015 Usasha studio. All rights reserved.
//

#import "ImageViewController.h"
#import "UIImageView+AFNetworking.h"
#import "MBProgressHUD.h"

@interface ImageViewController () <UIScrollViewDelegate>

@end

@implementation ImageViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self.view setBackgroundColor:[UIColor lightGrayColor]];
    [_imageView setFrame:CGRectMake(0, 0, _scrollView.frame.size.width, _scrollView.frame.size.height)];
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    NSURLRequest * request = [NSURLRequest requestWithURL:[NSURL URLWithString:_imageFile.filePathURLString]];
    [_imageView setImageWithURLRequest:request placeholderImage:nil success:^(NSURLRequest *request, NSHTTPURLResponse *response, UIImage *image) {
        
        [_imageView setImage:image];
        [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
    } failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error) {
        NSLog(@"Failed to download Image");
        [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
    }];
    
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [_scrollView setZoomScale:1];
    
    if ([_delegate respondsToSelector:@selector(pageViewDidAppear:)]) {
        [_delegate pageViewDidAppear:self];
    }
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

-(UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView
{
    return _imageView;
}

- (IBAction)doubleClicked:(id)sender {
    if (_scrollView.zoomScale <5) {
        [_scrollView setZoomScale:5 animated:YES];
    }
    else{
        [_scrollView setZoomScale:1 animated:YES];
    }
}
@end
