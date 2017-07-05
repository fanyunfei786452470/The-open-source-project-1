//
//  YRMine_mineCell.m
//  YRYZ
//
//  Created by 易超 on 16/7/18.
//  Copyright © 2016年 yryz. All rights reserved.
//

#import "YRMine_mineCell.h"

@implementation YRMine_mineCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    self.BtnA.layer.borderWidth = 1;
    self.BtnA.layer.borderColor = RGB_COLOR(249, 249, 249).CGColor;
    
    self.BtnB.layer.borderWidth = 1;
    self.BtnB.layer.borderColor = RGB_COLOR(249, 249, 249).CGColor;
    
    self.BtnC.layer.borderWidth = 1;
    self.BtnC.layer.borderColor = RGB_COLOR(249, 249, 249).CGColor;
    
    self.BtnD.layer.borderWidth = 1;
    self.BtnD.layer.borderColor = RGB_COLOR(249, 249, 249).CGColor;
    
    
    [self.BtnA setTitleColor:RGB_COLOR(51, 51, 51) forState:UIControlStateNormal];
    [self.BtnB setTitleColor:RGB_COLOR(51, 51, 51) forState:UIControlStateNormal];
    [self.BtnC setTitleColor:RGB_COLOR(51, 51, 51) forState:UIControlStateNormal];
    [self.BtnD setTitleColor:RGB_COLOR(51, 51, 51) forState:UIControlStateNormal];
}


- (IBAction)btnClick:(UIButton *)sender {
    if (self.mineCellButtonClickBlock) {
        self.mineCellButtonClickBlock(sender.tag);
    }
}


@end
