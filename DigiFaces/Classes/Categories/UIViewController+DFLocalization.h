//
//  UIViewController+DFLocalization.h
//  DigiFaces
//
//  Created by James on 10/17/15.
//  Copyright © 2015 INET360. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIViewController (DFLocalization)

- (void)viewDidLoad_override;
- (void)dealloc_override;
- (void)localizeThisUI;

@end
