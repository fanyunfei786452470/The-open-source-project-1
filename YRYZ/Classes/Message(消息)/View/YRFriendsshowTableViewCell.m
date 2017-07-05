//
//  YRFriendsshowTableViewCell.m
//  YRYZ
//
//  Created by Mrs_zhang on 16/7/14.
//  Copyright © 2016年 yryz. All rights reserved.
//

#import "YRFriendsshowTableViewCell.h"

@implementation YRFriendsshowTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
    self.headerImg.layer.cornerRadius = 3.f;
    self.headerImg.clipsToBounds = YES;
    
    CALayer *layer = [CALayer layer];
    layer.frame = CGRectMake(15, 69, SCREEN_WIDTH-15, 1);
    layer.backgroundColor = RGB_COLOR(245, 245, 245).CGColor;
    [self.layer addSublayer:layer];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
