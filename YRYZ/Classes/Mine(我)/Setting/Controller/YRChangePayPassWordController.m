//
//  YRChangePayPassWordController.m
//  YRYZ
//
//  Created by Sean on 16/8/17.
//  Copyright © 2016年 yryz. All rights reserved.
//

#import "YRChangePayPassWordController.h"

@interface YRChangePayPassWordController ()

@property (weak, nonatomic) IBOutlet YRPassWordView *textFiel1;

@property (weak, nonatomic) IBOutlet YRPassWordView *textFile2;

@property (weak, nonatomic) IBOutlet YRPassWordView *textFile3;

@property (weak, nonatomic) IBOutlet UILabel *title1;

@property (weak, nonatomic) IBOutlet UILabel *title2;

@property (weak, nonatomic) IBOutlet UILabel *title3;

@property (weak, nonatomic) IBOutlet UILabel *successLabel;
@property (weak, nonatomic) IBOutlet UILabel *line3;
@property (weak, nonatomic) IBOutlet UIButton *sureBtn;

@end

@implementation YRChangePayPassWordController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
//    YRAlertView *alertView = [[YRAlertView alloc] initWithTitle:@"保存相册失败" cancelButtonText:@"确定"];
    
    self.successLabel.hidden = YES;
    self.sureBtn.layer.cornerRadius = 20;
    self.sureBtn.clipsToBounds = YES;
    
//    [self loadFromXib:self.view];

    
    self.textFiel1.elementCount = 6;
    self.textFile2.elementCount = 6;
    self.textFile3.elementCount = 6;
    
    self.textFiel1.elementColor = RGB_COLOR(198, 198, 198);
    self.textFile2.elementColor = RGB_COLOR(198, 198, 198);
    self.textFile3.elementColor = RGB_COLOR(198, 198, 198);
    
    __weak typeof(self) weakSelf = self;

    if ([self.title isEqualToString:@"修改支付密码"]) {
        
        [self.textFiel1.textField becomeFirstResponder];
        self.textFiel1.passwordBlock = ^(NSString *password) {
            DLog(@"%@",password);
            if (password.length==6&&weakSelf.textFile2.textField.text.length<6) {
                [weakSelf.textFile2.textField becomeFirstResponder];
            }
            
        };
        self.textFile2.passwordBlock = ^(NSString *password) {
            DLog(@"%@",password);
            if (password.length ==6&&weakSelf.textFile3.textField.text.length<6) {
                [weakSelf.textFile3.textField becomeFirstResponder];
            }
            
        };
        self.textFile3.passwordBlock = ^(NSString *password) {
            DLog(@"%@",password);
            if (password.length ==6) {
                [weakSelf.view endEditing:YES];
                
            }
        };
        
    }else{
                [self.textFiel1.textField becomeFirstResponder];
                self.textFiel1.passwordBlock = ^(NSString *password) {
                    DLog(@"%@",password);
                    if (password.length==6&&weakSelf.textFile2.textField.text.length<6) {
                        [weakSelf.textFile2.textField becomeFirstResponder];
                    }
                    
                };
                self.textFile2.passwordBlock = ^(NSString *password) {
                    DLog(@"%@",password);
                    if (password.length ==6&&weakSelf.textFile3.textField.text.length<6) {
                         [weakSelf.view endEditing:YES];
                    }
                };
        
            self.title1.text = @"输入密码";
            self.title2.text = @"确认密码";
            self.textFile3.hidden = YES;
            self.title3.hidden = YES;
            self.line3.hidden = YES;
    }

}

- (IBAction)sureBtnClick:(UIButton *)sender {
   
    if ([self.title isEqualToString:@"修改支付密码"]) {
        if (self.textFiel1.textField.text.length!=6||self.textFile2.textField.text.length!=6||self.textFile3.textField.text.length!=6) {
            [self labelShowWithIsSuccess:@"0" withError:@"请输入完整密码"];
            return;
        }
        if (![self.textFile2.textField.text isEqualToString:self.textFile3.textField.text]) {
            [self labelShowWithIsSuccess:@"0" withError:@"两次密码输入不一致"];
            return;
        }
           [MBProgressHUD showMessage:@""];
        [YRHttpRequest changeThePayPassword:self.textFiel1.textField.text newPayPassword:self.textFile2.textField.text success:^(NSDictionary *data) {
            [self labelShowWithIsSuccess:@"1" withError:nil];
            [MBProgressHUD hideHUD];
             DLog(@"修改密码成功");
            
        } failure:^(NSString *errorInfo) {
             [MBProgressHUD hideHUD];
             [self labelShowWithIsSuccess:@"0" withError:errorInfo];
        }];
        
        
    }else{
        
        if (self.textFiel1.textField.text.length!=6||self.textFile2.textField.text.length!=6) {
            [self labelShowWithIsSuccess:@"0" withError:@"请输入完整密码"];
            return;
        }
        
        if (![self.textFiel1.textField.text isEqualToString:self.textFile2.textField.text]) {
            [self labelShowWithIsSuccess:@"0" withError:@"两次密码输入不一致"];
            return;
        }
        [MBProgressHUD showMessage:@""];
        [YRHttpRequest changeThePayPassword:@"" newPayPassword:self.textFiel1.textField.text success:^(NSDictionary *data) {
            DLog(@"%@",data);
            [self labelShowWithIsSuccess:@"2" withError:nil];
              [MBProgressHUD hideHUD];
 
        } failure:^(NSString *errorInfo) {
            
             [self labelShowWithIsSuccess:@"0" withError:errorInfo];
             [MBProgressHUD hideHUD];
        }];
        
    }
    
}

- (void)labelShowWithIsSuccess:(NSString *)isSuccess withError:(NSString *)error{
    if ([isSuccess integerValue]) {
        self.successLabel.text =  [self.title isEqualToString:@"修改支付密码"]?@"修改支付密码成功":@"设置支付密码成功";
        self.successLabel.hidden = NO;
    }else{
        self.successLabel.text = error;
        self.successLabel.hidden = NO;
    }
       [self performSelector:@selector(backSelector:) withObject:isSuccess afterDelay:1];
}
- (void)backSelector:(NSString *)isSuccess{
    
    if ([isSuccess integerValue]==1) {
        dispatch_async(dispatch_get_main_queue(), ^{
             [self.navigationController popViewControllerAnimated:YES];
        });
    }else if ([isSuccess integerValue]==2){
        YRAlertView *arlt = [[YRAlertView alloc]initWithPay:@"支付密码设置成功" cancelButtonTexts:@"开启小额免密支付功能"];
        arlt.addCancelAction = ^{
            [MBProgressHUD showMessage:@""];
            [YRHttpRequest setSmallFreeByType:YES success:^(NSDictionary *data) {
                DLog(@"设置小额免密成功,%@",data);
                [MBProgressHUD hideHUD];
                [self.navigationController popViewControllerAnimated:YES];
            } failure:^(NSString *error) {
                  [MBProgressHUD hideHUD];
            }];
        };
        arlt.addConfirmAction = ^{
            [self.navigationController popViewControllerAnimated:YES];
        };
        [arlt show];
    }
    else{
        self.successLabel.hidden = YES;
    }
 
}



-(void)viewDidLayoutSubviews{
    [super viewDidLayoutSubviews];
    
    if (kDevice_Is_iPhone5) {
        CGFloat autoSizeScaleX, autoSizeScaleY;
        
        autoSizeScaleX = SCREEN_POINT;
        autoSizeScaleY = SCREEN_H_POINT;
        
        
        for (UIView *temp in self.view.subviews) {
            if ([temp isKindOfClass:[YRPassWordView class]]) {
                CGRect rect;
                
                rect.origin.x = temp.frame.origin.x / autoSizeScaleX +20 ;
                
                rect.origin.y = temp.frame.origin.y +3;
                
                rect.size.width = temp.frame.size.width * autoSizeScaleX;
                
                rect.size.height = temp.frame.size.height * autoSizeScaleY;
                
                temp.frame = rect;
            }

        }
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
