//
//  File.m
//
//
//  Created by James on 9/11/15.
//
//

#import "File.h"
#import <MediaPlayer/MediaPlayer.h>

@implementation File

@dynamic amazonKey;
@dynamic cameraTagKey;
@dynamic extension;
@dynamic fileId;
@dynamic fileName;
@dynamic fileType;
@dynamic fileTypeId;
@dynamic isAmazonFile;
@dynamic isCameraTagFile;
@dynamic isViddlerFile;
@dynamic position;
@dynamic positionId;
@dynamic publicFileUrl;
@dynamic viddlerKey;

@synthesize fileDictionary;

@end


@implementation File (DynamicMethods)

+ (instancetype)fileWithDictionary:(NSDictionary *)dictionary insertedIntoManagedObjectContext:(NSManagedObjectContext *)managedObjectContext {
    File *file = [NSEntityDescription insertNewObjectForEntityForName:@"File" inManagedObjectContext:managedObjectContext];
    if (file) {
        
        file.fileDictionary = dictionary;
        
        file.fileType = dictionary[@"FileType"];
        file.fileId = @([dictionary[@"FileId"] integerValue]);
        file.fileName = dictionary[@"FileName"];
        file.isCameraTagFile = @([dictionary[@"IsCameraTagFile"] boolValue]);
        file.isAmazonFile = @([dictionary[@"IsAmazonFile"] boolValue]);
        file.isViddlerFile = @([dictionary[@"IsViddlerFile"] boolValue]);
        file.viddlerKey = dictionary[@"ViddlerKey"];
        file.amazonKey = dictionary[@"AmazonKey"];
        file.cameraTagKey = dictionary[@"CameraTagKey"];
        
        
    }
    
    return file;
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
        if ((self.viddlerKey.length > 6 && [[self.viddlerKey substringToIndex:7] isEqualToString:@"http://"]) || (self.viddlerKey.length > 7 && [[self.viddlerKey substringToIndex:8] isEqualToString:@"https://"])) {
            url = nil;
        } else {
            url = [NSString stringWithFormat:@"http://thumbs.cdn-ec.viddler.com/thumbnail_2_%@_v1.jpg", self.viddlerKey];
        }
    }
    return url;
}

-(NSString*)filePath {
    if (self.isAmazonFile.boolValue) {
        return self.amazonKey;
    } else if (self.isCameraTagFile.boolValue) {
        return self.cameraTagKey;
    } else if (self.isViddlerFile.boolValue) {
        if ([[self.viddlerKey substringToIndex:7] isEqualToString:@"http://"] || [[self.viddlerKey substringToIndex:8] isEqualToString:@"https://"]) {
            return self.viddlerKey;
        } else {
            return [NSString stringWithFormat:@"http://www.viddler.com/file/%@/html5mobile", self.viddlerKey];
        }
    } else if (self.amazonKey) {
        return self.amazonKey;
    } else return nil;
    
}

-(NSURL*)filePathURL {
    NSString *urlString = [self filePath];
    urlString = [urlString stringByReplacingOccurrencesOfString:@"\n" withString:@""];
    urlString = [urlString stringByReplacingOccurrencesOfString:@"\r" withString:@""];
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
