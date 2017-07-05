//
//  RRZSaveMoenyCell.m
//  Rrz
//
//  Created by 易超 on 16/5/2.
//  Copyright © 2016年 rongzhongwang. All rights reserved.
//

#import "RRZSaveMoenyCell.h"

@interface RRZSaveMoenyCell()





@end

@implementation RRZSaveMoenyCell

- (void)awakeFromNib {
    [super awakeFromNib];
//    self.backgroundColor = RGB_COLOR(245, 245, 245);
    [self.bgImageView setCircleHeadWithPoint:CGPointMake(64, 64) radius:4];
}

-(void)setTitle:(NSString *)title{
    _title = title;
    
    self.titleLabel.text = [NSString stringWithFormat:@"%@元",title];
}

@end
