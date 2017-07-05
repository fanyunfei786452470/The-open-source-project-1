//
//  YRTarBarBigButton.m
//  YRYZ
//
//  Created by 易超 on 16/6/30.
//  Copyright © 2016年 yryz. All rights reserved.
//

#import "YRTarBarBigButton.h"

@interface YRTarBarBigButton ()

/**
 *  背景
 */
@property(nonatomic, weak) UIView *bgView;

@end


@implementation YRTarBarBigButton


- (void)setNormalImage:(NSString *)tabBarNormal selImage:(NSString *)tabBarSel{
    
    [self setImage:[UIImage imageNamed:tabBarNormal] forState:UIControlStateNormal];
    self.imageView.contentMode = UIViewContentModeCenter;
    
    
}


// 内部图片的frame
//- (CGRect)imageRectForContentRect:(CGRect)contentRect
//{
//    CGFloat imageW = contentRect.size.width;
//    CGFloat imageH = contentRect.size.height;
//    return CGRectMake(0, 0, imageW, imageH);
//}
//
//-(CGRect)titleRectForContentRect:(CGRect)contentRect{
//    return CGRectMake(0, 0, 0, 0);
//}

-(void)layoutSubviews{
    [super layoutSubviews];
    
    self.imageView.frame = CGRectMake(0, 0, self.width, self.height);
}

@end
