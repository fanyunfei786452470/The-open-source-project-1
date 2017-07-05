//
//  YRCircleMainViewController.m
//  YRYZ
//
//  Created by weishibo on 16/8/3.
//  Copyright © 2016年 yryz. All rights reserved.
//

#import "YRCircleMainViewController.h"
#import "YRCircleViewController.h"


@interface YRCircleMainViewController ()
@end

@implementation YRCircleMainViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"圈子";
    [self setUpChildControllers];
    [self setRightNavButtonWithImage:[UIImage imageNamed:@"yr_msg_search"]];
 
}

- (void)rightNavAction:(UIButton*)button{

}
// 添加子控制器
- (void)setUpChildControllers{
    
    NSArray *arrary = @[@"全部",@"好友",@"关注"];
    [arrary enumerateObjectsUsingBlock:^(NSString *title, NSUInteger idx, BOOL * _Nonnull stop) {
        YRCircleViewController *circleViewController = [[YRCircleViewController alloc]init];
        circleViewController.title = title;
        [self addChildViewController:circleViewController];
    }];
    
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}


@end
