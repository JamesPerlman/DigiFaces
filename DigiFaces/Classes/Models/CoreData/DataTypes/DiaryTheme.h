//
//  DiaryTheme.h
//  
//
//  Created by James on 9/11/15.
//
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Module, Response;

@interface DiaryTheme : NSManagedObject

@property (nonatomic, retain) NSString * activityDesc;
@property (nonatomic, retain) NSNumber * activityId;
@property (nonatomic, retain) NSString * activityTitle;
@property (nonatomic, retain) NSNumber * activityTypeId;
@property (nonatomic, retain) NSNumber * isActive;
@property (nonatomic, retain) NSNumber * isRead;
@property (nonatomic, retain) NSNumber * parentActivityId;
@property (nonatomic, retain) NSNumber * unreadResponses;
@property (nonatomic, retain) NSSet *responses;
@property (nonatomic, retain) NSSet *modules;
@end

@interface DiaryTheme (CoreDataGeneratedAccessors)

- (void)addResponsesObject:(Response *)value;
- (void)removeResponsesObject:(Response *)value;
- (void)addResponses:(NSSet *)values;
- (void)removeResponses:(NSSet *)values;

- (void)addModulesObject:(Module *)value;
- (void)removeModulesObject:(Module *)value;
- (void)addModules:(NSSet *)values;
- (void)removeModules:(NSSet *)values;

@end
