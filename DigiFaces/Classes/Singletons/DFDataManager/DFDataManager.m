//
//  DFDataManager.m
//  DigiFaces
//
//  Created by James on 10/2/15.
//  Copyright © 2015 INET360. All rights reserved.
//

#import "DFDataManager.h"

@interface DFDataManager ()

@property (nonatomic, strong) NSManagedObjectContext *managedObjectContext;

@end

@implementation DFDataManager

+ (instancetype)sharedInstance
{
    static id _sharedInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _sharedInstance = [[self alloc] init];
    });
    
    return _sharedInstance;
}

+ (void)setManagedObjectContext:(NSManagedObjectContext *)managedObjectContext {
    [[self sharedInstance] setManagedObjectContext:managedObjectContext];
}

+ (void)removeEntitiesWithEntityName:(NSString*)entityName idKey:(NSString*)idKey notInArray:(NSArray*)array predicate:(NSPredicate*)predicate {
    [[self sharedInstance] removeEntitiesWithEntityName:entityName idKey:idKey notInArray:array predicate:predicate];
}

- (void)removeEntitiesWithEntityName:(NSString*)entityName idKey:(NSString*)idKey notInArray:(NSArray*)array predicate:(NSPredicate*)predicate {
    
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:entityName inManagedObjectContext:[self managedObjectContext]];
    [fetchRequest setEntity:entity];
    // Specify criteria for filtering which objects to fetch
    NSString *unionKeyPath = [NSString stringWithFormat:@"@distinctUnionOfObjects.%@", idKey];
    NSArray *idArray = [array valueForKeyPath:unionKeyPath];
    
    NSLog(@"Removing managed objects of the entity %@ whose %@ is not in \n(%@)", entityName, idKey, [idArray componentsJoinedByString:@", "]);
    
    NSPredicate *fetchPredicate, *notPredicate = [NSPredicate predicateWithFormat:@"NOT (%K in %@)", idKey, idArray];
    
    if (predicate) {
        fetchPredicate = [NSCompoundPredicate andPredicateWithSubpredicates:@[notPredicate, predicate]];
    } else {
        fetchPredicate = notPredicate;
    }
    
    [fetchRequest setPredicate:fetchPredicate];
    // Specify how the fetched objects should be sorted
    NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:idKey
                                                                   ascending:YES];
    [fetchRequest setSortDescriptors:[NSArray arrayWithObjects:sortDescriptor, nil]];
    
    NSError *error = nil;
    NSArray *fetchedObjects = [[self managedObjectContext] executeFetchRequest:fetchRequest error:&error];
    if (error) {
        NSLog(@"Something went wrong while fetching objects to delete: %@", error);
    } else {
        if (fetchedObjects != nil) {
            for (NSManagedObject *obj in fetchedObjects) {
                NSLog(@"Removing entity with %@ = %@", idKey, [obj valueForKey:idKey]);
                [[self managedObjectContext] deleteObject:obj];
            }
            [[self managedObjectContext] save:&error];
            if (error) {
                NSLog(@"Something went wrong saving the context after attempting to delete orphaned objects: %@", error);
            }
        }
    }
    
}
@end
