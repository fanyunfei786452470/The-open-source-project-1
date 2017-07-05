//
//  YRPhoneContactCell.m
//  tabeldataSource
//
//  Created by Sean on 16/8/19.
//  Copyright © 2016年 Sean. All rights reserved.
//

#import "YRPhoneContactCell.h"

@implementation YRPhoneContactCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
    self.isFocus.layer.cornerRadius = 5;
    self.isFocus.clipsToBounds = YES;
    
    [self.isFocus setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self.isFocus addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
    /**
     * @author Sean, 16-08-23 15:08:29
     *
     *   UITableViewCellSelectionStyleNone,
     UITableViewCellSelectionStyleBlue,
     UITableViewCellSelectionStyleGray,
     UITableViewCellSelectionStyleDefault NS_ENUM_AVAILABLE_IOS(7_0)
     */
//    self.selectionStyle =  UITableViewCellSelectionStyleNone;
    
    self.isFocus.backgroundColor = [UIColor themeColor];
}
- (void)btnClick:(UIButton *)sender{
    if (self.choose) {
        self.choose(YES);
    }
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
