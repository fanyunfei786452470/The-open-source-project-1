//
//  YRSunTextDetailGiftImageCell.m
//  YRYZ
//
//  Created by Mrs_zhang on 16/8/2.
//  Copyright © 2016年 yryz. All rights reserved.
//

#import "YRSunTextDetailGiftImageCell.h"

@implementation YRSunTextDetailGiftImageCell

- (instancetype)initWithFrame:(CGRect)frame{
 
    self = [super initWithFrame:frame];
    if (self) {
        
        UIImageView *iconImage = [UIImageView new];
        iconImage.frame = CGRectMake(0, 0, frame.size.height, frame.size.height);
        [self addSubview:iconImage];
        iconImage.image = [UIImage imageNamed:@"redPaperMoneyImage"];
        
        
        UILabel *countLab = [UILabel new];
        countLab.frame = CGRectMake(CGRectGetMaxX(iconImage.frame),frame.size.height-20, frame.size.width-frame.size.height, 20);
        countLab.font = [UIFont systemFontOfSize:13.f];
        countLab.textColor = [UIColor grayColor];
        countLab.textAlignment = NSTextAlignmentRight;
        [self addSubview:countLab];
        countLab.text = @"×5871";
        
    }
    return self;
}

@end
