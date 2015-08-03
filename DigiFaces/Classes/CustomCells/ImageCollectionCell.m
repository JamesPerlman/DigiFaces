//
//  ImageCollectionCell.m
//  DigiFaces
//
//  Created by confiz on 22/06/2015.
//  Copyright (c) 2015 Usasha studio. All rights reserved.
//

#import "ImageCollectionCell.h"

@implementation ImageCollectionCell


-(void)setSelected:(BOOL)selected
{
    [super setSelected:selected];
    if (selected) {
        [_selectionView setHidden:NO];
    }
    else{
        [_selectionView setHidden:YES];
    }
}

@end
