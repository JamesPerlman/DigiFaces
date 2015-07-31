//
//  File.m
//  DigiFaces
//
//  Created by Apple on 17/06/2015.
//  Copyright (c) 2015 Usasha studio. All rights reserved.
//

#import "File.h"

@implementation File

-(instancetype)initWithDictionary:(NSDictionary *)dict
{
    self = [super init];
    if (self) {
        self.fileDictionary = dict;
        
        self.fileType = [dict valueForKey:@"FileType"];
        self.fileId = [dict valueForKey:@"FileId"];
        self.fileName = dict[@"FileName"];
        self.isCameraTagFile = [dict valueForKey:@"IsCameraTagFile"];
        self.isAmazonFile = [dict valueForKey:@"IsAmazonFile"];
        self.isViddlerFile = [dict valueForKey:@"IsViddlerFile"];
        self.viddlerKey = [dict valueForKey:@"ViddlerKey"];
        self.amazonKey = dict[@"AmazonKey"];
        self.cameraTagKey = dict[@"CameraTagKey"];
        
      
    }
    
    return self;
}

- (NSDictionary*)dictionary {
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    NSArray *keys = @[@"fileId",
                      @"fileName",
                      @"fileTypeId",
                      @"fileType",
                      @"extension",
                      @"isAmazonFile",
                      @"amazonKey",
                      @"isViddlerFile",
                      @"viddlerKey",
                      @"isCameraTagFile",
                      @"cameraTagKey",
                      @"positionId",
                      @"position",
                      @"publicFileUrl",
                      @"filePath"];
    for (NSString *key in keys) {
        @try {
            NSString *keyCapitalizedFirstLetter = [[key substringToIndex:1] capitalizedString];
            NSString *keyRestOfString = [key substringFromIndex:1];
            NSString *Key = [keyCapitalizedFirstLetter stringByAppendingString:keyRestOfString];
            dict[Key] = [self valueForKey:key];
        } @catch (NSException *exc) {}
    }
    return [NSDictionary dictionaryWithDictionary:dict];
}

-(NSString *)getVideoThumbURL
{
    NSString * url;
    if (self.isViddlerFile.boolValue) {
        url = [NSString stringWithFormat:@"http://cdn-thumbs.viddler.com/thumbnail_2_%@.jpg", self.viddlerKey];
    }
    return url;
}

-(NSString*)filePath {
    if (self.isAmazonFile.boolValue) {
        return self.amazonKey;
    } else if (self.isCameraTagFile.boolValue) {
        return self.cameraTagKey;
    } else if (self.isViddlerFile.boolValue) {
        return [NSString stringWithFormat:@"http://www.viddler.com/file/%@/html5mobile", self.viddlerKey];
    } else if (self.amazonKey) {
        return self.amazonKey;
    } else return nil;

}

-(NSURL*)filePathURL {
    NSString *urlString = [self filePath];
    
    return [NSURL URLWithString:urlString];
}

-(NSString*)returnFilePathFromFileObject:(NSDictionary*)fileObject{
    
    NSString * imageUrl = @"";
    
    if ([[fileObject objectForKey:@"IsAmazonFile"] boolValue]) {
        imageUrl = [fileObject valueForKey:@"AmazonKey"];
    }
    else if ([[fileObject objectForKey:@"IsCameraTagFile"] boolValue])
    {
        imageUrl = [fileObject valueForKey:@"CameraTagKey"];
    }
    else if ([[fileObject objectForKey:@"IsViddlerFile"] boolValue])
    {
        NSString * key = [fileObject valueForKey:@"ViddlerKey"];
       // NSString * fileName = [fileObject valueForKey:@"FileName"];
        
        imageUrl = [NSString stringWithFormat:@"http://www.viddler.com/file/%@/html5mobile", key];
    }
    
    return imageUrl;
}
@end
