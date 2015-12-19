//
//  Announcement+CoreDataProperties.h
//  
//
//  Created by James on 12/18/15.
//
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

#import "Announcement.h"

NS_ASSUME_NONNULL_BEGIN

@interface Announcement (CoreDataProperties)

@property (nullable, nonatomic, retain) NSNumber *announcementId;
@property (nullable, nonatomic, retain) NSString *dateCreated;
@property (nullable, nonatomic, retain) NSString *dateCreatedFormatted;
@property (nullable, nonatomic, retain) NSNumber *isRead;
@property (nullable, nonatomic, retain) NSString *text;
@property (nullable, nonatomic, retain) NSString *title;
@property (nullable, nonatomic, retain) NSSet<File *> *files;
@property (nullable, nonatomic, retain) Project *project;

@end

@interface Announcement (CoreDataGeneratedAccessors)

- (void)addFilesObject:(File *)value;
- (void)removeFilesObject:(File *)value;
- (void)addFiles:(NSSet<File *> *)values;
- (void)removeFiles:(NSSet<File *> *)values;

@end

NS_ASSUME_NONNULL_END
