//
//  TextareaResponse.h
//  DigiFaces
//
//  Created by James on 7/29/15.
//  Copyright (c) 2015 INET360. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TextareaResponse : NSObject

@property (nonatomic, strong) NSNumber *textareaResponseId;
@property (nonatomic, strong) NSNumber *textareaId;
@property (nonatomic, strong) NSNumber *threadId;
@property (nonatomic, strong) NSNumber *isActive;
@property (nonatomic, retain) NSString *response;


@end
