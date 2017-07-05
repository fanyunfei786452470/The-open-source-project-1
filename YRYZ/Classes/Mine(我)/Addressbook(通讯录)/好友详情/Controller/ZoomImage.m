//
//  ZoomImage.m
//  YRYZ
//
//  Created by Sean on 16/10/20.
//  Copyright © 2016年 yryz. All rights reserved.
//

#import "ZoomImage.h"

static CGRect oldframe;

@implementation ZoomImage



+(void)showImage:(UIImageView*)avatarImageView

{
    
    UIImage *image =avatarImageView.image;
    
    UIWindow *window =[UIApplication sharedApplication].keyWindow;
    
    UIView *backgroundView =[[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
    
    oldframe =[avatarImageView convertRect:avatarImageView.bounds toView:window];
    
    backgroundView.backgroundColor =[UIColor blackColor];
    
    backgroundView.alpha =0.5;
    
    UIImageView *imageView =[[UIImageView alloc]initWithFrame:oldframe];
    
    imageView.image =image;
    
    imageView.tag =1;
    
    [backgroundView addSubview:imageView];
    
    [window addSubview:backgroundView];
    
    //点击图片缩小的手势
    
    UITapGestureRecognizer *tap =[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(hideImage:)];
    
    [backgroundView addGestureRecognizer:tap];
    
    
    
    [UIView animateWithDuration:0.3 animations:^{
        
        imageView.frame =CGRectMake(0,([UIScreen mainScreen].bounds.size.height-image.size.height*[UIScreen mainScreen].bounds.size.width/image.size.width)/2, [UIScreen mainScreen].bounds.size.width, image.size.height*[UIScreen mainScreen].bounds.size.width/image.size.width);
        
        backgroundView.alpha =1;
        
    }];
    
}

+(void)hideImage:(UITapGestureRecognizer *)tap{
    
    UIView *backgroundView =tap.view;
    
    UIImageView *imageView =(UIImageView *)[tap.view viewWithTag:1];
    
    [UIView animateWithDuration:0.3 animations:^{
        
        imageView.frame =oldframe;
        
        backgroundView.alpha =0;
        
    } completion:^(BOOL finished) {
        
        [backgroundView removeFromSuperview];
        
    }];
}

@end
