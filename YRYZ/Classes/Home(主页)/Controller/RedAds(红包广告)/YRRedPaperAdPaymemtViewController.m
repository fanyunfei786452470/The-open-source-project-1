//
//  YRRedPaperAdPaymemtViewController.m
//  YRYZ
//
//  Created by Rongzhong on 16/8/18.
//  Copyright © 2016年 yryz. All rights reserved.
//

#import "YRRedPaperAdPaymemtViewController.h"
#import "YRRedPaperAdPayment.h"
#import "IQKeyboardManager.h"
@interface YRRedPaperAdPaymemtViewController ()

@end

@implementation YRRedPaperAdPaymemtViewController

- (void)viewWillAppear:(BOOL)animated{
    
    [super viewWillAppear:animated];
    
    [IQKeyboardManager sharedManager].enable = NO;
    
}

- (void)viewWillDisappear:(BOOL)animated{
    
    [super viewWillDisappear:animated];
    
    [IQKeyboardManager sharedManager].enable = YES;
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setTitle:@"支付"];
    self.view.backgroundColor = [UIColor whiteColor];
    
    YRRedPaperAdPayment *redPaperAdPayment = [[YRRedPaperAdPayment alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
    [self.view addSubview:redPaperAdPayment];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
