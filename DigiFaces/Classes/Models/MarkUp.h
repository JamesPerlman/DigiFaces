//
//  MarkUp.h
//  DigiFaces
//
//  Created by confiz on 17/07/2015.
//  Copyright (c) 2015 Usasha studio. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MarkUp : NSObject

@property (nonatomic, strong) NSNumber * markupId;
@property (nonatomic, retain) NSString * markupUrl;

-(instancetype) initWithDictionary:(NSDictionary*)dict;

@end
