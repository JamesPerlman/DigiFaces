//
//  Diary.h
//  
//
//  Created by James on 9/11/15.
//
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class UserInfo;

@interface Diary : NSManagedObject

@property (nonatomic, retain) NSString * dateCreated;
@property (nonatomic, retain) NSString * dateCreatedFormatted;
@property (nonatomic, retain) NSNumber * isRead;
@property (nonatomic, retain) NSString * response;
@property (nonatomic, retain) NSNumber * responseId;
@property (nonatomic, retain) NSString * threadId;
@property (nonatomic, retain) NSString * title;
@property (nonatomic, retain) NSString * userId;
@property (nonatomic, retain) UserInfo *userInfo;

@end
