//
//  YRPaymentPasswordView.m
//  YRYZ
//
//  Created by Rongzhong on 16/7/14.
//  Copyright © 2016年 yryz. All rights reserved.
//

#import "YRPaymentPasswordView.h"

@interface YRPaymentPasswordView()

typedef void (^PaymentBlock)(NSString*);

@property (strong, nonatomic) PaymentBlock paymentBlock;

@property(strong,nonatomic) UIView *payBackView;
@property(strong,nonatomic) UITextField *hideTextField;
@property(strong,nonatomic) UILabel *moneyLabel;

@end

static YRPaymentPasswordView *paymentView = nil;

@implementation YRPaymentPasswordView



- (instancetype)initWithFrame:(CGRect)frame
{
    frame = CGRectMake(0, 0,  SCREEN_WIDTH , SCREEN_HEIGHT);
    self.frame = frame;
    if (self = [super initWithFrame:frame]) {
        [self setupViewWithTitle:@"支付金额"];
        self.hidden = YES;
        self.bounds = CGRectMake(0, 40, self.frame.size.width, self.frame.size.height);
    }
    return self;
}
-(instancetype)initWithiItegral{
    CGRect frame = CGRectMake(0, 0,  SCREEN_WIDTH , SCREEN_HEIGHT);
    self.frame = frame;
    if (self = [super initWithFrame:frame]) {
        [self setupViewWithTitle:@"兑换积分"];
        self.hidden = YES;
        self.bounds = CGRectMake(0, 40, self.frame.size.width, self.frame.size.height);
    }
    return self;
    
}
+ (YRPaymentPasswordView *)sharedPaymentView
{
    static dispatch_once_t predicate;
    dispatch_once(&predicate, ^{
        paymentView = [[YRPaymentPasswordView alloc]initWithFrame:CGRectMake(0, 0,  SCREEN_WIDTH , SCREEN_HEIGHT)];
        UIWindow *window = [[[UIApplication sharedApplication]delegate]window];
        [window addSubview:paymentView];
    });
    return paymentView;
}

+(void)showPaymentViewWithMoney:(NSString*)money paymentBlock:(void(^)(NSString*))paymentBlock
{
    [[YRPaymentPasswordView sharedPaymentView] showPaymentPasswordView];
    [[YRPaymentPasswordView sharedPaymentView] refreshDataWithMoney:money];
    [YRPaymentPasswordView sharedPaymentView].paymentBlock = paymentBlock;
}


+ (void)hidePaymentPasswordView{
  
    [[YRPaymentPasswordView sharedPaymentView] hidePaymentPasswordView];
    
}


-(void)setupViewWithTitle:(NSString *)title{
    UIView* shadeView = [[UIView alloc]init];
    shadeView.frame = self.bounds;
    shadeView.backgroundColor = [UIColor colorWithR:0 g:0 b:0 a:0.6];
    [self addSubview:shadeView];
    
    _payBackView = [[UIView alloc]init];
    _payBackView.backgroundColor = [UIColor whiteColor];
    _payBackView.layer.cornerRadius = 4;
    _payBackView.frame = YRRectMake(38.5, 568, 243, 183.5);
    [self addSubview:_payBackView];
    
    UILabel* titleLabel = [[UILabel alloc]init];
    titleLabel.text = @"请输入支付密码";
    titleLabel.textAlignment = NSTextAlignmentCenter;
    titleLabel.textColor = [UIColor wordColor];
    titleLabel.font = [UIFont boldSystemFontOfSize:16];
    titleLabel.frame = YRRectMake(0, 0, 243, 32.5);
    [_payBackView addSubview:titleLabel];
    
    UIButton* backButton = [[UIButton alloc]init];
    backButton.frame = CGRectMake(_payBackView.size.width -21, (titleLabel.size.height - 13)/2.0f, 13, 13);
    [backButton setBackgroundImage:[UIImage imageNamed:@"cancelPaymentImage"] forState:UIControlStateNormal];
    [backButton addTarget:self action:@selector(cancelAction) forControlEvents:UIControlEventTouchUpInside];
    [_payBackView addSubview:backButton];
    
    
    UILabel* lineLabel = [[UILabel alloc]init];
    lineLabel.backgroundColor = RGB_COLOR(238, 238, 238);
    lineLabel.frame = YRRectMake(0, 32.5, 243, 0.5);
    [_payBackView addSubview:lineLabel];
    
    
    UILabel *moneyTintLabel = [[UILabel alloc]init];
    moneyTintLabel.frame = YRRectMake(0, 54.5, 243, 16);
    moneyTintLabel.textColor = [UIColor wordColor];
    moneyTintLabel.text = title;
    moneyTintLabel.textAlignment = NSTextAlignmentCenter;
    moneyTintLabel.font = [UIFont systemFontOfSize:16];
    [_payBackView addSubview:moneyTintLabel];
    
    
    NSMutableAttributedString *moneyString= [[NSMutableAttributedString alloc] initWithString:@"1.50元"];
    [moneyString addAttribute:NSFontAttributeName
                        value:[UIFont systemFontOfSize:30]
                        range:NSMakeRange(0, 4)];
    
    _moneyLabel = [[UILabel alloc]init];
    _moneyLabel.frame = YRRectMake(0, 77, 243, 30);
    _moneyLabel.textColor = [UIColor themeColor];
    _moneyLabel.textAlignment = NSTextAlignmentCenter;
    _moneyLabel.font = [UIFont systemFontOfSize:14];
    _moneyLabel.attributedText = moneyString;
    [_payBackView addSubview:_moneyLabel];
    
    for (int i=0; i<6; i++) {
        UILabel* borderLabel = [[UILabel alloc]init];
        borderLabel.frame = YRRectMake(10+i*37, 127.5, 38, 38);
        borderLabel.backgroundColor = [UIColor whiteColor];
        borderLabel.layer.borderWidth = 1;
        borderLabel.layer.borderColor = [UIColor grayColorThree].CGColor;
        [_payBackView addSubview:borderLabel];
        
        UIButton* dotLabel = [[UIButton alloc]init];
        dotLabel.frame = YRRectMake(25.5+i*37, 141.5, 10, 10);
        dotLabel.tag = 100 + i;
        dotLabel.backgroundColor = [UIColor blackColor];
        dotLabel.layer.cornerRadius = 5 * SCREEN_WIDTH /320.0f;
        dotLabel.hidden = YES;
        [_payBackView addSubview:dotLabel];
        
    }

    _hideTextField = [[UITextField alloc]init];
    _hideTextField.frame = YRRectMake(320, 105, 200, 20);
    _hideTextField.keyboardType = UIKeyboardTypeNumberPad;
    [_hideTextField addTarget:self action:@selector(textFieldChangeAction)  forControlEvents:UIControlEventEditingChanged];
    [self addSubview:_hideTextField];
}

-(void)textFieldChangeAction
{
    if (_hideTextField.text.length==6) {
        if (_paymentBlock) {
            _paymentBlock(_hideTextField.text);
        }
    }
    if (_hideTextField.text.length>6) {
        _hideTextField.text=[_hideTextField.text substringWithRange:NSMakeRange(0, 6)];
    }
    for (int i=0; i<6; i++) {
        UILabel* dotLabel=(UILabel*)[_payBackView viewWithTag:100+i];
        if (i<_hideTextField.text.length) {
            dotLabel.hidden=NO;
        }
        else
        {
            dotLabel.hidden=YES;
        }
    }
}

-(void)refreshDataWithMoney:(NSString*)money{
    
    NSString *moneyString = [NSString stringWithFormat:@"%@元",money];
    
    NSMutableAttributedString *aString= [[NSMutableAttributedString alloc] initWithString:moneyString];
    [aString addAttribute:NSFontAttributeName
                        value:[UIFont systemFontOfSize:30]
                        range:[moneyString rangeOfString:money]];
    
    _moneyLabel.attributedText = aString;
}

-(void)cancelAction
{
    [self endEditing:YES];
    [UIView animateWithDuration:0.25 animations:^{
        _payBackView.frame = YRRectMake(38.5, 568, 243, 183.5);
    }completion:^(BOOL finished) {
        for (int i=0; i<6; i++) {
            UIButton* dotLabel=(UIButton*)[_payBackView viewWithTag:100+i];
            dotLabel.hidden=YES;
        }
        _hideTextField.text = @"";
        self.hidden = YES;
    }];
}

-(void)showPaymentPasswordView
{
    self.hidden = NO;
    [_hideTextField becomeFirstResponder];
    
    [UIView animateWithDuration:0.3 animations:^{
        _payBackView.frame = YRRectMake(38.5, (SCREEN_HEIGHT - 440) * 320.0f / SCREEN_WIDTH, 243, 183.5);
    }];
  
}
- (void)hidePaymentPasswordView{

    
    [self endEditing:NO];
    [UIView animateWithDuration:0.1 animations:^{
        _payBackView.frame = YRRectMake(38.5, 568, 243, 183.5);
    }completion:^(BOOL finished) {
        for (int i=0; i<6; i++) {
            UIButton* dotLabel=(UIButton*)[_payBackView viewWithTag:100+i];
            dotLabel.hidden=YES;
        }
        _hideTextField.text = @"";
        self.hidden = YES;
    }];
}


@end
