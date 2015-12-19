//
//  UIView+GestureRecognizerControls.h
//  Jarvis
//
//  Created by James on 7/10/15.
//  Copyright (c) 2015 Jarvis. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIView (GestureRecognizerControls)

- (void)setGestureRecognizersEnabled:(BOOL)enabled;
- (void)disableGestureRecognizers;
- (void)enableGestureRecognizers;

@end
