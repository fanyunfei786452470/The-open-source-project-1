//
//  YRLoginOutCell.m
//  YRYZ
//
//  Created by 易超 on 16/7/19.
//  Copyright © 2016年 yryz. All rights reserved.
//

#import "YRLoginOutCell.h"

@implementation YRLoginOutCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}


- (IBAction)loginOutBtnClick:(UIButton *)sender {
    
    
    if (self.loginOutBtnClickBlock) {
        self.loginOutBtnClickBlock();
    }
}

@end
