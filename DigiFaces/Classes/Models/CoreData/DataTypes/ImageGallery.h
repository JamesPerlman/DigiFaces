//
//  ImageGallery.h
//  
//
//  Created by James on 9/11/15.
//
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class File;

@interface ImageGallery : NSManagedObject

@property (nonatomic, retain) NSNumber * activityId;
@property (nonatomic, retain) NSString * galleryIds;
@property (nonatomic, retain) NSNumber * imageGalleryId;
@property (nonatomic, retain) NSString * userId;
@property (nonatomic, retain) NSSet *files;
@end

@interface ImageGallery (CoreDataGeneratedAccessors)

- (void)addFilesObject:(File *)value;
- (void)removeFilesObject:(File *)value;
- (void)addFiles:(NSSet *)values;
- (void)removeFiles:(NSSet *)values;

@end
