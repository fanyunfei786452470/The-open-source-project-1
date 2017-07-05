//
//  YRListenToMeTableViewCell.m
//  YRYZ
//
//  Created by Sean on 16/8/13.
//  Copyright © 2016年 yryz. All rights reserved.
//

#import "YRListenToMeTableViewCell.h"

@implementation YRListenToMeTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    
    self.name.textColor = RGB_COLOR(67, 67, 67);
    self.line.backgroundColor = RGB_COLOR(243, 243, 243);
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
