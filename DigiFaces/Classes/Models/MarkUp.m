//
//  MarkUp.m
//  DigiFaces
//
//  Created by confiz on 17/07/2015.
//  Copyright (c) 2015 Usasha studio. All rights reserved.
//

#import "MarkUp.h"

@implementation MarkUp

-(instancetype)initWithDictionary:(NSDictionary *)dict
{
    self = [super init];
    if (self) {
        self.markupId = [dict valueForKey:@"MarkupId"];
        self.markupUrl = [dict valueForKey:@"MarkupUrl"];
        
    }
    return self;
}

@end
