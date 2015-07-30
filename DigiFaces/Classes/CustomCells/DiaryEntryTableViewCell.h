//
//  DiaryEntryTableViewCell.h
//  DigiFaces
//
//  Created by James on 7/26/15.
//  Copyright (c) 2015 Usasha studio. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DiaryEntryTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *countInfoLabel;
@property (strong, nonatomic) UIView *unreadIndicator;

@property (nonatomic, assign) NSInteger videoCount;
@property (nonatomic, assign) NSInteger pictureCount;
@property (nonatomic, assign) NSInteger commentCount;
- (void)updateCountLabel;
@end
