//
//  YRMineLoginController.h
//  YRYZ
//
//  Created by Sean on 16/9/29.
//  Copyright © 2016年 yryz. All rights reserved.
//

#import "UserModel.h"
#import <UIKit/UIKit.h>
@protocol LoginSuccessDelegate <NSObject>

- (void)loginSuccessDelegate:(UserModel*)userModel;

@end


@interface YRMineLoginController : UIViewController
@property (nonatomic,assign) BOOL isLogin;

@property (nonatomic ,assign) id<LoginSuccessDelegate>   loginSuccessDelegate;
@end
