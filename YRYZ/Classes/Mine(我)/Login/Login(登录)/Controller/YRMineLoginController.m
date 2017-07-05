//
//  YRMineLoginController.m
//  YRYZ
//
//  Created by Sean on 16/9/29.
//  Copyright © 2016年 yryz. All rights reserved.
//

#import "YRMineLoginController.h"
#import "YRRegisterController.h"
#import "YRForgotPasswordController.h"
#import "YRLoginButton.h"
#import "UMShareAndLogin.h"
#import "SPUtil.h"
#import "SPKitExample.h"
#import "YRYYCache.h"
#import "LWLoadingView.h"
#import "Reachability.h"

#import "UMSocial.h"



#import "WXApi.h"
#import <TencentOpenAPI/QQApiInterface.h>
#import "WeiboSDK.h"


static NSString *kSSToolKitAccountNameService = @"SSToolKitAccountNameService";
@interface YRMineLoginController ()<UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet UIView *loginView;
@property (weak, nonatomic) IBOutlet UITextField *phoneTF;
@property (weak, nonatomic) IBOutlet UITextField *passwordTF;
@property (weak, nonatomic) IBOutlet UIButton *loginButton;
@property (weak, nonatomic) IBOutlet UIButton *registerButton;
@property (weak, nonatomic) IBOutlet UIButton *forgotButton;
@property (weak, nonatomic) IBOutlet UILabel *fastLabel;  // 快速登录（第三方）
@property (weak, nonatomic) IBOutlet YRLoginButton *QQButton;
@property (weak, nonatomic) IBOutlet YRLoginButton *weChatButton;
@property (weak, nonatomic) IBOutlet YRLoginButton *sinaButton;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *constH;

@property (weak, nonatomic) IBOutlet UIView *thirdView;

@property (nonatomic,strong) UserModel          *user;
@end

@implementation YRMineLoginController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"登录";
    [self setupAllTextField];
    self.loginView.layer.cornerRadius = 4;
    self.loginView.layer.masksToBounds = YES;
    
    
//    self.phoneTF.keyboardType = UIKeyboardTypeNumberPad;
//    self.passwordTF.keyboardType = UIKeyboardTypeNamePhonePad;
    //    if (SCREEN_WIDTH == 320.f) {
    //        self.constH.constant = 40.f;
    //    }
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.phoneTF.text = [YYKeychain getPasswordForService:kSSToolKitAccountNameService account:kSSToolKitAccountNameService];
    
    if (![WXApi isWXAppInstalled]){
        self.weChatButton.hidden = YES;
    }
    
    if (![WeiboSDK isWeiboAppInstalled]){
        self.sinaButton.hidden = YES;
    }
  
    if (![QQApiInterface isQQInstalled]){
        self.QQButton.hidden = YES;
    }
    if (![WXApi isWXAppInstalled]&&![WeiboSDK isWeiboAppInstalled]&&![QQApiInterface isQQInstalled]) {
        self.thirdView.hidden = YES;
    }
    
    //增加监听，当键盘出现或改变时收出消息
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillShow:)
                                                 name:UIKeyboardWillShowNotification
                                               object:nil];
    
    //增加监听，当键退出时收出消息
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillHide:)
                                                 name:UIKeyboardWillHideNotification
                                               object:nil];
}
//当键盘出现或改变时调用
- (void)keyboardWillShow:(NSNotification *)aNotification
{
    //获取键盘的高度
    NSDictionary *userInfo = [aNotification userInfo];
    NSValue *aValue = [userInfo objectForKey:UIKeyboardFrameEndUserInfoKey];
    CGRect keyboardRect = [aValue CGRectValue];
    NSLog(@"监听键盘的高度：%f",keyboardRect.size.height);
}

//当键退出时调用
- (void)keyboardWillHide:(NSNotification *)aNotification
{
}
-(void)setupAllTextField{
    
    NSMutableDictionary *attributes = [NSMutableDictionary dictionary];
    // 设置富文本对象的颜色
    attributes[NSForegroundColorAttributeName] = RGB_COLOR(203, 203, 203);
    // 设置UITextField的占位文字
    self.phoneTF.attributedPlaceholder = [[NSAttributedString alloc] initWithString:NSLocalizedString(@"login.placeholder.phone", nil) attributes:attributes];
    self.phoneTF.tintColor = RGB_COLOR(203, 203, 203);
    self.phoneTF.delegate = self;
    self.phoneTF.returnKeyType = UIReturnKeyNext;
    self.passwordTF.attributedPlaceholder = [[NSAttributedString alloc] initWithString:NSLocalizedString(@"login.placeholder.password", nil) attributes:attributes];
    self.passwordTF.tintColor = RGB_COLOR(203, 203, 203);
    self.passwordTF.delegate = self;
    //    self.passwordTF.returnKeyType = UIReturnKeyDone;
    
    [self.loginButton setTitle:NSLocalizedString(@"login.button.login", nil) forState:UIControlStateNormal];
    [self.registerButton setTitle:NSLocalizedString(@"login.button.register", nil) forState:UIControlStateNormal];
    [self.forgotButton setTitle:NSLocalizedString(@"login.button.forgotPassword", nil) forState:UIControlStateNormal];
    self.fastLabel.text = NSLocalizedString(@"login.label.fastLogin", nil);
    //    [self.QQButton setTitle:NSLocalizedString(@"login.button.QQ", nil) forState:UIControlStateNormal];
    //    [self.weChatButton setTitle:NSLocalizedString(@"login.button.weChat", nil) forState:UIControlStateNormal];
    //    [self.sinaButton setTitle:NSLocalizedString(@"login.button.sina", nil) forState:UIControlStateNormal];
}

/**
 *  @author weishibo, 16-07-11 14:07:31
 *
 *  登录
 *
 *  @param sender <#sender description#>
 */
- (IBAction)loginButtonClick:(UIButton *)sender {
    [self.passwordTF resignFirstResponder];
    [self.phoneTF resignFirstResponder];
    [self.view endEditing:YES];
    [self.phoneTF endEditing:YES];
    [self.passwordTF endEditing:YES];
    
    [YYKeychain setPassword:self.phoneTF.text forService:kSSToolKitAccountNameService account:kSSToolKitAccountNameService];
    if (self.passwordTF.text.length==0) {
        [MBProgressHUD showSuccess:@"请输入密码"];
        return;
    }
    
    [MBProgressHUD showMessage:@""];
    [YRHttpRequest loginSendRequestByAccout:self.phoneTF.text password:self.passwordTF.text success:^(NSDictionary *info) {
        [MBProgressHUD hideHUD];
        [self thirdLoginSuccessful:info withLoginType:@"4"];
    }failure:^(NSString *errorInfo) {
        [MBProgressHUD hideHUD];
        [MBProgressHUD showError:errorInfo];
    }];
}

- (IBAction)registerButtonClick:(UIButton *)sender {
    YRRegisterController *registerVC = [[YRRegisterController alloc]init];
    registerVC.title = @"注册";
    [self.navigationController pushViewController:registerVC animated:YES];
}


- (IBAction)forgetPasswordButtonClick:(UIButton *)sender {
    YRForgotPasswordController *forgotController = [[YRForgotPasswordController alloc]init];
    [self.navigationController pushViewController:forgotController animated:YES];
}
- (IBAction)QQButtonClick:(UIButton *)sender {
    
    
    [UMShareAndLogin UMLoginWithQQDataSourseWithController:self SuccessHandler:^(BOOL isSuccess, id result) {
        
        UMSocialAccountEntity *snsAccount = [[UMSocialAccountManager socialAccountDictionary] valueForKey:UMShareToQQ];
        NSString *openId = snsAccount.openId;
        NSString *accessToken = snsAccount.accessToken;
        
        [YRHttpRequest ThirdPartyLoginByThirdName:@"QQ" openId:openId  accessToken:(NSString *)accessToken  success:^(NSDictionary *data) {
            
            [self thirdLoginSuccessful:data withLoginType:@"3"];
            
        } failure:^(NSString *errorInfo) {
            
            [MBProgressHUD showError:errorInfo];
        }];
        
        
    }];
}


- (IBAction)weChatButtonClick:(UIButton *)sender {
    [UMShareAndLogin UMLoginWithWeChatDataSourseWithController:self SuccessHandler:^(BOOL isSuccess, id result) {
        
        UMSocialAccountEntity *snsAccount = [[UMSocialAccountManager socialAccountDictionary] valueForKey:UMShareToWechatSession];
        NSString *openId = snsAccount.openId;
        NSString *accessToken = snsAccount.accessToken;
        
        [YRHttpRequest ThirdPartyLoginByThirdName:@"WeChat" openId:openId  accessToken:(NSString *)accessToken   success:^(NSDictionary *data) {
            
            [self thirdLoginSuccessful:data withLoginType:@"1"];
            
        } failure:^(NSString *errorInfo) {
            [MBProgressHUD showError:errorInfo];
        }];
        
    }];
}


- (IBAction)sinaButtonClick:(UIButton *)sender {
    [UMShareAndLogin UMLoginWithWebDataSourseWithController:self SuccessHandler:^(BOOL isSuccess, id result) {
        
        UMSocialAccountEntity *snsAccount = [[UMSocialAccountManager socialAccountDictionary] valueForKey:UMShareToSina];
        NSString *openId = snsAccount.usid;
        NSString *accessToken = snsAccount.accessToken;
        
        [YRHttpRequest ThirdPartyLoginByThirdName:@"Sina" openId:openId  accessToken:(NSString *)accessToken  success:^(NSDictionary *data) {
            
            [self thirdLoginSuccessful:data withLoginType:@"2"];
            
        } failure:^(NSString *errorInfo) {
            [MBProgressHUD showError:errorInfo];
        }];
    }];
}

- (void)thirdLoginSuccessful:(NSDictionary *)info withLoginType:(NSString *)type{
    
    if (info) {
        NSMutableDictionary *dic = [[NSMutableDictionary alloc]initWithDictionary:info];
        [dic setObject:type forKey:@"loginType"];
        self.user = [UserModel mj_objectWithKeyValues:dic];
        
        if ([YRUserInfoManager manager].lastUuid) {
            if (![self.user.custId isEqualToString:[YRUserInfoManager manager].lastUuid]) {
                
                [[YRYYCache share].yyCache removeObjectForKey:@"MsgMyFriendsShow_Notification_Key"];
                [[YRYYCache share].yyCache removeObjectForKey:@"MsgMyShow_Notification_Key"];
                
                [[YRYYCache share].yyCache removeObjectForKey:@"YRCircleViewController0"];
                [[YRYYCache share].yyCache removeObjectForKey:@"YRCircleViewController1"];
                [[YRYYCache share].yyCache removeObjectForKey:@"YRCircleViewController2"];
                
                [[YRYYCache share].yyCache removeObjectForKey:@"myFocusOnModel"];
                [[YRYYCache share].yyCache removeObjectForKey:@"myFriendModel"];
                [[YRUserInfoManager manager] removeLastUid];
            }
        }
        
        
        [[YRUserInfoManager manager]setCurrentUser:self.user];
        [[YRYYCache share].yyCache setObject:dic forKey:self.user.custId];
        
        [[SPKitExample sharedInstance] callThisAfterISVAccountLoginSuccessWithYWLoginId:self.user.custId passWord:self.user.custId preloginedBlock:^{
            
        } successBlock:^{
//            [MBProgressHUD showError:@"登录成功"];
        } failedBlock:^(NSError *error) {
            
        }];
        
        [[NSNotificationCenter defaultCenter] postNotificationName:Login_Notification_Key object:self];
        
        
        [[YRUserInfoManager manager] setPassword:self.passwordTF.text];
//        NSSet *set = [NSSet setWithObjects:@"yryz_lottery_open", nil];
//        [JPUSHService setTags:set alias:self.user.custId fetchCompletionHandle:^(int iResCode, NSSet *iTags, NSString *iAlias){
//            DLog(@"rescode: %d, \ntags: %@, \nalias: %@\n", iResCode, iTags, iAlias);
//        }];
        if (self.isLogin) {
            [MBProgressHUD hideHUD];
            [self dismissViewControllerAnimated:YES completion:nil];
        }
        else{
            [MBProgressHUD hideHUD];
            [self.navigationController popViewControllerAnimated:YES];
        }
        if (self.loginSuccessDelegate && [self.loginSuccessDelegate  respondsToSelector:@selector(loginSuccessDelegate:)]) {
            [self.loginSuccessDelegate loginSuccessDelegate:self.user];
        }
        
        
    }
}


//- (void)leftNavAction:(UIButton *)button{
//
//
//    if (self.loginSuccessDelegate && [self.loginSuccessDelegate  respondsToSelector:@selector(loginSuccessDelegate:)]) {
//        [self.loginSuccessDelegate loginSuccessDelegate:self.user];
//    }
//
//    [self.navigationController popViewControllerAnimated:YES];
//}

#pragma mark - UITextFieldDelegate
- (BOOL)textFieldShouldReturn:(UITextField *)theTextField {
    if (theTextField == self.phoneTF) {
        [theTextField resignFirstResponder];
        [self.passwordTF becomeFirstResponder];
    }else{
        [self.passwordTF resignFirstResponder];
        //调登录
        [self loginButtonClick:nil];
    }
    return YES;
}

#pragma mark - textFieldDelegate
-(BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    
    if (textField == self.phoneTF) {
        if (string.length == 0) return YES;
        
        NSInteger existedLength = textField.text.length;
        NSInteger selectedLength = range.length;
        NSInteger replaceLength = string.length;
        if (existedLength - selectedLength + replaceLength > 11) {
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

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [self.view endEditing:YES];
}

@end
