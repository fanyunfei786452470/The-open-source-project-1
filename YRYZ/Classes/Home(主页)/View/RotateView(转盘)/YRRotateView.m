//
//  YRRotateView.m
//  YRYZ
//
//  Created by Rongzhong on 16/7/21.
//  Copyright © 2016年 yryz. All rights reserved.
//

#import "YRRotateView.h"
#import "YRRotateButton.h"

#define TurnTableWidth self.frame.size.width

#define ButtonWidth 82

#define ButtonToCircle 92 * SCREEN_WIDTH / 320.f

@implementation YRRotateView
{
    CGPoint prePoint;
    CGPoint startPoint;
    UIImageView* imageView;
    float radian;
    float radian1;
    float radian2;
    BOOL _isMove;
    
    float inertiaTime;
    
    UIImageView *baseView;
    NSTimer *timer;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if(self){
        [self initUI];

        [self setExclusiveTouch:YES];
        _isMove = NO;
    }
    return self;
}

-(void)initUI
{
    imageView = [[UIImageView alloc]init];
    imageView.frame = self.bounds;
    //imageView.image = [UIImage imageNamed:@"rotateBgImage"];
//    imageView.backgroundColor = [UIColor redColor];
//    imageView.layer.cornerRadius = TurnTableWidth/2.0f;
//    imageView.layer.masksToBounds = YES;
    imageView.userInteractionEnabled =YES;
    [self addSubview:imageView];
    
    baseView = [[UIImageView alloc]init];
    baseView.frame = self.bounds;
    baseView.image = [UIImage imageNamed:@"rotateBgImage"];
    baseView.userInteractionEnabled = YES;
    [imageView addSubview:baseView];
    
    
    
    
    for (int i=0; i<5; i++) {
        CGPoint centerPoint = CGPointMake(TurnTableWidth/2.0f - sin(M_PI/2.5f * i) * ButtonToCircle,TurnTableWidth/2.0f - cos(M_PI/2.5f * i) * ButtonToCircle);
        YRRotateButton *button = [YRRotateButton buttonWithType:UIButtonTypeCustom];
        button.tag = 101 + i;
        button.bounds = YRRectMake(0, 0, ButtonWidth, ButtonWidth);
        button.center = centerPoint;
        button.multipleTouchEnabled = NO;
        [button addTarget:self action:@selector(menuItemClicked:) forControlEvents:UIControlEventTouchUpInside];
        button.touchesBeganBlock = ^(NSSet<UITouch *> *touches)
        {
            [self touchesBeganAction:touches];
        };
        button.touchesMoveBlock = ^(NSSet<UITouch *> *touches)
        {
            [self touchesMovedAction:touches];
        };
        button.touchesEndBlock= ^(NSSet<UITouch *> *touches)
        {
            [self touchesEndedAction:touches];
        };
        
        [baseView addSubview:button];
        
        UIImageView *buttonImageView = [[UIImageView alloc]init];
        buttonImageView.frame = YRRectMake(16.5, 20.5, 49, 41);
        buttonImageView.image = [UIImage imageNamed:[NSString stringWithFormat:@"rotateButtonImage-%d",i+1]];
        [button addSubview:buttonImageView];
    };
    
    YRRotateButton *centerButton = [[YRRotateButton alloc]init];
    centerButton.touchesBeganBlock = ^(NSSet<UITouch *> *touches)
    {
        [self touchesBeganAction:touches];
    };
    centerButton.touchesMoveBlock = ^(NSSet<UITouch *> *touches)
    {
        [self touchesMovedAction:touches];
    };
    centerButton.touchesEndBlock= ^(NSSet<UITouch *> *touches)
    {
        [self touchesEndedAction:touches];
    };
    centerButton.tag = 100;
    centerButton.frame = YRRectMake(76, 76, 136, 136);
    [centerButton setBackgroundImage:[UIImage imageNamed:@"rotateCenterIamge"] forState:UIControlStateNormal];
    [centerButton setBackgroundImage:[UIImage imageNamed:@"rotateCenterIamge"] forState:UIControlStateHighlighted];
    [centerButton addTarget:self action:@selector(menuItemClicked:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:centerButton];
}

-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [self touchesBeganAction:touches];
}

-(void)touchesMoved:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [self touchesMovedAction:touches];
}

-(void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [self touchesEndedAction:touches];
}

-(void)touchesBeganAction:(NSSet<UITouch *> *)touches
{
    [timer invalidate];
    radian1 = 0;
    radian2 = 0;
    _isMove = NO;
    
    UITouch *touch = [touches anyObject];

    startPoint = [touch locationInView:self];
}

-(void)touchesMovedAction:(NSSet<UITouch *> *)touches
{
    _isMove = YES;
    
    UITouch *touch = [touches anyObject];
    CGPoint movePoint = [touch locationInView:self];
    
    float sideA1 = sqrt(pow(movePoint.x-TurnTableWidth/2.0f-1,2)+pow(movePoint.y-TurnTableWidth/2.0f,2));
    float sideB1 = sqrt(pow(movePoint.x-TurnTableWidth/2.0f,2)+pow(movePoint.y-TurnTableWidth/2.0f,2));
    float sideC1 = 1;
    radian1 = 0;
    
    if(movePoint.y > TurnTableWidth/2.0f)
    {
        radian1 = acos((pow(sideB1,2)+pow(sideC1,2)-pow(sideA1,2))/2/sideB1/sideC1);
    }
    else if(movePoint.y < TurnTableWidth/2.0f)
    {
        radian1 = -acos((pow(sideB1,2)+pow(sideC1,2)-pow(sideA1,2))/2/sideB1/sideC1);
    }
    else
    {
        if(movePoint.x >= TurnTableWidth/2.0f)
        {
            radian1 = 0;
        }
        else
        {
            radian1 = M_PI;
        }
        
    }
    
    float sideA2 = sqrt(pow(startPoint.x-TurnTableWidth/2.0f-1,2)+pow(startPoint.y-TurnTableWidth/2.0f,2));
    float sideB2 = sqrt(pow(startPoint.x-TurnTableWidth/2.0f,2)+pow(startPoint.y-TurnTableWidth/2.0f,2));
    float sideC2 = 1;
    radian2 = 0;
    if(startPoint.y > TurnTableWidth/2.0f)
    {
        radian2 = acos((pow(sideB2,2)+pow(sideC2,2)-pow(sideA2,2))/2/sideB2/sideC2);
    }
    else if(startPoint.y < TurnTableWidth/2.0f)
    {
        radian2 = -acos((pow(sideB2,2)+pow(sideC2,2)-pow(sideA2,2))/2/sideB2/sideC2);
    }
    else
    {
        if(startPoint.x >= TurnTableWidth/2.0f)
        {
            radian2 = 0;
        }
        else
        {
            radian2 = M_PI;
        }
        
    }
    
    radian += radian1 - radian2;
    
    baseView.transform = CGAffineTransformMakeRotation(radian);
    for (int i=0; i<6; i++)
    {
        UIButton* button = (UIButton*)[baseView viewWithTag:100 + i];
        button.transform = CGAffineTransformMakeRotation(-radian);
    }
    prePoint = startPoint;
    startPoint = movePoint;
}


-(void)touchesEndedAction:(NSSet<UITouch *> *)touches
{
    //baseView.userInteractionEnabled = NO;
    inertiaTime = 0.5;
    
    [timer invalidate];
    timer = [NSTimer scheduledTimerWithTimeInterval:0.02 target:self selector:@selector(timerFired) userInfo:nil repeats:YES];
}

-(void)timerFired
{
    
    if (_isMove) {
        inertiaTime -=0.02;
        
        float inertanceRadian;
        if((radian1 - radian2) <= M_PI && (radian1 - radian2) >= -M_PI)
        {
            inertanceRadian = (radian1 - radian2);
        }
        else if((radian1 - radian2) > M_PI)
        {
            inertanceRadian = ((radian1 - radian2) - M_PI * 2);
        }
        else
        {
            inertanceRadian = ((radian1 - radian2) + M_PI * 2);
        }

        radian += inertanceRadian * inertiaTime / 0.5f;
        baseView.transform = CGAffineTransformMakeRotation(radian);
        for (int i=0; i<6; i++)
        {
            UIButton* button = (UIButton*)[baseView viewWithTag:100 + i];
            button.transform = CGAffineTransformMakeRotation(-radian);
        }
        
        if (inertiaTime<=0) {
            [timer invalidate];
            baseView.userInteractionEnabled = YES;
        }
    }
}

-(void)menuItemClicked:(UIButton*)ItemButton
{
    if (_itemClikedBlock) {
        _itemClikedBlock(ItemButton.tag);
    }
}
@end
