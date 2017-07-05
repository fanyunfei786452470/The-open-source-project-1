//
//  YRBeforePrizeModel.h
//  YRYZ
//
//  Created by Sean on 16/8/10.
//  Copyright © 2016年 yryz. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface YRBeforePrizeModel : BaseModel
@property (nonatomic,copy) NSString *lotteryBounds;

@property (nonatomic,copy) NSString *lotteryName;

@property (nonatomic,copy) NSString *nickName;

@property (nonatomic,copy) NSString *number;

@property (nonatomic,copy) NSString *custId;
@end

@interface YRBeforeArray : BaseModel

@property (nonatomic,strong) NSMutableArray *list;

@property (nonatomic,copy) NSString *lotteryId;
@property (nonatomic,copy) NSString *no;
@property (nonatomic,copy) NSString *time;
@property (nonatomic,copy) NSString *total;

@end









