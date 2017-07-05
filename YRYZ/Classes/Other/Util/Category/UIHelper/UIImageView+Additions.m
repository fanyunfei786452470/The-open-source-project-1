//
//  UIImageView+Additions.m
//  Orimuse
//
//  Created by Bingjie on 14/12/22.
//  Copyright (c) 2014年 Bingjie. All rights reserved.
//

#import "UIImageView+Additions.h"

@implementation UIImageView (Additions)


- (void)setCircleHeadWithPoint:(CGPoint)point radius:(CGFloat)radius
{
    self.contentMode = UIViewContentModeScaleToFill;
    self.clipsToBounds = YES;
    self.layer.cornerRadius = radius;
//    self.layer.shouldRasterize = YES;
    
    
//    CAShapeLayer *pMaskLayer = [CAShapeLayer layer];
//    self.layer.mask = pMaskLayer;
//    CAShapeLayer *pCircleLayer = [CAShapeLayer layer];
//    pCircleLayer.lineWidth = 3.0;
//    pCircleLayer.fillColor = [[UIColor clearColor] CGColor];
//    pCircleLayer.strokeColor = [[UIColor clearColor] CGColor];
//    [self.layer addSublayer:pCircleLayer];
//    self.contentMode = UIViewContentModeScaleToFill;
//    [self updateCirclePathAtLocation:point radius:radius mask:pMaskLayer circle:pCircleLayer];
}

- (NSData *)resetSizeOfImageData:(UIImage *)source_image{
    CGSize newSize;
    if(source_image.size.width / source_image.size.height > 750.0f / 1334.0f){
        newSize = CGSizeMake(750, source_image.size.height * 750.0f / source_image.size.width);
    }else{
        newSize = CGSizeMake(source_image.size.width * 1334.0f / source_image.size.height, 1334);
    }
    UIGraphicsBeginImageContext(newSize);
    [source_image drawInRect:CGRectMake(0,0,newSize.width,newSize.height)];
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    //调整大小
    NSData *imageData = UIImageJPEGRepresentation(newImage, 0.5);
    return imageData;
}

- (void)setCircleHeadRadius:(CGFloat)radius strokeColor:(UIColor*)color
{
    CAShapeLayer *pMaskLayer = [CAShapeLayer layer];
    self.layer.mask = pMaskLayer;
    CAShapeLayer *pCircleLayer = [CAShapeLayer layer];
    pCircleLayer.lineWidth = 5.0;
    pCircleLayer.fillColor = [[UIColor clearColor] CGColor];
    pCircleLayer.strokeColor = [color CGColor];
    [self.layer addSublayer:pCircleLayer];
    self.contentMode = UIViewContentModeScaleToFill;
    [self updateCirclePathAtLocation:CGPointMake(radius, radius) radius:radius mask:pMaskLayer circle:pCircleLayer];
}

- (void)updateCirclePathAtLocation:(CGPoint)location radius:(CGFloat)radius mask:(CAShapeLayer*)maskLayer circle:(CAShapeLayer*)circle
{
    
    UIBezierPath *path = [UIBezierPath bezierPath];
    [path addArcWithCenter:location
                    radius:radius
                startAngle:0.0
                  endAngle:M_PI * 2.0
                 clockwise:YES];
    
    maskLayer.path = [path CGPath];
    circle.path = [path CGPath];
}


- (void)doCircleFrame{
    self.layer.masksToBounds = YES;
    self.layer.cornerRadius = self.frame.size.width/2;
    self.layer.borderWidth = 0.5;
    self.layer.borderColor = [UIColor colorWithHexString:@"0xdddddd"].CGColor;
}
- (void)doNotCircleFrame{
    self.layer.cornerRadius = 0.0;
    self.layer.borderWidth = 0.0;
}

- (void)doBorderWidth:(CGFloat)width color:(UIColor *)color cornerRadius:(CGFloat)cornerRadius{
    self.layer.masksToBounds = YES;
    self.layer.cornerRadius = cornerRadius;
    self.layer.borderWidth = width;
    if (!color) {
        self.layer.borderColor = [UIColor colorWithHexString:@"0xdddddd"].CGColor;
    }else{
        self.layer.borderColor = color.CGColor;
    }
}


@end