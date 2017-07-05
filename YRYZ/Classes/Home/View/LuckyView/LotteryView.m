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


- (instancetype)initWithNeedCount:(NSString *)needcount
{
    self = [super init];
    if (self) {
        self.needcount = needcount;
        [self configUI];
    }
    return self;
}
- (void)configUI{
    
    TYAttributedLabel *label = [[TYAttributedLabel alloc]init];
    _label = label;
   
//    [label appendImage:[UIImage imageNamed:@"yr_0_timer"]];
//    [label appendText:@" "];
//    [label appendImage:[UIImage imageNamed:@"yr_0_timer"]];
//        [label appendText:@" "];
//    [label appendImage:[UIImage imageNamed:@"yr_0_timer"]];
//        [label appendText:@" "];
//    [label appendImage:[UIImage imageNamed:@"yr_0_timer"]];
//        [label appendText:@" "];
//    [label appendImage:[UIImage imageNamed:@"yr_0_timer"]];
//        [label appendText:@" "];
    NSInteger length = self.needcount.length;
    
    for (int i = 0; i< 5 - length; i++) {
        [label appendImage:[UIImage imageNamed:@"yr_0_timer"]];
        [label appendText:@" "];
    }
    
    for (int i = 0; i<self.needcount.length; i++) {
        //获取索引对应的字符
        unichar c = [self.needcount characterAtIndex:i];
      NSString *name = [NSString stringWithFormat:@"yr_%C_timer",c];
        [label appendImage:[UIImage imageNamed:name]];
        [label appendText:@" "];
    }
    

    [self addSubview:label];
    label.backgroundColor = [UIColor clearColor];
    label.verticalAlignment = TYVerticalAlignmentCenter;
    [label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self);
        make.size.mas_equalTo(CGSizeMake(160, 40));
//        make.left.equalTo(self.mas_left).mas_offset(60);
        make.centerX.equalTo(self.mas_centerX);
    }];
    
    UILabel *label1 = [[UILabel alloc]init];
    UILabel *label2 = [[UILabel alloc]init];
    [self addSubview:label1];
    [self addSubview:label2];
    [label1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(label.mas_left);
        make.top.equalTo(self);
        make.size.mas_equalTo(CGSizeMake(50, 40));
    }];
    [label2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(label.mas_right);
        make.top.equalTo(self);
        make.size.mas_equalTo(CGSizeMake(60, 40));
    }];
    
    
    
    
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
