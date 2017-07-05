//
//  YRRedPaperPaymentViewController.m
//  YRYZ
//
//  Created by Rongzhong on 16/7/12.
//  Copyright © 2016年 yryz. All rights reserved.
//

#import "YRRedPaperPaymentViewController.h"
#import "YRRedPaperPaymentView.h"
#import "YRPaymentPasswordView.h"
#import "YRLotteryModel.h"
#import "YRTranSucessViewController.h"
#import "IQKeyboardManager.h"


@interface YRRedPaperPaymentViewController ()

@end

@implementation YRRedPaperPaymentViewController


-(YRProductListModel*)productModel{
    
    if (!_productModel) {
        _productModel = [[YRProductListModel alloc] init];
    }
    return _productModel;
}

- (YRCircleListModel*)circleModel{
    
    if (!_circleModel) {
        _circleModel = [[YRCircleListModel alloc] init];
    }
    return _circleModel;
}

- (void)viewWillAppear:(BOOL)animated{
    
    [super viewWillAppear:animated];
    
    [IQKeyboardManager sharedManager].enable = NO;
    
}

- (void)viewWillDisappear:(BOOL)animated{
    
    [super viewWillDisappear:animated];
    
    [IQKeyboardManager sharedManager].enable = YES;
    
}


- (void)viewDidLoad {
    [super viewDidLoad];
    [self setTitle:@"支付"];
    
    
    [self initUI];
    
}

-(void)initUI
{
    YRRedPaperPaymentView *redPaperPaymentView = [[YRRedPaperPaymentView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
    redPaperPaymentView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:redPaperPaymentView];
    @weakify(self);
    redPaperPaymentView.paymentBlock = ^(NSUInteger number , NSUInteger totalMoney ,NSUInteger singleMoney ,NSInteger redType){
        
        
        
        
        
        //是否发送红包
        __block  NSInteger isSendRedPacket = 0;
        __block  float  allMoney = 0;
        
        //                拼手气红包
        if (redType == 0) {
            if (number > 1 && totalMoney > 10 ) {
                isSendRedPacket = 1;
            }
        }
        //               普通红包
        if (redType == 1) {
            if (number > 1 && singleMoney > 10 ) {
                isSendRedPacket = 1;
                totalMoney = number * singleMoney;
            }
        }
        
         allMoney = totalMoney + 1.5;
        
        
        NSString *allMoneyStr = [NSString stringWithFormat:@"%.1f",allMoney];
        
        [YRPaymentPasswordView showPaymentViewWithMoney:allMoneyStr  paymentBlock:^(NSString* password){
            @strongify(self);
            if ([password isEqualToString:@"123456"]) {
                [YRPaymentPasswordView hidePaymentPasswordView];
                //                 圈子id或作品id
                NSString *pid = @"";
                NSInteger transferType = 0;
                NSString *authorid = @"";
                
                //转发作品
                if (self.productModel.uid && self.productModel.uid.length > 0) {
                    pid = self.productModel.uid;
                    transferType = 0 ;
                    authorid = self.productModel.authorid;
                }else{
                    //转发圈子
                    if (self.circleModel.clubId && self.circleModel.clubId.length > 0) {
                        pid = self.circleModel.clubId;
                        transferType = 1;
                        authorid =  self.circleModel.custId;
                    }
                }
                
                [YRHttpRequest productTran:transferType pID:pid transferType:kProductTranOriginal transferMoney:9999 authorId:authorid isSendRedPacket:isSendRedPacket packetType:redType totalCount:number amount:[allMoneyStr integerValue] success:^(id data) {
                    YRLotteryModel *lotteryModel = [YRLotteryModel mj_objectWithKeyValues:data];
                    YRTranSucessViewController *tranVc = [[YRTranSucessViewController alloc] init];
                    tranVc.lotteryModel = lotteryModel;
                    [self.navigationController pushViewController:tranVc animated:YES];
                } failure:^(NSString *data) {
                     [MBProgressHUD showError:data];
                }];
            }else{
                [YRPaymentPasswordView hidePaymentPasswordView];
                
                YRAlertView *alertView = [[YRAlertView alloc] initWithTitle:@"支付密码错误，请重试" cancelButtonText:@"忘记密码" confirmButtonText:@"重试"];
                
                alertView.addCancelAction = ^{
                    
                };
                alertView.addConfirmAction = ^{
                    
                };
                [alertView show];
                
                
                
            }
        }];
    };
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
