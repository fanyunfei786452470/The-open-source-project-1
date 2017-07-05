//
//  YRRetakePasswordController.m
//  YRYZ
//
//  Created by 易超 on 16/7/12.
//  Copyright © 2016年 yryz. All rights reserved.
//

#import "YRRetakePasswordController.h"
#import "YRMineWebController.h"

#import "YRYYCache.h"
#import "SPKitExample.h"
@interface YRRetakePasswordController ()<UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet UILabel *topTitleLabel;
@property (weak, nonatomic) IBOutlet UITextField *passwordTF;
@property (weak, nonatomic) IBOutlet UIButton *seeButton;
@property (weak, nonatomic) IBOutlet UIButton *finishButton;
@property (weak, nonatomic) IBOutlet UIButton *agreeButton;
@property (weak, nonatomic) IBOutlet UIButton *clauseButton;
@property (weak, nonatomic) IBOutlet UIButton *dealButton;

@property (weak, nonatomic) IBOutlet UIView *moreView;


@end

@implementation YRRetakePasswordController



- (void)viewDidLoad {
    [super viewDidLoad];
    
//    [self setTitle:@"重设密码"];
    self.passwordTF.delegate = self;
    self.passwordTF.returnKeyType = UIReturnKeyDone;
    self.agreeButton.selected = YES;
    if ([self.title isEqualToString:@"手机号注册"]) {
        self.topTitleLabel.text = @"你还没有注册悠然一指,现在开通:";
        self.moreView.hidden = NO;
//        self.moreView.backgroundColor = [UIColor redColor];
        [self.view addSubview:_moreView];
    }else{
        self.moreView.hidden = YES;
        self.topTitleLabel.text = @"重设密码后可用手机号登录："; 
    }
}

//密码可视
- (IBAction)seeButtonClick:(UIButton *)sender {
    sender.selected = !sender.selected;
    self.passwordTF.secureTextEntry = !sender.isSelected;
    if (kDevice_Is_iPhone5) {
        self.passwordTF.font = [UIFont systemFontOfSize:12];
    }else{
        self.passwordTF.font = [UIFont systemFontOfSize:14];
    }
}

//完成
- (IBAction)finishButtonClick:(UIButton *)sender {
    
    if (self.passwordTF.text.length<6) {
        [MBProgressHUD showError:@"密码不足6位" toView:self.view];
        return;
    }
    if ([self.passwordTF.text containsOnlyNumbers]) {
        [MBProgressHUD showError:@"密码不能全为数字" toView:self.view];
        return;
    }
    if ([self.passwordTF.text PureLetters:self.passwordTF.text]) {
        [MBProgressHUD showError:@"密码不能全为字母" toView:self.view];
        return;
    }
    if (![self.passwordTF.text isPassword]) {
        [MBProgressHUD showError:@"密码格式输入有误"];
        return;
    }
    if (!self.agreeButton.selected) {
         [MBProgressHUD showError:@"请同意用户服务协议"];
         return;
    }
    

    if([self.title isEqualToString:@"手机号注册"]){
         @weakify(self);
        [YRHttpRequest registerSendRequestByCustPhone:self.phoneTF password:self.passwordTF.text phoneCode:self.phoneCode regType:kCodeRegister success:^(NSDictionary *info) {
            @strongify(self);
            [MBProgressHUD hideHUDForView:self.view];
            
            if (info) {
                NSMutableDictionary *dic = [[NSMutableDictionary alloc]initWithDictionary:info];
                [dic setObject:@"4" forKey:@"loginType"];
                UserModel  *user = [UserModel mj_objectWithKeyValues:info];
                user.loginType = @"4";
                [[YRUserInfoManager manager]setCurrentUser:user];
                [[YRUserInfoManager manager] setPassword:self.passwordTF.text];
                [[YRYYCache share].yyCache setObject:dic forKey:user.custId];
                
                //应用登陆成功后，调用SDK
                [[SPKitExample sharedInstance] callThisAfterISVAccountLoginSuccessWithYWLoginId:@"visitor89"
                                                                                       passWord:@"taobao1234"
                                                                                preloginedBlock:^{
                                                                                    [self.navigationController popViewControllerAnimated:YES];
                                                                                } successBlock:^{
                                                                                    [self.navigationController popViewControllerAnimated:YES];
                                                                                } failedBlock:^(NSError *aError) {
                                                                                    if (aError.code == YWLoginErrorCodePasswordError || aError.code == YWLoginErrorCodePasswordInvalid || aError.code == YWLoginErrorCodeUserNotExsit) {
                                                                                    }
                                                                                }];
                
                [[NSNotificationCenter defaultCenter] postNotificationName:Login_Notification_Key object:self];
                [MBProgressHUD showSuccess:@"注册成功"];
                [self.navigationController popToRootViewControllerAnimated:YES];
            }
            
        } failure:^(NSString *errorInfo) {
            
            [MBProgressHUD hideHUDForView:self.view];
            DLog(@"errorInfo:%@",errorInfo);
            [MBProgressHUD showError:errorInfo toView:self.view];
            
        }];
    }
    else{
        
        [YRHttpRequest forgotPasswordRequestByPhoneNumber:self.phoneTF password:self.passwordTF.text phoneCode:self.phoneCode success:^(NSDictionary *data) {
                 [MBProgressHUD showSuccess:@"修改密码成功"];
            [self.navigationController popToRootViewControllerAnimated:YES];

        } failure:^(NSString *errorInfo) {
            
            [MBProgressHUD showSuccess:errorInfo];
        }];
    }
}

//同意
- (IBAction)agreeButtonClick:(UIButton *)sender {
    sender.selected = !sender.selected;
}

// 协议
- (IBAction)dealBtnClick {
    YRMineWebController *mineWeb = [[YRMineWebController alloc]init];
    mineWeb.title = @"用户服务协议";
    mineWeb.url = SERVICEAGREEMENT;
    [self.navigationController pushViewController:mineWeb animated:YES];
}

// 注册指南
- (IBAction)clauseBtnClick {
  
    
    
}


#pragma mark - UITextFieldDelegate
- (BOOL)textFieldShouldReturn:(UITextField *)theTextField {
    if (theTextField == self.passwordTF) {
        [theTextField resignFirstResponder];
        
    }
    return YES;
}

#pragma mark - textFieldDelegate
-(BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    
    if (textField == self.passwordTF) {
        if (string.length == 0) return YES;
        
        NSInteger existedLength = textField.text.length;
        NSInteger selectedLength = range.length;
        NSInteger replaceLength = string.length;
        if (existedLength - selectedLength + replaceLength > 18) {
            return NO;
        }
    }
    
    return YES;
}
-(void)viewWillLayoutSubviews{
    [super viewWillLayoutSubviews];
    if (kDevice_Is_iPhone5) {
        self.passwordTF.font = [UIFont systemFontOfSize:12];
    }else{
        self.passwordTF.font = [UIFont systemFontOfSize:14];
    }
    
}

@end
