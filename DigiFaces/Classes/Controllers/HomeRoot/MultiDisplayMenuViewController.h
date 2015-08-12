//
//  MultiDisplayMenuViewController.h
//  DigiFaces
//
//  Created by James on 8/5/15.
//  Copyright (c) 2015 INET360. All rights reserved.
//

#import <UIKit/UIKit.h>
@class MultiDisplayMenuViewController;
@interface UIViewController (MultiDisplayMenuViewController)
- (MultiDisplayMenuViewController*)multiDisplayViewController;
@end

@interface MultiDisplayMenuViewController : UIViewController

- (void)setViewController:(UIViewController*)viewController animated:(BOOL)animated;

@end

@interface MDMSetViewControllerSegue : UIStoryboardSegue

- (void)perform;

@end