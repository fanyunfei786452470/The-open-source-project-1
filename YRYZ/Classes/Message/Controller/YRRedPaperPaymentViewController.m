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
#import "YRAccountModel.h"
#import "RRZSaveMoneyController.h"
#import "YRChangePayPassWordController.h"
#import "YRMineWebController.h"
@interface YRRedPaperPaymentViewController ()
@property(strong , nonatomic)NSString  *balanceStr;
@property (assign ,nonatomic)BOOL       havePassword;
@property (assign ,nonatomic)BOOL       smallNopass;

@end

@implementation YRRedPaperPaymentViewController


//-(YRProductListModel*)productModel{
//    
//    if (!_productModel) {
//        _productModel = [[YRProductListModel alloc] init];
//    }
//    return _productModel;
//}
//
//- (YRCircleListModel*)circleModel{
//    
//    if (!_circleModel) {
//        _circleModel = [[YRCircleListModel alloc] init];
//    }
//    return _circleModel;
//}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setTitle:@"支付"];
    
    _havePassword = NO;
    _smallNopass = NO;
    [self queryPassWord];
    [self initUI];
    
}


- (void)queryPassWord{
    
    [YRHttpRequest QueryThePaymentPasswordSuccess:^(NSDictionary *data) {
        //是否设置支付密码
        self.havePassword = [data[@"isPayPassword"] boolValue];
        //小额免密开关
        self.smallNopass = [data[@"smallNopass"] boolValue];
        
        if (!self.havePassword) {
            
            YRAlertView *alertView = [[YRAlertView alloc] initWithTitle:@"请设置支付密码" cancelButtonText:@"取消" confirmButtonText:@"确认"];
            
            alertView.addCancelAction = ^{
                
            };
            alertView.addConfirmAction = ^{
                
                YRChangePayPassWordController *payVc = [[YRChangePayPassWordController alloc]init];
                payVc.title = @"设置支付密码";
                [self.navigationController pushViewController:payVc animated:YES];
            };
            [alertView show];
            
            return;
            
        }
        
        
    } failure:^(NSString *error) {
        
        [MBProgressHUD showError:error];
    }];
    
}

-(void)initUI
{
    YRRedPaperPaymentView *redPaperPaymentView = [[YRRedPaperPaymentView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
    redPaperPaymentView.type = self.type;
    redPaperPaymentView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:redPaperPaymentView];
    @weakify(self);
    
    redPaperPaymentView.rechargeBlock = ^(){
        RRZSaveMoneyController  *saveVc = [[RRZSaveMoneyController alloc] init];
        [self.navigationController pushViewController:saveVc animated:YES];
    };
    
    redPaperPaymentView.readRuleActionBlock = ^(){
        YRMineWebController *webVc = [[YRMineWebController alloc] init];
        webVc.url = Red_Rule_Action;
        webVc.titletext = @"圈子红包";
        [self.navigationController pushViewController:webVc animated:YES];
    };
    
    redPaperPaymentView.paymentBlock = ^(NSUInteger number , float totalMoney ,float singleMoney ,NSInteger redType,float account){
        @strongify(self);
        //是否发送红包
        __block  NSInteger isSendRedPacket = 0;
        __block  float  allMoney = 0;
        float  tranBaseMoney = 3.00 * 100;
        
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
        
        if (account*100 < allMoney) {
            [MBProgressHUD showError:@"余额不足,请充值"];
            return;
        }
        
        NSString *allMoneyStr = [NSString stringWithFormat:@"%.2f",allMoney *0.01];
        
        //                 圈子id或作品id
        NSString    *pid = @"";
        NSInteger   transferType = 0; //原创作品0 圈子转发1
        NSString    *authorid = @"";
        NSInteger   productTran = 1;  //0：重复转发  1：付费转发(现在都传1 都是付费转发)
        NSString    *clubRedId = @"";
        NSString    *redName = @"";
        
        //转发作品
        if (self.productModel.uid && self.productModel.uid.length > 0 ) {
            pid = self.productModel.uid;
            transferType = 0;
            authorid = self.productModel.custId ? self.productModel.custId :self.productDetail.custId ;
        }
        else if (self.productDetail.uid){
            pid = self.productDetail.uid;
            transferType = 0;
            authorid = self.productDetail.custId ? self.productDetail.custId :self.productModel.custId ;

        }else{
            //转发圈子
            if (self.circleModel.clubId && self.circleModel.clubId.length > 0) {
                pid = self.circleModel.clubId;
                transferType = 1;
                authorid =  self.circleModel.custId ? self.circleModel.custId : self.circleDetail.custId;
                clubRedId = self.circleModel.redpacketId;
                redName = self.circleModel.custNname ? self.circleModel.custNname : self.circleModel.custName;
            }
        }
        
        //小额免密打开并总支付小于50
        if (self.smallNopass && allMoney * 0.01 <= 50) {
            [MBProgressHUD showMessage:@""];
            [YRHttpRequest productTran:productTran pID:pid transferType:transferType transferMoney:tranBaseMoney authorId:authorid isSendRedPacket:isSendRedPacket packetType:redType totalCount:number amount:allMoney - tranBaseMoney payPassword:@"" success:^(id data) {
                [MBProgressHUD hideHUD];
                if (_circleModel.clubId) {
                    self.circleModel.transferBonud += 1;
                    self.circleModel.forwardStatus = 1;
                    
                }
                
                if (_productModel.uid) {
                    NSInteger transferCount = [self.productModel.transferCount integerValue] + 1;
                    self.productModel.transferCount = [NSString stringWithFormat:@"%ld",transferCount];
                    self.productModel.forwardStatus = 1;
        
                }
                
                
                if (self.tranSuccessDelegate && [self.tranSuccessDelegate  respondsToSelector:@selector(tranSuccessDelegate:circleListModel:indexPosition:)]) {
                    
                    [self.tranSuccessDelegate tranSuccessDelegate:self.productModel circleListModel:self.circleModel indexPosition:self.indexPosition];
                }
                
                YRLotteryModel *lotteryModel = [YRLotteryModel mj_objectWithKeyValues:data];
                YRTranSucessViewController *tranVc = [[YRTranSucessViewController alloc] init];
                tranVc.lotteryModel = lotteryModel;
                tranVc.clubRedId = clubRedId;
                tranVc.clubRedCustName = redName;
                [self.navigationController pushViewController:tranVc animated:YES];
                
                if (_refreshBlock) {
                    _refreshBlock();
                }
                
            } failure:^(NSString *data) {
                [MBProgressHUD hideHUD];
                [MBProgressHUD showError:data];
            }];
            
            return;
        }
        
        
        //大额支付
        [self passWord:allMoneyStr allMoney:allMoney pid:pid tranBaseMoney:tranBaseMoney authorid:authorid redType:redType number:number transferType:transferType isSendRedPacket:isSendRedPacket productTran:productTran cludRedId:clubRedId clubRedCustName:redName];
        
    };
}


- (void)passWord:(NSString*)allMoneyStr  allMoney:(float)allMoney pid:(NSString*)pid   tranBaseMoney:(float)tranBaseMoney authorid:(NSString*)authorid  redType:(NSInteger)redType number:(NSUInteger)number transferType:(NSInteger)transferType isSendRedPacket:(NSInteger)isSendRedPacket productTran:(NSInteger)productTran   cludRedId:(NSString*)cludRedId clubRedCustName:(NSString*)redName{
    @weakify(self);
    [YRPaymentPasswordView showPaymentViewWithMoney:allMoneyStr  paymentBlock:^(NSString  *password){
        @strongify(self);
        [YRPaymentPasswordView hidePaymentPasswordView];
        
        [MBProgressHUD showMessage:@""];
        [YRHttpRequest productTran:productTran pID:pid transferType:transferType transferMoney:tranBaseMoney authorId:authorid isSendRedPacket:isSendRedPacket packetType:redType totalCount:number amount:allMoney - tranBaseMoney payPassword:password success:^(id data) {
            [MBProgressHUD hideHUD];
            if (self.circleModel) {
                self.circleModel.transferBonud += 1;
                self.circleModel.forwardStatus = 1;
                
            }
            
            if (self.productModel) {
                NSInteger transferCount = [self.productModel.transferCount integerValue] + 1;
                self.productModel.transferCount = [NSString stringWithFormat:@"%ld",transferCount];
                self.productModel.forwardStatus = 1;
                
            }
            if ([YRModelManager manager].corcleModel) {
                 [YRModelManager manager].corcleModel.forwardStatus = 1;
            }
            if (self.tranSuccessDelegate && [self.tranSuccessDelegate  respondsToSelector:@selector(tranSuccessDelegate:circleListModel:indexPosition:)]) {
                [self.tranSuccessDelegate tranSuccessDelegate:self.productModel circleListModel:self.circleModel indexPosition:self.indexPosition];
            }
            
            YRLotteryModel *lotteryModel = [YRLotteryModel mj_objectWithKeyValues:data];
            YRTranSucessViewController *tranVc = [[YRTranSucessViewController alloc] init];
            tranVc.delegate = self.delegate;
            tranVc.lotteryModel = lotteryModel;
            tranVc.clubRedId = cludRedId;
            tranVc.clubRedCustName = redName;
            [self.navigationController pushViewController:tranVc animated:YES];
            
            if (_refreshBlock) {
                _refreshBlock();
            }
        } failure:^(NSString *data) {
            [MBProgressHUD hideHUD];
            if ([data isEqualToString:@"支付密码错误"]) {
                [YRPaymentPasswordView hidePaymentPasswordView];
                
                YRAlertView *alertView = [[YRAlertView alloc] initWithTitle:@"支付密码错误，请重试" cancelButtonText:@"确定"  ];
                alertView.addCancelAction = ^{
                    [self passWord:allMoneyStr allMoney:allMoney pid:pid tranBaseMoney:tranBaseMoney authorid:authorid redType:redType number:number transferType:transferType isSendRedPacket:isSendRedPacket productTran:productTran cludRedId:cludRedId clubRedCustName:redName];
                };
                [alertView show];
                return ;
            }
            [MBProgressHUD showError:data];
        }];
        
    }];
    
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
