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
#import "TextArea.h"
#import "MarkUp.h"
#import "imageGallery.h"
#import "SDConstants.h"


@interface Module : NSObject

@property (nonatomic, assign) NSInteger activityModuleId;
@property (nonatomic, assign) NSInteger activityId;
@property (nonatomic, assign) NSInteger activityTypeId;
@property (nonatomic, retain) NSString * activityType;
@property (nonatomic, assign) NSInteger moduleId;

@property (nonatomic, retain) DisplayText * displayText;
@property (nonatomic, retain) DisplayFile * displayFile;
@property (nonatomic, retain) TextArea * textArea;
@property (nonatomic, retain) MarkUp * markUp;
@property (nonatomic, retain) imageGallery * imageGallery;

-(instancetype) initWithDictionary:(NSDictionary*)dict;

-(ThemeType)themeType;

@end
