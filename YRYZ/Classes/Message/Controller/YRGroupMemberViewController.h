//
//  YRGroupMemberViewController.h
//  YRYZ
//
//  Created by Mrs_zhang on 16/7/14.
//  Copyright © 2016年 yryz. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <WXOpenIMSDKFMWK/YWFMWK.h>

@interface YRGroupMemberViewController : UIViewController
/** 新朋友*/
@property (assign, nonatomic) NSInteger newCount;

@property (nonatomic, strong) YWTribe *tribe;

@property (nonatomic,strong) NSMutableArray *dataSource;

@property (nonatomic,assign) BOOL isAddPerson;


@end
