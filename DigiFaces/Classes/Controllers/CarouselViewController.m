//
//  CarouselViewController.m
//  DigiFaces
//
//  Created by confiz on 16/07/2015.
//  Copyright (c) 2015 Usasha studio. All rights reserved.
//

#import "CarouselViewController.h"
#import "WebViewController.h"
#import "ImageViewController.h"
#import "File.h"

@interface CarouselViewController () <UIPageViewControllerDataSource, UIPageViewControllerDelegate>

@property (nonatomic, retain) NSMutableArray * controllers;

@end

@implementation CarouselViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _controllers = [[NSMutableArray alloc] init];
    for (File * file in self.files) {
        if ([file.fileType isEqualToString:@"Image"]) {
            ImageViewController * imageController = [self.storyboard instantiateViewControllerWithIdentifier:@"imageController"];
            imageController.imageFile = file;
            [self.controllers addObject:imageController];
        }
        else
        {
            WebViewController * webController = [self.storyboard instantiateViewControllerWithIdentifier:@"webController"];
            webController.url = file.filePath;
            [self.controllers addObject:webController];
        }
    }
    
    [self setViewControllers:@[_controllers[_selectedIndex]] direction:UIPageViewControllerNavigationDirectionForward animated:YES completion:nil];
    self.dataSource = self;
    // Do any additional setup after loading the view.
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


-(UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerAfterViewController:(UIViewController *)viewController
{
    NSLog(@"Controller");
    
    for (int i=0; i<_controllers.count; i++) {
        UIViewController * controller = [_controllers objectAtIndex:i];
        if ([viewController isEqual:controller]) {
            if (i+1<_controllers.count) {
                return [_controllers objectAtIndex:i+1];
            }
        }
    }
    
    return nil;
}

-(UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerBeforeViewController:(UIViewController *)viewController
{
    
    for (int i=0; i<_controllers.count; i++) {
        UIViewController * controller = [_controllers objectAtIndex:i];
        if ([viewController isEqual:controller]) {
            if (i-1>=0) {
                return [_controllers objectAtIndex:i-1];
            }
        }
    }
    return nil;
}

@end
