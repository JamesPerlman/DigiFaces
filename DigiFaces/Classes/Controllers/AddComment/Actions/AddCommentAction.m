//
//  AddCommentAction.m
//  DigiFaces
//
//  Created by James on 3/14/16.
//  Copyright © 2016 INET360. All rights reserved.
//

#import "AddCommentAction.h"

#import "Comment.h"

@implementation AddCommentAction

- (void)executeWithCommentText:(NSString*)commentText threadId:(NSNumber*)threadId completion:(void (^)(id comment, NSError *error))completionBlock {
    
    NSString *parsedCommentText = [commentText stringByReplacingOccurrencesOfString:@"\n" withString:@"<br/>"];
    
    
    NSDictionary * params = [self paramsWithCommentText:parsedCommentText threadId:threadId];
    
    [DFClient makeJSONRequest:[self apiMethodPath]
                       method:kPOST
                       params:params
                      success:^(NSDictionary *response, Comment *result) {
                          if (completionBlock) {
                              completionBlock(result, nil);
                          }
                      }
                      failure:^(NSError *error) {
                          if (completionBlock) {
                              completionBlock(nil, error);
                          }
                      }];
    
    
    
}

- (NSString*)paramNameForCommentId {
    return @"CommentId";
}

- (NSString*)apiMethodPath {
    return APIPathActivityUpdateComment;
}

- (NSDictionary*)paramsWithCommentText:(NSString*)commentText threadId:(NSNumber*)threadId {
    return @{[self paramNameForCommentId] : @0,
             @"ThreadId" : threadId,
             @"Response" : commentText,
             @"IsActive" : @YES};
}


@end
