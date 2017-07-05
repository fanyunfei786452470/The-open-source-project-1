//
//  YRImageTextMainViewController.m
//  YRYZ
//
//  Created by weishibo on 16/8/3.
//  Copyright © 2016年 yryz. All rights reserved.
//

#import "YRImageTextMainViewController.h"
#import "YRImageTextController.h"
#import "YRInfoProductTypeModel.h"
#import "YRReleaseImageTextViewController.h"
@interface YRImageTextMainViewController ()

@end

@implementation YRImageTextMainViewController
- (NSMutableArray*)typeDataSource{
    
    if (!_typeDataSource) {
        _typeDataSource = @[].mutableCopy;
    }
    return _typeDataSource;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setTitle:@"靓图美文"];
    [self setUpChildControllers];
    [self setRightNavButtonWithTitle:@"发布"];
}


// 添加子控制器
- (void)setUpChildControllers{
    
    [self.typeDataSource enumerateObjectsUsingBlock:^(YRInfoProductTypeModel *model, NSUInteger idx, BOOL * _Nonnull stop) {
        YRImageTextController *imageTextController = [[YRImageTextController alloc]init];
        imageTextController.title = model.channelName;
        imageTextController.model = model;
        [self addChildViewController:imageTextController];
        
    }];
    
}


- (void)rightNavAction:(UIButton *)button{
//    YRAlertView *alertView = [[YRAlertView alloc] initWithTitle:@"用户在“悠然一指”平台成功发布的作品,均有机会被付费转发到圈子。被转发后,发布作品的用户均能按照平台规则获得“转发定价x5%x被付费转发次数”的收益" cancelButtonText:@"确认" confirmButtonText:@"取消"];
//    alertView.bounds = CGRectMake(0, 0, 200, 200);
    
    YRAlertView *alertView = [[YRAlertView alloc] initWithFrame:CGRectMake(0, 0,250, 250) title:@"作品奖励规则" subTitle:@"用户在 “悠然一指” 平台成功发布的作品,均有机会被付费转发到圈子。被转发后,发布作品的用户均能按照平台规则获得 “转发定价x5%x被付费转发次数” 的收益" cancelButtonText:@"确认" confirmButtonText:@"取消"];
    alertView.center = self.view.center;
    
    [alertView show];
    alertView.addCancelAction = ^(){
        YRReleaseImageTextViewController *releaseVc = [[YRReleaseImageTextViewController alloc] init];
        [self.navigationController pushViewController:releaseVc animated:YES];
    };
    
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end
