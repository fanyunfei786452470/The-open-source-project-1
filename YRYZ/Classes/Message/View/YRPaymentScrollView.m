//
//  YRPaymentScrollView.m
//  YRYZ
//
//  Created by Rongzhong on 16/7/15.
//  Copyright © 2016年 yryz. All rights reserved.
//

#import "YRPaymentScrollView.h"

@implementation YRPaymentScrollView
{
    BOOL _isMove;
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    _isMove = NO;
    [super touchesBegan:touches withEvent:event];
}
-(void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event {
    _isMove = YES;
    [super touchesMoved:touches withEvent:event];
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
    [super touchesEnded:touches withEvent:event];
    if (_isMove) {
        _isMove = NO;
    }else{
        if (_touchesEndBlock) {
            _touchesEndBlock();
        }
    }
}

@end
