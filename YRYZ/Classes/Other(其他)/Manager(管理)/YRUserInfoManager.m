//
//  YRUserInfoManager.m
//  YRYZ
//
//  Created by 易超 on 16/7/19.
//  Copyright © 2016年 yryz. All rights reserved.
//

#import "YRUserInfoManager.h"
#import "YRYYCache.h"

static NSString *kLastUserKey = @"YryzLastUserKey";

@interface YRUserInfoManager ()

@property(nonatomic,strong)NSString       *lastUserID;


@end

@implementation YRUserInfoManager

+(YRUserInfoManager *)manager{
    static YRUserInfoManager *manager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        manager = [[self alloc] init];
    });
    return manager;
}




/**
 *  @author weishibo, 16-07-01 15:07:56
 *
 *  保存最后登录的账户信息
 *
 *  @param currentUser <#currentUser description#>
 */
- (void)setCurrentUser:(UserModel *)currentUser{
    
    _currentUser = currentUser;
    if (_currentUser) {
        self.lastUserID = _currentUser.custId;
        [[NSUserDefaults standardUserDefaults]setObject:self.lastUserID forKey:kLastUserKey];
        [[NSUserDefaults standardUserDefaults] synchronize];
    }
}

- (NSString*)lastUuid
{
    if (!_lastUserID) {
        _lastUserID = [[NSUserDefaults standardUserDefaults] objectForKey:kLastUserKey];
    }
    return _lastUserID;
}

- (void)removeLastUid
{
    _lastUserID = @"";
    [[NSUserDefaults standardUserDefaults]setObject:@"" forKey:kLastUserKey];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
}

@end
