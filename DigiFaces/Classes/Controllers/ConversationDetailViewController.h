//
//  ConversationDetailViewController.h
//  DigiFaces
//
//  Created by James on 8/12/15.
//  Copyright (c) 2015 INET360. All rights reserved.
//

#import <UIKit/UIKit.h>
@class Message;
@interface ConversationDetailViewController : UITableViewController

@property (nonatomic, strong) Message *message;

@property (nonatomic, strong) NSArray *messages;

@end
