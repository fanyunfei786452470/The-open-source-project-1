//
//  UIBarButtonItem+Item.m
//  01-BuDeJie
//
//  Created by 1 on 15/12/18.
//  Copyright © 2015年 xiaomage. All rights reserved.
//

#import "UIBarButtonItem+Item.h"

@implementation UIBarButtonItem (Item)



//+ (UIBarButtonItem *)itemWithBtnTitle:(NSString *)title
//                               target:(id)obj
//                               action:(SEL)selector
//{
//    UIBarButtonItem *buttonItem = [[UIBarButtonItem alloc] initWithTitle:title style:UIBarButtonItemStylePlain target:obj action:selector];
//    [buttonItem setTitleTextAttributes:@{NSForegroundColorAttributeName: [UIColor lightGrayColor]} forState:UIControlStateDisabled];
//    return buttonItem;
//}
//
//+ (UIBarButtonItem*)itemWithBtnImage:(NSString *)imageName
//                              target:(id)obj
//                              action:(SEL)selector
//{
//    
//    UIBarButtonItem *buttonItem = [[UIBarButtonItem alloc]
//                                   initWithImage:[UIImage imageNamed:imageName] style:UIBarButtonItemStylePlain target:obj action:selector];
//    return buttonItem;
//}

+ (UIBarButtonItem *)itemWithImage:(UIImage *)image highImage:(UIImage *)highImage target:(nullable id)target action:(nullable SEL)action
{
    UIButton *leftButton = [UIButton buttonWithType:UIButtonTypeCustom];
    leftButton.titleLabel.font = [UIFont systemFontOfSize:15];
    [leftButton setImage:image forState:UIControlStateNormal];
    [leftButton setImage:highImage forState:UIControlStateHighlighted];
    // 自适应尺寸:自动根据按钮图片和文字计算按钮大小
    [leftButton sizeToFit];
    [leftButton addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
    
    return  [[UIBarButtonItem alloc] initWithCustomView:leftButton];
    
}

+ (UIBarButtonItem *)itemWithImage:(UIImage *)image selImage:(UIImage *)selImage target:(nullable id)target action:(nullable SEL)action
{
    UIButton *leftButton = [UIButton buttonWithType:UIButtonTypeCustom];
    leftButton.titleLabel.font = [UIFont systemFontOfSize:15];
    [leftButton setImage:image forState:UIControlStateNormal];
    [leftButton setImage:selImage forState:UIControlStateSelected];
    // 自适应尺寸:自动根据按钮图片和文字计算按钮大小
    [leftButton sizeToFit];
    [leftButton addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
    
    return  [[UIBarButtonItem alloc] initWithCustomView:leftButton];
    
}

+ (UIBarButtonItem *)backItemWithImage:(UIImage *)image highImage:(UIImage *)highImage target:(nullable id)target action:(nullable SEL)action norColor:(UIColor *)norColor highColor:(UIColor *)highColor title:(NSString *)title
{
    UIButton *backButton = [UIButton buttonWithType:UIButtonTypeCustom];
    backButton.titleLabel.font = [UIFont systemFontOfSize:15];
    // 设置标题
    [backButton setTitle:title forState:UIControlStateNormal];
    
    // 设置图片
    [backButton setImage:image forState:UIControlStateNormal];
    [backButton setImage:highImage forState:UIControlStateHighlighted];
    
    // 设置标题颜色
    [backButton setTitleColor:norColor forState:UIControlStateNormal];
    [backButton setTitleColor:highColor forState:UIControlStateHighlighted];
    
    // 自适应尺寸:自动根据按钮图片和文字计算按钮大小
    [backButton sizeToFit];
    [backButton addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
    
    // 设置按钮内容内边距
    backButton.contentEdgeInsets = UIEdgeInsetsMake(0, -20, 0, 0);
    
    return  [[UIBarButtonItem alloc] initWithCustomView:backButton];
    
}

+ (UIBarButtonItem *)titleItemWithImage:(UIImage *)image highImage:(UIImage *)highImage target:(nullable id)target action:(nullable SEL)action norColor:(UIColor *)norColor highColor:(UIColor *)highColor title:(NSString *)title
{
    UIButton *backButton = [UIButton buttonWithType:UIButtonTypeCustom];
    backButton.titleLabel.font = [UIFont systemFontOfSize:15];
    // 设置标题
    [backButton setTitle:title forState:UIControlStateNormal];
    
    // 设置图片
    [backButton setImage:image forState:UIControlStateNormal];
    [backButton setImage:highImage forState:UIControlStateHighlighted];
    
    // 设置标题颜色
    [backButton setTitleColor:norColor forState:UIControlStateNormal];
    [backButton setTitleColor:highColor forState:UIControlStateHighlighted];
    
    // 自适应尺寸:自动根据按钮图片和文字计算按钮大小
    [backButton sizeToFit];
    [backButton addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
    
    // 设置按钮内容内边距
    backButton.contentEdgeInsets = UIEdgeInsetsMake(0, -20, 0, 0);
    
    return  [[UIBarButtonItem alloc] initWithCustomView:backButton];
    
}

+ (UIBarButtonItem *)itemWithTitle:(NSString *)title selTitle:(NSString *)selTitle target:(nullable id)target action:(nullable SEL)action norColor:(UIColor *)norColor selColor:(UIColor *)selColor
{
    UIButton *backButton = [UIButton buttonWithType:UIButtonTypeCustom];
    backButton.titleLabel.font = [UIFont systemFontOfSize:15];
    // 设置默认标题
    [backButton setTitle:title forState:UIControlStateNormal];
    // 设置选中标题
    [backButton setTitle:selTitle forState:UIControlStateSelected];
    
    // 设置标题颜色
    [backButton setTitleColor:norColor forState:UIControlStateNormal];
    [backButton setTitleColor:selColor forState:UIControlStateSelected];
    
    // 自适应尺寸:自动根据按钮图片和文字计算按钮大小
    [backButton sizeToFit];
    [backButton addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
    
    // 设置按钮内容内边距
    backButton.contentEdgeInsets = UIEdgeInsetsMake(0, -20, 0, 0);
    
    return  [[UIBarButtonItem alloc] initWithCustomView:backButton];
    
}

+ (UIBarButtonItem *)itemWithTitle:(NSString *)title highTitle:(NSString *)highTitle target:(nullable id)target action:(nullable SEL)action norColor:(UIColor *)norColor highColor:(UIColor *)highColor
{
    UIButton *backButton = [UIButton buttonWithType:UIButtonTypeCustom];
    backButton.titleLabel.font = [UIFont systemFontOfSize:15];
    // 设置默认标题
    [backButton setTitle:title forState:UIControlStateNormal];
    // 设置选中标题
    [backButton setTitle:highTitle forState:UIControlStateHighlighted];
    
    // 设置标题颜色
    [backButton setTitleColor:norColor forState:UIControlStateNormal];
    [backButton setTitleColor:highColor forState:UIControlStateHighlighted];
    
    // 自适应尺寸:自动根据按钮图片和文字计算按钮大小
    [backButton sizeToFit];
    [backButton addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
    
    // 设置按钮内容内边距
    backButton.contentEdgeInsets = UIEdgeInsetsMake(0, -20, 0, 0);
    
    return  [[UIBarButtonItem alloc] initWithCustomView:backButton];
    
}



@end
