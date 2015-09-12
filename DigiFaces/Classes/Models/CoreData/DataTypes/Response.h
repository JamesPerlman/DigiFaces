//
//  Response.h
//  
//
//  Created by James on 9/11/15.
//
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Comment, File, ImageGalleryResponse, TextareaResponse, UserInfo;

@interface Response : NSManagedObject

@property (nonatomic, retain) NSNumber * activityId;
@property (nonatomic, retain) NSString * dateCreated;
@property (nonatomic, retain) NSString * dateCreatedFormatted;
@property (nonatomic, retain) NSNumber * hasImageGalleryResponse;
@property (nonatomic, retain) NSNumber * hasTextareaResponse;
@property (nonatomic, retain) NSNumber * isActive;
@property (nonatomic, retain) NSNumber * isDraft;
@property (nonatomic, retain) NSNumber * isRead;
@property (nonatomic, retain) NSNumber * threadId;
@property (nonatomic, retain) UserInfo *userInfo;
@property (nonatomic, retain) NSSet *files;
@property (nonatomic, retain) NSSet *comments;
@property (nonatomic, retain) NSSet *textareaResponses;
@property (nonatomic, retain) NSSet *imageGalleryResponses;
//@property (nonatomic, retain) NSSet * tags;
@end

@interface Response (CoreDataGeneratedAccessors)

- (void)addFilesObject:(File *)value;
- (void)removeFilesObject:(File *)value;
- (void)addFiles:(NSSet *)values;
- (void)removeFiles:(NSSet *)values;

- (void)addCommentsObject:(Comment *)value;
- (void)removeCommentsObject:(Comment *)value;
- (void)addComments:(NSSet *)values;
- (void)removeComments:(NSSet *)values;

- (void)addTextareaResponsesObject:(TextareaResponse *)value;
- (void)removeTextareaResponsesObject:(TextareaResponse *)value;
- (void)addTextareaResponses:(NSSet *)values;
- (void)removeTextareaResponses:(NSSet *)values;

- (void)addImageGalleryResponsesObject:(ImageGalleryResponse *)value;
- (void)removeImageGalleryResponsesObject:(ImageGalleryResponse *)value;
- (void)addImageGalleryResponses:(NSSet *)values;
- (void)removeImageGalleryResponses:(NSSet *)values;

@end
