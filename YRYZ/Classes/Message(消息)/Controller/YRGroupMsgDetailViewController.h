//
//  YRGroupMsgDetailViewController.h
//  YRYZ
//
//  Created by Mrs_zhang on 16/7/13.
//  Copyright © 2016年 yryz. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <WXOpenIMSDKFMWK/YWFMWK.h>

typedef enum
{
    groupNameType         = 0,
    groupPeopleCountType  = 1,
    msgNoNotificationType = 2,
    emptyChatKeepType     = 3,
    reportType            = 4
} cellName;//枚举名称

@interface YRGroupMsgDetailViewController : UIViewController

@property (nonatomic, strong) YWTribe *tribe;
@property (nonatomic, strong) YWIMKit *imKit;


@end
