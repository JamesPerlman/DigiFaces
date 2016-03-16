//
//  Language.h
//  DigiFaces
//
//  Created by James on 3/16/16.
//  Copyright © 2016 INET360. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Language : NSObject


@property (nullable, nonatomic, retain) NSNumber *languageId;
@property (nullable, nonatomic, retain) NSString *languageCode;
@property (nullable, nonatomic, retain) NSString *languageName;

@end
