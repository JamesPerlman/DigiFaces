#import "RKCustomBOOLTransformer.h"
@implementation RKCustomBOOLTransformer

+ (instancetype)defaultTransformer {
    return [RKCustomBOOLTransformer new];
}

- (BOOL)validateTransformationFromClass:(Class)inputValueClass toClass:(Class)outputValueClass {
    return ([inputValueClass isSubclassOfClass:[NSNumber class]] &&
            [outputValueClass isSubclassOfClass:[NSNumber class]]);
}

- (BOOL)transformValue:(id)inputValue toValue:(id *)outputValue ofClass:(Class)outputValueClass error:(NSError **)error {
    RKValueTransformerTestInputValueIsKindOfClass(inputValue, (@[ [NSNumber class] ]), error);
    RKValueTransformerTestOutputValueClassIsSubclassOfClass(outputValueClass, (@[ [NSNumber class] ]), error);
    
    if (strcmp([inputValue objCType], @encode(BOOL)) == 0) {
        *outputValue = inputValue?@(1):@(0);
    } else if (strcmp([inputValue objCType], @encode(int)) == 0) {
        *outputValue = ([inputValue intValue] == 0) ? @(NO) : @(YES);
    }
    NSLog(@"%@", *outputValue);
    return YES;
}

@end