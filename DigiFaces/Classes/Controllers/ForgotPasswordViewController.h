//
//  ForgotPasswordViewController.h
//  DigiFaces
//
//  Created by Apple on 05/06/2015.
//  Copyright (c) 2015 Usasha studio. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AFNetworking.h"
#import "CustomAlertView.h"

@protocol MessageToViewMain;

@interface ForgotPasswordViewController : UIViewController<UITextFieldDelegate,MessageToViewMain>
@property (nonatomic,strong)IBOutlet UITextField * email;
@property (nonatomic,strong)IBOutlet UILabel * errorMessage;
@property(nonatomic,retain)CustomAlertView * customAlert;

-(IBAction)cancelThis:(id)sender;
@end
