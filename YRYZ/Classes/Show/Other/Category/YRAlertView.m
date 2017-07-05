//
//  YRAlertView.m
//  YRYZ
//
//  Created by Mrs_zhang on 16/8/13.
//  Copyright © 2016年 yryz. All rights reserved.
//

#import "YRAlertView.h"

#define ItemWidth 320.f/10
#define ItemHeight (320.f-ItemWidth*2)*0.6

@interface YRAlertWindow : UIView

@end
@implementation YRAlertWindow
- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        self.autoresizingMask = UIViewAutoresizingFlexibleWidth| UIViewAutoresizingFlexibleHeight;
        self.opaque = NO;
    }
    return self;
}
- (void)drawRect:(CGRect)rect {
    // Drawing code
    CGContextRef context = UIGraphicsGetCurrentContext();
    [[UIColor colorWithWhite:0 alpha:0.35] set];
    CGContextFillRect(context, self.bounds);
}
@end

#pragma mark - YRAlertView

@interface YRAlertView()
{
    BOOL _isAnimating;
}

@property (nonatomic,strong) YRAlertWindow *showAlertWindow;
@property (nonatomic,strong) UILabel *textLab;
@property (nonatomic,strong) UIButton *cancelBtn;
@property (nonatomic,strong) UIButton *confirmBtn;
@property (nonatomic,strong) UILabel *subTitle;
@property (nonatomic,strong) UILabel *line;

@end
@implementation YRAlertView

- (instancetype)initWithTitle:(NSString *)title cancelButtonText:(NSString *)cancelText confirmButtonText:(NSString *)confirmText{

    self = [super initWithFrame:CGRectMake((SCREEN_WIDTH - (320.f-ItemWidth*2))/2
                                           , (SCREEN_HEIGHT-ItemHeight)/2, 320.f-ItemWidth*2, ItemHeight)];
    if (self) {
        [self setBottomColorWithType:AletTypeTwo];
        self.backgroundColor = [UIColor whiteColor];
        self.layer.cornerRadius = 4.f;
        
        UIButton *cancelBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        cancelBtn.frame = CGRectMake(5, ItemHeight - ItemHeight/3+10, (320.f-ItemWidth*2)/2-10, ItemHeight/3-15);
        [self addSubview:cancelBtn];
        
        UIButton *confirmBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        confirmBtn.frame = CGRectMake((320.f-ItemWidth*2)/2+5, ItemHeight - ItemHeight/3+10, (320.f-ItemWidth*2)/2-10, ItemHeight/3-15);
        [self addSubview:confirmBtn];
        
        UILabel *textLab = [[UILabel alloc] initWithFrame:CGRectMake(15, 10, (320.f-ItemWidth*2)-30, (ItemHeight - ItemHeight/3+5)-20)];
        textLab.textAlignment = NSTextAlignmentCenter;
        textLab.numberOfLines = 0;
        [self addSubview:textLab];
        
        self.cancelBtn = cancelBtn;
        self.confirmBtn = confirmBtn;
        self.textLab = textLab;
        
        self.textLab.text = title?title:@"标题";
        [self.cancelBtn setTitle:cancelText?cancelText:@"取消" forState:UIControlStateNormal];
        [self.confirmBtn setTitle:confirmText?confirmText:@"确定" forState:UIControlStateNormal];
        if([confirmText isKindOfClass:[NSAttributedString class]]){
            [self.confirmBtn setAttributedTitle:(NSAttributedString*)confirmText forState:UIControlStateNormal];
        }
        [cancelBtn addTarget:self action:@selector(cancelAction) forControlEvents:UIControlEventTouchUpInside];
        [confirmBtn addTarget:self action:@selector(confirmAction) forControlEvents:UIControlEventTouchUpInside];
    }
    return self;
}

- (instancetype)initWithTitle:(NSString *)title cancelButtonText:(NSString *)cancelText{
    
    self = [super initWithFrame:CGRectMake((SCREEN_WIDTH - (320.f-ItemWidth*2))/2, (SCREEN_HEIGHT-ItemHeight)/2, 320.f-ItemWidth*2, ItemHeight)];
    if (self) {
        
        [self setBottomColorWithType:AletTypeOne];
        self.backgroundColor = [UIColor whiteColor];
        self.layer.cornerRadius = 4.f;
        
        UIButton *cancelBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        cancelBtn.frame = CGRectMake(5, ItemHeight - ItemHeight/3+10, (320.f-ItemWidth*2)-10, ItemHeight/3-15);
        [self addSubview:cancelBtn];

        
        UILabel *textLab = [[UILabel alloc] initWithFrame:CGRectMake(15, 10, (320.f-ItemWidth*2)-30, (ItemHeight - ItemHeight/3+5)-20)];
        textLab.textAlignment = NSTextAlignmentCenter;
        textLab.numberOfLines = 0;
        [self addSubview:textLab];
        
        self.cancelBtn = cancelBtn;
        self.textLab = textLab;
        self.textLab.text = title?title:@"标题";
        [self.cancelBtn setTitle:cancelText?cancelText:@"确定" forState:UIControlStateNormal];
        [cancelBtn addTarget:self action:@selector(cancelAction) forControlEvents:UIControlEventTouchUpInside];
    }
    return self;
}
- (instancetype)initWithPay:(NSString *)titles cancelButtonTexts:(NSString *)cancelTexts{
    
    self = [super initWithFrame:CGRectMake((SCREEN_WIDTH - (320.f-ItemWidth*2))/2, (SCREEN_HEIGHT-ItemHeight)/2, 320.f-ItemWidth*2, ItemHeight)];
    if (self) {
        
        [self setBottomColorWithType:AletTypeOne];
        self.backgroundColor = [UIColor whiteColor];
        self.layer.cornerRadius = 4.f;
        
        UIButton *cancelBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        cancelBtn.frame = CGRectMake(5, ItemHeight - ItemHeight/3+10, (320.f-ItemWidth*2)-10, ItemHeight/3-15);
        [self addSubview:cancelBtn];
        
        
        UILabel *textLab = [[UILabel alloc] initWithFrame:CGRectMake(15, 10, (320.f-ItemWidth*2)-30, (ItemHeight - ItemHeight/3+5)-20)];
        textLab.textAlignment = NSTextAlignmentCenter;
        textLab.numberOfLines = 0;
        [self addSubview:textLab];
        self.cancelBtn = cancelBtn;
        self.textLab = textLab;
        self.textLab.text = titles?titles:@"标题";
        [self.cancelBtn setTitle:cancelTexts?cancelTexts:@"确定" forState:UIControlStateNormal];
        [self.cancelBtn setImage:[UIImage imageNamed:@"yr_yesBtn_nor"] forState:UIControlStateNormal];
        [cancelBtn addTarget:self action:@selector(cancelAction) forControlEvents:UIControlEventTouchUpInside];
        self.cancelButtonFont = [UIFont systemFontOfSize:15];
        self.cancelButtonColor = RGB_COLOR(144, 144, 144);
        
        UIButton *msgX = [UIButton buttonWithType:UIButtonTypeCustom];
        msgX.userInteractionEnabled = YES;
        [msgX addTarget:self action:@selector(msgXClick:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:msgX];
        [msgX setImage:[UIImage imageNamed:@"yr_msg_X"] forState:UIControlStateNormal];
        [msgX mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.mas_top).mas_offset(0);
            make.right.equalTo(self.mas_right).mas_offset(-10);
            make.size.mas_equalTo(CGSizeMake(40, 40));
        }];
        
    }
    return self;
}
- (void)msgXClick:(UIButton *)sender{
    [self dismiss];
}
- (instancetype)initWithFrame:(CGRect)frame title:(NSString *)title subTitle:(NSString *)subTitle cancelButtonText:(NSString *)cancelText confirmButtonText:(NSString *)confirmText{
    
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
        self.layer.cornerRadius = 4.f;
        
        UIButton *cancelBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        UIButton *confirmBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        UILabel *textLab = [[UILabel alloc] init];
        UILabel *mySubTitle = [[UILabel alloc] init];
        UILabel *line = [[UILabel alloc] init];
        [self addSubview:textLab];
        [self addSubview:cancelBtn];
        [self addSubview:confirmBtn];
        [self addSubview:mySubTitle];
        [self addSubview:line];
        
        textLab.textAlignment = NSTextAlignmentCenter;
        textLab.numberOfLines = 0;
        mySubTitle.numberOfLines = 0;
        mySubTitle.textAlignment = NSTextAlignmentLeft;
        line.backgroundColor = [UIColor themeColor];
        mySubTitle.text = subTitle?subTitle:@"子标题";
        mySubTitle.textColor = RGB_COLOR(76, 76, 76);
        self.cancelBtn = cancelBtn;
        self.confirmBtn = confirmBtn;
        self.textLab = textLab;
        self.subTitle = mySubTitle;
        self.line = line;
        self.textLab.text = title?title:@"标题";
        [self.cancelBtn setTitle:cancelText?cancelText:@"取消" forState:UIControlStateNormal];
        [self.confirmBtn setTitle:confirmText?confirmText:@"确定" forState:UIControlStateNormal];
        if([confirmText isKindOfClass:[NSAttributedString class]]){
            [self.confirmBtn setAttributedTitle:(NSAttributedString*)confirmText forState:UIControlStateNormal];
        }
        
        [cancelBtn addTarget:self action:@selector(cancelAction) forControlEvents:UIControlEventTouchUpInside];
        [confirmBtn addTarget:self action:@selector(confirmAction) forControlEvents:UIControlEventTouchUpInside];
        
       [textLab mas_makeConstraints:^(MASConstraintMaker *make) {
           make.size.mas_equalTo(CGSizeMake(self.size.width, 40));
           make.top.equalTo(self.mas_top);
           make.centerX.equalTo(self.mas_centerX);
       }];
       [line mas_makeConstraints:^(MASConstraintMaker *make) {
           make.size.mas_equalTo(CGSizeMake(self.size.width, 1));
           make.top.equalTo(textLab.mas_bottom);
           make.centerX.equalTo(textLab);
       }];
       [mySubTitle mas_makeConstraints:^(MASConstraintMaker *make) {
           make.top.equalTo(line.mas_bottom);
           make.left.equalTo(self.mas_left).mas_offset(15);
           make.right.equalTo(self.mas_right).mas_offset(-15);
           make.bottom.equalTo(self).mas_equalTo(-45);
       }];
        
       [cancelBtn mas_makeConstraints:^(MASConstraintMaker *make) {
           make.left.equalTo(self);
           make.size.mas_equalTo(CGSizeMake(self.size.width/2, 45));
           make.bottom.equalTo(self);
       }];
       [confirmBtn mas_makeConstraints:^(MASConstraintMaker *make) {
           make.left.equalTo(cancelBtn.mas_right);
           make.bottom.equalTo(self);
           make.size.mas_equalTo(CGSizeMake(self.size.width/2, 45));
       }];
        [self setBottomColorWithType:AletTypeThree];
    }
    return self;
}


- (void)layoutSubviews{
    [super layoutSubviews];
    //字体
    self.cancelBtn.titleLabel.font = self.cancelButtonFont;
    self.confirmBtn.titleLabel.font = self.comfirmButtonFont;
    self.textLab.font = self.textLabFont;
    
    //字体颜色
    self.textLab.textColor = self.textLabColor?self.textLabColor:RGB_COLOR(102, 102, 102);
    [self.cancelBtn setTitleColor:self.cancelButtonColor?self.cancelButtonColor:[UIColor blackColor] forState:UIControlStateNormal];
    [self.confirmBtn setTitleColor:self.comfirmButtonColor?self.comfirmButtonColor:[UIColor blackColor] forState:UIControlStateNormal];
}



- (void)setBottomColorWithType:(TypeName)typeName{
    
    CALayer *layer = [CALayer layer];
    layer.frame = CGRectMake(0, ItemHeight - ItemHeight/3+5, 320.f-ItemWidth*2, ItemHeight/3-5);
    layer.cornerRadius = 4.f;
    layer.backgroundColor = RGB_COLOR(245, 245, 245).CGColor;
    [self.layer addSublayer:layer];
    
    CALayer *layerTwo = [CALayer layer];
    layerTwo.frame = CGRectMake(0, ItemHeight - ItemHeight/3+5, 320.f-ItemWidth*2, 5);
    layerTwo.backgroundColor = RGB_COLOR(245, 245, 245).CGColor;
    [self.layer addSublayer:layerTwo];
    
    if (typeName == AletTypeTwo) {
        CALayer *layerThree = [CALayer layer];
        layerThree.frame = CGRectMake((320.f-ItemWidth*2)/2, ItemHeight - ItemHeight/3+5, 0.5, ItemHeight/3-5);
        layerThree.backgroundColor = RGB_COLOR(232, 232, 232).CGColor;
        [self.layer addSublayer:layerThree];
    }
    if (typeName == AletTypeThree) {
        CALayer *layerThree = [CALayer layer];
        layerThree.frame = CGRectMake(self.frame.size.width/2,self.height - 45, 1, 45);
        layerThree.backgroundColor = RGB_COLOR(232, 232, 232).CGColor;
        layer.frame = CGRectMake(0, 0, self.width/2, 45);
        layerTwo.frame = CGRectMake(0, 0, self.width/2, 45);
        [self.cancelBtn.layer addSublayer:layer];
        [self.confirmBtn.layer addSublayer:layerTwo];
        [self.layer addSublayer:layerThree];
    }
}

#pragma mark - getter
- (YRAlertWindow *)showAlertWindowv{
    if (!_showAlertWindow) {
        _showAlertWindow = [[YRAlertWindow alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
        _showAlertWindow.alpha = 0.0;
    }
    return _showAlertWindow;
}


- (void)show{
    [self.showAlertWindowv addSubview:self];
    __weak typeof(self) weakSelf = self;

    UIWindow * keyWindow = [[UIApplication sharedApplication] keyWindow];
    [keyWindow addSubview:self.showAlertWindowv];
    [UIView animateWithDuration:0.15 animations:^{
        weakSelf.showAlertWindowv.alpha = 1.0f;
    } completion:^(BOOL finished) {
        if (finished) {
            [UIView animateWithDuration:0.2 animations:^{
                
           } completion:^(BOOL finished) {
                
            }];
        }
    }];
}
- (void)dismiss{
    
    __weak typeof(self) weakSelf = self;
    [UIView animateWithDuration:0.1 animations:^{
        CGAffineTransform transform = self.transform;
        weakSelf.transform = CGAffineTransformScale(transform, 1.2, 1.2);
    } completion:^(BOOL finished) {
        
        [UIView animateWithDuration:0.3 animations:^{
            weakSelf.showAlertWindowv.alpha = 0.0;
            CGAffineTransform transform = weakSelf.transform;
            weakSelf.transform = CGAffineTransformScale(transform, 0.01, 0.01);
            
        } completion:^(BOOL finished) {
            
            [weakSelf removeFromSuperview];
            [weakSelf.showAlertWindowv removeFromSuperview];

        }];
    }];
    
    
}
//取消
- (void)cancelAction{
    
    [self dismiss];

    dispatch_after( dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^(void){
        if(self.addCancelAction){
            self.addCancelAction();
        }
    });

}
//确定
- (void)confirmAction{
    [self dismiss];

    dispatch_after( dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^(void){
        if (self.addConfirmAction) {
                self.addConfirmAction();
        }
    });
}


@end
