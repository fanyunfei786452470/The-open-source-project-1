//
//  YRRedPaperAdPaymemtViewController.m
//  YRYZ
//
//  Created by Rongzhong on 16/8/18.
//  Copyright © 2016年 yryz. All rights reserved.
//

#import "YRRedPaperAdPaymemtViewController.h"
#import "YRRedPaperAdPayment.h"
#import "YRChangePayPassWordController.h"
#import "YRPaymentPasswordView.h"
#import "RRZSaveMoneyController.h"
#import "YRRedAdsPaySucceedController.h"
#import "YRRedAdsMainViewController.h"
#import "YRAccountModel.h"
#import "YRMineWebController.h"



@interface YRRedPaperAdPaymemtViewController ()
@property (nonatomic, assign) BOOL                          isFectDetail;
@property (nonatomic, assign) BOOL                          havePassword;
@property (nonatomic, assign) float                         adsPrice;

@property (nonatomic, strong) YRRedPaperAdPayment           *redPaperAdPayment;

@end

@implementation YRRedPaperAdPaymemtViewController



-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    if (!self.isFectDetail) {
        [self getAdsPriceDaysuccess];
        [self queryPassWord];
        self.isFectDetail = YES;
    }
    
}

///获取广告发布单价
- (void)getAdsPriceDaysuccess{
    
    [YRHttpRequest getAdsPriceDaysuccess:^(NSDictionary *data) {
        self.adsPrice = [data[@"advertPrice"] floatValue] * 0.01;
        _redPaperAdPayment.adsPrice = self.adsPrice;
        [_redPaperAdPayment refreshData];
    } failure:^(id data) {
        [MBProgressHUD showError:data];
    }];
}
- (void)queryPassWord{
    
    [YRHttpRequest QueryThePaymentPasswordSuccess:^(NSDictionary *data) {
        //是否设置支付密码
        self.havePassword = [data[@"isPayPassword"] boolValue];
        
    } failure:^(NSString *error) {
        
        [MBProgressHUD showError:error];
    }];
    
}


- (void)viewDidLoad {
    [super viewDidLoad];
    [self setTitle:@"支付"];
    
    self.view.backgroundColor = [UIColor whiteColor];
    _redPaperAdPayment = [[YRRedPaperAdPayment alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
    [self.view addSubview:_redPaperAdPayment];
    @weakify(self);
    _redPaperAdPayment.rechargeRedAdsBlock = ^(){
        @strongify(self);
        RRZSaveMoneyController  *saveVc = [[RRZSaveMoneyController alloc] init];
        [self.navigationController pushViewController:saveVc animated:YES];
    };
    
    _redPaperAdPayment.openUrlBlock = ^(){
        @strongify(self);
        YRMineWebController *webController = [[YRMineWebController alloc]init];
        webController.titletext = @"平台广告费";
        webController.url = REDADSMONEY;
        [self.navigationController pushViewController:webController animated:YES];
    };
    
    _redPaperAdPayment.payRedAdsMentBlock = ^(NSUInteger number , float totalMoney ,float singleMoney ,NSInteger redType,NSString *payDays){
        @strongify(self);
        
        if (!self.havePassword) {
            
            
            YRAlertView *alertView = [[YRAlertView alloc] initWithTitle:@"请先设置支付密码" cancelButtonText:@"取消" confirmButtonText:@"确认"];
            
            alertView.addCancelAction = ^{
                
            };
            alertView.addConfirmAction = ^{
                @strongify(self);
                YRChangePayPassWordController *payVc = [[YRChangePayPassWordController alloc]init];
                payVc.title = @"设置支付密码";
                [self.navigationController pushViewController:payVc animated:YES];
            };
            [alertView show];
            
            
            return ;
        }
        //是否发送红包
        __block  NSInteger isSendRedPacket = 0;
        __block  float  allMoney = 0;
        float  tranBaseMoney = self.adsPrice * 100 * [payDays intValue];
        
        //                拼手气红包
        if (redType == 0) {
            if (number > 1 && totalMoney > 1 ) {
                isSendRedPacket = 1;
                allMoney = 0.00;
                allMoney = totalMoney ;
            }
        }
        //               普通红包
        if (redType == 1) {
            if (number > 1 && singleMoney > 1 ) {
                isSendRedPacket = 1;
                allMoney = 0.00;
                totalMoney = number * singleMoney;
            }
        }
        
        allMoney = totalMoney  + tranBaseMoney;
        
        NSString *allMoneyStr = [NSString stringWithFormat:@"%.2f",allMoney *0.01];
        
        CGFloat   packetAmount = allMoney - tranBaseMoney;
        
        if (self.isAgainTry) {
            [self paymentPasswordViewByPayDays:payDays packetType:redType packetAmount:packetAmount packetNum:number allMoney:allMoneyStr];
        }else{
            
            if ([self.model.wishUpData isEqualToString:@"0"]) {
                self.model.wishUpData = nil;
            }
            [self paymentPasswordView:allMoneyStr releaseRedAds:self.model.adsTitle adsSmallPic:self.model.adsSmallPic picCount:self.model.picCount content:self.model.content adsType:self.model.adsType payDays:[payDays integerValue] wishUpDate:self.model.wishUpData phone:self.model.phone  adsInfoPath:self.model.adsInfoPath adsDesc:self.model.adsDesc redType:redType packetAmount:packetAmount packetNum:number];
            
        }
    };
}

- (void)paymentPasswordViewByPayDays:(NSString *)payDas packetType:(NSInteger)packetType packetAmount:(NSInteger)packetAmount packetNum:(NSInteger)packetNum  allMoney:(NSString *)allMoney{
    [YRPaymentPasswordView showPaymentViewWithMoney:allMoney  paymentBlock:^(NSString  *password){
        
        NSString *wishUp =[self timesTampWithTime:[NSString stringWithFormat:@"%@ 00:00:00",self.wishUpDate]];
        
        
        [YRHttpRequest giveMoneyToAdsNumber:self.mineModel.adsId payDays:payDas  wishUpDate:wishUp packetType:[NSString stringWithFormat:@"%ld",packetType] packetAmount:packetAmount packetNum:packetNum password:password success:^(NSDictionary *data) {
            
            if ([data[@"code"] integerValue]==1) {
                
                
                [MBProgressHUD showSuccess:@"发布成功"];
                [YRPaymentPasswordView hidePaymentPasswordView];
                [self.navigationController popViewControllerAnimated:YES];
            }else{
                [MBProgressHUD showError:@"发布失败"];
            }
        } failure:^(NSString *error) {
            [MBProgressHUD showError:error];
        }];
        
    }];
}
- (void)paymentPasswordView:(NSString*)allMoneyStr releaseRedAds:(NSString*)releaseRedAds adsSmallPic:(NSString*)adsSmallPic  picCount:(NSInteger)picCount content:(NSString*)content   adsType:(NSInteger)adsType  payDays:(NSInteger)payDays wishUpDate:(NSString *)wishUpDate  phone:(NSString*)phone  adsInfoPath:(NSString *)adsInfoPath adsDesc:(NSString *)adsDesc redType:(NSInteger)redType packetAmount:(CGFloat)packetAmount  packetNum:(NSInteger)packetNum {
    
    
    [YRPaymentPasswordView showPaymentViewWithMoney:allMoneyStr  paymentBlock:^(NSString  *password){
        [YRPaymentPasswordView hidePaymentPasswordView];
        //adsType 0图文 1视频
        [MBProgressHUD showMessage:@""];
        [YRHttpRequest releaseRedAds:releaseRedAds adsSmallPic:adsSmallPic picCount:picCount content:content adsType:adsType payDays:payDays wishUpDate:wishUpDate phone:phone packetType:redType packetAmount:packetAmount packetNum:packetNum password:password adsInfoPath:adsInfoPath adsDesc:adsDesc success:^(id data) {
//            [MBProgressHUD hideHUD];
            NSInteger code = [data[@"code"] integerValue];
            
            if (code) {
          
                
                switch (code) {
                    case 1:
                    {
                        [MBProgressHUD hideHUD];
                        [MBProgressHUD showError:@"发布成功，系统审核中，请耐心等待"];
                        [YRPaymentPasswordView hidePaymentPasswordView];
                        YRRedAdsPaySucceedController * paysucess = [[YRRedAdsPaySucceedController alloc]init];
                        [self.navigationController pushViewController:paysucess animated:YES];
                    }
                        break;
                    case 3:
                    {
                        [MBProgressHUD hideHUD];
                        [MBProgressHUD showError:@"失败"];
                        YRRedAdsMainViewController * main = [[YRRedAdsMainViewController alloc]init];
                        [self.navigationController pushViewController:main animated:YES];
                    }
                        break;
                    case 26:
                        [MBProgressHUD hideHUD];
                        [MBProgressHUD showError:@"余额不足"];
                        [YRPaymentPasswordView hidePaymentPasswordView];
                        break;
                    case 27:
                    {
                        [MBProgressHUD hideHUD];
                        [YRPaymentPasswordView hidePaymentPasswordView];
                        YRAlertView *alertView = [[YRAlertView alloc] initWithTitle:@"支付密码错误，请重试" cancelButtonText:@"确定"  ];
                        
                        alertView.addCancelAction = ^{                            //                                        @strongify(self);
                            //                                        [self paymentPasswordView:allMoneyStr releaseRedAds:@"广告标题" adsSmallPic:@"小图地址" picCount:111 content:@"广告主体内容" adsType:1 payDays:29 wishUpDate:2016 phone:@"18101898989" redType:redType packetAmount:packetAmount packetNum:packetNum];
                        };
                        [alertView show];
                        return ;
                    }
                        break;
                    case 28:
                        [MBProgressHUD hideHUD];
                        [MBProgressHUD showError:@"广告审核失败次数超过限制"];
                        [YRPaymentPasswordView hidePaymentPasswordView];
                        break;
                    case 29:
                        [MBProgressHUD hideHUD];
                        [MBProgressHUD showError:@"广告内容h5上传失败"];
                        [YRPaymentPasswordView hidePaymentPasswordView];
                        break;
                    case 30:
                        [MBProgressHUD hideHUD];
                        [MBProgressHUD showError:@"广告联系方式不合法"];
                        [YRPaymentPasswordView hidePaymentPasswordView];
                        break;
                    case 31:
                        [MBProgressHUD hideHUD];
                        [MBProgressHUD showError:@"广告内容存在敏感词"];
                        [YRPaymentPasswordView hidePaymentPasswordView];
                        break;
                    case 32:
                        [MBProgressHUD hideHUD];
                        [MBProgressHUD showError:@"视频广告地址没传"];
                        [YRPaymentPasswordView hidePaymentPasswordView];
                        break;
                    case 33:
                        [MBProgressHUD hideHUD];
                        [MBProgressHUD showError:@"图文内容为空"];
                        [YRPaymentPasswordView hidePaymentPasswordView];
                        break;
                    default:
                        break;
                }
                return ;
            }
            
            
        } failure:^(id data) {
            [MBProgressHUD hideHUD];
            [MBProgressHUD showError:data];
            [YRPaymentPasswordView hidePaymentPasswordView];
            
            
        }];
    }];
    
}

- (void)setModel:(YRRedAdsPaymentModel *)model{
    
    //    NSLog(@"model:%@:%@:%ld:%@:%ld:%ld:%@:%@",model.adsTitle,model.adsSmallPic,(long)model.picCount,model.content,(long)model.adsType,(long)model.payDays,model.wishUpData,model.phone);
    _model = model;
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
