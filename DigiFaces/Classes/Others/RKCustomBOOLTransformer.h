// thank you http://stackoverflow.com/a/22349468/892990

#import <Foundation/Foundation.h>

@interface RKCustomBOOLTransformer : NSObject  <RKValueTransforming>

+ (instancetype)defaultTransformer;

@end

