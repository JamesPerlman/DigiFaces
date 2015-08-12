//
//  ProjectIntroViewController.h
//  DigiFaces
//
//  Created by confiz on 20/06/2015.
//  Copyright (c) 2015 Usasha studio. All rights reserved.
//

#import <UIKit/UIKit.h>
@class Announcement;
@interface ProjectIntroViewController : UITableViewController
- (IBAction)goBack:(id)sender;

@property (nonatomic, strong) Announcement *announcement;

@end
