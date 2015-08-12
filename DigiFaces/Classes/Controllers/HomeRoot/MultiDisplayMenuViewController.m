//
//  MultiDisplayMenuViewController.m
//  DigiFaces
//
//  Created by James on 8/5/15.
//  Copyright (c) 2015 INET360. All rights reserved.
//

#import "MultiDisplayMenuViewController.h"
#import "NSLayoutConstraint+ConvenienceMethods.h"
#import <objc/runtime.h>

static NSTimeInterval MDMAnimationDuration = 0.5;
static NSString *mdmvc_assoc_key = @"MultiDisplayMenuViewControllerAssociatedKey";

@interface MultiDisplayMenuViewController () {
    NSMutableArray *_viewControllers;
}
@end

@implementation MultiDisplayMenuViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    _viewControllers = [NSMutableArray array];
    
    @try {
        [self performSegueWithIdentifier:@"init" sender:nil];
    } @catch (NSException *e) {
        NSLog(@"You better have some sorta plan!  No init segue found on %@.  Exception: %@", NSStringFromClass([self class]), e);
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (void)setViewController:(UIViewController*)viewController animated:(BOOL)animated {
    UIViewController *oldVC = _viewControllers.lastObject;
    
    [_viewControllers addObject:viewController]; // adds it to the end.
    
    [self addChildViewController:viewController];
    
    static BOOL firstTime = YES;
    if (firstTime) {
        firstTime = NO;
    } else {
        CGRect frame = self.view.frame;
        frame.origin = CGPointMake(frame.origin.x, frame.origin.y-self.navigationController.navigationBar.frame.size.height);
        viewController.view.frame = frame;
    }
    [self.view addSubview:viewController.view];
    /*
     [self.view addConstraint:[NSLayoutConstraint equalWidthWithItem:viewController.view toItem:self.view]];
     [self.view addConstraint:[NSLayoutConstraint centerXWithItem:viewController.view toItem:self.view]];
     [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-(nav)-[view]-(nav)-|" options:0 metrics:@{@"nav" : @(self.navigationController.navigationBar.frame.size.height)} views:@{@"view" : viewController.view}]];
     [self.view layoutIfNeeded];
     */
    objc_setAssociatedObject(oldVC, (__bridge const void *)mdmvc_assoc_key, nil, OBJC_ASSOCIATION_ASSIGN);
    
    objc_setAssociatedObject(viewController, (__bridge const void *)mdmvc_assoc_key, self, OBJC_ASSOCIATION_ASSIGN);
    void (^removeOldVC)(void) = ^{
        if (oldVC) {
            [oldVC.view removeFromSuperview];
            [oldVC removeFromParentViewController];
            [_viewControllers removeObject:oldVC];
            
        }
    };
    
    if (animated) {
        viewController.view.alpha = 0.0f;
        [UIView animateWithDuration:MDMAnimationDuration animations:^{
            viewController.view.alpha = 1.0f;
        } completion:^(BOOL finished) {
            removeOldVC();
        }];
    } else {
        removeOldVC();
    }
}

#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    if ([segue isKindOfClass:[MDMSetViewControllerSegue class]]) {
        UIViewController *vc = [segue destinationViewController];
        [self.navigationController addChildViewController:vc];
    }
}

@end


@implementation MDMSetViewControllerSegue

- (void)perform {
    UIViewController *src = self.sourceViewController;
    if ([src isKindOfClass:[MultiDisplayMenuViewController class]]) {
        UIViewController *dst = self.destinationViewController;
        [(MultiDisplayMenuViewController*)src setViewController:dst animated:true];
    }
}

@end

@implementation UIViewController (MultiDisplayMenuViewController)

- (MultiDisplayMenuViewController*)multiDisplayViewController {
    return objc_getAssociatedObject(self, (__bridge const void *)mdmvc_assoc_key);
}

@end