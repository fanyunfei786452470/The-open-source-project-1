//
//  YRRewardIntegralViewController.m
//  YRYZ
//
//  Created by weishibo on 16/8/9.
//  Copyright © 2016年 yryz. All rights reserved.
//

#import "YRRewardIntegralViewController.h"
#import "YRStatementViewController.h"
#import "YRPointsChangeController.h"
#import "YRChangePayPassWordController.h"

@interface YRRewardIntegralViewController ()
@property (nonatomic,strong) YRAccountModel     *accountModel;

@property (nonatomic,assign) CGFloat sum;

@property (nonatomic,assign) BOOL havePassword;

@property (nonatomic,assign) BOOL feachData;
@end

@implementation YRRewardIntegralViewController

- (void)viewDidLoad {
    [super viewDidLoad];
//    self.view.backgroundColor = [UIColor redColor];
    self.canNum.hidden = YES;
    self.canIntegral.hidden = YES;
    [self setRightNavButtonWithTitle:@"积分明细"];
    
    self.title = @"奖励积分";
    [self configUI];
    [self.Btn addTarget:self action:@selector(toTheConsumerAccount:) forControlEvents:UIControlEventTouchUpInside];
    
    NSString *reward = (NSString *)[[YRYYCache share].yyCache objectForKey:@"accountReward"];
     self.allNum.text = reward;
    [YRHttpRequest AccountBalanceQuerySuccess:^(NSDictionary *data) {
        self.accountModel = [YRAccountModel mj_objectWithKeyValues:data];
        CGFloat sum = [self.accountModel.integralSum integerValue] * 0.01;
        self.sum = sum;
        self.allNum.text = [NSString stringWithFormat:@"%.2f",sum];
        [[YRYYCache share].yyCache setObject:self.allNum.text forKey:@"accountReward"];
        
     } failure:^(NSString *error) {
           [MBProgressHUD hideHUD];
        [MBProgressHUD showError:error];
    }];
    
}

-(void)rightNavAction:(UIButton *)button{
    
    YRStatementViewController *stateMent = [[YRStatementViewController alloc]init];
    stateMent.isPrize = YES;
    
    [self.navigationController pushViewController:stateMent animated:YES];
    
}
- (void)configUI{
    self.allIntegral.textColor = RGB_COLOR(146, 146, 146);
    
    self.allNum.textColor = RGB_COLOR(5, 5, 5);
    self.allNum.text = self.accountModel.costSum;
//    self.allNum.font = [UIFont systemFontOfSize:25];
    self.canIntegral.textColor = RGB_COLOR(146, 146, 146);
    self.canNum.textColor = RGB_COLOR(5, 5, 5);
    self.canNum.font = [UIFont systemFontOfSize:30];
}
- (void)toTheConsumerAccount:(UIButton *)sender{
    self.feachData = YES;
    
    if (!self.havePassword) {
//        NSAttributedString *str = [[NSAttributedString alloc]initWithString:@"去设置" attributes:@{NSForegroundColorAttributeName:[UIColor themeColor]}];

        YRAlertView *alertView = [[YRAlertView alloc] initWithTitle:@"为了保护您的账户安全请先设置支付密码" cancelButtonText:@"取消" confirmButtonText:@"去设置"];
         alertView.comfirmButtonColor = [UIColor themeColor];
        alertView.addCancelAction = ^{
            
        };
        alertView.addConfirmAction = ^{
            YRChangePayPassWordController *payVc = [[YRChangePayPassWordController alloc]init];
            payVc.title = @"设置支付密码";
            [self.navigationController pushViewController:payVc animated:YES];
        };
        [alertView show];
        return;
    }
    
    YRPointsChangeController *points = [[YRPointsChangeController alloc]init];
    points.sum = self.sum;
    points.model = self.accountModel;
    
    [self.navigationController pushViewController:points animated:YES];
}
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    if (self.feachData) {
        [YRHttpRequest AccountBalanceQuerySuccess:^(NSDictionary *data) {
            self.accountModel = [YRAccountModel mj_objectWithKeyValues:data];
            CGFloat sum = [self.accountModel.integralSum integerValue] * 0.01;
            self.sum = sum;
            self.allNum.text = [NSString stringWithFormat:@"%.2f",sum];
            
        } failure:^(NSString *error) {
            [MBProgressHUD showError:error];
        }];
    }
    [self queryPassWord];
}

- (void)queryPassWord{
    
    @weakify(self);
    
    
    [YRHttpRequest QueryThePaymentPasswordSuccess:^(NSDictionary *data) {
        @strongify(self);
        //是否设置支付密码
        self.havePassword = [data[@"isPayPassword"] boolValue];
        
    } failure:^(NSString *error) {
        [MBProgressHUD showError:error];
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)dealloc{
    DLog(@"奖励积分页面死掉了");
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
