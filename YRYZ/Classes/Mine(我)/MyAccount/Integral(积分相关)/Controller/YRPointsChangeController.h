//
//  YRPointsChangeController.h
//  YRYZ
//
//  Created by Sean on 16/8/13.
//  Copyright © 2016年 yryz. All rights reserved.
//

#import "BaseViewController.h"
#import "YRAccountModel.h"
@interface YRPointsChangeController : BaseViewController
@property (nonatomic,assign) CGFloat sum;

@property (nonatomic,copy) NSString *canNum;

@property (nonatomic,weak) YRAccountModel *model;

@end
