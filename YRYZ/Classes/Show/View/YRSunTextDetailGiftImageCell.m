//
//  YRSunTextDetailGiftImageCell.m
//  YRYZ
//
//  Created by Mrs_zhang on 16/8/2.
//  Copyright © 2016年 yryz. All rights reserved.
//

#import "YRSunTextDetailGiftImageCell.h"
#import "YRGiftListModel.h"

@interface YRSunTextDetailGiftImageCell()



@end

@implementation YRSunTextDetailGiftImageCell

- (instancetype)initWithFrame:(CGRect)frame{
 
    self = [super initWithFrame:frame];
    if (self) {
        
        UIImageView *iconImage = [UIImageView new];
        iconImage.frame = CGRectMake(0, 0, frame.size.height, frame.size.height);
        iconImage.backgroundColor = RGB_COLOR(245, 245, 245);
        iconImage.contentMode = UIViewContentModeScaleAspectFill;
        iconImage.clipsToBounds = YES;
        [self addSubview:iconImage];
        self.iconImg = iconImage;
        
        UILabel *countLab = [UILabel new];
        countLab.frame = CGRectMake(CGRectGetMaxX(iconImage.frame),frame.size.height-20, frame.size.width-frame.size.height, 20);
        countLab.font = [UIFont systemFontOfSize:13.f];
        countLab.textColor = [UIColor grayColor];
        countLab.textAlignment = NSTextAlignmentLeft;
        [self addSubview:countLab];
        self.countLab = countLab;
        
    }
    return self;
}

//- (void)setModel:(YRGiftListModel *)model{
//    
////    [self.iconImg setImageWithURL:[NSURL URLWithString:model.gitfimg] placeholder:[UIImage imageNamed:@"testImage"]];
////
//    self.iconImg.image = [UIImage imageNamed:@"testImage"];
//    self.countLab.text = [NSString stringWithFormat:@"×%ld",model.count];
//}

@end
