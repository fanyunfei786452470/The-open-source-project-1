//
//  RRZCitySeleteController.h
//  Rrz
//
//  Created by 易超 on 16/3/18.
//  Copyright © 2016年 rongzhongwang. All rights reserved.
//

#import "BaseViewController.h"

@class RRZUserInfoItem;
@interface RRZCitySeleteController : BaseViewController

/** 包含的cities数组*/
@property (nonatomic ,strong) NSArray * cities;

/** 所选择的省份 */
@property (nonatomic, copy) NSString *province;

/** 数据*/
@property (strong, nonatomic) RRZUserInfoItem *item;

@end
