//
//  Announcement+CoreDataProperties.m
//  
//
//  Created by James on 12/18/15.
//
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

#import "Announcement+CoreDataProperties.h"

@implementation Announcement (CoreDataProperties)

@dynamic announcementId;
@dynamic dateCreated;
@dynamic dateCreatedFormatted;
@dynamic isRead;
@dynamic text;
@dynamic title;
@dynamic files;
@dynamic project;

@end
