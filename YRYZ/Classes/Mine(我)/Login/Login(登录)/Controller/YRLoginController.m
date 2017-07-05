//
//  YRLoginController.m
//  Rrz
//
//  Created by 易超 on 16/7/4.
//  Copyright © 2016年 rongzhongwang. All rights reserved.
//

#import "YRLoginController.h"
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


@interface YRLoginController ()<UITextFieldDelegate>

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

@implementation YRLoginController
- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [[SPKitExample sharedInstance] exampleGetFeedbackUnreadCount:YES inViewController:self];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"登录";
    [self setupAllTextField];
    self.loginView.layer.cornerRadius = 4;
    self.loginView.layer.masksToBounds = YES;
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
    self.QQButton.hidden = YES;
    if (![QQApiInterface isQQInstalled]){
        self.QQButton.hidden = YES;
    }
    if (![WXApi isWXAppInstalled]&&![WeiboSDK isWeiboAppInstalled]&&![QQApiInterface isQQInstalled]) {
        self.thirdView.hidden = YES;
    }
    
}

-(void)setupAllTextField{
    
    NSMutableDictionary *attributes = [NSMutableDictionary dictionary];
    // 设置富文本对象的颜色
    attributes[NSForegroundColorAttributeName] = RGB_COLOR(203, 203, 203);
    // 设置UITextField的占位文字
    self.phoneTF.attributedPlaceholder = [[NSAttributedString alloc] initWithString:NSLocalizedString(@"login.placeholder.phone", nil) attributes:attributes];
    self.phoneTF.delegate = self;
    self.phoneTF.returnKeyType = UIReturnKeyNext;
    self.passwordTF.attributedPlaceholder = [[NSAttributedString alloc] initWithString:NSLocalizedString(@"login.placeholder.password", nil) attributes:attributes];
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
    if (self.phoneTF.text.length==0) {
        [MBProgressHUD showError:@"请输入手机号"];
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
         [MBProgressHUD showMessage:@""];
        [YRHttpRequest ThirdPartyLoginByThirdName:@"QQ" openId:openId  accessToken:(NSString *)accessToken  success:^(NSDictionary *data) {
            
            [self thirdLoginSuccessful:data withLoginType:@"3"];
            
        } failure:^(NSString *errorInfo) {
            [MBProgressHUD hideHUD];
            [MBProgressHUD showError:errorInfo];
            
        }];
    }];
}

- (IBAction)weChatButtonClick:(UIButton *)sender {
    [UMShareAndLogin UMLoginWithWeChatDataSourseWithController:self SuccessHandler:^(BOOL isSuccess, id result) {
        
        UMSocialAccountEntity *snsAccount = [[UMSocialAccountManager socialAccountDictionary] valueForKey:UMShareToWechatSession];
        NSString *openId = snsAccount.openId;
        NSString *accessToken = snsAccount.accessToken;
         [MBProgressHUD showMessage:@""];
        [YRHttpRequest ThirdPartyLoginByThirdName:@"WeChat" openId:openId  accessToken:(NSString *)accessToken   success:^(NSDictionary *data) {
            
            [self thirdLoginSuccessful:data withLoginType:@"1"];
            
        } failure:^(NSString *errorInfo) {
            [MBProgressHUD hideHUD];
            [MBProgressHUD showError:errorInfo];
        }];
        
    }];
}
- (IBAction)sinaButtonClick:(UIButton *)sender {
    [UMShareAndLogin UMLoginWithWebDataSourseWithController:self SuccessHandler:^(BOOL isSuccess, id result) {
        
        UMSocialAccountEntity *snsAccount = [[UMSocialAccountManager socialAccountDictionary] valueForKey:UMShareToSina];
        NSString *openId = snsAccount.usid;
        NSString *accessToken = snsAccount.accessToken;
         [MBProgressHUD showMessage:@""];
        [YRHttpRequest ThirdPartyLoginByThirdName:@"Sina" openId:openId  accessToken:(NSString *)accessToken  success:^(NSDictionary *data) {
            
            [self thirdLoginSuccessful:data withLoginType:@"2"];
            
        } failure:^(NSString *errorInfo) {
            [MBProgressHUD hideHUD];
            [MBProgressHUD showError:errorInfo];
        }];
    }];
}

- (void)thirdLoginSuccessful:(NSDictionary *)info withLoginType:(NSString *)type{
  
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"logOut"];
    
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
                [[YRYYCache share].yyCache removeObjectForKey:@"YRSunTextViewController"];

                [[YRYYCache share].yyCache removeObjectForKey:@"myFocusOnModel"];
                [[YRYYCache share].yyCache removeObjectForKey:@"myFriendModel"];
                [[YRYYCache share].yyCache removeObjectForKey:@"userMoney"];
                [[YRYYCache share].yyCache removeObjectForKey:@"accountReward"];
                
                [[YRUserInfoManager manager] removeLastUid];
                [[YRYYCache share].yyCache removeObjectForKey:MsgFollow_Notification_Key];
            }
        }
        
        [[YRUserInfoManager manager]setCurrentUser:self.user];
        [[YRYYCache share].yyCache setObject:dic forKey:self.user.custId];
        
        [[NSNotificationCenter defaultCenter] postNotificationName:@"changeCircleData" object:nil];
        
        [[SPKitExample sharedInstance] callThisAfterISVAccountLoginSuccessWithYWLoginId:self.user.custId passWord:self.user.custId preloginedBlock:^{
            [[SPUtil sharedInstance] setWaitingIndicatorShown:NO withKey:self.description];
        } successBlock:^{
            [[SPUtil sharedInstance] setWaitingIndicatorShown:NO withKey:self.description];
//            [MBProgressHUD showError:@"登录成功"];
        } failedBlock:^(NSError *error) {
            
        }];

        [[NSNotificationCenter defaultCenter] postNotificationName:Login_Notification_Key object:self];
        
        [[YRUserInfoManager manager] setPassword:self.passwordTF.text];
        
        NSSet *set = [NSSet setWithObjects:@"yryz_lottery_open", nil];
        [JPUSHService setTags:set alias:self.user.custId fetchCompletionHandle:^(int iResCode, NSSet *iTags, NSString *iAlias){
            DLog(@"rescode: %d, \ntags: %@, \nalias: %@\n", iResCode, iTags, iAlias);
        }];
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

//-(void)viewWillAppear:(BOOL)animated{
//    [super viewWillAppear:animated];
//    
//}
-(void)viewWillLayoutSubviews{
    [super viewWillLayoutSubviews];
    CGFloat marginWith = (self.thirdView.frame.size.width - 90)/3;
    self.sinaButton.bounds = CGRectMake(0, 0, 45, 45);
    self.weChatButton.bounds = CGRectMake(0, 0, 45, 45);
    self.sinaButton.centerY = self.thirdView.frame.size.height/2;
    self.weChatButton.centerY = self.thirdView.frame.size.height/2;
    self.sinaButton.centerX = marginWith +22.5;
    self.weChatButton.centerX = marginWith*2+45+22.5;
    if (![WXApi isWXAppInstalled]){
        self.weChatButton.hidden = YES;
        self.sinaButton.centerX = marginWith*2 +45 +22.5;
    }
    
    if (![WeiboSDK isWeiboAppInstalled]){
        self.sinaButton.hidden = YES;
        self.weChatButton.centerX = self.thirdView.frame.size.width/2;
    }

    if (![WXApi isWXAppInstalled]&&![WeiboSDK isWeiboAppInstalled]) {
        self.thirdView.hidden = YES;
    }
}
- (void)viewDidLayoutSubviews{
    [super viewDidLayoutSubviews];
 

}

@end









