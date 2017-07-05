//
//  YRRedAdsPaySucceedController.m
//  YRYZ
//
//  Created by 21.5 on 16/9/26.
//  Copyright © 2016年 yryz. All rights reserved.
//

#import "YRRedAdsPaySucceedController.h"
#import "YRRedAdsMainViewController.h"
#import "YRRealseAdsViewController.h"
@interface YRRedAdsPaySucceedController ()
<UIGestureRecognizerDelegate>
@property BOOL                                              isCanSideBack;
@end

@implementation YRRedAdsPaySucceedController


- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    self.isCanSideBack = NO;
    //关闭ios右滑返回
    if([self.navigationController respondsToSelector:@selector(interactivePopGestureRecognizer)]) {
        self.navigationController.interactivePopGestureRecognizer.delegate = self;
    }
}

- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer*)gestureRecognizer {
    return self.isCanSideBack;
}

- (void)viewDidDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    // 开启返回手势
    [self resetSideBack];
}

- (void)resetSideBack {
    self.isCanSideBack = YES;
    if([self.navigationController respondsToSelector:@selector(interactivePopGestureRecognizer)]) {
        self.navigationController.interactivePopGestureRecognizer.delegate = nil;
    }
}



- (void)viewDidLoad {
    [super viewDidLoad];
    [self setTitle:@"支付成功"];
    [self setLeftNavButtonWithImage:[UIImage imageNamed:@"yr_return"]];
    UIImageView * headImage = [[UIImageView alloc]init];
    [headImage setImage:[UIImage imageNamed:@"yr_realease_success"]];
    [self.view addSubview:headImage];
    
    UILabel * paySuccee = [[UILabel alloc]init];
    paySuccee.text = @"支付成功，广告审核中";
    paySuccee.textAlignment = NSTextAlignmentCenter;
    paySuccee.textColor = [UIColor wordColor];
    [paySuccee setFont:[UIFont systemFontOfSize:16]];
    [self.view addSubview:paySuccee];
    
    
    UILabel * adsNumber = [[UILabel alloc]init];
    adsNumber.text = @"广告编号：GG20160828103039xyz";
    adsNumber.textColor = RGB_COLOR(102, 102, 102);
    [adsNumber setFont:[UIFont systemFontOfSize:15]];
    adsNumber.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:adsNumber];
    
    UIImageView * ruleImage = [[UIImageView alloc]init];
    ruleImage.image = [UIImage imageNamed:@"yr_pay_success"];
    [self.view addSubview:ruleImage];
    
    [headImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.view).offset(45*SCREEN_H_POINT);
        make.left.mas_equalTo(self.view).offset((SCREEN_WIDTH-100*SCREEN_H_POINT)/2);
        make.size.mas_equalTo(CGSizeMake(100*SCREEN_H_POINT, 100*SCREEN_H_POINT));
    }];
    
    [paySuccee mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(headImage.mas_bottom).offset(10*SCREEN_H_POINT);
        make.left.mas_equalTo(self.view).offset((SCREEN_WIDTH - 200*SCREEN_H_POINT)/2);
        make.size.mas_equalTo(CGSizeMake(200*SCREEN_H_POINT, 30*SCREEN_H_POINT));
    }];

    [adsNumber mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(paySuccee.mas_bottom).offset(15*SCREEN_H_POINT);
        make.left.mas_equalTo(self.view).offset((SCREEN_WIDTH - 300*SCREEN_H_POINT)/2);
        make.size.mas_equalTo(CGSizeMake(300*SCREEN_H_POINT, 25*SCREEN_H_POINT));
    }];
    [ruleImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(adsNumber.mas_bottom).offset(25*SCREEN_H_POINT);
        make.left.mas_equalTo(self.view).offset(20*SCREEN_H_POINT);
        make.size.mas_equalTo(CGSizeMake(SCREEN_WIDTH-40*SCREEN_H_POINT,(SCREEN_WIDTH-40*SCREEN_H_POINT)/1.08));
    }];
}

- (void)setLeftNavButtonWithImage:(UIImage*)leftImage{
    
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:leftImage style:UIBarButtonItemStylePlain target:self action:@selector(leftNavAction:)];
    
}

- (void)leftNavAction:(UIButton *)button{
    NSInteger count = self.navigationController.childViewControllers.count-1;
    [self.navigationController popToViewController:self.navigationController.childViewControllers[count-4] animated:YES];

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
