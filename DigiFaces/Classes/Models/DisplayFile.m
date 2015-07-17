//
//  DisplayFile.m
//  DigiFaces
//
//  Created by confiz on 17/07/2015.
//  Copyright (c) 2015 Usasha studio. All rights reserved.
//

#import "DisplayFile.h"

@implementation DisplayFile

-(instancetype)initWithDictionary:(NSDictionary *)dict
{
    self = [super init];
    if (self) {
        self.displayFileId = [[dict valueForKey:@"DisplayFileId"] integerValue];
        self.activityId = [[dict valueForKey:@"ActivityId"] integerValue];
        self.fileId = [[dict valueForKey:@"FileId"] integerValue];
        
        if ([dict valueForKey:@"File"]) {
            _file = [[File alloc] initWithDictionary:[dict valueForKey:@"File"]];
        }
       
    }
    return self;
}

@end
