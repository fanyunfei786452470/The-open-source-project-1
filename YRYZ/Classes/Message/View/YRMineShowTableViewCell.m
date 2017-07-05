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
    
//    self.lineLab.backgroundColor = RGB_COLOR(245, 245, 245);


    self.contextLab.textColor = [UIColor wordColor];
    self.timeLab.textColor = [UIColor grayColorThree];
    self.timeLab.mj_w = 50;
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
