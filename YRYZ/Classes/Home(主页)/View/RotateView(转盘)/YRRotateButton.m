//
//  YRRotateButton.m
//  YRYZ
//
//  Created by Rongzhong on 16/7/21.
//  Copyright © 2016年 yryz. All rights reserved.
//

#import "YRRotateButton.h"

@implementation YRRotateButton
{
    BOOL _isMove;
    CGPoint startPoint;
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    [super touchesBegan:touches withEvent:event];
    _isMove = NO;
    _touchesBeganBlock(touches);
    
    UITouch *touch = [touches anyObject];
    startPoint = [touch locationInView:self];
}

-(void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event {
    [super touchesMoved:touches withEvent:event];
    UITouch *touch = [touches anyObject];
    CGPoint movePoint = [touch locationInView:self];

    if (startPoint.x != movePoint.x || startPoint.y != movePoint.y) {
        _isMove = YES;
    }
    _touchesMoveBlock(touches);
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
    if (_isMove) {
        _isMove = NO;
    }
    else
    {
        [super touchesEnded:touches withEvent:event];
    }
    _touchesEndBlock(touches);
}

@end
