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

static NSString *mdmvc_assoc_key = @"MultiDisplayMenuViewControllerAssociatedKey";

@interface MultiDisplayMenuViewController () {
    BOOL _firstTimeViewControllerLoaded;
}
@property (nonatomic, strong) NSMutableArray *viewControllers;
@end

@implementation MultiDisplayMenuViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    _firstTimeViewControllerLoaded = YES;
    // Do any additional setup after loading the view.
    
    /*
    @try {
        [self performSegueWithIdentifier:@"init" sender:nil];
    } @catch (NSException *e) {
        NSLog(@"You better have some sorta plan!  No init segue found on %@.  Exception: %@", NSStringFromClass([self class]), e);
    }*/
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    for (id vc in self.viewControllers) {
        [self stopObserving:vc];
    }
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    for (id vc in self.viewControllers) {
        [self observe:vc];
    }
}

- (void)observe:(UIViewController*)viewController {
    [self stopObserving:viewController];
    [viewController addObserver:self forKeyPath:@"navigationItem.title" options:NSKeyValueObservingOptionNew|NSKeyValueObservingOptionInitial context:NULL];
}

- (void)stopObserving:(UIViewController*)viewController {
    @try {
        [viewController removeObserver:self forKeyPath:@"navigationItem.title"];
    } @catch(id anException){
        //do nothing, obviously it wasn't attached because an exception was thrown
    }
}

- (void)setViewController:(UIViewController*)viewController animated:(BOOL)animated {
    
    
    UIViewController *oldVC = self.viewControllers.lastObject;
    
    [self observe:viewController];
    
    [self.viewControllers addObject:viewController];
    
    self.navigationItem.title = viewController.navigationItem.title;
    
    
    [self stopObserving:oldVC];
    
    objc_setAssociatedObject(oldVC, (__bridge const void *)mdmvc_assoc_key, nil, OBJC_ASSOCIATION_ASSIGN);
    objc_setAssociatedObject(viewController, (__bridge const void *)mdmvc_assoc_key, self, OBJC_ASSOCIATION_ASSIGN);
    
    [self.viewControllers removeObject:oldVC];
    
    [self setFrontViewController:viewController animated:animated];
    
    if (_firstTimeViewControllerLoaded) {
        _firstTimeViewControllerLoaded = NO;
    } else {
        CGRect frame = self.view.frame;
        frame.origin = CGPointMake(frame.origin.x, frame.origin.y-self.navigationController.navigationBar.frame.size.height-[UIApplication sharedApplication].statusBarFrame.size.height);
        viewController.view.frame = frame;
    }
}

#pragma mark - Accessors
- (NSMutableArray*)viewControllers {
    if (!_viewControllers) {
        _viewControllers = [NSMutableArray array];
    }
    return _viewControllers;
}

#pragma mark - KVO
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSString *,id> *)change context:(void *)context {
    if ([keyPath isEqualToString:@"navigationItem.title"]) {
        self.navigationItem.title = [object navigationItem].title;
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