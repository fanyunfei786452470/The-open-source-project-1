//
//  YRRedPaperAdPayment.h
//  YRYZ
//
//  Created by Rongzhong on 16/8/18.
//  Copyright © 2016年 yryz. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface YRRedPaperAdPayment : UIScrollView

/**
 *  @author weishibo, 16-09-13 10:09:22
 *
 *
 *
 *  @param number      红包个数
 *  @param totalMoney  红包总金额
 *  @param singleMoney 单个红包
 *  @param redTpye     红包类型
 */
typedef void (^PayRedAdsMentBlock)(NSUInteger number , float totalMoney ,float singleMoney ,NSInteger redTpye,NSString *payDays);

@property (strong, nonatomic) PayRedAdsMentBlock    payRedAdsMentBlock;


- (instancetype)initWithFrame:(CGRect)frame;


typedef void (^RechargeRedAdsBlock)();
//充值
@property (strong, nonatomic) RechargeRedAdsBlock    rechargeRedAdsBlock;


typedef void (^OpenUrlBlock)();
//充值
@property (strong, nonatomic) OpenUrlBlock  openUrlBlock;

@property (nonatomic,assign) float adsPrice;


-(void)refreshData;


@end
