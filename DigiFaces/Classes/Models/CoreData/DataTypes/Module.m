//
//  Module.m
//  
//
//  Created by James on 9/11/15.
//
//

#import "Module.h"
#import "DisplayFile.h"
#import "DisplayText.h"
#import "ImageGallery.h"
#import "MarkUp.h"
#import "Textarea.h"


@implementation Module

@dynamic activityId;
@dynamic activityModuleId;
@dynamic activityType;
@dynamic activityTypeId;
@dynamic moduleId;
@dynamic sortOrder;
@dynamic textarea;
@dynamic displayText;
@dynamic displayFile;
@dynamic markUp;
@dynamic imageGallery;

@end

@implementation Module (DynamicMethods)

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
