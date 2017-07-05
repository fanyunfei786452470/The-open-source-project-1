//
//  RRZQRController.h
//  Rrz
//
//  Created by 易超 on 16/3/21.
//  Copyright © 2016年 rongzhongwang. All rights reserved.
//

#import "BaseViewController.h"

@class RRZUserInfoItem;
@interface RRZQRController : BaseViewController

/** 数据*/
@property (strong, nonatomic) RRZUserInfoItem *item;


@property (weak, nonatomic) IBOutlet UILabel *name;

@property (weak, nonatomic) IBOutlet UILabel *place;

@end
