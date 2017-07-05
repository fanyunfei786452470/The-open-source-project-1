//
//  YRUserRedBagModel.h
//  YRYZ
//
//  Created by Sean on 16/8/26.
//  Copyright © 2016年 yryz. All rights reserved.
//

#import "BaseModel.h"

@interface YRUserRedBagModel : BaseModel
/** 收到总红包个数 **/
@property (nonatomic,assign) NSInteger count;
/** 收到总红包金额 **/
@property (nonatomic,copy) NSString *totalAmount;
/** 总金额 **/
@property (nonatomic,assign) NSInteger  fee;
/** 领取个数 **/
@property (nonatomic,assign) NSInteger over;
/** 红包类型 拼手气,普通 **/
@property (nonatomic,copy) NSString *type;
/** 红包ID **/
@property (nonatomic,copy) NSString *rid;
@property (nonatomic,copy) NSString *scene;
/** 领取时间 **/
@property (nonatomic,copy) NSString *rctime;
@property (nonatomic,copy) NSString *userid;
/** 昵称 **/
@property (nonatomic,copy) NSString *nickName;
@property (nonatomic,copy) NSString *headImg;
@property (nonatomic,copy) NSString *remark;
/** 领取的金额 **/
@property (nonatomic,copy) NSArray *rlist;

@end
