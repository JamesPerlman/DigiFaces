//
//  NSArray+Search.m
//  DigiFaces
//
//  Created by James on 12/30/15.
//  Copyright © 2015 INET360. All rights reserved.
//

#import "NSArray+Search.h"

@implementation NSArray (Search)

- (BOOL)containsString:(NSString*)needle {
    for (NSString *hay in self) {
        if ([needle isEqualToString:hay]) {
            return true;
        }
    }
    return false;
}

@end
