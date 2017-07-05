//
//  YRRedAdsMainViewController.m
//  YRYZ
//
//  Created by weishibo on 16/8/18.
//  Copyright © 2016年 yryz. All rights reserved.
//

#import "YRRedAdsMainViewController.h"
#import "YRRedAdsViewController.h"
#import "YRAdsRulesViewController.h"

@interface YRRedAdsMainViewController ()

@end

@implementation YRRedAdsMainViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"红包广告";
    [self setRightNavButtonWithTitle:@"发布"];
    [self setUpChildControllers];
}

- (void)setUpChildControllers{
    NSArray *arrary = @[@"全部",@"未领红包",@"最热"];
    [arrary enumerateObjectsUsingBlock:^(NSString *title, NSUInteger idx, BOOL * _Nonnull stop) {
        YRRedAdsViewController *adController = [[YRRedAdsViewController alloc]init];
        adController.title = arrary[idx];
        [self addChildViewController:adController];
    }];
    
}


- (void)rightNavAction:(UIButton*)button{
    
    YRAdsRulesViewController *read = [[YRAdsRulesViewController alloc]init];
    [self.navigationController pushViewController:read animated:YES];

}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];

}


@end
