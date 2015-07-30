//
//  Module.h
//  DigiFaces
//
//  Created by confiz on 17/07/2015.
//  Copyright (c) 2015 Usasha studio. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DisplayText.h"
#import "DisplayFile.h"
#import "Textarea.h"
#import "MarkUp.h"
#import "ImageGallery.h"



@interface Module : NSObject

@property (nonatomic, strong) NSNumber * activityModuleId;
@property (nonatomic, strong) NSNumber * activityId;
@property (nonatomic, strong) NSNumber * activityTypeId;
@property (nonatomic, retain) NSString * activityType;
@property (nonatomic, strong) NSNumber * moduleId;
@property (nonatomic, strong) NSNumber * sortOrder;

@property (nonatomic, retain) DisplayText * displayText;
@property (nonatomic, retain) DisplayFile * displayFile;
@property (nonatomic, retain) Textarea * textArea;
@property (nonatomic, retain) MarkUp * markUp;
@property (nonatomic, retain) ImageGallery * imageGallery;

//-(instancetype) initWithDictionary:(NSDictionary*)dict;

-(ThemeType)themeType;

@end
