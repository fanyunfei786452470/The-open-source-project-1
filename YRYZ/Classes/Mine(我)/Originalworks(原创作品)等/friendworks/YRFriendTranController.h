//
//  YRFriendTranController.h
//  YRYZ
//
//  Created by Sean on 16/9/20.
//  Copyright © 2016年 yryz. All rights reserved.
//

#import "BaseViewController.h"
#import "YRUserDetail.h"
@interface YRFriendTranController : BaseViewController
@property (nonatomic,copy) NSString *custId;
@property (nonatomic,weak) YRUserDetail *model;
@end
