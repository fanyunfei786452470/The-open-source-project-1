//
//  YRRechargeCollectionHeadView.m
//  YRYZ
//
//  Created by 21.5 on 16/10/10.
//  Copyright © 2016年 yryz. All rights reserved.
//

#import "YRRechargeCollectionHeadView.h"

@implementation YRRechargeCollectionHeadView
- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        
        [self setupview];
        [self setframe];
    }
    return self;
}

- (void)setupview{
    [self addSubview:self.headImage];
    [self addSubview:self.name];
    [self addSubview:self.label1];
    [self addSubview:self.titleLabel];
    [self addSubview:self.label2];
    if ([YRUserInfoManager manager].currentUser.custId) {
        [_headImage setImageWithURL:[NSURL URLWithString:[YRUserInfoManager manager].currentUser.custImg] placeholder:[UIImage defaultHead]];
        _name.text = [YRUserInfoManager manager].currentUser.custNname;
        //        _subTitleLabel.text = [YRUserInfoManager sharedController].currentUser.custPhone;
    }else{
        
    }
}
- (UIImageView *)headImage{
    if (!_headImage) {
        _headImage = [[UIImageView alloc]init];
        _headImage.layer.cornerRadius = 5*SCREEN_H_POINT;
        _headImage.layer.masksToBounds = YES;
    }
    return _headImage;
}
- (UILabel *)name{
    
    if (!_name) {
        _name = [[UILabel alloc]init];
        [_name setFont:[UIFont systemFontOfSize:14]];
        _name.textColor = [UIColor themeColor];
        _name.textAlignment = NSTextAlignmentCenter;
    }
    return _name;
}
- (UILabel *)label1{
    if (!_label1) {
        _label1 = [[UILabel alloc]init];
        _label1.backgroundColor = RGB_COLOR(224, 224, 224);
        
    }
    return _label1;
}
- (UILabel *)titleLabel{
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc]init];
        _titleLabel.text = @"请选择充值金额";
        _titleLabel.textAlignment = NSTextAlignmentCenter;
        [_titleLabel setFont:[UIFont systemFontOfSize:14]];
        _titleLabel.textColor = RGB_COLOR(102, 102, 102);
    }
    return _titleLabel;
}
- (UILabel *)label2{
    if (!_label2) {
        _label2 = [[UILabel alloc]init];
        _label2.backgroundColor = RGB_COLOR(224, 224, 224);
    }
    return _label2;
}
- (void)setframe{
    [self.headImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(20*SCREEN_H_POINT);
        make.size.mas_equalTo(CGSizeMake(60*SCREEN_H_POINT, 60*SCREEN_H_POINT));
        make.left.mas_equalTo((SCREEN_WIDTH - 60*SCREEN_H_POINT)/2);
    }];
    [self.name mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.headImage.mas_bottom).offset(10*SCREEN_H_POINT);
        make.size.mas_equalTo(CGSizeMake(100*SCREEN_H_POINT, 30*SCREEN_H_POINT));
        make.left.mas_equalTo((SCREEN_WIDTH - 100*SCREEN_H_POINT)/2);
    }];
    [self.label1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.name.mas_bottom).offset(30*SCREEN_H_POINT);
        make.size.mas_equalTo(CGSizeMake(60*SCREEN_H_POINT, 1*SCREEN_H_POINT));
        make.left.mas_equalTo((SCREEN_WIDTH - 250*SCREEN_H_POINT)/2);
    }];
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.name.mas_bottom).offset(20*SCREEN_H_POINT);
        make.size.mas_equalTo(CGSizeMake(120*SCREEN_H_POINT, 21*SCREEN_H_POINT));
        make.left.mas_equalTo(self.label1.mas_right).offset(5*SCREEN_H_POINT);
    }];
    [self.label2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.name.mas_bottom).offset(30*SCREEN_H_POINT);
        make.size.mas_equalTo(CGSizeMake(60*SCREEN_H_POINT, 1*SCREEN_H_POINT));
        make.right.mas_equalTo(-(SCREEN_WIDTH - 250*SCREEN_H_POINT)/2);
    }];
    
}


@end
