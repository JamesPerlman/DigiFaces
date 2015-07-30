//
//  GalleryCell.h
//  DigiFaces
//
//  Created by confiz on 21/07/2015.
//  Copyright (c) 2015 Usasha studio. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol GalleryCellDelegate <NSObject>

-(void)galleryCell:(id)cel didClickOnIndex:(NSInteger)index;

@end

@interface GalleryCell : UITableViewCell

@property (nonatomic, assign) IBOutlet id<GalleryCellDelegate> delegate;
@property (strong, nonatomic) IBOutlet UIScrollView *scrollView;
@property (nonatomic, strong) NSArray * files;

-(void)reloadGallery;

@end
