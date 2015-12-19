//
//  DailyDiary.h
//  
//
//  Created by James on 12/18/15.
//
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Diary, File, Project;

NS_ASSUME_NONNULL_BEGIN

@interface DailyDiary : NSManagedObject

// Insert code here to declare functionality of your managed object subclass

@property (nonatomic, retain) NSMutableDictionary * diariesDict;
@property (nonatomic, retain) NSMutableArray * diariesDate;

- (void)checkForUnreadComments;
- (NSInteger)numberOfUnreadResponses;
//- (instancetype)initWithDictionary:(NSDictionary*)dict;
- (Diary*)getResponseWithThreadID:(NSNumber*)threadId;

@end

NS_ASSUME_NONNULL_END

#import "DailyDiary+CoreDataProperties.h"
