//
//  YRLoginController.h
//  Rrz
//
//  Created by 易超 on 16/7/4.
//  Copyright © 2016年 rongzhongwang. All rights reserved.
//

#import "BaseViewController.h"
#import "UserModel.h"
#import <UIKit/UIKit.h>
@protocol LoginSuccessDelegate <NSObject>

- (void)loginSuccessDelegate:(UserModel*)userModel;

@end


@interface YRLoginController : BaseViewController

@property (nonatomic,assign) BOOL isLogin;

@property (nonatomic ,assign) id<LoginSuccessDelegate>   loginSuccessDelegate;

@end
