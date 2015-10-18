//
//  NointernetController.m
//  DigiFaces
//
//  Created by confiz on 02/07/2015.
//  Copyright (c) 2015 Usasha studio. All rights reserved.
//

#import "NointernetController.h"

@interface NointernetController ()
@property (weak, nonatomic) IBOutlet UILabel *messageLabel;

@end

@implementation NointernetController

- (void)localizeUI {
    self.messageLabel.text = DFLocalizedString(@"app.error.no_internet", nil);
}

@end
