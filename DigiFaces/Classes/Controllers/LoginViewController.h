//
//  ViewController.h
//  DigiFaces
//
//  Created by Apple on 02/06/2015.
//  Copyright (c) 2015 Usasha studio. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AFNetworking.h"
#import "CustomAlertView.h"

@protocol MessageToViewMain;
@protocol PopUpDelegate;
@interface LoginViewController : UIViewController<UITextFieldDelegate,MessageToViewMain,PopUpDelegate>

@property(nonatomic,strong)CustomAlertView * customAlert;
@property (nonatomic,strong)IBOutlet UITextField * email;
@property (nonatomic,strong)IBOutlet UITextField * password;
@property (nonatomic,strong)IBOutlet UILabel * errorMessage;

@end

