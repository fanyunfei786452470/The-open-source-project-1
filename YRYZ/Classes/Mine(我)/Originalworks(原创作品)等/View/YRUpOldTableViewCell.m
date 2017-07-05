//
//  YRUpOldTableViewCell.m
//  YRYZ
//
//  Created by Sean on 16/8/11.
//  Copyright © 2016年 yryz. All rights reserved.
//

#import "YRUpOldTableViewCell.h"

@implementation YRUpOldTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
    self.redNum.hidden = YES;
    self.titles.numberOfLines = 2;
    self.titles.backgroundColor = RGB_COLOR(245, 245, 245);
    self.titles.textColor = RGB_COLOR(82, 82, 82);
    self.overTime.textColor = RGB_COLOR(104, 209, 203);

    
    [self.seeNum setImage:[UIImage imageNamed:@"yr_see_nor"] forState:UIControlStateNormal];
  
    self.seeNum.titleLabel.font = [UIFont systemFontOfSize:13];
    [self.seeNum setTitleColor:RGB_COLOR(144, 144, 144) forState:UIControlStateNormal];
    
    
    self.seeNum.titleEdgeInsets = UIEdgeInsetsMake(0, -50, 0, 0);
    self.seeNum.imageEdgeInsets = UIEdgeInsetsMake(0, -60, 0, 0);
    
    
     self.giveMoney.backgroundColor = RGB_COLOR(43, 193, 183);
    [self.giveMoney setTitle:@"续费" forState:UIControlStateNormal];
    [self.giveMoney setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    self.giveMoney.titleLabel.font = [UIFont systemFontOfSize:14];
    self.giveMoney.layer.cornerRadius = 4;
    self.giveMoney.clipsToBounds = YES;
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    
    [self.giveMoney addTarget:self action:@selector(giveMoneyBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    
}
- (void)giveMoneyBtnClick:(UIButton *)sender{
    if (self.renewalMoney||self.againRelease) {
        if ([sender.currentTitle isEqualToString:@"续费"]) {
            self.renewalMoney(YES);
        }
        if ([sender.currentTitle isEqualToString:@"再次发布"]) {
            self.againRelease(YES);
        }
    }
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setValue:(id)value forUndefinedKey:(NSString *)key{
    
    DLog(@"%@ %@",value,key);
}

@end
