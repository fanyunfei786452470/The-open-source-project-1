//
//  YRUserInfoManager.h
//  YRYZ
//
//  Created by 易超 on 16/7/19.
//  Copyright © 2016年 yryz. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "UserModel.h"

@interface YRUserInfoManager : NSObject
+(YRUserInfoManager *)manager;

@property (nonatomic,strong) NSString *password;

@property(nonatomic,strong,readonly)NSArray    *tableNames;

@property(nonatomic,strong,readwrite)UserModel *currentUser;

@property (nonatomic,strong) NSDictionary *openDic;

/** 开奖时间 **/
@property (nonatomic,assign) NSInteger winTime;

- (NSString*)showUserName;
//最后一次登录的user
- (NSString*)lastUuid;

- (void)removeLastUid;

@end
