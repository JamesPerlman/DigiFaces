//
//  AddResearcherCommentAction.m
//  DigiFaces
//
//  Created by James on 3/15/16.
//  Copyright © 2016 INET360. All rights reserved.
//

#import "AddResearcherCommentAction.h"

@implementation AddResearcherCommentAction

- (NSString *)apiMethodPath {
    return APIPathActivityUpdateResearcherComment;
}

- (NSString*)paramNameForCommentId {
    return @"ResearcherCommentId";
}

@end
