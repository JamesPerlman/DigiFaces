//
//  DFCollectionImageCell.m
//  DigiFaces
//
//  Created by James on 8/2/15.
//  Copyright (c) 2015 INET360. All rights reserved.
//

#import "DFCollectionViewImageCell.h"

@implementation DFCollectionViewImageCell

- (void)awakeFromNib {
    self.layer.borderColor = [UIColor blackColor].CGColor;
    self.layer.borderWidth = 1.0f;
}

@end
