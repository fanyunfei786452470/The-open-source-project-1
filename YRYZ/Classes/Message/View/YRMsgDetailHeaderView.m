//
//  YRMsgDetailHeaderView.m
//  YRYZ
//
//  Created by Mrs_zhang on 16/7/13.
//  Copyright © 2016年 yryz. All rights reserved.
//

#import "YRMsgDetailHeaderView.h"

@implementation YRMsgDetailHeaderView

- (instancetype)initWithFrame:(CGRect)frame Image:(UIImage *)image Name:(NSString *)name{

    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
        
        UIImageView *imgView = [[UIImageView alloc] init];
        imgView.mj_x = 25.f;
        imgView.mj_y = 15.f;
        imgView.mj_w = 60.f;
        imgView.mj_h = 60.f;
        imgView.userInteractionEnabled = YES;
        [self addSubview:imgView];
        [imgView addTapGesturesTarget:self selector:@selector(imageDidClick)];
        
        UILabel *nameLab = [[UILabel alloc] init];
        nameLab.mj_x = 25.f;
        nameLab.mj_y = CGRectGetMaxY(imgView.frame) + 10.f;
        nameLab.mj_w = 200.f;
        nameLab.mj_h = 30.f;
        nameLab.font = [UIFont systemFontOfSize:16.f];
        nameLab.textColor = RGB_COLOR(136, 136, 136);
        nameLab.textAlignment = NSTextAlignmentLeft;
        [self addSubview:nameLab];
        
        imgView.image = image?image:[UIImage imageNamed:@"yr_user_defaut"];
        nameLab.text = name;
        
        CALayer *layer = [CALayer layer];
        layer.frame = CGRectMake(0, CGRectGetMaxY(nameLab.frame) + 10, SCREEN_WIDTH, 10);
        layer.backgroundColor = RGB_COLOR(245, 245, 245).CGColor;
        [self.layer addSublayer:layer];

    }
    
    return self;
}

/**
 *  @author ZX, 16-09-10 13:09:10
 *
 *  头像点击
 */
- (void)imageDidClick{

    self.didHeadImg();

}

@end
