//
//  YRTabBar.h
//  YRYZ
//
//  Created by 易超 on 16/6/29.
//  Copyright © 2016年 yryz. All rights reserved.
//

#import <UIKit/UIKit.h>

@class YRTabBar;

@protocol YRTabBarDelegate <NSObject>

@optional
- (void)tabBar:(YRTabBar *)tabBar didClickFrom:(NSInteger)from to:(NSInteger)to;

@end

@interface YRTabBar : UIView

@property(nonatomic, weak) id<YRTabBarDelegate> delegate;

-(void)addTabBarItemWithTitle:(NSString *)title NormalImage:(NSString *)tabBarNormal selImage:(NSString *)tabBarSel;

-(void)addBigTabBarItemWithTitle:(NSString *)title NormalImage:(NSString *)tabBarNormal selImage:(NSString *)tabBarSel;

@end
