//
//  RRZAddressAddFriendCell.m
//  Rrz
//
//  Created by 易超 on 16/3/10.
//  Copyright © 2016年 rongzhongwang. All rights reserved.
//

#import "RRZAddressAddFriendCell.h"

@interface RRZAddressAddFriendCell ()



@end

@implementation RRZAddressAddFriendCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.iconImageView.layer.cornerRadius = 5;
    self.iconImageView.layer.masksToBounds = YES;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
