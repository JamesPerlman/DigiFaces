//
//  TextArea.h
//  DigiFaces
//
//  Created by confiz on 17/07/2015.
//  Copyright (c) 2015 Usasha studio. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Textarea : NSObject

@property (nonatomic, strong) NSNumber * textareaId;
@property (nonatomic, strong) NSNumber * activityId;
@property (nonatomic, strong) NSNumber * maxCharacters;
@property (nonatomic, retain) NSString * questionText;
@property (nonatomic, retain) NSString * placeHolder;

-(instancetype) initWithDictionary:(NSDictionary*)dict;

@end
