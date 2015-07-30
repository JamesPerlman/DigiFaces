//
//  PhotoGalleryViewController.h
//  DigiFaces
//
//  Created by Apple on 17/06/2015.
//  Copyright (c) 2015 Usasha studio. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PhotoGalleryViewController : UIViewController{

}

@property(nonatomic,strong)IBOutlet UIScrollView * scrollView;

@property (nonatomic, strong) NSArray *avatars;
@end
