//
//  RRZSetupNotsController.h
//  Rrz
//
//  Created by 易超 on 16/3/18.
//  Copyright © 2016年 rongzhongwang. All rights reserved.
//

#import "BaseViewController.h"
#import "YRUserDetail.h"
@class RRZUserInfoItem;
@interface RRZSetupNotsController : BaseViewController

/** 数据*/
@property (strong, nonatomic) RRZUserInfoItem *item;

@property (nonatomic,weak) YRUserDetail *model;

@end
