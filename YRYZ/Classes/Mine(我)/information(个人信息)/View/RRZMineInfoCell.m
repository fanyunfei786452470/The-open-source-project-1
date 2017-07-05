//
//  RRZMineInfoCell.m
//  Rrz
//
//  Created by 易超 on 16/3/17.
//  Copyright © 2016年 rongzhongwang. All rights reserved.
//

#import "RRZMineInfoCell.h"


@interface RRZMineInfoCell ()



@end

@implementation RRZMineInfoCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.IconImageView.layer.cornerRadius = 3;
    self.IconImageView.layer.masksToBounds = YES;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}




@end
