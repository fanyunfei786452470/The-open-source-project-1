//
//  LotteryView.m
//  LuckyDraw
//
//  Created by MrCai on 16/8/9.
//  Copyright © 2016年 Sean. All rights reserved.
//

#import "LotteryView.h"

#import <Masonry.h>
@interface LotteryView ()


@end

@implementation LotteryView


- (instancetype)init
{
    self = [super init];
    if (self) {
        [self configUI];
    }
    return self;
}
- (void)configUI{
    
    TYAttributedLabel *label = [[TYAttributedLabel alloc]init];
    _label = label;
   
    [label appendImage:[UIImage imageNamed:@"yr_0_timer"]];
    [label appendText:@" "];
    [label appendImage:[UIImage imageNamed:@"yr_0_timer"]];
        [label appendText:@" "];
    [label appendImage:[UIImage imageNamed:@"yr_0_timer"]];
        [label appendText:@" "];
    [label appendImage:[UIImage imageNamed:@"yr_0_timer"]];
        [label appendText:@" "];
    [label appendImage:[UIImage imageNamed:@"yr_0_timer"]];
        [label appendText:@" "];
    [self addSubview:label];
    label.backgroundColor = [UIColor clearColor];
    label.verticalAlignment = TYVerticalAlignmentCenter;
    [label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self);
        make.size.mas_equalTo(CGSizeMake(160, 40));
        make.left.equalTo(self.mas_left).mas_offset(60);
    }];
    
    UILabel *label1 = [[UILabel alloc]initWithFrame:CGRectMake(20, 0, 50, 40)];
    UILabel *label2 = [[UILabel alloc]initWithFrame:CGRectMake(220, 0, 60, 40)];
    [self addSubview:label1];
    [self addSubview:label2];
    
    label1.font = [UIFont systemFontOfSize:15];
//    label1.textColor = [UIColor whiteColor];
    label1.text = @"剩余";
    
    label2.text = @"次转发";
    label2.font = [UIFont systemFontOfSize:15];
//    label2.textColor = [UIColor whiteColor];
    
//    [label1 mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.left.equalTo(label.mas_left).mas_offset(10);
//        make.centerX.equalTo(label);
//        make.size.mas_equalTo(CGSizeMake(40, 40));
//    }];
    
    
    
}


/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
