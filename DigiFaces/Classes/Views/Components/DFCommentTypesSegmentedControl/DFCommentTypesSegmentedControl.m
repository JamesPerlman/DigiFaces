//
//  DFCommentTypesSegmentedControl.m
//  DigiFaces
//
//  Created by James on 3/15/16.
//  Copyright © 2016 INET360. All rights reserved.
//

#import "DFCommentTypesSegmentedControl.h"
#import "NSString+DigiFaces.h"

@implementation DFCommentTypesSegmentedControl

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/
- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    if (self) {
        [self customizeAppearance];
    }
    return self;
}


- (void)customizeAppearance {
    self.layer.cornerRadius = 0;
    self.layer.masksToBounds = NO;
    
    // change font
    NSDictionary *attrs = @{NSFontAttributeName : [UIFont fontWithName:@"FontAwesome" size:12.0]};
    [self setTitleTextAttributes:attrs forState:UIControlStateNormal];
    
     NSString *addCommentText = [NSString stringPrefixedWithFontAwesomeIcon:@"fa-comment-o" withLocalizedKey:@"list.comment_options.comment"];
    NSString *addInternalCommentText = [NSString stringPrefixedWithFontAwesomeIcon:@"fa-comments-o" withLocalizedKey:@"list.comment_options.internal"];
    NSString *addResearcherCommentText = [NSString stringPrefixedWithFontAwesomeIcon:@"fa-comments" withLocalizedKey:@"list.comment_options.researcher"];
    
    [self setSegments:@[addCommentText, addInternalCommentText, addResearcherCommentText]];
    
}

- (void)setSegments:(NSArray *)segments
{
    [self removeAllSegments];
    
    for (NSString *segment in segments) {
        [self insertSegmentWithTitle:segment atIndex:self.numberOfSegments animated:NO];
    }
}

@end
