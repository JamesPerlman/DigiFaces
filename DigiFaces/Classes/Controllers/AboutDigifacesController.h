//
//  AboutDigifacesController.h
//  DigiFaces
//
//  Created by confiz on 21/06/2015.
//  Copyright (c) 2015 Usasha studio. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RTLabel.h"

@interface AboutDigifacesController : UIViewController
@property (weak, nonatomic) IBOutlet UITextView *textView;
@property (weak, nonatomic) IBOutlet RTLabel *aboutLabel;
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;

@end
