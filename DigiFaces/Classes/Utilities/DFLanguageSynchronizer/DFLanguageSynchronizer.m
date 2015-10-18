//
//  DFLanguageSynchronizer.m
//  DigiFaces
//
//  Created by James on 10/17/15.
//  Copyright © 2015 INET360. All rights reserved.
//


#import "DFLanguageSynchronizer.h"
#import <AFNetworking/AFNetworking.h>

static NSBundle *staticCustomBundle = nil;

@interface DFLanguageSynchronizer ()

@property (nonatomic, strong) void (^processCompletionBlock)(NSError*);

@end

@implementation DFLanguageSynchronizer

#define DFCustomLanguageBundleName @"Localization.bundle"
#pragma mark Download Translation from server

+ (instancetype)sharedInstance
{
    static id _sharedInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _sharedInstance = [[self alloc] init];
    });
    
    return _sharedInstance;
}

+ (void)initialize {
    [self createNewBundle];
}

#pragma mark - Localization Method

+ (NSString*)localizedStringForKey:(NSString*)key withComment:(NSString*)comment {
    NSString *localizedString = [[[self class] getStaticCustomBundle] localizedStringForKey:key value:@"" table:nil];
    if (!localizedString || [localizedString isEqualToString:@""] || [localizedString isEqualToString:key]) {
        return NSLocalizedString(key, comment);
    }
    return localizedString;
}

#pragma mark - Bundle Management

+ (void)createNewBundle {
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = paths[0];
    // Get documents folder
    NSString *dataPath = [documentsDirectory stringByAppendingPathComponent:DFCustomLanguageBundleName];
    // adapt this
    staticCustomBundle = [NSBundle bundleWithPath:dataPath];
}

+ (NSBundle *)getStaticCustomBundle {
    if (nil == staticCustomBundle) {
        [self createNewBundle];
    } return staticCustomBundle;
}

#pragma mark - Convenience Methods

- (NSString*)currentLanguageCode {
    NSString *languageCode = [NSLocale preferredLanguages][0];
    return [languageCode substringToIndex:2];
}

// returns a url like http://digifaces.com/localization/en.strings
- (NSURL*)urlPathForCurrentLanguage {
    NSString *urlPath = [NSString stringWithFormat:@"%@%@.%@", DFLocalizedStringsDirectoryURLPath, [self currentLanguageCode], DFLocalizedStringsFileExtension];
    return [NSURL URLWithString:urlPath];
}

- (NSString*)folderPathForCustomLocalizationFile {
    return [NSString stringWithFormat:@"%@/%@.lproj", DFCustomLanguageBundleName, [self currentLanguageCode]];
}

- (void)completeProcessWithError:(NSError*)error {
    if (self.processCompletionBlock) {
        self.processCompletionBlock(error);
        self.processCompletionBlock = nil;
    }
}

#pragma mark - Data Loading

-(void)synchronizeStringsWithCompletion:(void (^)(NSError* error))completionBlock {
    
    self.processCompletionBlock = completionBlock;
    
    NSError *error = nil;
    [self loadStringsData:&error];
    
    if (error) {
        [self downloadStringsFromServer];
    } else {
        [self completeProcessWithError:nil];
    }
}

- (void)downloadStringsFromServer {
    NSURL *url = [self urlPathForCurrentLanguage];
    // adapt this
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    AFHTTPRequestOperation *operation = [[AFHTTPRequestOperation alloc] initWithRequest:request];
    
    __weak __typeof(self) wself = self;
    [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        __strong __typeof(wself) sself = wself;
        if (sself) {
            [sself handleStringsDownloadSuccessWithData:operation.responseData];
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        __strong __typeof(wself) sself = wself;
        if (sself) {
            [sself handleStringsDownloadFailureWithError:error];
        }
    }];
    [operation start];
}


- (void)handleStringsDownloadSuccessWithData:(NSData*)stringsData {
    NSError *error = nil;
    [self saveStringsData:stringsData error:&error];
    if (error) {
        [self handleStringsDownloadFailureWithError:error];
    } else {
        [self completeProcessWithError:nil];
    }
}

- (void)handleStringsDownloadFailureWithError:(NSError*)error {
    [self completeProcessWithError:error];
}

#pragma mark Data Caching

-(void)loadStringsData:(NSError * _Nullable __autoreleasing*)error {
    *error = nil;
    
    NSString *folder = [self folderPathForCustomLocalizationFile];
    NSString *filename = @"Localizable.strings";
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = paths[0];
    NSString *dataPath = [documentsDirectory stringByAppendingPathComponent:folder];
    NSString *filePath = [NSString stringWithFormat:@"%@/%@", dataPath, filename];
    
    if ([[NSFileManager defaultManager] fileExistsAtPath:filePath]) {
        NSURL *backUrl = [NSURL fileURLWithPath:filePath];
        [self addSkipBackupAttributeToItemAtURL:backUrl];
        
        // check if date is too old
        NSDictionary *attributes = [[NSFileManager defaultManager] attributesOfItemAtPath:filePath error:error];
        NSDate *date = [attributes fileModificationDate];
        
        if ([[NSDate date] timeIntervalSinceDate:date] > DFLocalizationSynchronizerUpdateInterval) {
            NSString *errorDescription = [NSString stringWithFormat:@"Localization data requires update."];
            *error = [NSError errorWithDomain:@"DFLanguageSynchronizer.data.needsUpdate" code:3 userInfo:@{NSLocalizedDescriptionKey : errorDescription}];
        }
    } else {
        NSString *errorDescription = [NSString stringWithFormat:@"File does not exist: %@", filePath];
        *error = [NSError errorWithDomain:@"DFLanguageSynchronizer.NSFileManager.load" code:2 userInfo:@{NSLocalizedDescriptionKey : errorDescription}];
    }
}

-(void)saveStringsData:(NSData *)data error:(NSError* _Nullable __autoreleasing*)error {
    *error = nil;
    
    NSString *folder = [self folderPathForCustomLocalizationFile];
    NSString *filename = @"Localizable.strings";
    NSData *dataToSave = data;
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = paths[0];
    
    // Get documents folder
    NSString *dataPath = [documentsDirectory stringByAppendingPathComponent:folder];
    if (![[NSFileManager defaultManager] fileExistsAtPath:dataPath]){
        [[NSFileManager defaultManager] createDirectoryAtPath:dataPath withIntermediateDirectories:YES attributes:nil error:error];
    }
    if (*error) return;
    //Create folder
    NSString *filePath = [NSString stringWithFormat:@"%@/%@", dataPath, filename];
    if(![dataToSave writeToFile:filePath atomically:YES]) {
        NSString *errorDescription = [NSString stringWithFormat:@"Could not save data to file: %@ in directory %@", filename, filePath];
        *error = [NSError errorWithDomain:@"DFLanguageSynchronizer.NSFileManager.save" code:1 userInfo:@{NSLocalizedDescriptionKey : errorDescription}];
    } else {
        // DON'T forget to call the next function.
        // Since we do not want the downloaded data to be saved through iCloud
        // Otherwise App would be rejected by Apple. You can only save data in the
        // iCloud if it is created by the user (not downloaded...)
        NSURL *backUrl = [NSURL fileURLWithPath:filePath];
        [self addSkipBackupAttributeToItemAtURL:backUrl];
        NSLog(@"DFLanguageSynchronizer synchronized localization files: %@ to %@", filename, filePath);
    }
}
// needed, so that images are not stored in iCloud!
- (BOOL)addSkipBackupAttributeToItemAtURL:(NSURL *)URL {
    assert([[NSFileManager defaultManager] fileExistsAtPath: [URL path]]);
    NSError *error = nil;
    BOOL success = [URL setResourceValue: [NSNumber numberWithBool: YES] forKey: NSURLIsExcludedFromBackupKey error: &error];
    if(!success){
        NSLog(@"Error excluding %@ from backup %@", [URL lastPathComponent], error);
    }
    return success;
}
//- See more at: http://iosapplove.com/archive/2013/01/localizable-strings-how-to-load-translations-dynamically-and-use-it-inside-your-iphone-app/#sthash.ABbl63u0.dpuf


//- See more at: http://iosapplove.com/archive/2013/01/localizable-strings-how-to-load-translations-dynamically-and-use-it-inside-your-iphone-app/#sthash.ABbl63u0.dpuf


@end