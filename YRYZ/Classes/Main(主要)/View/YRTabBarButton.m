//
//  YRTabBarButton.m
//  YRYZ
//
//  Created by 易超 on 16/6/29.
//  Copyright © 2016年 yryz. All rights reserved.
//

#import "YRTabBarButton.h"

@implementation YRTabBarButton

#define YRTabBarButtonImageRatio 0.65
- (void)tabBarButtonAnimationCompletion:(tabBarActionBlock)completion{
    [UIView animateWithDuration:0.1f delay:0 options:UIViewAnimationOptionBeginFromCurrentState | UIViewAnimationOptionCurveEaseInOut
                     animations:^{
                         self.imageView.transform = CGAffineTransformMakeScale(1.5f, 1.5f);
                     } completion:^(BOOL finished) {
                         [UIView animateWithDuration:0.1f delay:0 options:UIViewAnimationOptionBeginFromCurrentState | UIViewAnimationOptionCurveEaseInOut
                                          animations:^{
                                              self.imageView.transform = CGAffineTransformMakeScale(0.9, 0.9);
                                          } completion:^(BOOL finished) {
                                              [UIView animateWithDuration:0.1f delay:0 options:UIViewAnimationOptionBeginFromCurrentState | UIViewAnimationOptionCurveEaseInOut
                                                               animations:^{
                                                                   self.imageView.transform = CGAffineTransformMakeScale(1.0f, 1.0f);
                                                               } completion:^(BOOL finished) {
                                                                   completion(self.isSelected);
                                                               }];
                                          }];
                     }];
}


- (void)setTitle:(NSString *)title NormalImage:(NSString *)tabBarNormal selImage:(NSString *)tabBarSel
{
    [self setImage:[UIImage imageNamed:tabBarNormal] forState:UIControlStateNormal];
    [self setImage:[UIImage imageNamed:tabBarSel] forState:UIControlStateSelected];
    [self setTitle:title forState:UIControlStateNormal];
    self.imageView.contentMode = UIViewContentModeCenter;
    self.titleLabel.textAlignment = NSTextAlignmentCenter;
    
    // 设置文字的字体
    self.titleLabel.font = [UIFont systemFontOfSize:12];
    
    // 选中时文字的颜色
    UIColor *selColor = [UIColor themeColor];
    // 正常时候文字颜色
    UIColor *nolColor = [UIColor lightGrayColor];
    
    [self setTitleColor:selColor forState:UIControlStateSelected];
    [self setTitleColor:nolColor forState:UIControlStateNormal];
}

// 取消高亮状态
- (void)setHighlighted:(BOOL)highlighted
{
}

// 内部图片的frame
- (CGRect)imageRectForContentRect:(CGRect)contentRect
{
    CGFloat imageW = contentRect.size.width;
    CGFloat imageH = contentRect.size.height * YRTabBarButtonImageRatio;
    return CGRectMake(0, 0, imageW, imageH);
}

// 内部文字的frame
- (CGRect)titleRectForContentRect:(CGRect)contentRect
{
    CGFloat titleY = contentRect.size.height * YRTabBarButtonImageRatio;
    CGFloat titleW = contentRect.size.width;
    CGFloat titleH = contentRect.size.height - titleY;
    
    return CGRectMake(0, titleY, titleW, titleH);
}

@end
