//
//  YRRedPackingTableViewCell.m
//  YRYZ
//
//  Created by Sean on 16/8/12.
//  Copyright © 2016年 yryz. All rights reserved.
//

#import "YRRedPackingTableViewCell.h"

@implementation YRRedPackingTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
    self.titles.numberOfLines = 2;
    self.titles.backgroundColor = RGB_COLOR(245, 245, 245);
     self.titles.textColor = RGB_COLOR(82, 82, 82);
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    
    self.isBacking.layer.cornerRadius = 5;
    self.isBacking.clipsToBounds = YES;
    
    
    self.redBack.layer.cornerRadius = 5;
    self.redBack.clipsToBounds = YES;
//    [self.redBack addTarget:self action:@selector(backMoneyToMine:) forControlEvents:UIControlEventTouchUpInside];
//    [self.isBacking addTarget:self action:@selector(changeTheAds:) forControlEvents:UIControlEventTouchUpInside];
    
    [self.isBacking addTarget:self action:@selector(backMoneyToMine:) forControlEvents:UIControlEventTouchUpInside];
}
- (void)changeTheAds:(UIButton *)sender{
    if (self.change) {
        self.change(YES);
    }
}
- (void)backMoneyToMine:(UIButton *)sender{
    if (self.backMoney) {
        self.backMoney(YES);
    }
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
