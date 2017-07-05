//
//  YRTransmitAlert.m
//  YRYZ
//
//  Created by 21.5 on 16/9/28.
//  Copyright © 2016年 yryz. All rights reserved.
//

#import "YRTransmitAlert.h"

@interface YRTransmitAlert()
@property(strong,nonatomic) NSArray * superid_ad_closeTargets;
@property(strong,nonatomic) UIButton *closeBtn;
@property(strong,nonatomic) UIView *bgView;
@property(strong,nonatomic) UILabel * title;
@property(strong,nonatomic) UIView * line;
@property(strong,nonatomic) UITextView * content;
@end

@implementation YRTransmitAlert
- (id)init{
    
    self = [super init];
    
    if (self) {
        self.frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT);
        self.backgroundColor = [UIColor clearColor];
        UIView *maskView = ({
            
            UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
            view.backgroundColor = [UIColor blackColor];
            view.alpha = 0.3;
            view;
        });
        [self addSubview:maskView];
        
        _bgView = ({
            
            UIView *view =[[UIView alloc]initWithFrame: CGRectMake((SCREEN_WIDTH - 200*SCREEN_H_POINT)/2, (SCREEN_HEIGHT - 200*SCREEN_H_POINT)/2, 250*SCREEN_H_POINT, 250*SCREEN_H_POINT)];
            view.center = CGPointMake(SCREEN_WIDTH/2, SCREEN_HEIGHT/2);
            view.backgroundColor = [UIColor whiteColor];
            view.layer.cornerRadius = 6.0;
            view.clipsToBounds = YES;
            view.layer.borderWidth=1;
            view.layer.borderColor=[UIColor whiteColor].CGColor;
            view;
            
        });
        
        [self addSubview:_bgView];
        
        _title = ({
            UILabel * title = [[UILabel alloc]initWithFrame:CGRectMake(20*SCREEN_H_POINT, 5*SCREEN_H_POINT,_bgView.frame.size.width-40*SCREEN_H_POINT , 30*SCREEN_H_POINT)];
            title.textColor = [UIColor wordColor];
            [title setFont:[UIFont systemFontOfSize:15*SCREEN_H_POINT]];
            title.textAlignment = NSTextAlignmentCenter;
            title;
        });
        [_bgView addSubview:_title];
        
        _line = ({
            UIView * line = [[UIView alloc]initWithFrame:CGRectMake(0, 40*SCREEN_H_POINT, CGRectGetMaxX(_bgView.frame), 1)];
            line.backgroundColor = [UIColor themeColor];
            line;
        });
        [_bgView addSubview:_line];
        
        _content = ({
            UITextView * content = [[UITextView alloc]initWithFrame:CGRectMake(5*SCREEN_H_POINT, CGRectGetMaxY(_line.frame)+5*SCREEN_H_POINT, _bgView.frame.size.width- 10*SCREEN_H_POINT, 205*SCREEN_H_POINT)];
            content.textColor = RGB_COLOR(102, 102, 102);
            content.editable = NO;
            [content setFont:[UIFont systemFontOfSize:16*SCREEN_H_POINT]];
            content;
        });
        [_bgView addSubview:_content];
        
        _closeBtn = ({
            
            UIButton *btn = [UIButton buttonWithType:UIButtonTypeSystem];;
            btn.frame = CGRectMake(CGRectGetMaxX(_bgView.frame)-30*SCREEN_H_POINT/2, CGRectGetMinY(_bgView.frame)-30*SCREEN_H_POINT/2, 30*SCREEN_H_POINT, 30*SCREEN_H_POINT);
            [btn setBackgroundImage:[UIImage imageNamed:@"CircleClose"] forState:normal];
            [btn addTarget:self action:@selector(closeBtnClickEventHandle) forControlEvents:UIControlEventTouchUpInside];
            
            btn;
        });
        
        [self addSubview:_closeBtn];
    }
        return self;
}

- (void)closeBtnClickEventHandle{
    [self removeFromSuperview];
}
- (void)showForwardingruletitle:(NSString *)title rule:(NSString *)rule{
    
    _title.text = title;
    _content.text = rule;
    [[self getCurrentVC].view addSubview:self];
}

- (UIViewController *)getCurrentVC
{
    UIViewController *result = nil;
    
    UIWindow * window = [[UIApplication sharedApplication] keyWindow];
    if (window.windowLevel != UIWindowLevelNormal)
    {
        NSArray *windows = [[UIApplication sharedApplication] windows];
        for(UIWindow * tmpWin in windows)
        {
            if (tmpWin.windowLevel == UIWindowLevelNormal)
            {
                window = tmpWin;
                break;
            }
        }
    }
    
    UIView *frontView = [[window subviews] objectAtIndex:0];
    id nextResponder = [frontView nextResponder];
    
    if ([nextResponder isKindOfClass:[UIViewController class]])
        result = nextResponder;
    else
        result = window.rootViewController;
    
    return result;
}

- (void)drawSuperid_ad_close
{
    //// Color Declarations
    UIColor* white = [UIColor colorWithRed: 1 green: 1 blue: 1 alpha: 1];
    
    //// yuan Drawing
    UIBezierPath* yuanPath = [UIBezierPath bezierPathWithOvalInRect: CGRectMake(2, 2, 60, 61)];
    [white setStroke];
    yuanPath.lineWidth = 2;
    [yuanPath stroke];
    
    
    //// mid Drawing
    UIBezierPath* midPath = UIBezierPath.bezierPath;
    [midPath moveToPoint: CGPointMake(30.01, 32.5)];
    [midPath addLineToPoint: CGPointMake(18.74, 43.96)];
    [midPath addCurveToPoint: CGPointMake(18.74, 45.98) controlPoint1: CGPointMake(18.2, 44.51) controlPoint2: CGPointMake(18.19, 45.42)];
    [midPath addCurveToPoint: CGPointMake(20.73, 45.98) controlPoint1: CGPointMake(19.29, 46.54) controlPoint2: CGPointMake(20.18, 46.54)];
    [midPath addLineToPoint: CGPointMake(32, 34.52)];
    [midPath addLineToPoint: CGPointMake(43.27, 45.98)];
    [midPath addCurveToPoint: CGPointMake(45.26, 45.98) controlPoint1: CGPointMake(43.82, 46.54) controlPoint2: CGPointMake(44.71, 46.54)];
    [midPath addCurveToPoint: CGPointMake(45.26, 43.96) controlPoint1: CGPointMake(45.81, 45.42) controlPoint2: CGPointMake(45.8, 44.51)];
    [midPath addLineToPoint: CGPointMake(33.99, 32.5)];
    [midPath addLineToPoint: CGPointMake(45.26, 21.04)];
    [midPath addCurveToPoint: CGPointMake(45.26, 19.02) controlPoint1: CGPointMake(45.8, 20.49) controlPoint2: CGPointMake(45.81, 19.58)];
    [midPath addCurveToPoint: CGPointMake(43.27, 19.02) controlPoint1: CGPointMake(44.71, 18.46) controlPoint2: CGPointMake(43.82, 18.46)];
    [midPath addLineToPoint: CGPointMake(32, 30.48)];
    [midPath addLineToPoint: CGPointMake(20.73, 19.02)];
    [midPath addCurveToPoint: CGPointMake(18.74, 19.02) controlPoint1: CGPointMake(20.18, 18.46) controlPoint2: CGPointMake(19.29, 18.46)];
    [midPath addCurveToPoint: CGPointMake(18.74, 21.04) controlPoint1: CGPointMake(18.19, 19.58) controlPoint2: CGPointMake(18.2, 20.49)];
    [midPath addLineToPoint: CGPointMake(30.01, 32.5)];
    [midPath closePath];
    midPath.miterLimit = 4;
    
    midPath.usesEvenOddFillRule = YES;
    
    [white setFill];
    [midPath fill];
}

@end


