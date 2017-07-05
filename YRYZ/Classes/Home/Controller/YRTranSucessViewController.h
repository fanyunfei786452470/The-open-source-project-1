//
//  YRTranSucessViewController.h
//  YRYZ
//
//  Created by 易超 on 16/8/22.
//  Copyright © 2016年 yryz. All rights reserved.
//

#import "BaseViewController.h"
#import "YRLotteryModel.h"
#import "YRVidioDetailController.h"
@interface YRTranSucessViewController : BaseViewController


@property (strong ,nonatomic)YRLotteryModel   *lotteryModel;


@property (strong ,nonatomic)NSString          *clubRedId; //圈子红包id


@property (strong ,nonatomic)NSString          *clubRedCustName; //圈子红包发放者Name


@property (nonatomic,assign) BOOL  msgTrans;

@property (nonatomic,assign) BOOL feachData;

@property (nonatomic,weak) YRVidioDetailController *delegate;
@end
