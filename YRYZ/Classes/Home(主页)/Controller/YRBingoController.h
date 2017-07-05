//
//  YRBingoController.h
//  YRYZ
//
//  Created by Sean on 16/8/10.
//  Copyright © 2016年 yryz. All rights reserved.
//

#import "BaseViewController.h"

@interface YRBingoController : BaseViewController

//num = 0 显示开奖中状态 num = 1 显示没有中奖状态 num =2 中得一/二等奖状态
@property (nonatomic,assign) NSInteger num;
@end
