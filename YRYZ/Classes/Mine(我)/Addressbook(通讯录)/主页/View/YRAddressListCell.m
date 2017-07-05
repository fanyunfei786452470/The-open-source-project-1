//
//  YRAddressListCell.m
//  YRYZ
//
//  Created by 易超 on 16/7/11.
//  Copyright © 2016年 yryz. All rights reserved.
//

#import "YRAddressListCell.h"

@interface YRAddressListCell()

@end

@implementation YRAddressListCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.iconImage.layer.cornerRadius = 4;
    self.iconImage.layer.masksToBounds = YES;
    self.neLabel.layer.cornerRadius = self.neLabel.width *0.2;
    self.neLabel.clipsToBounds = YES;
    
    self.message = [[UILabel alloc]init];
    self.message.backgroundColor = RGB_COLOR(250, 114, 111);
    self.message.textColor = [UIColor whiteColor];
    self.message.textAlignment = NSTextAlignmentCenter;
    [self.contentView addSubview:self.message];
    [self.message mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.contentView.mas_right).mas_offset(-5);
        make.centerY.equalTo(self.contentView);
        make.size.mas_equalTo(CGSizeMake(25, 16));
    }];
    self.message.layer.cornerRadius = 8;
    self.message.clipsToBounds = YES;
}

-(void)layoutSubviews{
    [super layoutSubviews];
//    self.neLabel.frame = CGRectMake(SCREEN_WIDTH-50, 10, 25, 16);

}
@end
