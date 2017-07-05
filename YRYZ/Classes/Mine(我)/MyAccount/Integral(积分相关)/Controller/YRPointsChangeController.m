//
//  YRPointsChangeController.m
//  YRYZ
//
//  Created by Sean on 16/8/13.
//  Copyright © 2016年 yryz. All rights reserved.
//

#import "YRPointsChangeController.h"
//#import "YRPaymentPasswordView.h"
#import "YRMinePayView.h"
#import "YRChangePayPassWordController.h"
@interface YRPointsChangeController ()<UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet UILabel *canChange;

@property (weak, nonatomic) IBOutlet UILabel *Money;
@property (weak, nonatomic) IBOutlet UITextField *inuView;

@property (weak, nonatomic) IBOutlet UIButton *sureBtn;
@property (weak, nonatomic) IBOutlet UILabel *moneyG;

@property (weak, nonatomic) IBOutlet UILabel *allText;

@property (nonatomic,assign) BOOL havePassword;


@end

@implementation YRPointsChangeController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
//    self.sureBtn.backgroundColor = [UIColor redColor];
    self.title = @"积分兑换";
    self.view.backgroundColor = RGB_COLOR(246, 246, 246);
    [self configUI];
}
- (void)viewWillAppear:(BOOL)animated{
    
    [super viewWillAppear:animated];
   
}
- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [self.inuView endEditing:YES];
}
- (void)configUI{
    self.sureBtn.titleLabel.font = [UIFont boldSystemFontOfSize:17];
    
    [self.sureBtn addTarget:self action:@selector(sureBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    
    self.canChange.textColor = RGB_COLOR(170, 170, 170);
    self.Money.textColor = RGB_COLOR(45, 199, 185);
//    CGFloat sum = [self.model.integralSum integerValue] * 0.01;
    
    self.Money.text = [NSString stringWithFormat:@" : %.2f",self.sum];
    self.inuView.keyboardType = UIKeyboardTypeDecimalPad;
    
    UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(10, 10,100, 40)];
    label.text = @"  兑换积分";
    label.textColor = RGB_COLOR(38, 38, 38);
    label.font = [UIFont boldSystemFontOfSize:17];
    self.inuView.leftView = label;
    self.inuView.leftViewMode = UITextFieldViewModeAlways;
    self.inuView.borderStyle = UITextBorderStyleNone;
    self.inuView.backgroundColor = [UIColor whiteColor];
    self.inuView.delegate = self;
    self.moneyG.font = [UIFont boldSystemFontOfSize:18];
    self.inuView.keyboardType = UIKeyboardTypeNumberPad;
    
    self.moneyG.textColor = RGB_COLOR(38, 38, 38);
    self.allText.text = @"";
//    self.allText.text = @"点击门店配置下的规则管理的添加积分规,选择规则设定,这里可以选所有门店规则相同或者门店默认规则设定.我们选择门店默认规则设定,然后下一步,选择门店,最后就是填写此门店的积分比例,改即可";
    [self.allText sizeToFit];
    self.allText.numberOfLines = 0;
    self.allText.textColor = RGB_COLOR(108, 108, 108);
    
}
- (void)sureBtnClick:(UIButton *)sender{
    
    NSArray *ary = [self.Money.text componentsSeparatedByString:@" "];
    if ([self.inuView.text isEqualToString:@""]) {
        [MBProgressHUD showError:@"请输入积分"];
        return;
    }
    if ([self.inuView.text integerValue]<=0) {
        [MBProgressHUD showError:@"请输入正确金额"];
        return;
    }
    
    if (![self.inuView.text containsOnlyNumbers]) {
        [MBProgressHUD showError:@"输入不正确,请重新输入"];
        return;
    }
     if ([self.inuView.text floatValue]>[ary.lastObject floatValue]) {
        DLog(@"积分不足");
        [MBProgressHUD showError:@"积分不足"];
        return;
    }

    
   [self sendPointsWithText];
 
}


- (void)sendPointsWithText{
    
    [YRMinePayView showPaymentViewWithMoney:self.inuView.text paymentBlock:^(NSString *password) {
        [YRMinePayView hidePaymentPasswordView];
        [YRHttpRequest pointsToTheConsumerAccountByChangeTheAmount:self.inuView.text.floatValue*100 password:password success:^(NSDictionary *data) {
            [MBProgressHUD showError:@"积分兑换成功"];
            [YRMinePayView hidePaymentPasswordView];
            [self.navigationController popViewControllerAnimated:YES];
        } failure:^(NSString *data) {
            if ([data isEqualToString:@"支付密码错误"]) {
                [YRMinePayView hidePaymentPasswordView];
                
                YRAlertView *alertView = [[YRAlertView alloc] initWithTitle:@"支付密码错误，请重试" cancelButtonText:@"确定"  ];
                
                alertView.addCancelAction = ^{
                    [self sendPointsWithText];
                };
                [alertView show];
                return ;
            }
            [MBProgressHUD showError:data];
            
        }];
    }];
    
    
}

//- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)strin{
//    if ([textField.text isEqualToString:@"0"]) {
//        if ([strin isEqualToString:@"0"]) {
//             textField.text = @"0.";
//        }
//    }
//    
//    return YES;
//}


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
