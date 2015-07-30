//
//  CarouselViewController.h
//  DigiFaces
//
//  Created by confiz on 16/07/2015.
//  Copyright (c) 2015 Usasha studio. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CarouselViewController : UIPageViewController

@property (nonatomic, retain) NSArray * files;
@property (nonatomic, assign) NSInteger selectedIndex;


@end
