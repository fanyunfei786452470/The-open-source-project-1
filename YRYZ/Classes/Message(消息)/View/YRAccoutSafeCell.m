//
//  YRAccoutSafeCell.m
//  YRYZ
//
//  Created by weishibo on 16/8/10.
//  Copyright © 2016年 yryz. All rights reserved.
//

#import "YRAccoutSafeCell.h"

@implementation YRAccoutSafeCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
    self.headImageView.layer.cornerRadius = 3.f;
    self.headImageView.clipsToBounds = YES;
    
    self.bageBtn.layer.cornerRadius = 3.f;
    self.bageBtn.clipsToBounds = YES;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
