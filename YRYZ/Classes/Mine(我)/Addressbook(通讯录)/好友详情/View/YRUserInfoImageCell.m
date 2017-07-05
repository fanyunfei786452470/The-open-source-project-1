//
//  YRUserInfoImageCell.m
//  YRYZ
//
//  Created by 易超 on 16/7/13.
//  Copyright © 2016年 yryz. All rights reserved.
//

#import "YRUserInfoImageCell.h"

@interface YRUserInfoImageCell()


@property (weak, nonatomic) IBOutlet UIView *containerView;

@end

@implementation YRUserInfoImageCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    if (SCREEN_WIDTH>=375) {
        self.image4 = [[UIImageView alloc]init];
        [self.containerView addSubview:self.image4];
    }
    self.titleLabel.font = [UIFont titleFont17];
}

-(void)layoutSubviews{
    [super layoutSubviews];
    if (SCREEN_WIDTH>=375) {
        self.image1.frame = CGRectMake(10, 0, 56, 56);
        self.image2.frame = CGRectMake(76, 0, 56, 56);
        self.image3.frame = CGRectMake(142, 0, 56, 56);
        self.image4.bounds = self.image3.bounds;
        self.image4.centerY = self.image3.centerY;
        self.image4.centerX = self.image3.centerX +10+56;        
    }
}


@end
