//
//  YRChangePayController.m
//  YRYZ
//
//  Created by Sean on 16/10/18.
//  Copyright © 2016年 yryz. All rights reserved.
//

#import "YRChangePayController.h"
#import "YRPassWordView.h"
@interface YRChangePayController ()

@property (weak, nonatomic) IBOutlet YRPassWordView *passView;

@property (weak, nonatomic) IBOutlet UIButton *suerBtn;

@property (weak, nonatomic) IBOutlet UILabel *subtitle;

@end

@implementation YRChangePayController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self configUI];
}
- (void)configUI{
    self.passView.elementCount = 6;
    self.suerBtn.backgroundColor = [UIColor themeColor];
    self.suerBtn.layer.cornerRadius = 20;
    self.suerBtn.clipsToBounds = YES;
    [self.suerBtn setTitle:self.sureBtnTitle forState:UIControlStateNormal];
    self.subtitle.text = self.subtitleText;
    
    @weakify(self);
    if ([self.title isEqualToString:@"修改支付密码"]) {
        self.suerBtn.hidden = YES;
        self.passView.passwordBlock = ^(NSString *password){
            DLog(@"%@",password);
            if (password.length==6) {
                YRChangePayController *suer = [[YRChangePayController alloc]init];
                @strongify(self);
                suer.password = password;
                [self.navigationController pushViewController:suer animated:YES];
            }
        };
    }
    else if ([self.title isEqualToString:@"设置支付密码"]){
        self.suerBtn.hidden = YES;
        self.passView.passwordBlock = ^(NSString *password){
            DLog(@"%@",password);
            
        };
    }
    else if ([self.title isEqualToString:@"确认支付密码"]){
        self.suerBtn.hidden = NO;
        self.passView.passwordBlock = ^(NSString *password){
            DLog(@"%@",password);
            if (password.length==6) {
                YRChangePayController *suer = [[YRChangePayController alloc]init];
                @strongify(self);
                suer.password = password;
                [self.navigationController pushViewController:suer animated:YES];
            }
        };
    }
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
