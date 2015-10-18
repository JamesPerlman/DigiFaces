//
//  DFLanguageSynchronizer.h
//  DigiFaces
//
//  Created by James on 10/17/15.
//  Copyright © 2015 INET360. All rights reserved.
//

#import <Foundation/Foundation.h>
#define DFLocalizedString(key, comment) [DFLanguageSynchronizer localizedStringForKey:key withComment:comment]
@interface DFLanguageSynchronizer : NSObject
+ (instancetype)sharedInstance;
+ (NSString*)localizedStringForKey:(NSString*)key withComment:(NSString*)comment;

-(void)downloadLocalizedStringsFromServerWithCompletion:(void (^)(NSError* error))completionBlock;

@end
