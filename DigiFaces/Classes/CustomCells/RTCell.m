//
//  RTCell.m
//  DigiFaces
//
//  Created by confiz on 11/07/2015.
//  Copyright (c) 2015 Usasha studio. All rights reserved.
//

#import "RTCell.h"
#import "UILabel+setHTML.h"
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

- (void)layoutSubviews {
    [super layoutSubviews];
    self.moreLessButton.hidden = (self.height > self.fullHeight);
    
}
- (IBAction)moreLessToggle:(id)sender {
    /*if (expanded) {
        [self minimize];
    } else {
        [self maximize];
    }*/
    if ([self.delegate respondsToSelector:@selector(textCellDidTapMore:)]) {
        [self.delegate textCellDidTapMore:self];
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
    CGSize sizeThatFits = [self.bodyLabel sizeThatFits:CGSizeMake([UIScreen mainScreen].bounds.size.width-16, CGFLOAT_MAX)];
    CGFloat mlbh = self.moreLessButton?self.moreLessButton.frame.size.height:0.0f;
    return sizeThatFits.height + 8.0f + mlbh + 8.0f;
}

- (CGFloat)maxHeight {
    return ([UIScreen mainScreen].bounds.size.height*.4f);
}
- (BOOL)hasMoreToShow {
    UILabel *item = self.bodyLabel;
    CGSize sizeOfText = [item.text boundingRectWithSize: CGSizeMake(item.intrinsicContentSize.width, CGFLOAT_MAX)
                                                 options: (NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingUsesFontLeading)
                                              attributes: [NSDictionary dictionaryWithObject:item.font forKey:NSFontAttributeName] context: nil].size;
    // item.intrinsicContentSize.height < sizeOfText.height
    return ( sizeOfText.height > self.height);
}

- (void)setText:(NSString *)text {
    [self.bodyLabel setHTML:text];
}

@end
