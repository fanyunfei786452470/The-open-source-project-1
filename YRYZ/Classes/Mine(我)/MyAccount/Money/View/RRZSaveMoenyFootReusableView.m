//
//  RRZSaveMoenyFootReusableView.m
//  Rrz
//
//  Created by 易超 on 16/5/2.
//  Copyright © 2016年 rongzhongwang. All rights reserved.
//

#import "RRZSaveMoenyFootReusableView.h"

@implementation RRZSaveMoenyFootReusableView

- (void)awakeFromNib {
    [super awakeFromNib];
    self.payButton.layer.masksToBounds = YES;
    self.payButton.layer.cornerRadius = 15;
    self.payButton.backgroundColor = [UIColor themeColor];
    [self.payButton setTitle:@"充值" forState:UIControlStateNormal];
    self.payButton.titleLabel.font = [UIFont titleFont18];
    [self.payButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    self.helpBtn.layer.masksToBounds = YES;
    self.helpBtn.layer.cornerRadius = 10;
    self.helpBtn.backgroundColor = [UIColor clearColor];
    [self.helpBtn.titleLabel setFont:[UIFont systemFontOfSize:14] ];
    [self.helpBtn setTitle:@"充值遇到问题？请戳这里" forState:UIControlStateNormal];
    [self.helpBtn setTitleColor:[UIColor themeColor] forState:UIControlStateNormal];
    
}

@end
