//
//  File.h
//  
//
//  Created by James on 9/11/15.
//
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface File : NSManagedObject

@property (nonatomic, retain) NSString * amazonKey;
@property (nonatomic, retain) NSString * cameraTagKey;
@property (nonatomic, retain) NSString * extension;
@property (nonatomic, retain) NSNumber * fileId;
@property (nonatomic, retain) NSString * fileName;
@property (nonatomic, retain) NSString * fileType;
@property (nonatomic, retain) NSNumber * fileTypeId;
@property (nonatomic, retain) NSNumber * isAmazonFile;
@property (nonatomic, retain) NSNumber * isCameraTagFile;
@property (nonatomic, retain) NSNumber * isViddlerFile;
@property (nonatomic, retain) NSString * position;
@property (nonatomic, retain) NSNumber * positionId;
@property (nonatomic, retain) NSString * publicFileUrl;
@property (nonatomic, retain) NSString * viddlerKey;

@property (nonatomic, retain) NSDictionary * fileDictionary;


@end

@interface File (DynamicMethods)

+ (instancetype)fileWithDictionary:(NSDictionary *)dictionary insertedIntoManagedObjectContext:(NSManagedObjectContext *)managedObjectContext;

-(NSString*)getVideoThumbURL;
-(NSDictionary*)dictionary;

- (NSString*)filePath;
- (NSURL*)filePathURL;

@end
