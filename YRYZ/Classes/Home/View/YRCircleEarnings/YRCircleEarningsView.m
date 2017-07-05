//
//  YRCircleEarningsView.m
//  YRYZ
//
//  Created by 21.5 on 16/9/22.
//  Copyright © 2016年 yryz. All rights reserved.
//

#import "YRCircleEarningsView.h"

#define superid_ad_color_title          HEXRGB(0x0099cc)
#define superid_ad_color_tips           HEXRGB(0x333333)

//RGB Color transform（16 bit->10 bit）
#define HEXRGB(rgbValue) [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0]

//Screen Height and width
#define Screen_height   [[UIScreen mainScreen] bounds].size.height
#define Screen_width    [[UIScreen mainScreen] bounds].size.width
#define VIEW_BX(view) (view.frame.origin.x + view.frame.size.width)
#define VIEW_BY(view) (view.frame.origin.y + view.frame.size.height)
//Get View size:
#define VIEW_W(view)  (view.frame.size.width)
#define VIEW_H(view)  (view.frame.size.height)

//iPhone4
#define   isIphone4  [UIScreen mainScreen].bounds.size.height < 50
@interface YRCircleEarningsView ()
@property(strong,nonatomic) NSArray * superid_ad_closeTargets;
@property(strong,nonatomic) UIButton        *closeBtn;
@property(strong,nonatomic) UIView          *bgView;
@property(strong,nonatomic) UIView          *titleBgView;
@property(strong,nonatomic) UIImageView     *adImageView;
@property(strong,nonatomic)NSDictionary * layerDict;//三层文字说明
@property(strong,nonatomic)UIImageView * headImage;//用户昵称和头像
@property(strong,nonatomic)UIView * totalNum;//跟转总人数
@property(strong,nonatomic)UIView * totalEarn;//获得总收益
@property(strong,nonatomic)UILabel * firstLayer;//第一层数据
@property(strong,nonatomic)UILabel * secondLayer;//第二层数据
@property(strong,nonatomic)UILabel * thirdLayer;//第三层数据
@property(strong,nonatomic)UILabel * firstLayer1;
@property(strong,nonatomic)UILabel * secondLayer1;
@property(strong,nonatomic)UILabel * thirdLayer1;
@property(strong,nonatomic)UIButton * earnBtn;//跟转挣收益按钮
@property(strong,nonatomic)UILabel * btnTitle;//按钮的titile
@property(strong,nonatomic)UILabel * numLabel;
@property(strong,nonatomic)UILabel * earnLabel;
@property(strong,nonatomic)UILabel * num;
@property(strong,nonatomic)UILabel * earn;
@property(strong,nonatomic)UIView * backView;
@property(strong,nonatomic)UILabel * nickName;
@end
@implementation YRCircleEarningsView
- (id)init{
    
    self = [super init];
    
    if (self) {
        self.frame = CGRectMake(0, 0, Screen_width, Screen_height);
        self.backgroundColor = [UIColor clearColor];
        UIView *maskView = ({
            
            UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, Screen_width, Screen_height)];
            view.backgroundColor = [UIColor blackColor];
            view.alpha = 0.3;
            view;
        });
        [self addSubview:maskView];
        
        _bgView = ({
            
            UIView *view =[[UIView alloc]initWithFrame: CGRectMake(0, 0, 0.8125*Screen_width, 1.46*0.825*Screen_width)];
            view.frame = CGRectMake(0, 0, 0.8125*Screen_width, 1.46*0.825*Screen_width);
            view.center = CGPointMake(Screen_width/2, Screen_height/2);
            NSLog(@"%f",view.frame.size.height);
            if (isIphone4) {
                
                self.center = CGPointMake(Screen_width/2, Screen_height/2+20);
            }
            view.backgroundColor = [UIColor whiteColor];
            view.layer.cornerRadius = 6.0;
            view.clipsToBounds = YES;
            view.layer.borderWidth=1;
            view.backgroundColor = [UIColor redColor];
            view.layer.borderColor=[UIColor whiteColor].CGColor;
            view;
            
        });
        
        [self addSubview:_bgView];
        
        _closeBtn = ({
            
            UIButton *btn = [UIButton buttonWithType:UIButtonTypeSystem];;
            btn.frame = CGRectMake(CGRectGetMaxX(_bgView.frame)-33*SCREEN_H_POINT/2, CGRectGetMinY(_bgView.frame)-33*SCREEN_H_POINT/2, 33*SCREEN_H_POINT, 33*SCREEN_H_POINT);
//            if (isIphone4) {
//                
//                btn.frame = CGRectMake(VIEW_BX(_bgView)-32, 12, 33, 33);
//                
//            }
            [btn setBackgroundImage:[UIImage imageNamed:@"CircleClose"] forState:normal];
            [btn addTarget:self action:@selector(closeBtnClickEventHandle) forControlEvents:UIControlEventTouchUpInside];
            
            btn;
        });
        
        [self addSubview:_closeBtn];
        
        _adImageView = ({
            
            UIImageView *view = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, VIEW_W(_bgView), VIEW_H(_bgView))];
            view.userInteractionEnabled = YES;
            view;
            
        });
        [_bgView addSubview:_adImageView];
        
        _titleBgView = ({
            
            UIView *view = [[UIView alloc]initWithFrame:CGRectMake(15*SCREEN_H_POINT, 10*SCREEN_H_POINT, (_adImageView.frame.size.width-30*SCREEN_H_POINT), 60*SCREEN_H_POINT)];
            view;
        });
        [_bgView addSubview:_titleBgView];
        
        _headImage = ({
            UIImageView * headImage = [[UIImageView alloc]initWithFrame:CGRectMake(20*SCREEN_H_POINT, 5*SCREEN_H_POINT, 50*SCREEN_H_POINT, 50*SCREEN_H_POINT)];
            headImage.layer.masksToBounds = YES;
            headImage.layer.cornerRadius = 25*SCREEN_H_POINT;
            headImage;
        });
        [_titleBgView addSubview:_headImage];
        
        _nickName= ({
            UILabel * nickName = [[UILabel alloc]initWithFrame:CGRectMake(10*SCREEN_H_POINT, 35*SCREEN_H_POINT, 70*SCREEN_H_POINT, 20*SCREEN_H_POINT)];
            nickName.backgroundColor = [UIColor clearColor];
            nickName.textAlignment = NSTextAlignmentCenter;
            nickName.textColor = [UIColor whiteColor];
            [nickName setFont:[UIFont systemFontOfSize:11]];
            nickName;
        });
        [_titleBgView addSubview:_nickName];
        
        _totalNum = ({
            UIView * totalNum = [[UIView alloc]initWithFrame:CGRectMake(CGRectGetMaxX(_headImage.frame)+10*SCREEN_H_POINT, CGRectGetMinY(_headImage.frame), _titleBgView.frame.size.width - CGRectGetMaxX(_headImage.frame)-20*SCREEN_H_POINT, 25*SCREEN_H_POINT)];
            totalNum;
        });
        [_titleBgView addSubview:_totalNum];
        
        _numLabel = ({
            UILabel * numLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, _totalNum.frame.size.width/2, 25*SCREEN_H_POINT)];
            numLabel.textColor = [UIColor wordColor];
            [numLabel setFont:[UIFont systemFontOfSize:16*SCREEN_H_POINT]];
            numLabel.text = @"被跟转";
            numLabel;
        });
        [_totalNum addSubview:_numLabel];
        
        _num = ({
            UILabel * num = [[UILabel alloc]initWithFrame:CGRectMake(_totalNum.frame.size.width/2, 0, _totalNum.frame.size.width/2, 25*SCREEN_H_POINT)];
            [num setFont:[UIFont systemFontOfSize:16*SCREEN_H_POINT]];
            num.textColor = [UIColor themeColor];
            num;
 
        });
        [_totalNum addSubview:_num];
        
        _totalEarn = ({
            UIView * totalEarn = [[UIView alloc]initWithFrame:CGRectMake(CGRectGetMinX(_totalNum.frame), CGRectGetMaxY(_totalNum.frame), _totalNum.frame.size.width, 25*SCREEN_H_POINT)];
            totalEarn;
        });
        [_titleBgView addSubview:_totalEarn];
        
        _earnLabel = ({
            UILabel * earnLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, _totalEarn.frame.size.width/2, 25*SCREEN_H_POINT)];
            earnLabel.text = @"获得收益";
            [earnLabel setFont:[UIFont systemFontOfSize:16*SCREEN_H_POINT]];
            earnLabel;

        });
        [_totalEarn addSubview:_earnLabel];
        
        _earn = ({
            UILabel * earn = [[UILabel alloc]initWithFrame:CGRectMake(_totalEarn.frame.size.width/2, 0, _totalEarn.frame.size.width/2, 25*SCREEN_H_POINT)];
            earn.textColor = [UIColor themeColor];
            [earn setFont:[UIFont systemFontOfSize:16*SCREEN_H_POINT]];
            earn;
            
          
        });
        [_totalEarn addSubview:_earn];
        
        _firstLayer = ({
            UILabel * firstLayer = [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMinX(_titleBgView.frame)+60*SCREEN_H_POINT, CGRectGetMaxY(_titleBgView.frame)+48*SCREEN_H_POINT,CGRectGetMaxX(_titleBgView.frame)-CGRectGetMinX(_titleBgView.frame)-80*SCREEN_H_POINT, 20*SCREEN_H_POINT)];
            [firstLayer setFont:[UIFont systemFontOfSize:10*SCREEN_H_POINT]];
            firstLayer.textColor = RGB_COLOR(135, 135, 135);
            firstLayer.numberOfLines = 0;
            firstLayer.textAlignment = NSTextAlignmentCenter;
            firstLayer.font = [UIFont titleFont13];
            firstLayer.adjustsFontSizeToFitWidth = YES;
            firstLayer;
        });
        [_adImageView addSubview:_firstLayer];
        _firstLayer1 = ({
            UILabel * firstLayer = [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMinX(_firstLayer.frame), CGRectGetMaxY(_firstLayer.frame),CGRectGetMaxX(_titleBgView.frame)-CGRectGetMinX(_titleBgView.frame)-80*SCREEN_H_POINT, 20*SCREEN_H_POINT)];
            [firstLayer setFont:[UIFont systemFontOfSize:10*SCREEN_H_POINT]];
            firstLayer.textColor = RGB_COLOR(135, 135, 135);
            firstLayer.numberOfLines = 0;
            firstLayer.font = [UIFont titleFont13];
            firstLayer.adjustsFontSizeToFitWidth = YES;
            firstLayer.textAlignment = NSTextAlignmentCenter;
            firstLayer;
        });
        [_adImageView addSubview:_firstLayer1];

        _secondLayer = ({
            UILabel * secondLayer = [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMinX(_titleBgView.frame)+60*SCREEN_H_POINT, CGRectGetMaxY(_firstLayer1.frame)+65*SCREEN_H_POINT, CGRectGetMaxX(_titleBgView.frame)-CGRectGetMinX(_titleBgView.frame)-80*SCREEN_H_POINT, 20*SCREEN_H_POINT)];
            [secondLayer setFont:[UIFont systemFontOfSize:10*SCREEN_H_POINT]];
            secondLayer.textColor = RGB_COLOR(135, 135, 135);
            secondLayer.numberOfLines = 0;
            secondLayer.adjustsFontSizeToFitWidth =YES;
            secondLayer.textAlignment = NSTextAlignmentCenter;
            secondLayer.font =[UIFont titleFont13];
            secondLayer;
        });
        [_adImageView addSubview:_secondLayer];
        _secondLayer1 = ({
            UILabel * firstLayer = [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMinX(_secondLayer.frame), CGRectGetMaxY(_secondLayer.frame),CGRectGetMaxX(_titleBgView.frame)-CGRectGetMinX(_titleBgView.frame)-80*SCREEN_H_POINT, 20*SCREEN_H_POINT)];
            [firstLayer setFont:[UIFont systemFontOfSize:10*SCREEN_H_POINT]];
            firstLayer.textColor = RGB_COLOR(135, 135, 135);
            firstLayer.numberOfLines = 0;
            firstLayer.adjustsFontSizeToFitWidth =YES;
            firstLayer.font = [UIFont titleFont13];
            firstLayer.textAlignment = NSTextAlignmentCenter;
            firstLayer;
        });
        [_adImageView addSubview:_secondLayer1];

        _thirdLayer = ({
            UILabel * thirdLayer = [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMinX(_titleBgView.frame)+60*SCREEN_H_POINT, CGRectGetMaxY(_secondLayer1.frame)+65*SCREEN_H_POINT, CGRectGetMaxX(_titleBgView.frame)-CGRectGetMinX(_titleBgView.frame)-80*SCREEN_H_POINT, 20*SCREEN_H_POINT) ];
            [thirdLayer setFont:[UIFont systemFontOfSize:10*SCREEN_H_POINT]];
            thirdLayer.textColor = RGB_COLOR(135, 135, 135);
            thirdLayer.numberOfLines = 0;
            thirdLayer.adjustsFontSizeToFitWidth =YES;
            thirdLayer.textAlignment = NSTextAlignmentCenter;
            thirdLayer.font = [UIFont titleFont13];
            thirdLayer;
        });
        [_adImageView addSubview:_thirdLayer];
        _thirdLayer1 = ({
            UILabel * firstLayer = [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMinX(_thirdLayer.frame), CGRectGetMaxY(_thirdLayer.frame),CGRectGetMaxX(_titleBgView.frame)-CGRectGetMinX(_titleBgView.frame)-80*SCREEN_H_POINT, 20*SCREEN_H_POINT)];
            [firstLayer setFont:[UIFont systemFontOfSize:10*SCREEN_H_POINT]];
            firstLayer.textColor = RGB_COLOR(135, 135, 135);
            firstLayer.numberOfLines = 0;
            firstLayer.font = [UIFont titleFont13];
            firstLayer.adjustsFontSizeToFitWidth = YES;
            firstLayer.textAlignment = NSTextAlignmentCenter;
            firstLayer;
        });
        [_adImageView addSubview:_thirdLayer1];
        _earnBtn = ({
            UIButton * earnBtn = [[UIButton alloc]initWithFrame:CGRectMake(50*SCREEN_H_POINT, CGRectGetMaxY(_adImageView.frame)-60*SCREEN_H_POINT, _adImageView.frame.size.width- 100*SCREEN_H_POINT, 40*SCREEN_H_POINT)];
//            earnBtn.titleLabel.text = @"跟转得奖励";
            [earnBtn addTarget:self action:@selector(followEarnings:) forControlEvents:UIControlEventTouchUpInside];
            earnBtn.backgroundColor = [UIColor themeColor];
            [earnBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            earnBtn.layer.masksToBounds = YES;
            earnBtn.layer.cornerRadius = 20*SCREEN_H_POINT;
            earnBtn.userInteractionEnabled = YES;
            earnBtn;
        });
        [_adImageView addSubview:_earnBtn];
        
        _btnTitle = ({
            UILabel * btnTitle = [[UILabel alloc]initWithFrame:CGRectMake(20*SCREEN_H_POINT,5*SCREEN_H_POINT,_earnBtn.frame.size.width-40*SCREEN_H_POINT,30*SCREEN_H_POINT)];
            btnTitle.textAlignment = NSTextAlignmentCenter;
            btnTitle.textColor = [UIColor whiteColor];
            btnTitle.text = @"邀请转发";
            btnTitle;
        });
        [_earnBtn addSubview:_btnTitle];
   
    }
    return self;
}
- (void)showInView:(UIView *)view withFaceInfo: (NSDictionary *)info advertisementImage: (UIImage *)image borderColor: (UIColor *)color{
    
    if (!info) {
        
        return;
    }
    _adImageView.image = image;
    if (color) {
        
        _bgView.layer.borderColor = color.CGColor;
        
    }
    [view addSubview:self];
    
}

- (void)showWithFaceInfo: (NSDictionary *)info advertisementImage: (UIImage *)image borderColor: (UIColor *)color circle:(YRCircleListModel *)circle{
    
    if (!info) {
        
        return;
    }
    [_headImage setImageWithURL:[NSURL URLWithString:circle.headPath] placeholder:[UIImage imageNamed:@"userDefaultImage"]];
    _num.text = [NSString stringWithFormat:@"%ld次",[[info objectForKey:@"level1Count"] integerValue]+[[info objectForKey:@"level2Count"] integerValue]+[[info objectForKey:@"level3Count"] integerValue]];
    _earn.text = [NSString stringWithFormat:@"%.2f",([[info objectForKey:@"level1Bonud"] integerValue]+[[info objectForKey:@"level2Bonud"] integerValue]+[[info objectForKey:@"level3Bonud"] integerValue])*0.01] ;
    _firstLayer.text = [NSString stringWithFormat:@"第一层跟转总数%ld次",[[info objectForKey:@"level1Count"] integerValue]];
    _firstLayer1.text = [NSString stringWithFormat:@"为你带来了%.2f",[[info objectForKey:@"level1Bonud"] integerValue]*0.01];
    _secondLayer.text = [NSString stringWithFormat:@"第二层对第一层进行了%ld次跟转",[[info objectForKey:@"level2Count"] integerValue]];
    _secondLayer1.text =[NSString stringWithFormat:@"为你带来了%.2f",[[info objectForKey:@"level2Bonud"] integerValue]*0.01];
    _thirdLayer.text = [NSString stringWithFormat:@"第三层对第二层进行了%ld次跟转",[[info objectForKey:@"level3Count"] integerValue]];
    _thirdLayer1.text = [NSString stringWithFormat:@"为你带来了%.2f",[[info objectForKey:@"level3Bonud"] integerValue]*0.01];
    _adImageView.image = image;
    if ([circle.custName isEqual:nil]) {
    }else{
        _nickName.text = circle.custName;
    }
    if (color) {
        
        _bgView.layer.borderColor = color.CGColor;
        
    }
    [[self getCurrentVC].view addSubview:self];
    
}

- (void)closeBtnClickEventHandle{
    [self removeFromSuperview];
    _adImageView.image = nil;
    
}

- (void)setCircleModel:(YRCircleListModel *)circleModel{

    _circleModel = circleModel;
}
- (void)followEarnings:(UIButton *)sender{
        if (self.delegate) {
            [UIView animateWithDuration:0.25 animations:^{
                self.transform = CGAffineTransformMakeScale(0.1, 0.1);
                self.alpha = 0;
            } completion:^(BOOL finished) {
                [self removeFromSuperview];
            }];
            [self.delegate invitateRransmitcircle:_circleModel];
        }
}

- (void)dealloc{

    _headImage = nil;
    _num = nil;
    _earn = nil;
    _firstLayer = nil;
    _secondLayer = nil;
    _thirdLayer = nil;
    _firstLayer1 = nil;
    _secondLayer1 = nil;
    _thirdLayer1 = nil;
    _adImageView = nil;
    _bgView = nil;
    _titleBgView = nil;
    _closeBtn = nil;
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
