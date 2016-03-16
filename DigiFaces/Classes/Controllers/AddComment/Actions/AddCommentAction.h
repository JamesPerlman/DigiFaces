//
//  AddCommentAction.h
//  DigiFaces
//
//  Created by James on 3/14/16.
//  Copyright © 2016 INET360. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface AddCommentAction : NSObject

- (void)executeWithCommentText:(NSString*)commentText threadId:(NSNumber*)threadId completion:(void (^)(id comment, NSError *error))completionBlock;

- (NSString*)apiMethodPath;
- (NSString*)paramNameForCommentId;
- (NSDictionary*)paramsWithCommentText:(NSString*)commentText threadId:(NSNumber*)threadId;

@end
