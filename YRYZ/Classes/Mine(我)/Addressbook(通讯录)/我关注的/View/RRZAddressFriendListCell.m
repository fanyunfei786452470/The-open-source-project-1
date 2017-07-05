//
//  RRZAddressFriendListCell.m
//  Rrz
//
//  Created by 易超 on 16/3/14.
//  Copyright © 2016年 rongzhongwang. All rights reserved.
//

#import "RRZAddressFriendListCell.h"

@implementation RRZAddressFriendListCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.iconImage.layer.cornerRadius = 4;
    self.iconImage.layer.masksToBounds = YES;
    
    self.neLabel.layer.cornerRadius = self.neLabel.width *0.5;
    self.neLabel.layer.masksToBounds = YES;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
