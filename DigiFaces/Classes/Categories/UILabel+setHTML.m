//
//  UILabel+setHTML.m
//  DigiFaces
//
//  Created by James on 8/3/15.
//  Copyright (c) 2015 INET360. All rights reserved.
//

#import "UILabel+setHTML.h"
#import "NSString+stripHTML.h"

@implementation UILabel (setHTML)

- (void)setHTML:(NSString*)html {

    
    // scan and replace small fonts  (font-size: 11px;)
    NSError *error;
    NSData *textData = [html dataUsingEncoding:NSUnicodeStringEncoding];
    NSMutableAttributedString *attrStr = [[NSMutableAttributedString alloc] initWithData:textData options:@{NSDocumentTypeDocumentAttribute:NSHTMLTextDocumentType} documentAttributes:nil error:&error];
    [attrStr setAttributes:@{NSFontAttributeName : [UIFont systemFontOfSize:16.0f]} range:NSMakeRange(0,attrStr.length)];
    
    if (error) {
        NSLog(@"Error processing HTML");
        self.text = [html stripHTML];
    } else {
        self.attributedText = attrStr;
    }
}
@end
