//
//  YRAccountCell.m
//  YRYZ
//
//  Created by 易超 on 16/7/20.
//  Copyright © 2016年 yryz. All rights reserved.
//

#import "YRAccountCell.h"

@implementation YRAccountCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

-(void)setFrame:(CGRect)frame{
    frame.size.height -= 1;
    [super setFrame:frame];
}

@end
