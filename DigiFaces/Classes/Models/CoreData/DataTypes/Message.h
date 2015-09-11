//
//  Message.h
//  
//
//  Created by James on 9/11/15.
//
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Message, UserInfo;

@interface Message : NSManagedObject

@property (nonatomic, retain) NSString * dateCreated;
@property (nonatomic, retain) NSString * dateCreatedFormatted;
@property (nonatomic, retain) NSString * fromUser;
@property (nonatomic, retain) NSNumber * isRead;
@property (nonatomic, retain) NSNumber * messageId;
@property (nonatomic, retain) NSNumber * projectId;
@property (nonatomic, retain) NSString * response;
@property (nonatomic, retain) NSString * subject;
@property (nonatomic, retain) NSString * toUser;
@property (nonatomic, retain) NSSet *childMessages;
@property (nonatomic, retain) UserInfo *fromUserInfo;
@property (nonatomic, retain) UserInfo *toUserInfo;
@end

@interface Message (CoreDataGeneratedAccessors)

- (void)addChildMessagesObject:(Message *)value;
- (void)removeChildMessagesObject:(Message *)value;
- (void)addChildMessages:(NSSet *)values;
- (void)removeChildMessages:(NSSet *)values;

@end
