//
//  DisplayFile.h
//  DigiFaces
//
//  Created by confiz on 17/07/2015.
//  Copyright (c) 2015 Usasha studio. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "File.h"

@interface DisplayFile : NSObject

@property (nonatomic, strong) NSNumber * displayFileId;
@property (nonatomic, strong) NSNumber * activityId;
@property (nonatomic, strong) NSNumber * fileId;
@property (nonatomic, retain) File * file;

-(instancetype) initWithDictionary:(NSDictionary*)dict;

@end
