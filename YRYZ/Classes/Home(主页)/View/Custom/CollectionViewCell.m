//
//  CollectionViewCell.m
//  share
//
//  Created by Sean on 16/7/19.
//  Copyright © 2016年 Sean. All rights reserved.
//

#import "CollectionViewCell.h"

@implementation CollectionViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
   
    
    CGFloat width = self.icon.frame.size.height;
    self.icon.layer.cornerRadius = width/2;
    self.icon.clipsToBounds = YES;

    // Initialization code
}

@end
