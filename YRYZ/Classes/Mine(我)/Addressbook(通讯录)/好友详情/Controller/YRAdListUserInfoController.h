//
//  YRAdListUserInfoController.h
//  YRYZ
//
//  Created by 易超 on 16/7/13.
//  Copyright © 2016年 yryz. All rights reserved.
//

#import "BaseViewController.h"
#import "YRAdListItem.h"

#import "FriendsModel.h"
#import "RRZCommendFriend.h"
@interface YRAdListUserInfoController : BaseViewController

/** 好友id*/
@property (strong, nonatomic) NSString *custId;

//@property (nonatomic,copy) NSString *uid;

@property (nonatomic,assign) BOOL isFriend;
//好友模型
@property (nonatomic,weak) YRAdListItem *item;

@property (nonatomic,weak) FriendsModel *foucnMyfriend;

@property (nonatomic,weak) RRZCommendFriend *searchModel;

@end
