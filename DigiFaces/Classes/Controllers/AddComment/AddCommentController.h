//
//  AddCommentController.h
//  DigiFaces
//
//  Created by James on 3/13/16.
//  Copyright © 2016 INET360. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AddCommentControllerDelegate.h"


@interface AddCommentController : UITableViewController

@property (nonatomic, weak) UIView *parentControllerView;

@property (nonatomic, weak) id<AddCommentControllerDelegate> delegate;

- (void)addCommentText:(NSString *)commentText withThreadId:(NSNumber *)threadId;

- (CGSize)tableViewSize;

- (BOOL)shouldShowCommentInputTextView;

@end
