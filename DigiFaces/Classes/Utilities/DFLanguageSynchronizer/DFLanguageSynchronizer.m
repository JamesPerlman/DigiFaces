//
//  DFLanguageSynchronizer.m
//  DigiFaces
//
//  Created by James on 10/17/15.
//  Copyright © 2015 INET360. All rights reserved.
//


#import "DFLanguageSynchronizer.h"
#import <AFNetworking/AFNetworking.h>
#import "Language.h"

static NSMutableDictionary<NSString *, NSBundle *> *staticCustomBundles = nil;

@interface DFLanguageSynchronizer ()

@property (nonatomic, strong) void (^processCompletionBlock)(NSError*);

@property (nonatomic, strong) NSString *currentLanguageCode;

@end

@implementation DFLanguageSynchronizer

#define DFCustomLanguageBundlePrefix @"Localized"
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
+ (void)initialize
{
    if (self == [DFLanguageSynchronizer class]) {
        staticCustomBundles = [NSMutableDictionary dictionary];
    }
}

#pragma mark - Localization Method

+ (NSString*)localizedStringForKey:(NSString*)key withComment:(NSString*)comment {
    NSString *localizedString = [[[self class] getStaticCustomBundleForLanguageCode:[[self sharedInstance] currentLanguageCode]] localizedStringForKey:key value:@"" table:nil];
    if (!localizedString || [localizedString isEqualToString:@""] || [localizedString isEqualToString:key]) {
        return NSLocalizedString(key, comment);
    }
    return localizedString;
}

#pragma mark - Bundle Management

+ (void)createNewBundleForLanguageCode:(NSString*)languageCode {
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = paths[0];
    // Get documents folder
    NSString *dataPath = [documentsDirectory stringByAppendingPathComponent:[self bundleNameForLanguageCode:languageCode]];
    // adapt this
    staticCustomBundles[languageCode] = [NSBundle bundleWithPath:dataPath];
}

+ (NSBundle *)getStaticCustomBundleForLanguageCode:(NSString*)languageCode {
    if (nil == staticCustomBundles[languageCode]) {
        [self createNewBundleForLanguageCode:languageCode];
    } return staticCustomBundles[languageCode];
}

+ (NSString *)bundleNameForLanguageCode:(NSString *)languageCode {
    return [NSString stringWithFormat:@"%@-%@.bundle", DFCustomLanguageBundlePrefix, languageCode];
}

#pragma mark - Convenience Methods

- (void)reset {
    LS[LSMyLanguageCodeKey] = nil;
    self.currentLanguageCode = [self systemLanguageCode];
}

- (NSString*)systemLanguageCode {
    NSString *languageCode = [NSLocale preferredLanguages][0];
    return [languageCode substringToIndex:2];
}

- (NSString*)currentLanguageCode {
    if (!_currentLanguageCode) {
        if (LS[LSMyLanguageCodeKey] == nil) {
            _currentLanguageCode = [self systemLanguageCode];
        } else {
            _currentLanguageCode = LS[LSMyLanguageCodeKey];
        }
    }
    return _currentLanguageCode;
}

// returns a url like http://digifaces.com/localization/en.strings

- (NSURL*)urlPathForLanguageWithCode:(NSString*)languageCode {
    NSString *urlPath = [NSString stringWithFormat:@"%@%@.%@", DFLocalizedStringsDirectoryURLPath, languageCode, DFLocalizedStringsFileExtension];
    return [NSURL URLWithString:urlPath];
}

- (NSString*)folderPathForCustomLocalizationFileWithLanguageCode:(NSString*)languageCode {
    return [NSString stringWithFormat:@"%@/%@.lproj", [[self class] bundleNameForLanguageCode:languageCode], [self systemLanguageCode]];
}

- (void)completeProcessWithError:(NSError*)error {
    if (self.processCompletionBlock) {
        self.processCompletionBlock(error);
        self.processCompletionBlock = nil;
    }
}

#pragma mark - Data Loading

- (void)getUserLanguageFromServerWithCompletion:(void (^)(NSError* error, NSString *languageCode))completionBlock {
    
    NSNumber *myLanguageId = LS.myUserInfo.defaultLanguageId;
    if (myLanguageId == nil) {
        if (completionBlock) {
            NSString *errorDescription = [NSString stringWithFormat:@"No default language is set.  Use system language."];
            NSError *error = [NSError errorWithDomain:@"DFLanguageSynchronizer.data.userInfoNoLanguageSet" code:5 userInfo:@{NSLocalizedDescriptionKey : errorDescription}];
            completionBlock(error, nil);
        }
    } else {
        [DFClient makeRequest:APIPathGetLanguages method:kGET params:nil success:^(NSDictionary *response, id result) {
            
            NSArray *languages;
            if ([result isKindOfClass:[NSArray class]]) {
                languages = result;
            } else if (languages != nil) {
                languages = @[result];
            } else {
                languages = @[];
            }
            
            // get key for language code and save it in LocalStorage
            NSString *languageCode = nil;
            for (Language *language in languages) {
                if ([language.languageId isEqualToNumber:myLanguageId]) {
                    languageCode = language.languageCode;
                    break;
                }
            }
            
            NSError *error = nil;
            
            if (languageCode == nil) {
                NSString *errorDescription = [NSString stringWithFormat:@"Could not find language with id %@.  Use system language.", myLanguageId];
                error = [NSError errorWithDomain:@"DFLanguageSynchronizer.data.serverResponseNoLanguageFound" code:4 userInfo:@{NSLocalizedDescriptionKey : errorDescription}];
            }
            if (completionBlock) {
                completionBlock(error, languageCode);
            }
        } failure:^(NSError *error) {
            if (completionBlock) {
                completionBlock(error, nil);
            }
        }];
    }
}

- (void)synchronizeStringsWithCompletion:(void (^)(NSError* error))completionBlock {
    
    
    self.processCompletionBlock = completionBlock;
    
    // Sync with server if possible
    __weak __typeof(self) wself = self;
    [self getUserLanguageFromServerWithCompletion:^(NSError *error, NSString *languageCode) {
        __strong __typeof(wself) sself = wself;
        if (error) {
            NSLog(@"%@", error);
            [sself updateLocalizedStringsWithLanguageCode:[self systemLanguageCode]];
        } else if (languageCode) {
            [sself updateLocalizedStringsWithLanguageCode:languageCode];
            LS[LSMyLanguageCodeKey] = languageCode;
        }
    }];
    
    
}

- (void)updateLocalizedStringsWithLanguageCode:(NSString*)languageCode {
    
    NSError *error = nil;
    [self loadStringsDataWithLanguageCode:languageCode error:&error];
    
    if (error) {
        [self downloadStringsFromServerWithLanguageCode:languageCode];
    } else {
        [self completeProcessWithError:nil];
    }
    
}

- (void)downloadStringsFromServerWithLanguageCode:(NSString*)languageCode {
    NSURL *url = [self urlPathForLanguageWithCode:languageCode];
    // adapt this
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    AFHTTPRequestOperation *operation = [[AFHTTPRequestOperation alloc] initWithRequest:request];
    
    __weak __typeof(self) wself = self;
    [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        __strong __typeof(wself) sself = wself;
        if (sself) {
            [sself handleStringsDownloadSuccessWithData:operation.responseData languageCode:languageCode];
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        __strong __typeof(wself) sself = wself;
        if (sself) {
            [sself handleStringsDownloadFailureWithError:error];
        }
    }];
    [operation start];
}


- (void)handleStringsDownloadSuccessWithData:(NSData*)stringsData languageCode:(NSString*)languageCode {
    NSError *error = nil;
    self.currentLanguageCode = languageCode;
    [self saveStringsForLanguageCode:languageCode withData:stringsData error:&error];
    if (error) {
        [self handleStringsDownloadFailureWithError:error];
    } else {
        [[NSNotificationCenter defaultCenter] postNotificationName:DFLocalizationDidSynchronizeNotification object:nil];
        [self completeProcessWithError:nil];
    }
}

- (void)handleStringsDownloadFailureWithError:(NSError*)error {
    [self completeProcessWithError:error];
}

#pragma mark Data Caching

-(void)loadStringsDataWithLanguageCode:(NSString*)languageCode error:(NSError * _Nullable __autoreleasing*)error {
    *error = nil;
    
    NSString *folder = [self folderPathForCustomLocalizationFileWithLanguageCode:languageCode];
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
        
        if ([[NSDate date] timeIntervalSinceDate:date] > DFLocalizationSynchronizerUpdateInterval
            || ![languageCode isEqualToString:[self currentLanguageCode]]) {
            NSString *errorDescription = [NSString stringWithFormat:@"Localization data requires update."];
            *error = [NSError errorWithDomain:@"DFLanguageSynchronizer.data.needsUpdate" code:3 userInfo:@{NSLocalizedDescriptionKey : errorDescription}];
        }
    } else {
        NSString *errorDescription = [NSString stringWithFormat:@"File does not exist: %@", filePath];
        *error = [NSError errorWithDomain:@"DFLanguageSynchronizer.NSFileManager.load" code:2 userInfo:@{NSLocalizedDescriptionKey : errorDescription}];
    }
}

-(void)saveStringsForLanguageCode:(NSString *)languageCode withData:(NSData *)data error:(NSError* _Nullable __autoreleasing*)error {
    *error = nil;
    NSString *folder = [self folderPathForCustomLocalizationFileWithLanguageCode:languageCode];
    NSString *filename = @"Localizable.strings";
    NSData *dataToSave = data;
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = paths[0];
    
    // Get documents folder
    NSString *dataPath = [documentsDirectory stringByAppendingPathComponent:folder];
    if ([[NSFileManager defaultManager] fileExistsAtPath:dataPath]){
        [[NSFileManager defaultManager] removeItemAtPath:dataPath error:error];
    }
    [[NSFileManager defaultManager] createDirectoryAtPath:dataPath withIntermediateDirectories:YES attributes:nil error:error];
    
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

// http://stackoverflow.com/questions/13525665/is-there-a-way-to-invalidate-nsbundle-localization-cache-withour-restarting-app

// First, we declare the function. Making it weak-linked
// ensures the preference pane won't crash if the function
// is removed from in a future version of Mac OS X.
extern void _CFBundleFlushBundleCaches(CFBundleRef bundle)
__attribute__((weak_import));

BOOL FlushBundleCache(NSBundle *prefBundle) {
    // Before calling the function, we need to check if it exists
    // since it was weak-linked.
    if (_CFBundleFlushBundleCaches != NULL) {
        NSLog(@"Flushing bundle cache with _CFBundleFlushBundleCaches");
        CFBundleRef cfBundle =
        CFBundleCreate(nil, (CFURLRef)[prefBundle bundleURL]);
        _CFBundleFlushBundleCaches(cfBundle);
        CFRelease(cfBundle);
        return YES; // Success
    }
    return NO; // Not available
}

//- See more at: http://iosapplove.com/archive/2013/01/localizable-strings-how-to-load-translations-dynamically-and-use-it-inside-your-iphone-app/#sthash.ABbl63u0.dpuf


@end