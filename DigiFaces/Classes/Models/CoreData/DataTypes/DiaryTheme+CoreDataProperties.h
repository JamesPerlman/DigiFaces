//
//  DiaryTheme+CoreDataProperties.h
//  
//
//  Created by James on 12/18/15.
//
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

#import "DiaryTheme.h"

NS_ASSUME_NONNULL_BEGIN

@interface DiaryTheme (CoreDataProperties)

@property (nullable, nonatomic, retain) NSString *activityDesc;
@property (nullable, nonatomic, retain) NSNumber *activityId;
@property (nullable, nonatomic, retain) NSString *activityTitle;
@property (nullable, nonatomic, retain) NSNumber *activityTypeId;
@property (nullable, nonatomic, retain) NSNumber *isActive;
@property (nullable, nonatomic, retain) NSNumber *isRead;
@property (nullable, nonatomic, retain) NSNumber *parentActivityId;
@property (nullable, nonatomic, retain) NSNumber *unreadResponses;
@property (nullable, nonatomic, retain) NSSet<Module *> *modules;
@property (nullable, nonatomic, retain) NSSet<Response *> *responses;
@property (nullable, nonatomic, retain) Project *project;

@end

@interface DiaryTheme (CoreDataGeneratedAccessors)

- (void)addModulesObject:(Module *)value;
- (void)removeModulesObject:(Module *)value;
- (void)addModules:(NSSet<Module *> *)values;
- (void)removeModules:(NSSet<Module *> *)values;

- (void)addResponsesObject:(Response *)value;
- (void)removeResponsesObject:(Response *)value;
- (void)addResponses:(NSSet<Response *> *)values;
- (void)removeResponses:(NSSet<Response *> *)values;

@end

NS_ASSUME_NONNULL_END
