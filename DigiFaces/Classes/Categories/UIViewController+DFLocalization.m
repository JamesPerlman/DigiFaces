//
//  UIViewController+DFLocalization.m
//  DigiFaces
//
//  Created by James on 10/17/15.
//  Copyright © 2015 INET360. All rights reserved.
//

#import <objc/runtime.h>
#import "UIViewController+DFLocalization.h"

@implementation UIViewController (DFLocalization)

+(void)initialize {
    Method vdl1 = class_getInstanceMethod([UIViewController class], @selector(viewDidLoad));
    Method vdl2 = class_getInstanceMethod([UIViewController class], @selector(viewDidLoad_override));
    method_exchangeImplementations(vdl1, vdl2);
    Method d1 = class_getInstanceMethod([UIViewController class], NSSelectorFromString(@"dealloc"));
    Method d2 = class_getInstanceMethod([UIViewController class], @selector(dealloc_override));
    method_exchangeImplementations(d1, d2);
    
}

- (void)localizeThisUI {
    if ([self respondsToSelector:NSSelectorFromString(@"localizeUI")]) {
        SEL selector = NSSelectorFromString(@"localizeUI");
        IMP imp = [self methodForSelector:selector];
        void (*func)(id, SEL) = (void *)imp;
        func(self, selector);
    }
}

- (void)viewDidLoad_override {
    
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(localizeThisUI) name:DFLocalizationDidSynchronizeNotification object:nil];
    
    [self viewDidLoad_override];
    [self localizeThisUI];
    
}

- (void)dealloc_override {
    [self dealloc_override];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:DFLocalizationDidSynchronizeNotification object:nil];
}

@end
