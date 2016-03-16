//
//  Diary.h
//  
//
//  Created by James on 9/11/15.
//
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Comment, InternalComment, ResearcherComment, File, UserInfo;

@interface Diary : NSManagedObject

@property (nonatomic, retain) NSString * dateCreated;
@property (nonatomic, retain) NSString * dateCreatedFormatted;
@property (nonatomic, retain) NSNumber * isRead;
@property (nonatomic, retain) NSString * response;
@property (nonatomic, retain) NSNumber * responseId;
@property (nonatomic, retain) NSNumber * threadId;
@property (nonatomic, retain) NSString * title;
@property (nonatomic, retain) NSString * userId;
@property (nonatomic, retain) UserInfo *userInfo;
@property (nonatomic, retain) NSSet *files;
@property (nonatomic, retain) NSSet *comments;
@property (nonatomic, retain) NSSet *internalComments;
@property (nonatomic, retain) NSSet *researcherComments;

@end

@interface Diary (CoreDataGeneratedAccessors)

- (void)addFilesObject:(File *)value;
- (void)removeFilesObject:(File *)value;
- (void)addFiles:(NSSet *)values;
- (void)removeFiles:(NSSet *)values;

- (void)addCommentsObject:(Comment *)value;
- (void)removeCommentsObject:(Comment *)value;
- (void)addComments:(NSSet *)values;
- (void)removeComments:(NSSet *)values;

- (void)addInternalCommentsObject:(InternalComment *)value;
- (void)removeInternalCommentsObject:(InternalComment *)value;
- (void)addInternalComments:(NSSet *)values;
- (void)removeInternalComments:(NSSet *)values;

- (void)addResearcherCommentsObject:(ResearcherComment *)value;
- (void)removeResearcherCommentsObject:(ResearcherComment *)value;
- (void)addResearcherComments:(NSSet *)values;
- (void)removeResearcherComments:(NSSet *)values;

@end

@interface Diary (DynamicMethods)

-(NSInteger)picturesCount;
-(NSInteger)videosCount;

@end
