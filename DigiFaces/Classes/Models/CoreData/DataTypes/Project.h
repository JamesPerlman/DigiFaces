//
//  Project.h
//  
//
//  Created by James on 9/12/15.
//
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Company, DailyDiary, Integer;

@interface Project : NSManagedObject

@property (nonatomic, retain) NSNumber * allowProfilePicUpload;
@property (nonatomic, retain) NSNumber * companyId;
@property (nonatomic, retain) NSNumber * enableAvatarLibrary;
@property (nonatomic, retain) NSNumber * hasDailyDiary;
@property (nonatomic, retain) NSNumber * isActive;
@property (nonatomic, retain) NSNumber * isTrial;
@property (nonatomic, retain) NSNumber * languageId;
@property (nonatomic, retain) NSString * projectEndDate;
@property (nonatomic, retain) NSNumber * projectId;
@property (nonatomic, retain) NSString * projectInternalName;
@property (nonatomic, retain) NSString * projectName;
@property (nonatomic, retain) NSString * projectStartDate;
@property (nonatomic, retain) NSNumber * regionId;
@property (nonatomic, retain) DailyDiary *dailyDiary;
@property (nonatomic, retain) Company *company;
@property (nonatomic, retain) NSSet *dailyDiaryList;
@end

@interface Project (CoreDataGeneratedAccessors)

- (void)addDailyDiaryListObject:(Integer *)value;
- (void)removeDailyDiaryListObject:(Integer *)value;
- (void)addDailyDiaryList:(NSSet *)values;
- (void)removeDailyDiaryList:(NSSet *)values;

@end
