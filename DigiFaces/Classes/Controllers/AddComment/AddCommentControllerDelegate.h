//
//  AddCommentControllerDelegate.h
//  
//
//  Created by James on 3/13/16.
//
//

#import <Foundation/Foundation.h>

@class AddCommentController;

@protocol AddCommentControllerDelegate <NSObject>

- (void)addCommentControllerDidSendComment:(AddCommentController *)controller;

- (void)addCommentController:(AddCommentController *)controller didGetServerResponseWithComment:(id)comment error:(NSError*)error;

- (void)addCommentControllerDidRequestPopupMenu:(AddCommentController *)controller;

@end
