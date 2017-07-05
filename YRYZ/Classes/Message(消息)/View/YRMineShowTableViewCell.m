//
//  YRMineShowTableViewCell.m
//  YRYZ
//
//  Created by Mrs_zhang on 16/7/14.
//  Copyright © 2016年 yryz. All rights reserved.
//

#import "YRMineShowTableViewCell.h"

@implementation YRMineShowTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
    self.lineLab.backgroundColor = RGB_COLOR(245, 245, 245);
    self.typeLab.layer.cornerRadius = 10.f;
    self.typeLab.clipsToBounds = YES;
    self.typeLab.backgroundColor = RGB_COLOR(159, 211, 255);
    self.contextLab.textColor = [UIColor wordColor];
    self.timeLab.textColor = [UIColor grayColorThree];
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
