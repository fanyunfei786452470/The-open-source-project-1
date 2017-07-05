//
//  RRZSeachTextField.m
//  Rrz
//
//  Created by 易超 on 16/3/10.
//  Copyright © 2016年 rongzhongwang. All rights reserved.
//

#import "RRZSeachTextField.h"

@implementation RRZSeachTextField

//控制文本所在的的位置，左右缩35
-(CGRect)textRectForBounds:(CGRect)bounds{
    return CGRectInset(bounds, 35, 0);
}

//控制编辑文本时所在的位置，左右缩35
-(CGRect)editingRectForBounds:(CGRect)bounds{
    return CGRectInset(bounds, 35, 0);
}

@end
