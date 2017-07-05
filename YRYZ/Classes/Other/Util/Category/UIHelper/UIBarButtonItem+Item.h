//
//  UIBarButtonItem+Item.h
//  01-BuDeJie
//
//  Created by 1 on 15/12/18.
//  Copyright © 2015年 xiaomage. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIBarButtonItem (Item)
+ (UIBarButtonItem *)itemWithImage:(UIImage *)image highImage:(UIImage *)highImage target:(id)target action:(SEL)action;
+ (UIBarButtonItem *)itemWithImage:(UIImage *)image selImage:(UIImage *)selImage target:(id)target action:(SEL)action;
+ (UIBarButtonItem *)backItemWithImage:(UIImage *)image highImage:(UIImage *)highImage target:(id)target action:(SEL)action norColor:(UIColor *)norColor highColor:(UIColor *)highColor title:(NSString *)title;
+ (UIBarButtonItem *)titleItemWithImage:(UIImage *)image highImage:(UIImage *)highImage target:(id)target action:(SEL)action norColor:(UIColor *)norColor highColor:(UIColor *)highColor title:(NSString *)title;
+ (UIBarButtonItem *)itemWithTitle:(NSString *)title selTitle:(NSString *)selTitle target:(id)target action:(SEL)action norColor:(UIColor *)norColor selColor:(UIColor *)selColor;
+ (UIBarButtonItem *)itemWithTitle:(NSString *)title highTitle:(NSString *)highTitle target:(id)target action:(SEL)action norColor:(UIColor *)norColor highColor:(UIColor *)highColor;

@end
