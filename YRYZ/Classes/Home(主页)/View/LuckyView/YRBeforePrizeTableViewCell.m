//
//  YRBeforePrizeTableViewCell.m
//  YRYZ
//
//  Created by Sean on 16/8/10.
//  Copyright © 2016年 yryz. All rights reserved.
//

#import "YRBeforePrizeTableViewCell.h"
#import <TYAttributedLabel.h>
@implementation YRBeforePrizeTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
//    self.whatNum.backgroundColor = RGB_COLOR(253, 207, 48);
//    self.whatNum setBackgroundImage:<#(nullable UIImage *)#> forState:<#(UIControlState)#>
    
    [self.whatNum setTitle:@"189期" forState:UIControlStateNormal];
    self.contentView.backgroundColor = RGB_COLOR(245, 245, 245);
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    
    self.time.textColor = RGB_COLOR(184, 184, 184);
    
      TYAttributedLabel *label = [[TYAttributedLabel alloc]init];
    label.backgroundColor = [UIColor clearColor];
    NSString *one = @"一等奖 ";
    NSString *oneP = @"3000积分";
    
    NSMutableAttributedString *attributedStringA = [[NSMutableAttributedString alloc]initWithString:one];
    [attributedStringA addAttributeTextColor:[UIColor blackColor]];
    [attributedStringA addAttributeFont:[UIFont boldSystemFontOfSize:18]];
   
    
    [label appendTextAttributedString:attributedStringA];
    
    
    NSMutableAttributedString *attributedStringB = [[NSMutableAttributedString alloc]initWithString:oneP];
    [attributedStringB addAttributeTextColor:[UIColor redColor]];
     [attributedStringB addAttributeFont:[UIFont systemFontOfSize:18]];
    [label appendTextAttributedString:attributedStringB];
    
    [self.first addSubview:label];
    [label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.first).mas_offset(5);
        make.left.equalTo(self.first).mas_offset(10);
        make.size.mas_equalTo(CGSizeMake(150, 30));
    }];
    
    UILabel *labelOneKey = [[UILabel alloc]init];
    labelOneKey.text = @"SG1234566DGS47W50";
    [self.first addSubview:labelOneKey];
    [labelOneKey mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(label.mas_left).mas_offset(0);
        make.size.mas_equalTo(CGSizeMake(200, 30));
        make.top.equalTo(label.mas_bottom).mas_offset(0);
        
    }];
    _OneKey = labelOneKey;
    
    
    UILabel *OneName = [[UILabel alloc]init];
    OneName.text = @"刘雨薇百公里远";
    OneName.textColor = RGB_COLOR(75, 200, 191);
    [self.first addSubview:OneName];
    _OneName = OneName;
    [OneName mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.first).mas_offset(-5);
        make.top.equalTo(label.mas_bottom);
        make.size.mas_equalTo(CGSizeMake(150, 30));
    }];
    
    
    
    
    
    NSString *two = @"二等奖 ";
    NSString *twoP = @"1000积分";
    
    TYAttributedLabel *labelT = [[TYAttributedLabel alloc]init];
    label.backgroundColor = [UIColor clearColor];
   
    
    NSMutableAttributedString *attributedStringFA = [[NSMutableAttributedString alloc]initWithString:two];
    [attributedStringFA addAttributeTextColor:[UIColor blackColor]];
    [attributedStringFA addAttributeFont:[UIFont boldSystemFontOfSize:18]];
    
    
    [labelT appendTextAttributedString:attributedStringFA];
    
    
    NSMutableAttributedString *attributedStringFB = [[NSMutableAttributedString alloc]initWithString:twoP];
    [attributedStringFB addAttributeTextColor:[UIColor redColor]];
    [attributedStringFB addAttributeFont:[UIFont systemFontOfSize:18]];
    [labelT appendTextAttributedString:attributedStringFB];
    
    [self.second addSubview:labelT];
    
    [labelT mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.second).mas_offset(5);
        make.left.equalTo(self.second).mas_offset(10);
        make.size.mas_equalTo(CGSizeMake(150, 30));
    }];
    
    UILabel *TwoOneKey = [[UILabel alloc]init];
    TwoOneKey.text = @"SG1234566DGS47W50";
    [self.second addSubview:TwoOneKey];
    [TwoOneKey mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(labelT);
        
        make.top.equalTo(labelT.mas_bottom);
        make.size.mas_equalTo(CGSizeMake(200, 30));
    }];
    _TwoOneKey = TwoOneKey;
    
    UILabel *TwoOneName = [[UILabel alloc]init];
    _TwoOneName = TwoOneName;
    TwoOneName.text = @"似懂非懂";
    TwoOneName.textColor = RGB_COLOR(75, 200, 191);
    [self.second addSubview:TwoOneName];
    
    [TwoOneName mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.second.mas_right).mas_offset(-5);
        make.top.equalTo(TwoOneKey);
        make.size.mas_equalTo(CGSizeMake(150, 30));
    }];
    
    UILabel *TwoTwoeKey = [[UILabel alloc]init];
    TwoTwoeKey.text = @"SG1234566DGS47W50";
    
      _TwoTwoKey =TwoTwoeKey;
    [self.second addSubview:TwoTwoeKey];
    [TwoTwoeKey mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(labelT);
        
        make.top.equalTo(TwoOneName.mas_bottom);
        make.size.mas_equalTo(CGSizeMake(200, 30));
    }];
    
    UILabel *TwoTwoName = [[UILabel alloc]init];
    TwoTwoName.textColor = RGB_COLOR(75, 200, 191);
    TwoTwoName.text = @"angelababy";
    
    [self.second addSubview:TwoTwoName];
    _TwoTwoName =TwoTwoName;
    [TwoTwoName mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.second.mas_right).mas_offset(-5);
        make.top.equalTo(TwoTwoeKey);
        make.size.mas_equalTo(CGSizeMake(150, 30));
    }];
    
    self.OneKey.font = [UIFont systemFontOfSize:15];
    self.TwoOneKey.font = [UIFont systemFontOfSize:15];
    self.TwoTwoKey.font = [UIFont systemFontOfSize:15];
    
    self.OneName.textAlignment = NSTextAlignmentRight;
    self.TwoOneName.textAlignment = NSTextAlignmentRight;
    self.TwoTwoName.textAlignment = NSTextAlignmentRight;
    
    
    self.OneName.font = [UIFont systemFontOfSize:15];
    self.TwoOneName.font = [UIFont systemFontOfSize:15];
    self.TwoTwoName.font = [UIFont systemFontOfSize:15];
}
- (void)setUIWithModel:(YRBeforeArray *)model{
    
    NSString *whatNum = [NSString stringWithFormat:@"第%@期",model.no];
    [self.whatNum setTitle:whatNum forState:UIControlStateNormal];
     NSString *time = [NSString stringWithFormat:@"开奖日期:%@",model.time];
    self.time.text = time;
    YRBeforePrizeModel *modelF = model.list[0];
    YRBeforePrizeModel *modelS1 = model.list[1];
    YRBeforePrizeModel *modelS2 = model.list[2];
    self.OneKey.text = modelF.number;
    self.OneName.text = modelF.nickName;
    
    self.TwoOneKey.text = modelS1.number;
    self.TwoOneName.text = modelS1.nickName;
    
    self.TwoTwoKey.text = modelS2.number;
    self.TwoTwoName.text = modelS2.nickName;
    
}





- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
