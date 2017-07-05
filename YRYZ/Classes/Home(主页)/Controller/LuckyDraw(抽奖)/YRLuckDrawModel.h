//
//  YRLuckDrawModel.h
//  YRYZ
//
//  Created by Sean on 16/9/18.
//  Copyright © 2016年 yryz. All rights reserved.
//

#import "BaseModel.h"
#import "YRBeforePrizeModel.h"
@interface YRLuckDrawModel : BaseModel
@property (nonatomic,assign) NSInteger amount1;
@property (nonatomic,assign) NSInteger amount2;
@property (nonatomic,assign) NSInteger count;
@property (nonatomic,copy)  NSString   *lotteryId;
@property (nonatomic,assign) NSString  *maxstage;
@property (nonatomic,assign) NSInteger  needcount;
@property (nonatomic,strong) NSMutableArray *mycodes;
@property (nonatomic,assign) NSInteger  lotteryNumber;

@property (nonatomic,strong) YRBeforeArray *lotto;

@end
