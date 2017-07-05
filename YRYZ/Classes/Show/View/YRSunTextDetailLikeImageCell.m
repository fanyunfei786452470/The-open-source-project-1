//
//  YRSunTextDetailLikeImageCell.m
//  YRYZ
//
//  Created by Mrs_zhang on 16/8/2.
//  Copyright © 2016年 yryz. All rights reserved.
//

#import "YRSunTextDetailLikeImageCell.h"

@implementation YRSunTextDetailLikeImageCell
- (instancetype)initWithFrame:(CGRect)frame{
    
    self = [super initWithFrame:frame];
    if (self) {
        
        UIImageView *iconImage = [UIImageView new];
        iconImage.frame = CGRectMake(0, 0, frame.size.width, frame.size.height);
        iconImage.contentMode = UIViewContentModeScaleAspectFill;
        iconImage.clipsToBounds = YES;
        [self addSubview:iconImage];
        iconImage.image = [UIImage imageNamed:@"yr_user_defaut"];
        
        self.headImg = iconImage;
    }
    return self;
}

@end
