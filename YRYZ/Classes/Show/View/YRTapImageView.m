//
//  YRTapImageView.m
//  YRYZ
//
//  Created by Mrs_zhang on 16/7/22.
//  Copyright © 2016年 yryz. All rights reserved.
//

#import "YRTapImageView.h"

@implementation YRTapImageView

- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {

        self.userInteractionEnabled = YES;
        [self addTapGesturesTarget:self selector:@selector(tapAction:)];
        
    }
    return self;
}

- (void)tapAction:(UITapGestureRecognizer *)tap{

    if ([self.delegate respondsToSelector:@selector(didSeleteImageViewWithTag:)]) {
        [self.delegate didSeleteImageViewWithTag:self.tag];
    }
     
}
@end
