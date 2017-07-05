//
//  YROpenLuckController.m
//  YRYZ
//
//  Created by Sean on 16/9/19.
//  Copyright © 2016年 yryz. All rights reserved.
//

#import "YROpenLuckController.h"
#import <TYAttributedLabel.h>

#import "YROpenLuckView.h"
@interface YROpenLuckController ()

@end

@implementation YROpenLuckController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self configHeader];
}
- (void)configHeader{
    UIImageView *headerImage = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"yr_luck_head"]];
    
    CGFloat BL = 1080/1140.0;
    [self.view addSubview:headerImage];
    [headerImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view.mas_top).mas_offset(0);
        make.size.mas_equalTo(CGSizeMake(SCREEN_WIDTH, SCREEN_WIDTH*BL));
        make.centerX.equalTo(self.view);
    }];
    
    UILabel *first = [[UILabel alloc]init];
    first.text = @"一等奖 200积分";
    first.textAlignment = NSTextAlignmentCenter;
    first.font = [UIFont systemFontOfSize:20];
    [headerImage addSubview:first];
    [first mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(headerImage);
        make.size.mas_equalTo(YRSizeMake(180, 30));
        make.top.equalTo(headerImage.mas_top).mas_offset(8*SCREEN_H_POINT);
        
    }];
    
    YROpenLuckView *firstView = [[YROpenLuckView alloc]init];
    [headerImage addSubview:firstView];
    [firstView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(first.mas_bottom).mas_offset(9*SCREEN_H_POINT);
        make.size.mas_equalTo(YRSizeMake(SCREEN_WIDTH -100, 40));
        make.centerX.equalTo(first);        
    }];
    
    
//    
//     UILabel *second = [[UILabel alloc]init];
//    second.text = @"二等奖 50积分";
//    second.textAlignment = NSTextAlignmentCenter;
//    second.font = [UIFont systemFontOfSize:20];
//    [headerImage addSubview:second];
//    [second mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.centerX.equalTo(headerImage);
//        make.size.mas_equalTo(YRSizeMake(180, 30));
//        make.top.equalTo( .mas_bottom).mas_offset(5*SCREEN_H_POINT);
//        
//    }];
//    
    
 }
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
