//
//  YRDiscoverViewController.m
//  YRYZ
//
//  Created by 易超 on 16/6/29.
//  Copyright © 2016年 yryz. All rights reserved.
//

#import "YRDiscoverViewController.h"
#import "YRCacheController.h"
@interface YRDiscoverViewController ()

@end

@implementation YRDiscoverViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor randomColor];
 
 

}
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
//
//    YRAlertView *alertView = [[YRAlertView alloc] initWithTitle:@"退出后不会通知群聊中其他成员，且不会再接受此群聊消息" cancelButtonText:@"确定"];
//    
//    alertView.addCancelAction = ^{
//        
//    };
//    alertView.addConfirmAction = ^{
//        
//        
//    };
//    [alertView show];
    YRCacheController *cache = [[YRCacheController alloc]init];
    
    [self.navigationController pushViewController:cache animated:YES];
    

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
