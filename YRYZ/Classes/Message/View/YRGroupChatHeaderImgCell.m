//
//  YRGroupChatHeaderCell.m
//  YRYZ
//
//  Created by Mrs_zhang on 16/7/13.
//  Copyright © 2016年 yryz. All rights reserved.
//

#import "YRGroupChatHeaderImgCell.h"
#define itemHeight (kScreenWidth-140)/4

@implementation YRGroupChatHeaderImgCell

- (instancetype)initWithFrame:(CGRect)frame{
    
    self = [super initWithFrame:frame];
    if (self) {
        
        self.imageView.image = [UIImage imageNamed:@"yr_msg_headImg"];
        
        UILabel *nameLab = [[UILabel alloc] init];
        nameLab.mj_x = 0;
        nameLab.mj_y = itemHeight+10;
        nameLab.mj_w = self.imageView.width;
        nameLab.mj_h = 15;
        nameLab.font = [UIFont systemFontOfSize:14.f];
        nameLab.textAlignment = NSTextAlignmentCenter;
        nameLab.textColor = RGB_COLOR(102, 102, 102);
        nameLab.text = @"吴莫愁";
        [self addSubview:nameLab];
  
        self.nameLab = nameLab;
    }
    return self;
}

@end
