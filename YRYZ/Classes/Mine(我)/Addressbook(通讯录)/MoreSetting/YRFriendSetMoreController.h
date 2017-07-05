//
//  YRFriendSetMoreController.h
//  YRYZ
//
//  Created by Sean on 16/9/1.
//  Copyright © 2016年 yryz. All rights reserved.
//

#import "BaseViewController.h"
#import "FriendsModel.h"
#import "RRZCommendFriend.h"
@interface YRFriendSetMoreController : BaseViewController

@property (nonatomic,assign) BOOL isFriend;

@property (nonatomic,copy) NSString *custId;

@property (nonatomic,weak) FriendsModel *foucnMyfriend;

@property (nonatomic,weak) RRZCommendFriend *searchModel;
@end
