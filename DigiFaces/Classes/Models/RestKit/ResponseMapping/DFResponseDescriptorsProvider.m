//
//  DFResponseDescriptorProvider.m
//  DigiFaces
//
//  Created by James on 7/28/15.
//  Copyright (c) 2015 INET360. All rights reserved.
//

// vvv Super duper convenient
#define DESCRIPTOR(mappingSelector, requestMethod, pathString, keyPathString) [RKResponseDescriptor responseDescriptorWithMapping:[MAPPER mappingSelector] method:requestMethod pathPattern:pathString keyPath:keyPathString statusCodes:RKStatusCodeIndexSetForClass(RKStatusCodeClassSuccessful)]


#import "DFResponseDescriptorsProvider.h"


#define MAPPER [APIResponseDataMapper sharedInstance]


#import "DFResponseDataMapper.h"
#import "DFConstants.h"

@implementation DFResponseDescriptorsProvider


+ (instancetype)sharedInstance
{
    static DFResponseDescriptorsProvider *_sharedInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _sharedInstance = [[DFResponseDescriptorsProvider alloc] init];
    });
    
    
    return _sharedInstance;
}


- (NSArray*)responseDescriptors {
    return @[
             ];
}

@end
