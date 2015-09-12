//
//  Module.h
//  
//
//  Created by James on 9/11/15.
//
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class DisplayFile, DisplayText, ImageGallery, MarkUp, Textarea;

@interface Module : NSManagedObject

@property (nonatomic, retain) NSNumber * activityId;
@property (nonatomic, retain) NSNumber * activityModuleId;
@property (nonatomic, retain) NSString * activityType;
@property (nonatomic, retain) NSNumber * activityTypeId;
@property (nonatomic, retain) NSNumber * moduleId;
@property (nonatomic, retain) NSNumber * sortOrder;
@property (nonatomic, retain) Textarea *textarea;
@property (nonatomic, retain) DisplayText *displayText;
@property (nonatomic, retain) DisplayFile *displayFile;
@property (nonatomic, retain) MarkUp *markUp;
@property (nonatomic, retain) ImageGallery *imageGallery;

@end

@interface Module (DynamicMethods)

-(ThemeType)themeType;

@end
