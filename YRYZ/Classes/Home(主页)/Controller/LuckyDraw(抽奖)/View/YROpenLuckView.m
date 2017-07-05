//
//  YROpenLuckView.m
//  YRYZ
//
//  Created by Sean on 16/9/19.
//  Copyright © 2016年 yryz. All rights reserved.
//

#import "YROpenLuckView.h"

@interface YROpenLuckView ()



@end
@implementation YROpenLuckView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self configUI];
    }
    return self;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        [self configUI];
    }
    return self;
}

- (void)configUI{
   UILabel *title = [[UILabel alloc]init];
    self.title = title;
    title.text = @"获奖者";
    [self addSubview:title];
    [title mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self);
        make.centerX.equalTo(self);
        make.height.mas_equalTo(30);
    }];
    UIButton *btn  = [UIButton buttonWithType:UIButtonTypeCustom];
    [btn setBackgroundImage:[UIImage imageNamed:@"yr_luck_two"] forState:UIControlStateNormal];
    [btn setTitle:@"即将开奖" forState:UIControlStateNormal];
    [self addSubview:btn];
    [btn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(title.mas_bottom).offset(5);
        make.bottom.equalTo(self);
        make.left.right.equalTo(self);
    }];
    

}
@end































