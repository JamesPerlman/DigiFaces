//
//  ResponseViewCell.h
//  DigiFaces
//
//  Created by confiz on 28/06/2015.
//  Copyright (c) 2015 Usasha studio. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ImagesScrollviewer.h"

@interface ResponseViewCell : UITableViewCell<UICollectionViewDataSource, UICollectionViewDelegate>

@property (nonatomic, weak) IBOutlet UICollectionView *collectionView;
@property (nonatomic, weak) UIViewController *viewController;
@property (weak, nonatomic) IBOutlet UIImageView *userImage;
@property (weak, nonatomic) IBOutlet UILabel *lblName;
@property (weak, nonatomic) IBOutlet UILabel *lblTime;
@property (weak, nonatomic) IBOutlet UILabel *lblResponse;
@property (weak, nonatomic) IBOutlet ImagesScrollviewer *scrollView;
@property (weak, nonatomic) IBOutlet UIButton *btnComments;
@property (nonatomic, retain) NSArray * files;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *responseHeightConst;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *collectionViewHeightConstraint;
- (IBAction)commentClicked:(id)sender;
-(void)setImageCircular;

@end
