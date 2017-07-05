//
//  YRLoginPasswordViewController.m
//  YRYZ
//
//  Created by weishibo on 16/8/11.
//  Copyright © 2016年 yryz. All rights reserved.
//

#import "YRLoginPasswordViewController.h"

#import "SPKitExample.h"

#import "YRYYCache.h"
#import "YRLoginController.h"

@interface YRLoginPasswordViewController ()

@property (nonatomic,strong) NSMutableArray *textAry;

@end

@implementation YRLoginPasswordViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setTitle:@"修改登录密码"];
    [self initUI];
}


- (void)initUI{
    
    self.view.bounds = CGRectMake(0, -10, SCREEN_WIDTH, SCREEN_HEIGHT);
    
    UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0,-10, SCREEN_WIDTH, 10)];
    view.backgroundColor = RGB_COLOR(245, 245, 245);
    
    [self.view addSubview:view];
    
    NSMutableArray *TextFilearray = [[NSMutableArray alloc]init];
    
    NSArray *array = @[@"请输入旧密码",@"请输入新密码",@"请确认密码"];
    NSArray *pwdArray = @[@"请输入旧密码",@"请输入新密码",@"请确认密码"];
    [array enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(10, 75*0 + 54 *idx, 100, 54)];
        label.text = pwdArray[idx];
        label.textColor = RGB_COLOR(43, 43, 43);
        label.textAlignment = NSTextAlignmentLeft;
        label.font = [UIFont systemFontOfSize:16];
        [self.view addSubview:label];
        
        if (idx != 0) {
            UILabel *lineLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 76*0 + 54 * idx, SCREEN_WIDTH - 20, 1)];
            lineLabel.backgroundColor = RGB_COLOR(238, 238, 238);
            [self.view addSubview:lineLabel];
        }
        
        
        UITextField *textField = [[UITextField alloc] initWithFrame:CGRectMake(120, 75*0 + 54 *idx , SCREEN_WIDTH - 120, 54)];
        NSAttributedString *art = [[NSAttributedString alloc]initWithString:array[idx] attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:16],NSForegroundColorAttributeName:RGB_COLOR(144, 144, 144)}];
        textField.secureTextEntry = YES;
        [TextFilearray addObject:textField];
//        textField.placeholder = array[idx];
        textField.attributedPlaceholder = art;
        [self.view addSubview:textField];
    
    }];
    
    self.textAry = TextFilearray;
    
    
    UIButton *okButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [okButton setBackgroundImage:[UIImage imageNamed:@"yr_button_Bg"] forState:UIControlStateNormal];
    okButton.frame = CGRectMake((SCREEN_WIDTH - 280)/2, 320-100 , 280, 40);
    [okButton setTitle:@"确认" forState:UIControlStateNormal];
    okButton.titleLabel.font = [UIFont titleFont18];
    [okButton addTarget:self action:@selector(okbuttonClick) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:okButton];
    
}

- (void)okbuttonClick{
    
    
     UITextField *textField1 = self.textAry[0];
     UITextField *textField2 = self.textAry[1];
     UITextField *textField3 = self.textAry[2];
    
//    if (![textField1.text isEqualToString:[YRUserInfoManager manager].password]) {
//        [MBProgressHUD showError:@"密码输入错误"];
//        return;
//    }
    if (![textField2.text isEqualToString:textField3.text]) {
        [MBProgressHUD showError:@"两次输入密码不一致,请重新输入"];
        return;
    }
    if (![textField2.text isPassword]) {
        [MBProgressHUD showError:@"密码格式输入有误" toView:self.view];
        return;
    }
    [YRHttpRequest ChangeThePasswordFromOldPassword:textField1.text newPassword:textField2.text success:^(NSDictionary *data) {
        
        [MBProgressHUD showSuccess:@"修改密码成功"];
        [self loginOut];
        
    } failure:^(NSString *errorInfo) {
        [MBProgressHUD showError:errorInfo];
        
    }];
    

}

- (void)loginOut{
    
    @weakify(self);
    [YRHttpRequest userLoginOutSuccess:^(id data) {

        @strongify(self);
        [[SPKitExample sharedInstance] callThisBeforeISVAccountLogout];
        
//        [[YRUserInfoManager manager] removeLastUid];
        [YRUserInfoManager manager].currentUser = nil;
        [self.navigationController popToRootViewControllerAnimated:YES];
        
        YRLoginController *login = [[YRLoginController alloc]init];
        [self.delegate.navigationController pushViewController:login animated:YES];
     
    } failure:^(id data) {
        @strongify(self);
        [[SPKitExample sharedInstance] callThisBeforeISVAccountLogout];
//        [[YRUserInfoManager manager] removeLastUid];
        [YRUserInfoManager manager].currentUser = nil;
        [self.navigationController popToRootViewControllerAnimated:YES];
        
        YRLoginController *login = [[YRLoginController alloc]init];
        [self.delegate.navigationController pushViewController:login animated:YES];
    }];
    
}






- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
