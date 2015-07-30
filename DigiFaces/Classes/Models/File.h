//
//  File.h
//  DigiFaces
//
//  Created by Apple on 17/06/2015.
//  Copyright (c) 2015 Usasha studio. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface File : NSObject

@property (nonatomic, retain) NSNumber * fileId;
@property (nonatomic, retain) NSString * fileName;
@property (nonatomic, retain) NSNumber * fileTypeId;
@property (nonatomic, retain) NSString * fileType;
@property (nonatomic, retain) NSString * extension;
@property (nonatomic, retain) NSNumber * isAmazonFile;
@property (nonatomic, retain) NSString * amazonKey;
@property (nonatomic, retain) NSNumber * isViddlerFile;
@property (nonatomic, retain) NSString * viddlerKey;
@property (nonatomic, retain) NSNumber * isCameraTagFile;
@property (nonatomic, retain) NSString * cameraTagKey;
@property (nonatomic, retain) NSNumber * positionId;
@property (nonatomic, retain) NSString * position;
@property (nonatomic, retain) NSString * publicFileUrl;

@property (nonatomic, retain) NSString * filePath;

@property (nonatomic, retain) NSDictionary * fileDictionary;

-(NSString*)getVideoThumbURL;
-(NSDictionary*)getFileDictionary;

-(instancetype)initWithDictionary:(NSDictionary*)dict;
-(NSString*)returnFilePathFromFileObject:(NSDictionary*)fileObject;

- (NSString*)filePathURLString;
@end
