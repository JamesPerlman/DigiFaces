//
//  UIView+GestureRecognizerControls.m
//  Jarvis
//
//  Created by James on 7/10/15.
//  Copyright (c) 2015 Jarvis. All rights reserved.
//

#import "UIView+GestureRecognizerControls.h"

@implementation UIView (GestureRecognizerControls)

- (void)setGestureRecognizersEnabled:(BOOL)enabled {
/*
    // recursive method
    for (UIView *view in self.subviews) {
        for (UIGestureRecognizer *gr in view.gestureRecognizers) {
            gr.enabled = enabled;
        }
        [view setGestureRecognizersEnabled:enabled];
    }
  */
    // non-recursive method
    NSMutableArray *views = [NSMutableArray arrayWithObject:self];
    UIView *view;
    NSArray *subviews;
    while (views.count) {
        view = views.lastObject;
        for (UIGestureRecognizer *gr in view.gestureRecognizers) {
            gr.enabled = enabled;
        }
        subviews = view.subviews;
        [views removeLastObject];
        [views addObjectsFromArray:subviews];
    }
    
}
- (void)disableGestureRecognizers {
    [self setGestureRecognizersEnabled:false];
}
- (void)enableGestureRecognizers {
    [self setGestureRecognizersEnabled:true];
}

@end
