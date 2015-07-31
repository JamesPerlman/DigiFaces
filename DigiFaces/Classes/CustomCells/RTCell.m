//
//  RTCell.m
//  DigiFaces
//
//  Created by confiz on 11/07/2015.
//  Copyright (c) 2015 Usasha studio. All rights reserved.
//

#import "RTCell.h"

@interface RTCell () {
    CGFloat moreLessButtonInitialHeightConstraintConstant;
    BOOL expanded;
}

@end

@implementation RTCell
- (void)awakeFromNib {
    [super awakeFromNib];
    [self minimize];
    moreLessButtonInitialHeightConstraintConstant = self.moreLessButtonHeightConstraint.constant;
}


- (IBAction)moreLessToggle:(id)sender {
    if (expanded) {
        [self minimize];
    } else {
        [self maximize];
    }
    if ([self.delegate respondsToSelector:@selector(textCellDidChangeSize:)]) {
        [self.delegate textCellDidChangeSize:self];
    }
}

- (void)minimize {
    expanded = false;
    [self.moreLessButton setTitle:@"More" forState:UIControlStateNormal];
}

- (void)maximize {
    expanded = true;
    [self.moreLessButton setTitle:@"Less" forState:UIControlStateNormal];
    
}

- (CGFloat)height {
    CGFloat fullHeight = [self fullHeight];
    if (expanded) {
        return fullHeight;
    } else {
        CGFloat maxHeight = [self maxHeight];
        return maxHeight;
    }
}

- (CGFloat)fullHeight {
    return [self.webView sizeThatFits:CGSizeMake(self.textView.frame.size.width, CGFLOAT_MAX)].height + self.moreLessButton.frame.size.height + 20.0f;
}

- (CGFloat)maxHeight {
    return ([UIScreen mainScreen].bounds.size.height*.4f);
}
- (void)setText:(NSString *)text {
    [self.webView loadHTMLString:text baseURL:nil];
}

@end
