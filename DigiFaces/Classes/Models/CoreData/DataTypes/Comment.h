//
//  Comment.h
//  
//
//  Created by James on 9/11/15.
//
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class UserInfo;

@interface Comment : NSManagedObject

@property (nonatomic, retain) NSNumber * commentId;
@property (nonatomic, retain) NSString * dateCreated;
@property (nonatomic, retain) NSString * dateCreatedFormatted;
@property (nonatomic, retain) NSNumber * isActive;
@property (nonatomic, retain) NSNumber * isRead;
@property (nonatomic, retain) NSString * response;
@property (nonatomic, retain) NSNumber * threadId;
@property (nonatomic, retain) NSString * userId;
@property (nonatomic, retain) UserInfo *userInfo;

@end
