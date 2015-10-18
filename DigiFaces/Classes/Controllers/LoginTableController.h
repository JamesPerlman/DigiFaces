//
//  LoginTableController.h
//  DigiFaces
//
//  Created by confiz on 02/07/2015.
//  Copyright (c) 2015 Usasha studio. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CustomAlertView.h"

@interface LoginTableController : UITableViewController
@property(nonatomic,strong) CustomAlertView * customAlert;

- (IBAction)forgotPasswordPressed:(id)sender;
- (IBAction)exitOnEnd:(id)sender;

- (IBAction)signInPressed:(id)sender;
@end
