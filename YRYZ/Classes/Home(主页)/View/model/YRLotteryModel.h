//
//  YRLotteryModel.h
//  YRYZ
//
//  Created by weishibo on 16/8/20.
//  Copyright © 2016年 yryz. All rights reserved.
//

#import "BaseModel.h"

@interface YRLotteryModel : BaseModel
@property (nonatomic,strong) NSString           *lotteryId;    //抽奖码

@property (nonatomic,strong) NSString           *lotteryNumber;  //抽奖号码个数

@property (nonatomic,strong) NSString           *lotteryPeriod; //开奖基数

@property (nonatomic,strong) NSString           *uid;  //圈子id

@property (nonatomic,strong) NSString           *redpackId; //红包id
@end
