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
    NSString *htmlString;
    @try {
        
        NSError *error = nil;
        NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:@"</p>[\\\\r|\\\\n|\\s]*?<p>" options:NSRegularExpressionCaseInsensitive error:&error];
        htmlString = [regex stringByReplacingMatchesInString:html options:0 range:NSMakeRange(0, [html length]) withTemplate:@"</p><br/><p>"];
        NSLog(@"%@", htmlString);
    } @catch (NSException *exc) {
        htmlString = html;
    }
    NSData *textData = [htmlString dataUsingEncoding:NSUnicodeStringEncoding];
    
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
