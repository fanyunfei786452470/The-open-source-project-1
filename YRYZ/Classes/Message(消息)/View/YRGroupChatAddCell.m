//
//  YRGroupChatAddCell.m
//  YRYZ
//
//  Created by Mrs_zhang on 16/7/13.
//  Copyright © 2016年 yryz. All rights reserved.
//

#import "YRGroupChatAddCell.h"
#define itemHeight (kScreenWidth-140)/4

@implementation YRGroupChatAddCell

- (instancetype)initWithFrame:(CGRect)frame{

    self = [super initWithFrame:frame];
    if (self) {
        
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0,itemHeight , itemHeight)];
        imageView.image = [UIImage imageNamed:@"yr_msg_add"];
        [self addSubview:imageView];
        
        imageView.layer.cornerRadius = 3.f;
        imageView.clipsToBounds = YES;
        self.imageView = imageView;
        
    }
    return self;
}

@end
