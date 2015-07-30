//
//  About.h
//  DigiFaces
//
//  Created by James on 7/28/15.
//  Copyright (c) 2015 INET360. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface About : NSObject

@property (nonatomic, strong) NSNumber *aboutId;
@property (nonatomic, copy) NSString *aboutTitle;
@property (nonatomic, copy) NSString *aboutText;
@property (nonatomic, copy) NSString *languageCode;

@end
