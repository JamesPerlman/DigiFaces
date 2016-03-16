//
//  AddInternalCommentAction.m
//  DigiFaces
//
//  Created by James on 3/15/16.
//  Copyright © 2016 INET360. All rights reserved.
//

#import "AddInternalCommentAction.h"

@implementation AddInternalCommentAction

- (NSString *)apiMethodPath {
    return APIPathActivityUpdateInternalComment;
}

- (NSString*)paramNameForCommentId {
    return @"InternalCommentId";
}

@end
