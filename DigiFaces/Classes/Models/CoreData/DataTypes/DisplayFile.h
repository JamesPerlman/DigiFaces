//
//  DisplayFile.h
//  
//
//  Created by James on 9/11/15.
//
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class File;

@interface DisplayFile : NSManagedObject

@property (nonatomic, retain) NSNumber * activityId;
@property (nonatomic, retain) NSNumber * displayFileId;
@property (nonatomic, retain) NSNumber * fileId;
@property (nonatomic, retain) File *file;

@end
