//
//  YRLoginButton.m
//  Rrz
//
//  Created by 易超 on 16/7/4.
//  Copyright © 2016年 rongzhongwang. All rights reserved.
//

#import "YRLoginButton.h"

@implementation YRLoginButton

- (void)layoutSubviews
{
    // 会根据xib描述的,计算内部子控件的位置
    [super layoutSubviews];
    
    // 设置图片
    self.imageView.y = 10;
    self.imageView.centerX = self.width * 0.5;
    
    // 设置文字
    [self.titleLabel sizeToFit];
    self.titleLabel.y = self.height - self.titleLabel.height;
    self.titleLabel.centerX = self.width * 0.5;
}

@end
