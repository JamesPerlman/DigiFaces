//
//  InternalComment+CoreDataProperties.h
//  DigiFaces
//
//  Created by James on 3/15/16.
//  Copyright © 2016 INET360. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

#import "InternalComment.h"

NS_ASSUME_NONNULL_BEGIN

@interface InternalComment (CoreDataProperties)

@property (nullable, nonatomic, retain) NSNumber *internalCommentId;
@property (nullable, nonatomic, retain) NSDate *dateCreated;
@property (nullable, nonatomic, retain) NSString *dateCreatedFormatted;
@property (nullable, nonatomic, retain) NSNumber *isActive;
@property (nullable, nonatomic, retain) NSString *response;
@property (nullable, nonatomic, retain) NSNumber *threadId;
@property (nullable, nonatomic, retain) NSNumber *userId;
@property (nullable, nonatomic, retain) UserInfo *userInfo;

@end

NS_ASSUME_NONNULL_END
