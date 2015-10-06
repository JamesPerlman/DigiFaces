//
//  DFDataManager.h
//  DigiFaces
//
//  Created by James on 10/2/15.
//  Copyright © 2015 INET360. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DFDataManager : NSObject

+ (instancetype)sharedManager;

+ (void)setManagedObjectContext:(NSManagedObjectContext*)managedObjectContext;

+ (void)removeEntitiesWithEntityName:(NSString*)entityName idKey:(NSString*)idKey notInArray:(NSArray*)array predicate:(NSPredicate*)predicate;

@end
