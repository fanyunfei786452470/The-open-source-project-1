//
//  YRRedBagController.m
//  YRYZ
//
//  Created by 易超 on 16/7/21.
//  Copyright © 2016年 yryz. All rights reserved.
//

#import "YRRedBagController.h"
#import "YRSendRedBagController.h"
#import "YRReceiptRedBagController.h"

@interface YRRedBagController ()

@end

@implementation YRRedBagController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setTitle:@"红包记录"];
    
    [self setUpChildControllers];
}


// 添加子控制器
- (void)setUpChildControllers{
    
    YRSendRedBagController *sendRedBagVC = [[YRSendRedBagController alloc]init];
    sendRedBagVC.title = @"收到的红包";
    [self addChildViewController:sendRedBagVC];
    
    YRSendRedBagController *receiptRedBagVC = [[YRSendRedBagController alloc]init];
    receiptRedBagVC.title = @"发出的红包";
    [self addChildViewController:receiptRedBagVC];
 
}

-(void)dealloc{
    DLog(@"红包记录死掉了");
}

@end
