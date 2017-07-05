//
//  YRGroupChatMinusCell.m
//  YRYZ
//
//  Created by Mrs_zhang on 16/7/18.
//  Copyright © 2016年 yryz. All rights reserved.
//

#import "YRGroupChatMinusCell.h"

@implementation YRGroupChatMinusCell

- (instancetype)initWithFrame:(CGRect)frame{
    
    self = [super initWithFrame:frame];
    if (self) {
        
        self.imageView.image = [UIImage imageNamed:@"yr_msg_cut"];

        
    }
    return self;
}

@end
