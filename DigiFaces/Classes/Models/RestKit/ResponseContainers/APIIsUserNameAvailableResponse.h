//
//  APIIsUserNameAvailableResponse.h
//  DigiFaces
//
//  Created by James on 7/29/15.
//  Copyright (c) 2015 INET360. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface APIIsUserNameAvailableResponse : NSObject

@property (nonatomic, strong) NSNumber *isAvailable;
@property (nonatomic, retain) NSString *error;

@end
