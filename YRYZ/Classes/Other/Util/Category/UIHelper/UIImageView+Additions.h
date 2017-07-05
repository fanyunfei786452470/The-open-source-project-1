//
//  UIImageView+Additions.h
//  Orimuse
//
//  Created by Bingjie on 14/12/22.
//  Copyright (c) 2014年 Bingjie. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImageView (Additions)


- (void)setCircleHeadWithPoint:(CGPoint)point radius:(CGFloat)radius;

- (void)setCircleHeadRadius:(CGFloat)radius strokeColor:(UIColor*)color;

- (void)doCircleFrame;

- (void)doNotCircleFrame;

//压缩图片返回nsdata
- (NSData *)resetSizeOfImageData:(UIImage *)source_image;

/**
 *  当cornerRadius = self.frame.size.width / 2 时候，显示为圆形
 *
 *  @param width        BorderWidth
 *  @param color        BorderColor
 *  @param cornerRadius cornerRadius
 */
- (void)doBorderWidth:(CGFloat)width color:(UIColor *)color cornerRadius:(CGFloat)cornerRadius;


@end
