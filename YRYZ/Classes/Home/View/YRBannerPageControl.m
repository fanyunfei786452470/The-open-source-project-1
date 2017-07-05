//
//  YRBannerPageControl.m
//  YRYZ
//
//  Created by Rongzhong on 16/7/25.
//  Copyright © 2016年 yryz. All rights reserved.
//

#import "YRBannerPageControl.h"

@implementation YRBannerPageControl
{
    UIImage* activeImage;
    UIImage* inactiveImage;
}

-(id) initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    activeImage = [UIImage imageNamed:@"selectedPointImage"];
    inactiveImage = [UIImage imageNamed:@"unSelectedPointImage"];
    
    return self;
}

-(void) updateDots
{
    for (int i=0; i<[self.subviews count]; i++) {
        UIView* dot = [self.subviews objectAtIndex:i];
        CGSize size;
        size.height = 5;     //自定义圆点的大小
        size.width = 12;      //自定义圆点的大小

        dot.bounds = CGRectMake(0, 0, size.width, size.height);
        dot.backgroundColor = [UIColor clearColor];
        
        for (UIView *view in dot.subviews) {
            [view removeFromSuperview];
        }
        //[dot setFrame:CGRectMake(dot.frame.origin.x, dot.frame.origin.y, size.width, size.width)];
        
        UIImageView *dotImageView = [[UIImageView alloc]init];
        dotImageView.tag = 1;
        dotImageView.frame = dot.bounds;
        [dot addSubview:dotImageView];
        
        if (i == self.currentPage){
            UIImageView *dotImageView = [dot viewWithTag:1];
            dotImageView.image = activeImage;
        }else{
            UIImageView *dotImageView = [dot viewWithTag:1];
            dotImageView.image = inactiveImage;
        }
    }
}


-(void) setCurrentPage:(NSInteger)page
{
    [super setCurrentPage:page];
    [self updateDots];
}

@end
