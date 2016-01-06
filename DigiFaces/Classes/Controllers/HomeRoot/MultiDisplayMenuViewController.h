//
//  MultiDisplayMenuViewController.h
//  DigiFaces
//
//  Created by James on 8/5/15.
//  Copyright (c) 2015 INET360. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SWRevealViewController.h"

@class MultiDisplayMenuViewController;
@interface UIViewController (MultiDisplayMenuViewController)
- (MultiDisplayMenuViewController*)multiDisplayViewController;
@end

@interface MultiDisplayMenuViewController : SWRevealViewController

- (void)setViewController:(UIViewController*)viewController animated:(BOOL)animated;

- (void)setViewControllerWithID:(NSString*)VCID;

@end

@interface MDMSetViewControllerSegue : UIStoryboardSegue

- (void)perform;

@end

@interface MDMRevealViewControllerSegue : UIStoryboardSegue

- (void)perform;

@property (nonatomic) BOOL destinationViewControllerHidden;

@end