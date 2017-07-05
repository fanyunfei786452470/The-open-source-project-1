//
//  YRRegisterController.m
//  Rrz
//
//  Created by 易超 on 16/7/4.
//  Copyright © 2016年 rongzhongwang. All rights reserved.
//

#import "YRRegisterController.h"
#import "CountDownTool.h"
#import "AFHTTPSessionManager.h"

#import "YRYYCache.h"

#import "SPKitExample.h"
#import "YRMineWebController.h"
@interface YRRegisterController ()<UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet UITextField *phoneTf;

@property (weak, nonatomic) IBOutlet UITextField *checkingTF;

@property (weak, nonatomic) IBOutlet UITextField *passwordTF;
// 协议View
@property (weak, nonatomic) IBOutlet UIView      *dealView;

@property (nonatomic, strong)dispatch_source_t   timer;

@property (weak, nonatomic) IBOutlet UIButton *argeeBtn;

@property (weak, nonatomic) IBOutlet UIButton *sendCodeBtn;

@end

@implementation YRRegisterController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.sendCodeBtn.layer.cornerRadius = 20;
    self.sendCodeBtn.clipsToBounds = YES;
    CountDownTool *countDownTool = [CountDownTool shareCountDownTool];
    
    
    if (countDownTool.timer!=0) {
        NSString *time = [NSString stringWithFormat:@"%ld",(long)countDownTool.timer];
        [countDownTool startTime:time timer:self.timer sender:self.sendCodeBtn];
        self.sendCodeBtn.userInteractionEnabled = NO;
        self.sendCodeBtn.backgroundColor = [UIColor grayColor];
    }
    self.argeeBtn.selected = YES;
//    [self setTitle:@"注册"];
    [self setupAllTextField];
    if ([self.title isEqualToString:@"绑定手机号"]) {
        self.dealView.hidden = YES;
    }
    
  

    
}


-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [self.view endEditing:YES];
}

-(void)setupAllTextField{
    self.phoneTf.delegate = self;
    self.phoneTf.returnKeyType = UIReturnKeyNext;
    
    self.checkingTF.delegate = self;
    self.checkingTF.returnKeyType = UIReturnKeyNext;
    
    self.passwordTF.delegate = self;
    self.passwordTF.returnKeyType = UIReturnKeyDone;
}

//发送验证码
- (IBAction)sendButtonClick:(UIButton *)sender {
    [self.view endEditing:YES];
    if (![self.phoneTf.text isMobileNumber]) {
        [MBProgressHUD showError:@"手机号输入有误"];
        return;
    };
    sender.userInteractionEnabled = NO;

    CountDownTool *countDownTool = [CountDownTool shareCountDownTool];
    if (countDownTool.timer==0) {
        [countDownTool startTime:@"90" timer:self.timer sender:sender];
         self.sendCodeBtn.backgroundColor = [UIColor grayColor];
    }
    [self.checkingTF becomeFirstResponder];
    
    @weakify(self);
    if ([self.title isEqualToString:@"注册"]) {
        [YRHttpRequest getRegisterCheckingByCustPhone:self.phoneTf.text  codeType:(AuthCodeType)kAuthCodeRegister  success:^(NSDictionary *info) {
            
//            DLog(@"info:%@",info);
//            @strongify(self);
            
        }failure:^(NSString *errorInfo) {
            [MBProgressHUD showError:errorInfo toView:self.view];
            
        }];
    }else{
        [YRHttpRequest getRegisterCheckingByCustPhone:self.phoneTf.text  codeType:(AuthCodeType)kAuthReplacePhone  success:^(NSDictionary *info) {
            
            DLog(@"info:%@",info);
            @strongify(self);
            
            self.checkingTF.text = info[@"veriCode"];
            
        }failure:^(NSString *errorInfo) {
            [MBProgressHUD showError:errorInfo toView:self.view];
            
        }];
    }
   

}

//密码可视
- (IBAction)seeButtonClick:(UIButton *)sender {
    sender.selected = !sender.selected;
    self.passwordTF.secureTextEntry = !sender.isSelected;
}

//完成
- (IBAction)finishButtonClick:(UIButton *)sender {
    
    [self.view endEditing:YES];
    
    if (![self.phoneTf.text isMobileNumber]) {
        [MBProgressHUD showError:@"手机号输入有误" toView:self.view];
        return;
    };
    if (self.checkingTF.text.length != 4) {
        [MBProgressHUD showError:@"验证码长度不正确" toView:self.view];
        return;
    };
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
        [MBProgressHUD showError:@"密码格式输入有误" toView:self.view];
        return;
    }
    if (!self.argeeBtn.selected) {
        [MBProgressHUD showError:@"请同意用户服务协议" toView:self.view];
        return;
    }
    @weakify(self);
    if ([self.title isEqualToString:@"注册"]) {
        NSString *passwordStr = self.passwordTF.text;
        [MBProgressHUD showMessage:NSLocalizedString(@"public.hud.loding", nil) toView:self.view];
        [YRHttpRequest registerSendRequestByCustPhone:self.phoneTf.text password:passwordStr phoneCode:self.checkingTF.text regType:kCodeRegister success:^(NSDictionary *info) {
            
            @strongify(self);
            [MBProgressHUD hideHUDForView:self.view];
            
            if (info) {
                NSMutableDictionary *dic = [[NSMutableDictionary alloc]initWithDictionary:info];
                [dic setObject:@"4" forKey:@"loginType"];
                UserModel  *user = [UserModel mj_objectWithKeyValues:dic];
                [[YRUserInfoManager manager]setCurrentUser:user];
                [[YRUserInfoManager manager] setPassword:passwordStr];
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
    }else{
        NSString *passwordStr = self.passwordTF.text;
    [YRHttpRequest bindOtherAccountByThePhone:self.phoneTf.text veriCode:self.checkingTF.text  password:(NSString *)passwordStr  success:^(NSDictionary *dic){
           [MBProgressHUD showError:@"绑定成功"];
         [self.navigationController popViewControllerAnimated:YES];
       } failure:^(NSString *error) {
           [MBProgressHUD showError:error];
       }];
    }
    
}

//同意
- (IBAction)agreeButtonClick:(UIButton *)sender {
    sender.selected = !sender.selected;
}

// 协议
- (IBAction)dealBtnClick {
   
}




// 注册指南
- (IBAction)clauseBtnClick {
    YRMineWebController *mineWeb = [[YRMineWebController alloc]init];
    mineWeb.titletext = @"用户服务协议";
    mineWeb.url = SERVICEAGREEMENT;
    [self.navigationController pushViewController:mineWeb animated:YES];
}


#pragma mark - UITextFieldDelegate
- (BOOL)textFieldShouldReturn:(UITextField *)theTextField {
    if (theTextField == self.phoneTf) {
        [theTextField resignFirstResponder];
        [self.checkingTF becomeFirstResponder];
    }else if (theTextField == self.checkingTF){
        [theTextField resignFirstResponder];
        [self.passwordTF becomeFirstResponder];
    }else{
        [self.passwordTF resignFirstResponder];
        //调注册
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
#pragma mark - textFieldDelegate
-(BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    
    if (textField == self.phoneTf) {
        if (string.length == 0) return YES;
        
        NSInteger existedLength = textField.text.length;
        NSInteger selectedLength = range.length;
        NSInteger replaceLength = string.length;
        if (existedLength - selectedLength + replaceLength > 11) {
            return NO;
        }
    }
    
    if (textField == self.checkingTF) {
        if (string.length == 0) return YES;
        
        NSInteger existedLength = textField.text.length;
        NSInteger selectedLength = range.length;
        NSInteger replaceLength = string.length;
        if (existedLength - selectedLength + replaceLength > 6) {
            return NO;
        }
    }
    
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

@end
