//
//  YRMineRedBagModel.h
//  YRYZ
//
//  Created by Sean on 16/9/17.
//  Copyright © 2016年 yryz. All rights reserved.
//

#import "BaseModel.h"

@interface YRMineRedBagModel : BaseModel
/** 红包总数**/
@property (nonatomic,assign) NSInteger count;
/** 总金额 (单位 分)**/
@property (nonatomic,assign) CGFloat fee;
/** 红包已领的个数 **/
@property (nonatomic,assign) NSInteger over;
/**红包ID**/
@property (nonatomic,copy) NSString  * rid;
/**红包场景**/
@property (nonatomic,copy) NSString  * scene;
/**红包状态**/
@property (nonatomic,copy) NSString  * status;
/**发放时间**/
@property (nonatomic,assign) NSInteger time;
/**红包类型(普通 拼手气)**/
@property (nonatomic,copy) NSString  * type;

@property (nonatomic,copy) NSString *custId;
@property (nonatomic,copy) NSString *custid;
@property (nonatomic,copy) NSString *headImg;
@property (nonatomic,copy) NSString *nickName;
@property (nonatomic,copy) NSString *rctime;
@property (nonatomic,copy) NSString *remark;
@property (nonatomic,copy) NSString *sign;

@end
