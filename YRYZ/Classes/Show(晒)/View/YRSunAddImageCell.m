//
//  YRSunAddImageCell.m
//  YRYZ
//
//  Created by Mrs_zhang on 16/7/29.
//  Copyright © 2016年 yryz. All rights reserved.
//

#import "YRSunAddImageCell.h"

@implementation YRSunAddImageCell

- (instancetype)initWithFrame:(CGRect)frame{

    self = [super initWithFrame:frame];
    if (self) {
        
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, frame.size.width, frame.size.height)];
        imageView.image = [UIImage imageNamed:@"yr_msg_add"];

        [self addSubview:imageView];
        self.imgV = imageView;
        
    }
    return self;
}
@end
