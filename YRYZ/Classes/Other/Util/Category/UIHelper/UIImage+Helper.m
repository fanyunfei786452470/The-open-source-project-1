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
    return [UIImage imageNamed:@"yr_list_default"];
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

//图片压缩到指定大小
- (UIImage*)imageByScalingAndCroppingForSize:(CGSize)targetSize
{
    UIImage *sourceImage = self;
    UIImage *newImage = nil;
    CGSize imageSize = sourceImage.size;
    CGFloat width = imageSize.width;
    CGFloat height = imageSize.height;
    CGFloat targetWidth = targetSize.width;
    CGFloat targetHeight = targetSize.height;
    CGFloat scaleFactor = 0.0;
    CGFloat scaledWidth = targetWidth;
    CGFloat scaledHeight = targetHeight;
    CGPoint thumbnailPoint = CGPointMake(0.0,0.0);
    
    if (CGSizeEqualToSize(imageSize, targetSize) == NO)
    {
        CGFloat widthFactor = targetWidth / width;
        CGFloat heightFactor = targetHeight / height;
        
        if (widthFactor > heightFactor)
            scaleFactor = widthFactor; // scale to fit height
        else
            scaleFactor = heightFactor; // scale to fit width
        scaledWidth= width * scaleFactor;
        scaledHeight = height * scaleFactor;
        
        // center the image
        if (widthFactor > heightFactor)
        {
            thumbnailPoint.y = (targetHeight - scaledHeight) * 0.5;
        }
        else if (widthFactor < heightFactor)
        {
            thumbnailPoint.x = (targetWidth - scaledWidth) * 0.5;
        }
    }
    
    UIGraphicsBeginImageContext(targetSize); // this will crop
    
    CGRect thumbnailRect = CGRectZero;
    thumbnailRect.origin = thumbnailPoint;
    thumbnailRect.size.width= scaledWidth;
    thumbnailRect.size.height = scaledHeight;
    
    [sourceImage drawInRect:thumbnailRect];
    
    newImage = UIGraphicsGetImageFromCurrentImageContext();
    if(newImage == nil)
        NSLog(@"could not scale image");
    
    //pop the context to get back to the default
    UIGraphicsEndImageContext();
    return newImage;
}
// 压缩图片
- (UIImage *)resetSizeOfMaxSize:(NSInteger)maxSize
{
    //先调整分辨率
    CGSize newSize = CGSizeMake(self.size.width, self.size.height);
    CGFloat tempHeight = newSize.height / 1024;
    CGFloat tempWidth = newSize.width / 1024;
    if (tempWidth > 1.0 && tempWidth > tempHeight) {
        newSize = CGSizeMake(self.size.width / tempWidth, self.size.height / tempWidth);
    }
    else if (tempHeight > 1.0 && tempWidth < tempHeight){
        newSize = CGSizeMake(self.size.width / tempHeight, self.size.height / tempHeight);
    }
    UIGraphicsBeginImageContext(newSize);
    [self drawInRect:CGRectMake(0,0,newSize.width,newSize.height)];
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    //调整大小
    NSData *imageData;
    if (UIImagePNGRepresentation(newImage)) {
        imageData = UIImagePNGRepresentation(newImage);
    }else{
        imageData = UIImageJPEGRepresentation(newImage, 0.5);
    }
    NSUInteger sizeOrigin = [imageData length];
    NSUInteger sizeOriginKB = sizeOrigin / 1024;
    if (sizeOriginKB > maxSize) {
        NSData *finallImageData = UIImageJPEGRepresentation(newImage,0.50);
        UIImage *ima = [UIImage imageWithData:finallImageData];
        return ima;
    }
    UIImage *ima = [UIImage imageWithData:imageData];
    return ima;
}
- (NSData *)imageWithImageScaledToSize:(CGSize)newSize;
{
    UIGraphicsBeginImageContext(newSize);
    [self drawInRect:CGRectMake(0,0,newSize.width,newSize.height)];
    UIImage* newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return UIImageJPEGRepresentation(newImage, 0.1);
}
//压缩图片
- (NSData *)resetSizeOfImageData{
    CGSize newSize;
    if(self.size.width / self.size.height > 750.0f / 1334.0f){
        newSize = CGSizeMake(750, self.size.height * 750.0f / self.size.width);
    }else{
        newSize = CGSizeMake(self.size.width * 1334.0f / self.size.height, 1334);
    }
    UIGraphicsBeginImageContext(newSize);
    [self drawInRect:CGRectMake(0,0,newSize.width,newSize.height)];
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    //调整大小
    NSData *imageData = UIImageJPEGRepresentation(newImage, 0.5);
    return imageData;
}


@end
