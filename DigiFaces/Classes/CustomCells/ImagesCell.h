//
//  ImagesCell.h
//  DigiFaces
//
//  Created by confiz on 27/06/2015.
//  Copyright (c) 2015 Usasha studio. All rights reserved.
//

#import <UIKit/UIKit.h>

@class File;
@protocol ImageCellDelegate <NSObject>

-(void)imageCell:(id)cell didClickOnButton:(id)button atIndex:(NSInteger)index atFile:(File*)file;

@end

@interface ImagesCell : UITableViewCell

@property (weak, nonatomic) UIViewController *viewController;
@property (weak, nonatomic) id<ImageCellDelegate> delegate;
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
-(void)setImagesFiles:(NSArray*)files;

@end
