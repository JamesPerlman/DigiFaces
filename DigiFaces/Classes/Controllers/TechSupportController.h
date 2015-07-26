//
//  TechSupportController.h
//  DigiFaces
//
//  Created by confiz on 21/06/2015.
//  Copyright (c) 2015 Usasha studio. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CustomAlertView.h"

@interface TechSupportController : UITableViewController<PopUpDelegate>
{
    CustomAlertView * alertView;
}
@property (weak, nonatomic) IBOutlet UITextField *txtSubject;

@property (weak, nonatomic) IBOutlet UITextView *textArea;
@property (weak, nonatomic) IBOutlet UILabel *lblPlaceholder;

@end
