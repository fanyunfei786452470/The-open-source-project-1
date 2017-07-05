//
//  YRRedAdsMainViewController.m
//  YRYZ
//
//  Created by weishibo on 16/8/18.
//  Copyright © 2016年 yryz. All rights reserved.
//

#import "YRRedAdsMainViewController.h"
#import "YRRedAdsViewController.h"
#import "YRRealseAdsViewController.h"
#import "YRRedPaperAdPaymemtViewController.h"
#import "YRReleaseGraphicAdsViewController.h"

@interface YRRedAdsMainViewController ()

@end

@implementation YRRedAdsMainViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"红包广告";
    [self setRightNavButtonWithImage:@"yr_show_edit" title:@"发布"];
    [self setLeftNavButtonWithImage:[UIImage imageNamed:@"yr_return"]];
    [self setUpChildControllers];
}
- (void)setUpChildControllers{
    NSArray *arrary = @[@"全部",@"最热"];
    [arrary enumerateObjectsUsingBlock:^(NSString *title, NSUInteger idx, BOOL * _Nonnull stop) {
        YRRedAdsViewController *adController = [[YRRedAdsViewController alloc]init];
        adController.title = arrary[idx];
        [self addChildViewController:adController];
    }];
}
- (void)leftNavAction:(UIButton *)button{
    [self.navigationController popToRootViewControllerAnimated:YES];
}
- (void)rightNavAction:(UIButton*)button{
    if ([YRUserInfoManager manager].currentUser==nil) {
        [self noLoginTip];
    }else{

    YRRealseAdsViewController *read = [[YRRealseAdsViewController alloc]init];
    [self.navigationController pushViewController:read animated:YES];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];

}


@end
