//
//  DailyDiary+CoreDataProperties.h
//  
//
//  Created by James on 12/18/15.
//
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

#import "DailyDiary.h"

NS_ASSUME_NONNULL_BEGIN

@interface DailyDiary (CoreDataProperties)

@property (nullable, nonatomic, retain) NSNumber *activityId;
@property (nullable, nonatomic, retain) NSNumber *diaryId;
@property (nullable, nonatomic, retain) NSString *diaryIntroduction;
@property (nullable, nonatomic, retain) NSString *diaryQuestion;
@property (nullable, nonatomic, retain) File *file;
@property (nullable, nonatomic, retain) NSSet<Diary *> *userDiaries;
@property (nullable, nonatomic, retain) Project *project;

@end

@interface DailyDiary (CoreDataGeneratedAccessors)

- (void)addUserDiariesObject:(Diary *)value;
- (void)removeUserDiariesObject:(Diary *)value;
- (void)addUserDiaries:(NSSet<Diary *> *)values;
- (void)removeUserDiaries:(NSSet<Diary *> *)values;

@end

NS_ASSUME_NONNULL_END
