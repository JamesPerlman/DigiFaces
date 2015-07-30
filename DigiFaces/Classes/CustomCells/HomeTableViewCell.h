//
//  HomeTableViewCell.h
//  DigiFaces
//
//  Created by James on 7/27/15.
//  Copyright (c) 2015 Usasha studio. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HomeTableViewCell : UITableViewCell
@property (nonatomic, weak) IBOutlet UILabel *titleLabel;
@property (nonatomic, weak) IBOutlet UILabel *unreadItemLabel;
@property (nonatomic, setter=setUnreadCount:) NSInteger unreadCount;

@end
