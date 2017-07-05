//
//  YRChangeTwoController.m
//  YRYZ
//
//  Created by Sean on 16/10/18.
//  Copyright © 2016年 yryz. All rights reserved.
//

#import "YRChangeTwoController.h"
#import "YRPassWordView.h"
#import "YRChangeThreeController.h"
@interface YRChangeTwoController ()

@end

@implementation YRChangeTwoController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}
- (void)configUI{
    
    UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(0, 45, SCREEN_WIDTH, 20)];
    label.centerX = self.view.centerX;
    [self.view addSubview:label];
    label.text = @"设置新的6位数支付密码";
    label.textAlignment = NSTextAlignmentCenter;
    label.font = [UIFont systemFontOfSize:16];
    label.textColor = RGB_COLOR(51, 51, 51);
    
    YRPassWordView *pass = [[YRPassWordView alloc]initWithFrame:CGRectMake(0, 85, 310, 45)];
    pass.centerX = self.view.centerX;
    pass.elementCount = 6;
    [self.view addSubview:pass];
    
    pass.passwordBlock = ^(NSString *password){
        DLog(@"%@",password);
        if (password.length==6) {
            YRChangeThreeController *change = [[YRChangeThreeController alloc]init];
            change.title = @"修改支付密码";
            [self.navigationController pushViewController:change animated:YES];
        }
    };
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
