//
//  NSArray+orderedDistinctUnionOfObjects.m
//  DigiFaces
//
//  Created by James on 7/29/15.
//  Copyright (c) 2015 INET360. All rights reserved.
//

#import "NSArray+orderedDistinctUnionOfObjects.h"

@implementation NSArray (orderedDistinctUnionOfObjects)
/*
- (id) _orderedDistinctUnionOfObjectsForKeyPath:(NSString*)keyPath {
    NSMutableArray *values = [NSMutableArray array];
    
    for (NSUInteger i = 0, n = self.count; i < n; ++i) {
        id obj1 = [self objectAtIndex:i];
        BOOL obj1_isNumber = [obj1 isKindOfClass:[NSNumber class]];
        BOOL obj1_isString = [obj1 isKindOfClass:[NSString class]];
        
        for (NSUInteger j = i+1; j < n; ++j) {
            id obj2 = [self objectAtIndex:j];
            BOOL obj2_isNumber = [obj2 isKindOfClass:[NSNumber class]];
            BOOL obj2_isString
            if ()
        }
    }
    
    return [NSArray arrayWithArray:values];
}*/

- (id) _orderedDistinctUnionOfStringsForKeyPath:(NSString*)keyPath {
    NSMutableArray *removeValues = [NSMutableArray array];
    
    for (NSUInteger i = 0, n = self.count; i < n; ++i) {
        NSString *str1 = [[self objectAtIndex:i] valueForKeyPath:keyPath];
        
        for (NSUInteger j = i+1; j < n; ++j) {
            id obj = [self objectAtIndex:j];
            NSString *str2 = [obj valueForKeyPath:keyPath];
            
            if ([str1 isEqualToString:str2]) {
                [removeValues addObject:obj];
            }
        }
    }
    
    NSMutableArray *myMutableCopy = [self mutableCopy];
    [myMutableCopy removeObjectsInArray:removeValues];
    
    return [[NSArray arrayWithArray:myMutableCopy] valueForKeyPath:[NSString stringWithFormat:@"@unionOfObjects.%@", keyPath]];
}
@end
