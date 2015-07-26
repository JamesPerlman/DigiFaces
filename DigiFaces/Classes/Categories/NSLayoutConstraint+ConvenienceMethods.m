//
//  NSLayoutConstraint+ConvenienceMethods.m
//  Jarvis
//
//  Created by James on 6/12/15.
//  Copyright (c) 2015 Jarvis. All rights reserved.
//

#import "NSLayoutConstraint+ConvenienceMethods.h"

@implementation NSLayoutConstraint (ConvenienceMethods)

+ (instancetype)equalConstraintWithItem:(id)firstItem attribute:(NSLayoutAttribute)attribute toItem:(id)secondItem {
    return [NSLayoutConstraint constraintWithItem:firstItem attribute:attribute relatedBy:NSLayoutRelationEqual toItem:secondItem attribute:attribute multiplier:1.f constant:0.f];
}

+ (instancetype)centerXWithItem:(id)firstItem toItem:(id)secondItem {
    return [NSLayoutConstraint equalConstraintWithItem:firstItem attribute:NSLayoutAttributeCenterX toItem:secondItem];
}

+ (instancetype)centerYWithItem:(id)firstItem toItem:(id)secondItem {
    return [NSLayoutConstraint equalConstraintWithItem:firstItem attribute:NSLayoutAttributeCenterY toItem:secondItem];
}

+ (instancetype)equalHeightWithItem:(id)firstItem toItem:(id)secondItem {
    return [NSLayoutConstraint equalConstraintWithItem:firstItem attribute:NSLayoutAttributeHeight toItem:secondItem];
}

+ (instancetype)equalWidthWithItem:(id)firstItem toItem:(id)secondItem {
    return [NSLayoutConstraint equalConstraintWithItem:firstItem attribute:NSLayoutAttributeWidth toItem:secondItem];
}

+ (NSArray*)equalSizeAndCentersWithItem:(id)firstItem toItem:(id)secondItem {
    return @[[self equalWidthWithItem:firstItem toItem:secondItem],
             [self equalHeightWithItem:firstItem toItem:secondItem],
             [self centerXWithItem:firstItem toItem:secondItem],
             [self centerYWithItem:firstItem toItem:secondItem]];
}

+ (instancetype)alignBottomOfItem:(id)firstItem toTopOfItem:(id)secondItem {
    return [NSLayoutConstraint constraintWithItem:firstItem attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:secondItem attribute:NSLayoutAttributeTop multiplier:1.0f constant:0.0f];
}

+ (instancetype)alignBottomOfItem:(id)firstItem toBottomOfItem:(id)secondItem {
    return [NSLayoutConstraint constraintWithItem:firstItem attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:secondItem attribute:NSLayoutAttributeBottom multiplier:1.0f constant:0.0f];
}

+ (instancetype)alignTopOfItem:(id)firstItem toTopOfItem:(id)secondItem {
    return [NSLayoutConstraint constraintWithItem:firstItem attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:secondItem attribute:NSLayoutAttributeTop multiplier:1.0f constant:0.0f];
}

+ (instancetype)alignTopOfItem:(id)firstItem toBottomOfItem:(id)secondItem {
    return [NSLayoutConstraint constraintWithItem:firstItem attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:secondItem attribute:NSLayoutAttributeBottom multiplier:1.0f constant:0.0f];
}

@end
