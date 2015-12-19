//
//  GalleryCell.h
//  DigiFaces
//
//  Created by confiz on 21/07/2015.
//  Copyright (c) 2015 Usasha studio. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol GalleryCellDelegate <NSObject>

-(void)galleryCell:(id)cell didClickOnIndex:(NSInteger)index;

@end

@interface GalleryCell : UITableViewCell<UIScrollViewDelegate, UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout>
@property (nonatomic, weak) UIViewController *viewController;
@property (nonatomic, assign) IBOutlet id<GalleryCellDelegate> delegate;
@property (nonatomic, weak) IBOutlet UICollectionView *collectionView;
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (weak, nonatomic) IBOutlet UIButton *leftButton;
@property (weak, nonatomic) IBOutlet UIButton *rightButton;
@property (nonatomic, strong) NSArray * files;

-(void)reloadGallery;

@end
