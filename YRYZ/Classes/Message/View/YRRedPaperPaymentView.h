//
//  YRRedPaperPaymentView.h
//  YRYZ
//
//  Created by Rongzhong on 16/7/12.
//  Copyright © 2016年 yryz. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface YRRedPaperPaymentView : UIScrollView

typedef void (^PaymentBlock)(NSUInteger number , float totalMoney ,float singleMoney ,NSInteger redTpye ,float account);

@property (strong, nonatomic) PaymentBlock paymentBlock;


typedef void (^RechargeBlock)();
//充值
@property (strong, nonatomic) RechargeBlock    rechargeBlock;



//圈子红包
typedef void (^ReadRuleActionBlock)();

@property (strong, nonatomic) ReadRuleActionBlock    readRuleActionBlock;

//0为广告红包，1为圈子红包
@property NSInteger type;


@property (nonatomic ,assign)float                         account;//账户余额


@end
