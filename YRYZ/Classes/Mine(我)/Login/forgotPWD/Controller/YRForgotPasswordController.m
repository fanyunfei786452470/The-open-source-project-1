//
//  YRForgotPasswordController.m
//  YRYZ
//
//  Created by 易超 on 16/7/12.
//  Copyright © 2016年 yryz. All rights reserved.
//

#import "YRForgotPasswordController.h"
#import "YRRetakePasswordController.h"
#import "CountDownTool.h"

@interface YRForgotPasswordController ()<UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet UITextField    *phoneTF;
@property (weak, nonatomic) IBOutlet UITextField    *checkingTF;
@property (weak, nonatomic) IBOutlet UIButton       *sendButton;
@property (weak, nonatomic) IBOutlet UIButton       *nextButton;
@property (nonatomic, strong)dispatch_source_t      timer;

@property (nonatomic,assign) BOOL isRegister;
@property (nonatomic,copy) NSString *VerificationCode;

@end

@implementation YRForgotPasswordController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.sendButton.layer.cornerRadius = 20;
    self.sendButton.clipsToBounds = YES;
    [self setTitle:@"忘记密码"];
    [self setupAllTextField];

    CountDownTool *countDownTool = [CountDownTool shareCountDownTool];
    if (countDownTool.timer!=0) {
        NSString *time = [NSString stringWithFormat:@"%ld",countDownTool.timer];
        [countDownTool startTime:time timer:self.timer sender:self.sendButton];
        self.sendButton.userInteractionEnabled = NO;
        self.sendButton.backgroundColor = [UIColor grayColor];
    }
}

-(void)setupAllTextField{
    self.phoneTF.delegate = self;
    self.phoneTF.returnKeyType = UIReturnKeyNext;
    
    self.checkingTF.delegate = self;
    self.checkingTF.returnKeyType = UIReturnKeyDone;
}

- (IBAction)sendButtonClick:(UIButton *)sender {
    [self.view endEditing:YES];
    if (![self.phoneTF.text isMobileNumber]) {
        [MBProgressHUD showError:@"手机号输入有误"];
        return;
    };
    sender.userInteractionEnabled = NO;
    @weakify(self);
    [self.checkingTF becomeFirstResponder];
//    [YRHttpRequest getRegisterCheckingByCustPhone:self.phoneTF.text codeType:nil success:^(NSDictionary *data) {
//        @strongify(self);
//        DLog(@"%@",data);
//        
//        self.VerificationCode = data[@"veriCode"];
//        
//        self.checkingTF.text = data[@"veriCode"];
//        
//    } failure:^(NSString *errorInfo) {
//        
//        [MBProgressHUD showError:errorInfo];
//
//    }];
    
    [YRHttpRequest whetherToChangeThePassword:self.phoneTF.text success:^(NSDictionary *data) {
        @strongify(self);
        if ([data[@"code"] integerValue]==1){
            self.isRegister = YES;
        }
//        self.VerificationCode = data[@"veriCode"];
        
//        self.checkingTF.text = data[@"veriCode"];

        
    } failure:^(NSString *errorInfo) {
        [MBProgressHUD showError:errorInfo];
        
    }];
    
    CountDownTool *countDownTool = [CountDownTool shareCountDownTool];
    if (countDownTool.timer==0) {
//        NSString *time = [NSString stringWithFormat:@"%ld",countDownTool.timer];
        [countDownTool startTime:@"90" timer:self.timer sender:self.sendButton];
         self.sendButton.backgroundColor = [UIColor grayColor];
    }
    

    
}

- (IBAction)nextButtonClick {
    
    [self.view endEditing:YES];
    
    if (![self.phoneTF.text isMobileNumber]) {
        [MBProgressHUD showError:@"手机号输入有误" toView:self.view];
        return;
    };
    if (self.checkingTF.text.length != 4) {
        [MBProgressHUD showError:@"验证码长度不正确" toView:self.view];
        return;
    };
//    if ([self.checkingTF.text isEqualToString:self.VerificationCode]) {
    
        if (self.isRegister) {
            YRRetakePasswordController *retakeController = [[YRRetakePasswordController alloc]init];
            retakeController.title = @"手机号注册";
            retakeController.phoneTF = self.phoneTF.text;
            retakeController.phoneCode = self.checkingTF.text;
            [self.navigationController pushViewController:retakeController animated:YES];
            
        }else{
            YRRetakePasswordController *retakeController = [[YRRetakePasswordController alloc]init];
            retakeController.title = @"重设密码";
             retakeController.phoneTF = self.phoneTF.text;
            retakeController.phoneCode = self.checkingTF.text;
             [self.navigationController pushViewController:retakeController animated:YES];
        }
//    }
//else{
//          [MBProgressHUD showError:@"验证码错误" toView:self.view];
//        
//    }

}


#pragma mark - UITextFieldDelegate
- (BOOL)textFieldShouldReturn:(UITextField *)theTextField {
    if (theTextField == self.phoneTF) {
        [theTextField resignFirstResponder];
        [self.checkingTF becomeFirstResponder];
    }else{
        [self.checkingTF resignFirstResponder];
        //调next
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
    
    if (textField == self.checkingTF) {
        if (string.length == 0) return YES;
        
        NSInteger existedLength = textField.text.length;
        NSInteger selectedLength = range.length;
        NSInteger replaceLength = string.length;
        if (existedLength - selectedLength + replaceLength > 6) {
            return NO;
        }
    }
    
    return YES;
}

@end
