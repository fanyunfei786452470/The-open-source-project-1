//
//  YRAddNewGroupViewController.h
//  YRYZ
//
//  Created by Mrs_zhang on 16/9/9.
//  Copyright © 2016年 yryz. All rights reserved.
//

#import "BaseViewController.h"
#import <WXOpenIMSDKFMWK/YWFMWK.h>
#import "YRCircleListModel.h"

@interface YRAddNewGroupViewController : BaseViewController
/** 新朋友*/
@property (assign, nonatomic) NSInteger newCount;
@property (nonatomic,strong) NSString                *infoId;
@property (nonatomic,assign) NSInteger                type;//    //1是邀请作品 2是圈子
@end
