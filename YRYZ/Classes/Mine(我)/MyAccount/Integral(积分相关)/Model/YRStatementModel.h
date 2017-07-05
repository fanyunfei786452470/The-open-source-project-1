//
//  YRStatementModel.h
//  YRYZ
//
//  Created by Sean on 16/9/5.
//  Copyright © 2016年 yryz. All rights reserved.
//

#import "BaseModel.h"

@interface YRStatementModel : BaseModel

@property (nonatomic,copy) NSString *accountSum;
@property (nonatomic,copy) NSString *cost;
@property (nonatomic,copy) NSString *createTime;
@property (nonatomic,copy) NSString *custId;
@property (nonatomic,copy) NSString *orderDesc;
@property (nonatomic,copy) NSString *orderId;
@property (nonatomic,copy) NSString *orderType;
@property (nonatomic,copy) NSString *productDesc;
@property (nonatomic,copy) NSString *productId;
@property (nonatomic,copy) NSString *productType;

@end
