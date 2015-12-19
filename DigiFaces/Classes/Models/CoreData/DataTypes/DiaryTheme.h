//
//  DiaryTheme.h
//  
//
//  Created by James on 12/18/15.
//
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Module, Response, Project;

NS_ASSUME_NONNULL_BEGIN

@interface DiaryTheme : NSManagedObject

// Insert code here to declare functionality of your managed object subclass

- (Module*)getModuleWithThemeType:(ThemeType)type;
- (NSArray*)sortedResponsesArray;

@end

NS_ASSUME_NONNULL_END

#import "DiaryTheme+CoreDataProperties.h"
