//
//  YRMineTopCell.m
//  YRYZ
//
//  Created by 易超 on 16/7/18.
//  Copyright © 2016年 yryz. All rights reserved.
//

#import "YRMineTopCell.h"

@interface YRMineTopCell()


@property (weak, nonatomic) IBOutlet UIImageView *QRCodeImageView;


@end

@implementation YRMineTopCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.iconImageView.userInteractionEnabled = YES;
    self.iconImageView.layer.cornerRadius = 4;
    self.iconImageView.layer.masksToBounds = YES;
    self.nameLabel.textColor = RGB_COLOR(51, 51, 51);
    self.nameLabel.font = [UIFont titleFont19];
    [self.iconImageView addTapGesturesTarget:self  selector:@selector(iconClick)];
}
- (void)iconClick{
    if (self.chooseCell) {
         self.chooseCell(YES);
    }
}

@end
