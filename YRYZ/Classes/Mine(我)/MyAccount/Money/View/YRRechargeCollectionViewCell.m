//
//  YRRechargeCollectionViewCell.m
//  YRYZ
//
//  Created by 21.5 on 16/10/10.
//  Copyright © 2016年 yryz. All rights reserved.
//

#import "YRRechargeCollectionViewCell.h"
@interface YRRechargeCollectionViewCell ()

@end
@implementation YRRechargeCollectionViewCell
- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        [self setupview];
        [self setframe];
    }
    return self;
}
- (void)setupview{
    [self addSubview:self.bgImage];
//    [self addSubview:self.cionImage];
//    [self addSubview:self.labelView];
    [self addSubview:self.cionLabel];
//    [self.labelView addSubview:self.ciontext];
//    [self addSubview:self.moneyImage];
   // [self.moneyImage addSubview:self.moneyLabel];
}
- (UIImageView *)bgImage{
    if (!_bgImage) {
        _bgImage = [[UIImageView alloc]init];
        _bgImage.image = [UIImage imageNamed:@"yr_recharge_unselected"];
    }
    return _bgImage;
}

- (UIImageView *)cionImage{
    if (!_cionImage) {
        _cionImage = [[UIImageView alloc]init];
        _cionImage.image = [UIImage imageNamed:@"yr_recharge_coin"];
    }
    return _cionImage;
}
- (UIView *)labelView{
    if (!_labelView) {
        _labelView = [[UIView alloc]init];
    }
    return _labelView;
}
- (UILabel *)cionLabel{
    if (!_cionLabel) {
        _cionLabel = [[UILabel alloc]init];
//        [_cionLabel setFont:[UIFont systemFontOfSize:15*SCREEN_H_POINT]];
        _cionLabel.adjustsFontSizeToFitWidth = YES;
        _cionLabel.font = [UIFont titleFont18];
        _cionLabel.textAlignment = NSTextAlignmentCenter;
        _cionLabel.textColor = RGB_COLOR(153, 153, 153);
    }
    return _cionLabel;
}
- (UILabel *)ciontext{
    if (!_ciontext) {
        _ciontext = [[UILabel alloc]init];
        _ciontext.textAlignment = NSTextAlignmentLeft;
        [_ciontext setFont:[UIFont systemFontOfSize:10*SCREEN_H_POINT]];
        _ciontext.textColor = RGB_COLOR(255, 180, 76);
    }
    return _ciontext;
}
- (UILabel *)moneyImage{
    if (!_moneyImage) {
        _moneyImage = [[UILabel alloc]init];
        //[_moneyImage setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        _moneyImage.backgroundColor = [UIColor themeColor];
        _moneyImage.userInteractionEnabled = YES;
        _moneyImage.layer.masksToBounds = YES;
        //[_moneyImage.titleLabel setFont:[UIFont systemFontOfSize:14*SCREEN_H_POINT]];
        _moneyImage.layer.cornerRadius = 23/2*SCREEN_H_POINT;
        _moneyImage.textColor = [UIColor whiteColor];
        [_moneyImage setFont:[UIFont systemFontOfSize:14]];
        _moneyImage.textAlignment = NSTextAlignmentCenter;
    }
    return _moneyImage;
}
- (UILabel *)moneyLabel{
    if (!_moneyLabel) {
        _moneyLabel = [[UILabel alloc]init];
        _moneyLabel.backgroundColor = [UIColor redColor];
        _moneyLabel.textColor = [UIColor whiteColor];
    }
    return _moneyLabel;
}
- (void)setframe{
    [self.bgImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self).offset(0);
        make.left.mas_equalTo(self).offset(0);
        make.right.mas_equalTo(self).offset(0);
        make.bottom.mas_equalTo(self.mas_bottom).offset(0);
    }];
//    [self.cionImage mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.top.mas_equalTo(self.bgImage.mas_top).offset(15*SCREEN_H_POINT);
//        make.left.mas_equalTo(self.bgImage.mas_left).offset(8*SCREEN_H_POINT);
//        make.size.mas_equalTo(CGSizeMake(18*SCREEN_H_POINT, 22*SCREEN_H_POINT));
//    }];
//    [self.labelView mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.top.mas_equalTo(self.cionImage.mas_top).offset(0);
//        make.left.mas_equalTo(self.cionImage.mas_right).offset(1*SCREEN_H_POINT);
//        make.right.mas_equalTo(self.bgImage.mas_right).offset(-8*SCREEN_H_POINT);
//        make.height.mas_equalTo(self.cionImage.mas_height);
//    }];
    [self.cionLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self).offset((self.frame.size.height - 40*SCREEN_H_POINT)/2);
        make.left.mas_equalTo(self).offset((self.frame.size.width - 80*SCREEN_H_POINT)/2);
        make.width.mas_equalTo(80*SCREEN_H_POINT);
        make.height.mas_equalTo(40*SCREEN_H_POINT);
    }];
//    [self.ciontext mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.top.mas_equalTo(self.labelView.mas_top).offset(0);
//        make.left.mas_equalTo(self.cionLabel.mas_right).offset(0);
//        make.width.mas_equalTo(31*SCREEN_H_POINT);
//        make.height.mas_equalTo(self.labelView.mas_height);
//    }];
//    [self.moneyImage mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.top.mas_equalTo(self.cionImage.mas_bottom).offset(10*SCREEN_H_POINT);
//        make.left.mas_equalTo(self.cionImage.mas_left).offset(0*SCREEN_H_POINT);
//        make.width.mas_equalTo(74*SCREEN_H_POINT);
//        make.bottom.mas_equalTo(self.bgImage.mas_bottom).offset(-10*SCREEN_H_POINT);
//    }];
//    [self.moneyLabel mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.top.mas_equalTo(0);
//        make.left.mas_equalTo(35*SCREEN_H_POINT);
//        make.right.mas_equalTo(0);
//        make.bottom.mas_equalTo(0);
//    }];
}
- (void)setCiontitle:(NSString *)ciontitle{
    self.cionLabel.text = ciontitle;
}
//- (void)setCiontip:(NSString *)ciontip{
//    self.ciontext.text = ciontip;
//}
- (void)setMoneytitle:(NSString *)moneytitle{
    //[self.moneyImage setTitle:moneytitle forState:UIControlStateNormal];
    self.moneyImage.text = moneytitle;
}
@end
