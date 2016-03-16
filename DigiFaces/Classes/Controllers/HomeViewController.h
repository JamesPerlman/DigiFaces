//
//  HomeViewController.h
//  DigiFaces
//
//  Created by Apple on 09/06/2015.
//  Copyright (c) 2015 Usasha studio. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CustomAlertView.h"
#import "UIViewController+DFLocalization.h"

@protocol MessageToViewMain;

@interface HomeViewController : UITableViewController<UITableViewDelegate,UITableViewDataSource>

//@property (nonatomic,strong)IBOutlet UIImageView * userPicture;
@property(nonatomic,retain)CustomAlertView * customAlert;


@end
