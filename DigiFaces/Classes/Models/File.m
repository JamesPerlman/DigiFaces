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
        self.isCameraTagFile = [dict valueForKey:@"IsCameraTagFile"];
        self.isAmazonFile = [dict valueForKey:@"IsAmazonFile"];
        self.isViddlerFile = [dict valueForKey:@"IsViddlerFile"];
        self.viddlerKey = [dict valueForKey:@"ViddlerKey"];
        self.filePath = [[self returnFilePathFromFileObject:dict] stringByReplacingOccurrencesOfString:@"\n" withString:@""];
    }
    
    return self;
}

-(NSString *)getVideoThumbURL
{
    NSString * url;
    if (self.isViddlerFile.boolValue) {
        url = [NSString stringWithFormat:@"http://cdn-thumbs.viddler.com/thumbnail_2_%@.jpg", self.viddlerKey];
    }
    return url;
}

-(NSString*)filePathURLString {
    if (self.isAmazonFile.boolValue) {
        return self.amazonKey;
    } else if (self.isCameraTagFile.boolValue) {
        return self.cameraTagKey;
    } else if (self.isViddlerFile.boolValue) {
        return [NSString stringWithFormat:@"http://www.viddler.com/file/%@/html5mobile", self.viddlerKey];
    } else return nil;

}

-(NSURL*)filePathURL {
    NSString *urlString = [self filePathURLString];
    
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
