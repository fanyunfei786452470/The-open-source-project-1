//
//  UIImage+Helper.h
//  Rrz
//
//  Created by weishibo on 16/2/17.
//  Copyright © 2016年 rongzhongwang. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImage (Helper)
+ (UIImage*)defaultHead;
+ (UIImage*)defaultImage;

/**
 *  @author yichao, 16-03-07 16:03:00
 *
 *  利用图形上下文对图片进行圆角处理
 */
- (instancetype)yc_circleImage;

/**
 *  @author yichao, 16-03-07 16:03:01
 *
 *  利用图形上下文设置图片的圆角
 */
- (UIImage *)yc_imageWithRoundedCornersAndSize:(CGSize)sizeToFit andCornerRadius:(CGFloat)radius;
- (UIImage*)imageByScalingAndCroppingForSize:(CGSize)targetSize;
/*****压缩图片*****/
- (UIImage *)resetSizeOfMaxSize:(NSInteger)maxSize;
- (NSData *)imageWithImageScaledToSize:(CGSize)newSize;
//压缩图片
- (NSData *)resetSizeOfImageData;
@end