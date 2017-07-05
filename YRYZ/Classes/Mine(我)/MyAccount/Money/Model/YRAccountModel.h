//
//  YRAccountModel.h
//  YRYZ
//
//  Created by Sean on 16/8/24.
//  Copyright © 2016年 yryz. All rights reserved.
//

#import "BaseModel.h"

@interface YRAccountModel : BaseModel
///** 资金账户余额 **/
//@property (nonatomic,copy) NSString *cashAccount;
///** 转消费账号总金额 **/
//@property (nonatomic,copy) NSString *toConsumeBonus;
///** 中奖总金额 **/
//@property (nonatomic,copy) NSString *lotteryBonus;
///** 周原创作品总收益 **/
//@property (nonatomic,copy) NSString *opusBonusOf7;
///** 周中奖总金额 **/
//@property (nonatomic,copy) NSString *lotteryBonusOf7;
///** 消费账户余额 **/
//@property (nonatomic,copy) NSString *consumeAccount;
///** 提现总金额 **/
//@property (nonatomic,copy) NSString *getBonus;
///** 周被打赏总金额 **/
//@property (nonatomic,copy) NSString *rewardBonusOf7;
///** 周转发总收益 **/
//@property (nonatomic,copy) NSString *transferBonusOf7;
///** 积分账户余额 **/
//@property (nonatomic,copy) NSString *pointsAccount;
///** 原创作品总收益 **/
//@property (nonatomic,copy) NSString *opusBonus;
/** :1表示账户正常，0表示账户被冻结 **/
@property (nonatomic,copy) NSString *accountState;
/** 消费余额 **/
@property (nonatomic,copy) NSString *accountSum;
/** 累计余额 **/
@property (nonatomic,copy) NSString *costSum;
/** 原创作品总收益 **/
@property (nonatomic,copy) NSString *custId;
/** 积分余额 **/
@property (nonatomic,assign) NSString *integralSum;
/** 原创作品总收益 **/
@property (nonatomic,copy) NSString *smallNopass;




@end
