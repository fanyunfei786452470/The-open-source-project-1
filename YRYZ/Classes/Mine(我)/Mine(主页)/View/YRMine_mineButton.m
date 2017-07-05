//
//  YRMine_mineButton.m
//  YRYZ
//
//  Created by 易超 on 16/7/18.
//  Copyright © 2016年 yryz. All rights reserved.
//

#import "YRMine_mineButton.h"

@implementation YRMine_mineButton

- (void)layoutSubviews
{
    // 会根据xib描述的,计算内部子控件的位置
    [super layoutSubviews];
    
    // 设置图片
    self.imageView.y = 10;
    self.imageView.centerX = self.width * 0.5;
    
    // 设置文字
    [self.titleLabel sizeToFit];
    self.titleLabel.y = self.imageView.height + 20;
    self.titleLabel.centerX = self.width * 0.5;
}

@end
