//
//  YRTabBar.m
//  YRYZ
//
//  Created by 易超 on 16/6/29.
//  Copyright © 2016年 yryz. All rights reserved.
//

#import "YRTabBar.h"
#import "YRTabBarButton.h"
#import "YRTarBarBigButton.h"


@interface YRTabBar ()
// 记录被选中的按钮
@property (weak, nonatomic) UIButton *selectedBtn;

@end

@implementation YRTabBar

-(void)addTabBarItemWithTitle:(NSString *)title NormalImage:(NSString *)tabBarNormal selImage:(NSString *)tabBarSel
{
    YRTabBarButton *tabBarButton = [YRTabBarButton buttonWithType:UIButtonTypeCustom];
    [tabBarButton setTitle:title NormalImage:tabBarNormal selImage:tabBarSel];
    
    tabBarButton.titleLabel.font = [UIFont systemFontOfSize:12 weight:1.1];
    [tabBarButton setTitleColor:RGB_COLOR(102,102,102) forState:UIControlStateNormal];
    [tabBarButton setTitleColor:RGB_COLOR(19, 161, 152) forState:UIControlStateSelected];
    
    [tabBarButton addTarget:self action:@selector(buttonDidClick:) forControlEvents:UIControlEventTouchDown];
    [self addSubview:tabBarButton];
}

-(void)addBigTabBarItemWithTitle:(NSString *)title NormalImage:(NSString *)tabBarNormal selImage:(NSString *)tabBarSel{
    YRTarBarBigButton *tabBarButton = [YRTarBarBigButton buttonWithType:UIButtonTypeCustom];
    [tabBarButton setNormalImage:tabBarNormal selImage:tabBarSel];
//     tabBarButton.titleLabel.font = [UIFont systemFontOfSize:12];
  
    [tabBarButton addTarget:self action:@selector(buttonDidClick:) forControlEvents:UIControlEventTouchDown];
    [self addSubview:tabBarButton];
}

// 监听按钮点击事件
- (void)buttonDidClick:(YRTabBarButton *)button
{
    
//        [button tabBarButtonAnimationCompletion:^(BOOL isSelectd) {
            if ([self.delegate respondsToSelector:@selector(tabBar:didClickFrom:to:)]) {
                [self.delegate tabBar:self didClickFrom:self.selectedBtn.tag to:button.tag];
                self.selectedBtn.selected = NO;
                self.selectedBtn = button;
                self.selectedBtn.selected = YES;
            }
//        }];
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    
    NSInteger count = self.subviews.count;
    CGFloat width;
    CGFloat height;
    
    for (int i = 0; i < count; i++) {
        CGFloat x;
        CGFloat y;
        
        if (i == 2) {
      
            if (SCREEN_WIDTH == 375.f) {
                y = -22;
            }else if (SCREEN_WIDTH == 414.f){
                y = -25;
            }else{
                y = -20;
            }
            x = i * (self.bounds.size.width / count)-10;
            width = self.bounds.size.width / count +20;
            height = self.bounds.size.height + 80;
            
        }else{
            
            y = 0;
            width = self.bounds.size.width / count;
            height = self.bounds.size.height;
            x = i * width;

        }

        // 让第一个btn默认选中
        UIButton *btn = self.subviews[i];
        btn.tag = i;
        if (btn.tag  == 0) {
            btn.selected = YES;
            self.selectedBtn = btn;
        }
        btn.frame = CGRectMake(x, y, width, height);
    }
}

@end
