//
//  YRMsgReportViewController.m
//  YRYZ
//
//  Created by Mrs_zhang on 16/7/13.
//  Copyright © 2016年 yryz. All rights reserved.
//  消息-->举报

#import "YRMsgReportViewController.h"
#import "YRReportTextView.h"
@interface YRMsgReportViewController ()

@property (nonatomic,weak) YRReportTextView *textView;

@end

@implementation YRMsgReportViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"举报";
    self.view.backgroundColor = RGB_COLOR(245, 245, 245);
    self.automaticallyAdjustsScrollViewInsets = false;
    YRReportTextView *reportTextView = [[YRReportTextView alloc] initWithFrame:CGRectMake(10, 10, SCREEN_WIDTH-20, 150)];
 
    reportTextView.font = [UIFont systemFontOfSize:17.f];
    self.textView = reportTextView;
    [self.view addSubview:reportTextView];
    
    reportTextView.placeholder = @"输入举报原因...";
    reportTextView.layer.cornerRadius = 5.f;
    reportTextView.layer.borderWidth = 1.f;
    reportTextView.layer.borderColor = RGB_COLOR(229, 229, 229).CGColor;
    reportTextView.clipsToBounds = YES;
    
    UIButton *confirmBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    confirmBtn.frame = CGRectMake(50, SCREEN_HEIGHT-80-64, SCREEN_WIDTH-100, 40);
    confirmBtn.backgroundColor = [UIColor themeColor];
    confirmBtn.titleLabel.font = [UIFont boldSystemFontOfSize:18];
    [confirmBtn setTitle:@"提交" forState:UIControlStateNormal];
    [confirmBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self.view addSubview:confirmBtn];
    
    confirmBtn.layer.cornerRadius = 20.f;
    confirmBtn.clipsToBounds = YES;
    
    [confirmBtn addTarget:self action:@selector(confirmAction) forControlEvents:UIControlEventTouchUpInside];

}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{

    [self.view endEditing:YES];
}
/**
 *  @author ZX, 16-07-13 15:07:11
 *
 *  提交按钮响应事件
 */
- (void)confirmAction{
 
    
    if (self.textView.text == nil || [self.textView.text isEqualToString:@""]||[[self.textView.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]]length]==0) {
        [MBProgressHUD showError:@"请输入举报原因"];
        
    }else{
        
        NSString *custId = [YRUserInfoManager manager].currentUser.custId;
        if ([custId isEqualToString:self.sourceId]) {
             [MBProgressHUD showError:@"不能举报自己哟"];
            return;
        }
        
        [YRHttpRequest reportWorksAndPeopleByType:self.type sourceId:self.sourceId content:self.textView.text success:^(NSDictionary *data) {
            [MBProgressHUD showError:@"举报成功！"];
            if (self.isPop) {
              NSInteger count = self.navigationController.childViewControllers.count;
            [self.navigationController popToViewController:self.navigationController.childViewControllers[count-4] animated:YES];
                
            }else{
                
                [self.navigationController popViewControllerAnimated:YES];
            }
        } failure:^(NSString *error) {
            [MBProgressHUD showError:error];
        }];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
