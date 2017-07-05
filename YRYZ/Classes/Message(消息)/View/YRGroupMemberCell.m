//
//  YRGroupMemberCell.m
//  YRYZ
//
//  Created by Mrs_zhang on 16/7/14.
//  Copyright © 2016年 yryz. All rights reserved.
//

#import "YRGroupMemberCell.h"

@implementation YRGroupMemberCell

- (void)awakeFromNib {
    [super awakeFromNib];

    self.headerImg.layer.cornerRadius = 3.f;
    self.headerImg.clipsToBounds = YES;
    self.nameLab.textColor = [UIColor wordColor];
    
    CALayer *layer = [CALayer layer];
    layer.frame = CGRectMake(13, 56, SCREEN_WIDTH-13, 1);
    layer.backgroundColor = RGB_COLOR(245, 245, 245).CGColor;
    [self.layer addSublayer:layer];

}


/**
 *  @author ZX, 16-07-14 10:07:26
 *
 *  勾选按钮
 *
 *  @param sender 按钮
 */
- (IBAction)seleteButton:(UIButton *)sender {
    
    
    
}


@end
