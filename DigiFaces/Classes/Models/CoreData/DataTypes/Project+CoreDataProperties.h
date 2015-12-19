//
//  Project+CoreDataProperties.h
//  
//
//  Created by James on 12/18/15.
//
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

#import "Project.h"

NS_ASSUME_NONNULL_BEGIN

@interface Project (CoreDataProperties)

@property (nullable, nonatomic, retain) NSNumber *allowProfilePicUpload;
@property (nullable, nonatomic, retain) NSNumber *companyId;
@property (nullable, nonatomic, retain) NSNumber *enableAvatarLibrary;
@property (nullable, nonatomic, retain) NSNumber *hasDailyDiary;
@property (nullable, nonatomic, retain) NSNumber *isActive;
@property (nullable, nonatomic, retain) NSNumber *isTrial;
@property (nullable, nonatomic, retain) NSNumber *languageId;
@property (nullable, nonatomic, retain) NSString *projectEndDate;
@property (nullable, nonatomic, retain) NSNumber *projectId;
@property (nullable, nonatomic, retain) NSString *projectInternalName;
@property (nullable, nonatomic, retain) NSString *projectName;
@property (nullable, nonatomic, retain) NSString *projectStartDate;
@property (nullable, nonatomic, retain) NSNumber *regionId;
@property (nullable, nonatomic, retain) Company *company;
@property (nullable, nonatomic, retain) DailyDiary *dailyDiary;
@property (nullable, nonatomic, retain) NSSet<Integer *> *dailyDiaryList;
@property (nullable, nonatomic, retain) NSSet<DiaryTheme *> *activities;
@property (nullable, nonatomic, retain) NSSet<Announcement *> *announcements;

@end

@interface Project (CoreDataGeneratedAccessors)

- (void)addDailyDiaryListObject:(Integer *)value;
- (void)removeDailyDiaryListObject:(Integer *)value;
- (void)addDailyDiaryList:(NSSet<Integer *> *)values;
- (void)removeDailyDiaryList:(NSSet<Integer *> *)values;

- (void)addActivitiesObject:(NSManagedObject *)value;
- (void)removeActivitiesObject:(NSManagedObject *)value;
- (void)addActivities:(NSSet<NSManagedObject *> *)values;
- (void)removeActivities:(NSSet<NSManagedObject *> *)values;

- (void)addAnnouncementsObject:(Announcement *)value;
- (void)removeAnnouncementsObject:(Announcement *)value;
- (void)addAnnouncements:(NSSet<Announcement *> *)values;
- (void)removeAnnouncements:(NSSet<Announcement *> *)values;

@end

NS_ASSUME_NONNULL_END
