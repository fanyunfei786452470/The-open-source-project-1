//
//  UIImage+Helper.m
//  Rrz
//
//  Created by weishibo on 16/2/17.
//  Copyright © 2016年 rongzhongwang. All rights reserved.
//

#import "UIImage+Helper.h"
#import <Accelerate/Accelerate.h>
#import <QuartzCore/QuartzCore.h>

@implementation UIImage (Helper)



+ (UIImage*)defaultHead
{
    return [UIImage imageNamed:@"yr_user_defaut"];
}

+ (UIImage*)defaultImage
{
    return [UIImage imageNamed:@"r_rrz1"];
}

+ (UIImage*)defaultImage2
{
    return [UIImage imageNamed:@"r_rrz2"];
}

+ (UIImage*)defaultImage3
{
    return [UIImage imageNamed:@"r_rrz3"];
}



/**
 *  @author yichao, 16-03-07 16:03:00
 *
 *  利用图形上下文返回一个圆
 */
- (instancetype)yc_circleImage
{
    // 1.开启图形上下文
    UIGraphicsBeginImageContextWithOptions(self.size, NO, 0);
    
    // 2.描述圆形路径
    UIBezierPath *path = [UIBezierPath bezierPathWithOvalInRect:CGRectMake(0, 0, self.size.width, self.size.height)];
    // 3.设置裁剪区域
    [path addClip];
    
    // 4.画图
    [self drawAtPoint:CGPointZero];
    
    // 5.取出图片
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    
    // 6.关闭上下文
    UIGraphicsEndImageContext();
    
    return image;
}


/**
 *  @author yichao, 16-03-07 16:03:01
 *
 *  利用图形上下文设置图片的圆角
 */
- (UIImage *)yc_imageWithRoundedCornersAndSize:(CGSize)sizeToFit andCornerRadius:(CGFloat)radius
{
    CGRect rect = (CGRect){0.f, 0.f, sizeToFit};
    
    UIGraphicsBeginImageContextWithOptions(sizeToFit, NO, UIScreen.mainScreen.scale);
    CGContextAddPath(UIGraphicsGetCurrentContext(),
                     [UIBezierPath bezierPathWithRoundedRect:rect cornerRadius:radius].CGPath);
    CGContextClip(UIGraphicsGetCurrentContext());
    
    [self drawInRect:rect];
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    
    UIGraphicsEndImageContext();
    
    return image;
}



@end
