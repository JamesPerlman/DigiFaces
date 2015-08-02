//
//  RTCell.h
//  DigiFaces
//
//  Created by confiz on 11/07/2015.
//  Copyright (c) 2015 Usasha studio. All rights reserved.
//
#import <UIKit/UIKit.h>
@class RTCell;
@protocol ExpandableTextCellDelegate <NSObject>

- (void)textCellDidTapMore:(RTCell*)cell;

@end

@interface RTCell : UITableViewCell
@property (nonatomic, assign) id<ExpandableTextCellDelegate>delegate;

@property (weak, nonatomic) IBOutlet UITextView *textView;
@property (weak, nonatomic) IBOutlet UIWebView *webView;
@property (weak, nonatomic) IBOutlet UILabel *bodyLabel;
@property (weak, nonatomic) IBOutlet UIButton *moreLessButton;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *moreLessButtonHeightConstraint;

- (void)setText:(NSString*)text;
- (void)minimize;
- (void)maximize;
- (CGFloat)height;
- (CGFloat)fullHeight;
- (CGFloat)maxHeight;
- (IBAction)moreLessToggle:(id)sender;

@end
