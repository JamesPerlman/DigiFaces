//
//  NSLayoutConstraint+ConvenienceMethods.h
//  Jarvis
//
//  Created by James on 6/12/15.
//  Copyright (c) 2015 Jarvis. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface NSLayoutConstraint (ConvenienceMethods)

+ (instancetype)equalConstraintWithItem:(id)firstItem attribute:(NSLayoutAttribute)attribute toItem:(id)secondItem;
+ (instancetype)centerXWithItem:(id)firstItem toItem:(id)secondItem;
+ (instancetype)centerYWithItem:(id)firstItem toItem:(id)secondItem;
+ (instancetype)equalWidthWithItem:(id)firstItem toItem:(id)secondItem;
+ (instancetype)equalHeightWithItem:(id)firstItem toItem:(id)secondItem;
+ (NSArray*)equalSizeAndCentersWithItem:(id)firstItem toItem:(id)secondItem;

+ (instancetype)alignBottomOfItem:(id)firstItem toTopOfItem:(id)secondItem;
+ (instancetype)alignBottomOfItem:(id)firstItem toBottomOfItem:(id)secondItem;
+ (instancetype)alignTopOfItem:(id)firstItem toTopOfItem:(id)secondItem;
+ (instancetype)alignTopOfItem:(id)firstItem toBottomOfItem:(id)secondItem;
@end
