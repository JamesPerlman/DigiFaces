//
//  UserViewController.h
//  DigiFaces
//
//  Created by Apple on 04/06/2015.
//  Copyright (c) 2015 Usasha studio. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AFNetworking.h"
#import "CustomAlertView.h"

@protocol PopUpDelegate;

@protocol MessageToViewMain;

@protocol MessageToViewMain <NSObject>

-(void)pushControl;

@end

@interface UserViewController : UIViewController<UITextFieldDelegate,PopUpDelegate>
@property (nonatomic,strong) id<MessageToViewMain>delegate;
@property(nonatomic,retain)CustomAlertView * customAlert;

@end
