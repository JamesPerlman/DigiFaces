//
//  DailyDiary.h
//  
//
//  Created by James on 9/11/15.
//
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Diary, File;

@interface DailyDiary : NSManagedObject

@property (nonatomic, retain) NSNumber * activityId;
@property (nonatomic, retain) NSNumber * diaryId;
@property (nonatomic, retain) NSString * diaryIntroduction;
@property (nonatomic, retain) NSString * diaryQuestion;
@property (nonatomic, retain) NSSet *userDiaries;
@property (nonatomic, retain) File *file;
@end

@interface DailyDiary (CoreDataGeneratedAccessors)

- (void)addUserDiariesObject:(Diary *)value;
- (void)removeUserDiariesObject:(Diary *)value;
- (void)addUserDiaries:(NSSet *)values;
- (void)removeUserDiaries:(NSSet *)values;

@end

@interface DailyDiary (DynamicMethods)

@property (nonatomic, retain) NSMutableDictionary * diariesDict;
@property (nonatomic, retain) NSMutableArray * diariesDate;

- (void)checkForUnreadComments;
- (NSInteger)numberOfUnreadResponses;
//- (instancetype)initWithDictionary:(NSDictionary*)dict;
- (Diary*)getResponseWithThreadID:(NSNumber*)threadId;

@end
