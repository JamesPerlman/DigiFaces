//
//  ImageGalleryResponse.h
//  
//
//  Created by James on 9/11/15.
//
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class File;

@interface ImageGalleryResponse : NSManagedObject

@property (nonatomic, retain) NSString * galleryIds;
@property (nonatomic, retain) NSNumber * imageGalleryId;
@property (nonatomic, retain) NSNumber * imageGalleryResponseId;
@property (nonatomic, retain) NSNumber * isActive;
@property (nonatomic, retain) NSString * response;
@property (nonatomic, retain) NSNumber * threadId;
@property (nonatomic, retain) NSString * userId;
@property (nonatomic, retain) NSSet *files;
@end

@interface ImageGalleryResponse (CoreDataGeneratedAccessors)

- (void)addFilesObject:(File *)value;
- (void)removeFilesObject:(File *)value;
- (void)addFiles:(NSSet *)values;
- (void)removeFiles:(NSSet *)values;

@end
