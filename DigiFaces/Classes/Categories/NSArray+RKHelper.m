//
//  NSArray+RKHelper.m
//  DigiFaces
//
//  Created by James on 7/28/15.
//  Copyright (c) 2015 INET360. All rights reserved.
//

#import "NSArray+RKHelper.h"

@implementation NSArray (RKHelper)



- (NSDictionary*)camelCaseDict {
    NSMutableDictionary *camelCaseDict = [NSMutableDictionary dictionary];
    for (NSString * str in self) {
        // downcase first letter
        NSString *firstLetter = [[str substringToIndex:1] lowercaseString];
        NSString *restOfString = [str substringFromIndex:1];
        
        NSString *camelCaseString = [firstLetter stringByAppendingString:restOfString];
        camelCaseDict[str] = camelCaseString;
    }
    
    return [NSDictionary dictionaryWithDictionary:camelCaseDict];
    
}
@end
