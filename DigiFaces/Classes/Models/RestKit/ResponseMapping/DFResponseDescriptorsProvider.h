//
//  DFResponseDescriptorProvider.h
//  DigiFaces
//
//  Created by James on 7/28/15.
//  Copyright (c) 2015 INET360. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DFResponseDescriptorsProvider : NSObject

+ (instancetype)sharedInstance;
- (NSArray *)responseDescriptors;
@end
