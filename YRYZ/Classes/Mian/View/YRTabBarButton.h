//
//  YRTabBarButton.h
//  YRYZ
//
//  Created by 易超 on 16/6/29.
//  Copyright © 2016年 yryz. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef void(^tabBarActionBlock)(BOOL isSelectd);

@interface YRTabBarButton : UIButton

- (void)setTitle:(NSString *)title  NormalImage:(NSString *)tabBarNormal selImage:(NSString *)tabBarSel;
- (void)tabBarButtonAnimationCompletion:(tabBarActionBlock)completion;

@end
