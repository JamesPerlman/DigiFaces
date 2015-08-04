//
//  Module.m
//  DigiFaces
//
//  Created by confiz on 17/07/2015.
//  Copyright (c) 2015 Usasha studio. All rights reserved.
//

#import "Module.h"

@implementation Module
/*
-(instancetype)initWithDictionary:(NSDictionary *)dict
{
    self = [super init];
    if (self) {
        self.activityModuleId =[[dict valueForKey:@"ActivityModuleId"] integerValue];
        self.activityId = [[dict valueForKey:@"ActivityId"] integerValue];
        self.activityTypeId = [[dict valueForKey:@"ActivityTypeId"] integerValue];
        self.activityType = [dict valueForKey:@"ActivityType"];
        self.moduleId = [[dict valueForKey:@"ModuleId"] integerValue];
        if ([dict valueForKey:@"DisplayText"] && [[dict valueForKey:@"DisplayText"] isKindOfClass:[NSDictionary class]]) {
            _displayText = [[DisplayText alloc] initWithDictionary:[dict valueForKey:@"DisplayText"]];
        }
        
        if ([dict valueForKey:@"DisplayFile"] && [[dict valueForKey:@"DisplayFile"] isKindOfClass:[NSDictionary class]]) {
            _displayFile = [[DisplayFile alloc] initWithDictionary:[dict valueForKey:@"DisplayFile"]];
        }
        
        if ([dict valueForKey:@"Textarea"] && [[dict valueForKey:@"Textarea"] isKindOfClass:[NSDictionary class]]) {
            _textArea = [[TextArea alloc] initWithDictionary:[dict valueForKey:@"Textarea"]];
        }
        
        if ([dict valueForKey:@"Markup"] && [[dict valueForKey:@"Markup"] isKindOfClass:[NSDictionary class]]) {
            _markUp = [[MarkUp alloc] initWithDictionary:[dict valueForKey:@"Markup"]];
        }
        
        if ([dict valueForKey:@"ImageGallery"] && [[dict valueForKey:@"ImageGallery"] isKindOfClass:[NSDictionary class]]) {
            _imageGallery = [[ImageGallery alloc] initWithDictionary:[dict valueForKey:@"ImageGallery"]];
        }
        
    }
    
    return self;
}*/

-(ThemeType)themeType
{
    if ([self.activityType isEqualToString:@"ImageGallery"]) {
        return ThemeTypeImageGallery;
    }
    else if ([self.activityType isEqualToString:@"DisplayImage"]){
        return ThemeTypeDisplayImage;
    }
    else if ([self.activityType isEqualToString:@"DisplayText"]){
        return ThemeTypeDisplayText;
    }
    else if ([self.activityType isEqualToString:@"Markup"]){
        return ThemeTypeMarkup;
    }
    else if ([self.activityType isEqualToString:@"Textarea"]){
        return ThemeTypeTextArea;
    }
    else if ([self.activityType isEqualToString:@"VideoResponse"]) {
        return ThemeTypeVideoResponse;
    }
    return ThemeTypeNone;
}

@end
