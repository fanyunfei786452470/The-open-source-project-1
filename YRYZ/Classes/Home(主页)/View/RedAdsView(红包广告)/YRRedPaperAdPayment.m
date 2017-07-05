//
//  YRRedPaperAdPayment.m
//  YRYZ
//
//  Created by Rongzhong on 16/8/18.
//  Copyright © 2016年 yryz. All rights reserved.
//

#import "YRRedPaperAdPayment.h"
#import "YRPaymentScrollView.h"

@interface YRRedPaperAdPayment()<UITextFieldDelegate>

@property(strong,nonatomic) UILabel *topTintLabel;
@property(strong,nonatomic) YRPaymentScrollView *baseScrollView;

@property(strong,nonatomic) UITextField *numberTextField;
@property(strong,nonatomic) UITextField *totalMoneyTextField;
@property(strong,nonatomic) UITextField *singleMoneyTextField;
@property(strong,nonatomic) UILabel     *selectLineLabel;

@property(strong,nonatomic) UIView      *redPaperBgView;

@end



@implementation YRRedPaperAdPayment
{
    NSInteger type;
    
    BOOL isAddRedPaper;
    
    BOOL isInputValid; // 输入是否合法
    NSInteger redPaperNumber;
    NSString *totalMoney;
    NSString *singleMoney;
    
}

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        self.userInteractionEnabled = YES;
        
        
        
        isAddRedPaper = NO;
        type = 0;
        
        isInputValid = YES;
        redPaperNumber = 0;
        totalMoney = 0;
        
        [self setupView];
    }
    return self;
}

-(void)setupView
{
    //增加监听，当键盘出现或改变时收出消息
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillShow:)
                                                 name:UIKeyboardWillShowNotification
                                               object:nil];
    
    //增加监听，当键退出时收出消息
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillHide:)
                                                 name:UIKeyboardWillHideNotification
                                               object:nil];
    
    _baseScrollView = [[YRPaymentScrollView alloc]init];
    @weakify(self);
    _baseScrollView.touchesEndBlock = ^{
        @strongify(self);
        [self endEditing:YES];
    };
    _baseScrollView.frame =  CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT - 108);
    _baseScrollView.contentSize = CGSizeMake(SCREEN_WIDTH, 530);
    [self addSubview:_baseScrollView];

    [self setRedPaperBgView];
    
    _topTintLabel = [[UILabel alloc]init];
    _topTintLabel.frame = CGRectMake(0, -29, SCREEN_WIDTH, 29);
    _topTintLabel.text = @"红包金额不能高于10000.00元";
    _topTintLabel.textColor = [UIColor whiteColor];
    _topTintLabel.backgroundColor = RGB_COLOR(250, 114, 110);
    _topTintLabel.textAlignment = NSTextAlignmentCenter;
    _topTintLabel.font = [UIFont systemFontOfSize:14];
    [self addSubview:_topTintLabel];
    
    
    UILabel *tintLabel = [[UILabel alloc]init];
    tintLabel.frame = CGRectMake(0, 30, SCREEN_WIDTH, 18);
    tintLabel.text = @"绑定红包广告";
    tintLabel.textColor = [UIColor wordColor];
    tintLabel.textAlignment = NSTextAlignmentCenter;
    tintLabel.font = [UIFont systemFontOfSize:18];
    [_baseScrollView addSubview:tintLabel];

    UILabel *tintLabel2 = [[UILabel alloc]init];
    tintLabel2.frame = CGRectMake(0, 237, SCREEN_WIDTH, 18);
    tintLabel2.text = @"平台广告费";
    tintLabel2.textColor = [UIColor wordColor];
    tintLabel2.textAlignment = NSTextAlignmentCenter;
    tintLabel2.font = [UIFont systemFontOfSize:18];
    [_baseScrollView addSubview:tintLabel2];
    
    UIView *moneyBgView = [[UIView alloc]init];
    moneyBgView.frame = CGRectMake(10, 272, SCREEN_WIDTH - 20, 67);
    moneyBgView.backgroundColor = [UIColor colorWithR:246 g:246 b:246 a:1.0];
    moneyBgView.layer.borderWidth = 0.5;
    moneyBgView.layer.borderColor= [UIColor colorWithR:221 g:221 b:221 a:1.0].CGColor;
    moneyBgView.layer.cornerRadius = 5;
    [_baseScrollView addSubview:moneyBgView];
    
    
    UITextField *transferTextField = [[UITextField alloc]init];
    transferTextField.frame = CGRectMake(10, 15, SCREEN_WIDTH - 40, 37);
    transferTextField.backgroundColor = [UIColor whiteColor];
    transferTextField.layer.borderWidth = 0.5;
    transferTextField.layer.borderColor= [UIColor colorWithR:229 g:229 b:229 a:1.0].CGColor;
    transferTextField.layer.cornerRadius = 4;
    transferTextField.keyboardType = UIKeyboardTypeNumberPad;
    transferTextField.textAlignment = NSTextAlignmentRight;
    transferTextField.placeholder = @"至少7";
    transferTextField.textColor = [UIColor themeColor];
    [moneyBgView addSubview:transferTextField];
    
    
    NSMutableAttributedString *dayString= [[NSMutableAttributedString alloc] initWithString:@"购买天数（每天30元/条）"];
    
    [dayString addAttribute:NSForegroundColorAttributeName
                        value:[UIColor wordColor]
                        range:NSMakeRange(0, 4)];
    
    UILabel *dayTintLabel = [[UILabel alloc]init];
    dayTintLabel.frame = CGRectMake(0, 0, 200, 37);
    dayTintLabel.textColor = [UIColor themeColor];
    dayTintLabel.attributedText = dayString;
    dayTintLabel.textAlignment = NSTextAlignmentCenter;
    dayTintLabel.font = [UIFont systemFontOfSize:16];
    
    UILabel *elementLabel1 = [[UILabel alloc]init];
    elementLabel1.frame = CGRectMake(0, 0, 28, 37);
    elementLabel1.text = @"天";
    elementLabel1.textColor = [UIColor wordColor];
    elementLabel1.textAlignment = NSTextAlignmentCenter;
    elementLabel1.font = [UIFont systemFontOfSize:16];
    
    transferTextField.leftView = dayTintLabel;
    transferTextField.leftViewMode = UITextFieldViewModeAlways;
    
    transferTextField.rightView = elementLabel1;
    transferTextField.rightViewMode = UITextFieldViewModeAlways;
    
    
    UIView *totalMoneyBgView = [[UIView alloc]init];
    totalMoneyBgView.frame = CGRectMake(55, 369, SCREEN_WIDTH - 110, 54);
    totalMoneyBgView.backgroundColor = [UIColor colorWithR:246 g:246 b:246 a:1.0];
    totalMoneyBgView.layer.borderWidth = 0.5;
    totalMoneyBgView.layer.borderColor= [UIColor colorWithR:221 g:221 b:221 a:1.0].CGColor;
    totalMoneyBgView.layer.cornerRadius = 27;
    [_baseScrollView addSubview:totalMoneyBgView];
    
    UILabel *lineLabel = [[UILabel alloc]init];
    lineLabel.frame = CGRectMake(SCREEN_WIDTH / 2.0f - 55, 5, 0.5, 44);
    lineLabel.backgroundColor = RGB_COLOR(221, 221, 221);
    [totalMoneyBgView addSubview:lineLabel];
    
    NSArray *titleArray = @[@"红包总额",@"平台广告费"];
    NSArray *moneyArray = @[@"6840.00元",@"300.00元"];
    
    for(int i=0;i<2;i++){
        UILabel *tintLabel = [[UILabel alloc]init];
        tintLabel.frame = CGRectMake((SCREEN_WIDTH / 2.0f - 55) * i, 10, (SCREEN_WIDTH / 2.0f - 55), 15);
        tintLabel.textColor = [UIColor grayColorOne];
        tintLabel.text = [titleArray objectAtIndex:i];
        tintLabel.textAlignment = NSTextAlignmentCenter;
        tintLabel.font = [UIFont systemFontOfSize:15];
        [totalMoneyBgView addSubview:tintLabel];
        
        UILabel *moneyLabel = [[UILabel alloc]init];
        moneyLabel.frame = CGRectMake((SCREEN_WIDTH / 2.0f - 55) * i, 29, (SCREEN_WIDTH / 2.0f - 55), 15);
        moneyLabel.textColor = [UIColor grayColorOne];
        moneyLabel.text = [moneyArray objectAtIndex:i];
        moneyLabel.textAlignment = NSTextAlignmentCenter;
        moneyLabel.font = [UIFont systemFontOfSize:15];
        [totalMoneyBgView addSubview:moneyLabel];
    }
    
    UILabel *tintLabel3 = [[UILabel alloc]init];
    tintLabel3.frame = CGRectMake(0, 443, SCREEN_WIDTH, 18);
    tintLabel3.text = @"支付总额";
    tintLabel3.textColor = [UIColor wordColor];
    tintLabel3.textAlignment = NSTextAlignmentCenter;
    tintLabel3.font = [UIFont systemFontOfSize:18];
    [_baseScrollView addSubview:tintLabel3];
    
    
    UILabel *payMoneyLabel = [[UILabel alloc]init];
    payMoneyLabel.frame = CGRectMake(0, 478, SCREEN_WIDTH, 25);
    payMoneyLabel.textColor = [UIColor themeColor];
    payMoneyLabel.text = @"7140.00元";
    payMoneyLabel.textAlignment = NSTextAlignmentCenter;
    payMoneyLabel.font = [UIFont systemFontOfSize:25];
    [_baseScrollView addSubview:payMoneyLabel];

    UIView *bottomView = [[UIView alloc]init];
    bottomView.frame = CGRectMake(0, SCREEN_HEIGHT - 44 - 64, SCREEN_WIDTH, 44);
    bottomView.backgroundColor = [UIColor colorWithR:246 g:246 b:246 a:1.0];
    [self addSubview:bottomView];
    
    
    
    NSMutableAttributedString *moneyString= [[NSMutableAttributedString alloc] initWithString:@"总额  777777.00元"];
    
    [moneyString addAttribute:NSForegroundColorAttributeName
                        value:[UIColor grayColorOne]
                        range:NSMakeRange(0, 2)];
    
    [moneyString addAttribute:NSFontAttributeName
                        value:[UIFont systemFontOfSize:14]
                        range:NSMakeRange(0, 2)];
    
    
    UILabel *totalMoneyLabel = [[UILabel alloc]init];
    totalMoneyLabel.frame = CGRectMake(10, 0, 180, 44);
    totalMoneyLabel.textColor = RGB_COLOR(250,114, 110);
    totalMoneyLabel.font = [UIFont systemFontOfSize:18];
    totalMoneyLabel.attributedText = moneyString;
    [bottomView addSubview:totalMoneyLabel];
    
    
    UIButton *rechargeButton =[UIButton buttonWithType:UIButtonTypeCustom];
    rechargeButton.frame = CGRectMake(SCREEN_WIDTH - 170, 5, 60, 34);
    rechargeButton.layer.cornerRadius = 17;
    rechargeButton.layer.borderWidth = 0.5;
    rechargeButton.layer.borderColor = RGB_COLOR(191, 191, 191).CGColor;
    [rechargeButton setTitleColor:[UIColor themeColor] forState:UIControlStateNormal];
    [rechargeButton setTitle:@"充值" forState:UIControlStateNormal];
    [rechargeButton addTarget:self action:@selector(rechargeAction) forControlEvents:UIControlEventTouchUpInside];
    [bottomView addSubview:rechargeButton];
    
    
    UIButton *paymentButton =[UIButton buttonWithType:UIButtonTypeCustom];
    paymentButton.frame = CGRectMake(SCREEN_WIDTH - 100, 5, 90, 34);
    paymentButton.layer.cornerRadius = 17;
    paymentButton.backgroundColor = [UIColor themeColor];
    [paymentButton setTitle:@"支付" forState:UIControlStateNormal];
    [paymentButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [paymentButton addTarget:self action:@selector(paymentAction) forControlEvents:UIControlEventTouchUpInside];
    [bottomView addSubview:paymentButton];
}

-(void)setRedPaperBgView
{
    _redPaperBgView = [[UIView alloc]init];
    _redPaperBgView.frame = CGRectMake(10, 65, SCREEN_WIDTH - 20, 155);
    _redPaperBgView.backgroundColor = [UIColor colorWithR:246 g:246 b:246 a:1.0];
    _redPaperBgView.layer.borderWidth = 0.5;
    _redPaperBgView.layer.borderColor= [UIColor colorWithR:221 g:221 b:221 a:1.0].CGColor;
    _redPaperBgView.layer.cornerRadius = 5;
    [_baseScrollView addSubview:_redPaperBgView];

    NSArray* buttonTitleArray = @[@"拼手气红包",@"普通红包"];
    
    for (int index = 0; index < 2; index++) {
        UIButton *typeButton =[UIButton buttonWithType:UIButtonTypeCustom];
        typeButton.tag = 100 + index;
        typeButton.frame = CGRectMake((SCREEN_WIDTH / 2.0f - 10) * index, 0, SCREEN_WIDTH / 2.0f - 10, 38);
        typeButton.titleLabel.font = [UIFont systemFontOfSize:15];
        [typeButton setTitle:[buttonTitleArray objectAtIndex:index] forState:UIControlStateNormal];
        [typeButton addTarget:self action:@selector(changeTypeAction:) forControlEvents:UIControlEventTouchUpInside];
        [_redPaperBgView addSubview:typeButton];
        if (index == 0) {
            [typeButton setTitleColor:[UIColor themeColor] forState:UIControlStateNormal];
        }
        else
        {
            [typeButton setTitleColor:[UIColor grayColorOne] forState:UIControlStateNormal];
        }
    }
    
    _selectLineLabel = [[UILabel alloc]init];
    _selectLineLabel.frame = CGRectMake(25, 36, SCREEN_WIDTH / 2.0f - 60, 2);
    _selectLineLabel.backgroundColor = [UIColor themeColor];
    [_redPaperBgView addSubview:_selectLineLabel];
    
    
    UILabel *lineLabel = [[UILabel alloc]init];
    lineLabel.frame = CGRectMake(SCREEN_WIDTH / 2.0f - 10, 6, 0.5, 26);
    lineLabel.backgroundColor = RGB_COLOR(221, 221, 221);
    [_redPaperBgView addSubview:lineLabel];
    
    UILabel *horizontalLineLabel = [[UILabel alloc]init];
    horizontalLineLabel.frame = CGRectMake(0, 38, SCREEN_WIDTH - 20, 0.5);
    horizontalLineLabel.backgroundColor = RGB_COLOR(221, 221, 221);
    [_redPaperBgView addSubview:horizontalLineLabel];
    
    
    _numberTextField = [[UITextField alloc]init];
    _numberTextField.frame = CGRectMake(10, 54, SCREEN_WIDTH - 40, 37);
    _numberTextField.backgroundColor = [UIColor whiteColor];
    _numberTextField.layer.borderWidth = 0.5;
    _numberTextField.layer.borderColor= [UIColor colorWithR:229 g:229 b:229 a:1.0].CGColor;
    _numberTextField.layer.cornerRadius = 4;
    _numberTextField.textAlignment = NSTextAlignmentRight;
    _numberTextField.keyboardType = UIKeyboardTypeNumberPad;
    _numberTextField.placeholder = @"填写个数";
    _numberTextField.textColor = [UIColor wordColor];
    [_numberTextField addTarget:self
                         action:@selector(numberTextFieldDidChange:)
               forControlEvents:UIControlEventEditingChanged];
    [_redPaperBgView addSubview:_numberTextField];
    
    UILabel *numberTintLabel = [[UILabel alloc]init];
    numberTintLabel.frame = CGRectMake(0, 0, 80, 37);
    numberTintLabel.text = @"红包个数";
    numberTintLabel.textColor = [UIColor wordColor];
    numberTintLabel.textAlignment = NSTextAlignmentCenter;
    numberTintLabel.font = [UIFont systemFontOfSize:16];
    
    UILabel *elementLabel1 = [[UILabel alloc]init];
    elementLabel1.frame = CGRectMake(0, 0, 28, 37);
    elementLabel1.text = @"个";
    elementLabel1.textColor = [UIColor wordColor];
    elementLabel1.textAlignment = NSTextAlignmentCenter;
    elementLabel1.font = [UIFont systemFontOfSize:16];
    
    _numberTextField.leftView = numberTintLabel;
    _numberTextField.leftViewMode = UITextFieldViewModeAlways;
    
    _numberTextField.rightView = elementLabel1;
    _numberTextField.rightViewMode = UITextFieldViewModeAlways;
    
    
    _totalMoneyTextField = [[UITextField alloc]init];
    _totalMoneyTextField.frame = CGRectMake(10, 103, SCREEN_WIDTH - 40, 37);
    _totalMoneyTextField.backgroundColor = [UIColor whiteColor];
    _totalMoneyTextField.layer.borderWidth = 0.5;
    _totalMoneyTextField.layer.borderColor= [UIColor colorWithR:229 g:229 b:229 a:1.0].CGColor;
    _totalMoneyTextField.layer.cornerRadius = 4;
    _totalMoneyTextField.textAlignment = NSTextAlignmentRight;
    _totalMoneyTextField.keyboardType = UIKeyboardTypeDecimalPad;
    _totalMoneyTextField.placeholder = @"填写金额";
    _totalMoneyTextField.delegate = self;
    _totalMoneyTextField.textColor = [UIColor wordColor];//RGB_COLOR(250, 114, 111);
    [_totalMoneyTextField addTarget:self
                             action:@selector(totalMoneyTextFieldDidChange:)
                   forControlEvents:UIControlEventEditingChanged];
    [_redPaperBgView addSubview:_totalMoneyTextField];
    
    UILabel *totalTintLabel = [[UILabel alloc]init];
    totalTintLabel.frame = CGRectMake(0, 0, 64, 37);
    totalTintLabel.text = @"总金额";
    totalTintLabel.textColor = [UIColor wordColor];
    totalTintLabel.textAlignment = NSTextAlignmentCenter;
    totalTintLabel.font = [UIFont systemFontOfSize:16];
    
    UILabel *elementLabel2 = [[UILabel alloc]init];
    elementLabel2.frame = CGRectMake(0, 0, 28, 37);
    elementLabel2.text = @"元";
    elementLabel2.textColor = [UIColor wordColor];
    elementLabel2.textAlignment = NSTextAlignmentCenter;
    elementLabel2.font = [UIFont systemFontOfSize:16];
    
    _totalMoneyTextField.leftView = totalTintLabel;
    _totalMoneyTextField.leftViewMode = UITextFieldViewModeAlways;
    
    _totalMoneyTextField.rightView = elementLabel2;
    _totalMoneyTextField.rightViewMode = UITextFieldViewModeAlways;
    
    
    _singleMoneyTextField = [[UITextField alloc]init];
    _singleMoneyTextField.frame = CGRectMake(SCREEN_WIDTH - 10, 103, SCREEN_WIDTH - 40, 37);
    _singleMoneyTextField.backgroundColor = [UIColor whiteColor];
    _singleMoneyTextField.layer.borderWidth = 0.5;
    _singleMoneyTextField.layer.borderColor= [UIColor colorWithR:229 g:229 b:229 a:1.0].CGColor;
    _singleMoneyTextField.layer.cornerRadius = 4;
    _singleMoneyTextField.textAlignment = NSTextAlignmentRight;
    _singleMoneyTextField.keyboardType = UIKeyboardTypeDecimalPad;
    _singleMoneyTextField.placeholder = @"填写金额";
    _singleMoneyTextField.delegate = self;
    _singleMoneyTextField.textColor = [UIColor wordColor];//RGB_COLOR(250, 114, 111);
    [_singleMoneyTextField addTarget:self
                              action:@selector(singleMoneyTextFieldDidChange:)
                    forControlEvents:UIControlEventEditingChanged];
    [_redPaperBgView addSubview:_singleMoneyTextField];
    
    UILabel *singleTintLabel = [[UILabel alloc]init];
    singleTintLabel.frame = CGRectMake(0, 0, 80, 37);
    singleTintLabel.text = @"单个金额";
    singleTintLabel.textColor = [UIColor wordColor];
    singleTintLabel.textAlignment = NSTextAlignmentCenter;
    singleTintLabel.font = [UIFont systemFontOfSize:16];
    
    UILabel *elementLabel3 = [[UILabel alloc]init];
    elementLabel3.frame = CGRectMake(0, 0, 28, 37);
    elementLabel3.text = @"元";
    elementLabel3.textColor = [UIColor wordColor];
    elementLabel3.textAlignment = NSTextAlignmentCenter;
    elementLabel3.font = [UIFont systemFontOfSize:16];
    
    _singleMoneyTextField.leftView = singleTintLabel;
    _singleMoneyTextField.leftViewMode = UITextFieldViewModeAlways;
    
    _singleMoneyTextField.rightView = elementLabel3;
    _singleMoneyTextField.rightViewMode = UITextFieldViewModeAlways;
    
}

-(void)readRuleAction
{
    
}

-(void)rechargeAction
{
    
}

-(void)paymentAction
{
    //if (_paymentBlock) {
        //_paymentBlock();
    //}
}

-(void)changeTypeAction:(UIButton*)selectedButton
{
    if (type == selectedButton.tag - 100) {
        return;
    }
    else
    {
        type = selectedButton.tag - 100;
    }
    
    UIButton *unSelectedButton = (UIButton*)[[selectedButton superview]viewWithTag:(201 - selectedButton.tag)];
    
    [selectedButton setTitleColor:[UIColor themeColor] forState:UIControlStateNormal];
    [unSelectedButton setTitleColor:[UIColor grayColorOne] forState:UIControlStateNormal];
    
    if (type == 0) {
        if (redPaperNumber != 0) {
            _totalMoneyTextField.text = [NSString stringWithFormat:@"%.2f",[_singleMoneyTextField.text floatValue] * redPaperNumber];
        }
        else
        {
            _totalMoneyTextField.text = [NSString stringWithFormat:@"%.2f",[_singleMoneyTextField.text floatValue]];
        }
    }
    else{
        if (redPaperNumber != 0) {
            _singleMoneyTextField.text = [NSString stringWithFormat:@"%.2f",[_totalMoneyTextField.text floatValue] / redPaperNumber];
        }
        else
        {
            _singleMoneyTextField.text = [NSString stringWithFormat:@"%.2f",[_totalMoneyTextField.text floatValue]];
        }
    }
    
    [UIView animateWithDuration:0.3 animations:^{
        
        _selectLineLabel.frame = CGRectMake(25 + (SCREEN_WIDTH / 2.0f - 10) * (selectedButton.tag - 100), 36, SCREEN_WIDTH / 2.0f - 60, 2);
        
        if (type == 0) {
            
            _totalMoneyTextField.frame = CGRectMake(10, 103, SCREEN_WIDTH - 40, 37);
            _singleMoneyTextField.frame = CGRectMake(30 - SCREEN_WIDTH, 103, SCREEN_WIDTH - 40, 37);
        }
        else{
            _totalMoneyTextField.frame = CGRectMake(30 - SCREEN_WIDTH, 103, SCREEN_WIDTH - 40, 37);
            _singleMoneyTextField.frame = CGRectMake(10, 103, SCREEN_WIDTH - 40, 37);
        }
    } completion:^(BOOL finished) {
        if (type == 0) {
            _singleMoneyTextField.frame = CGRectMake(SCREEN_WIDTH - 10, 103, SCREEN_WIDTH - 40, 37);
        }
        else
        {
            _totalMoneyTextField.frame = CGRectMake(SCREEN_WIDTH - 10, 103, SCREEN_WIDTH - 40, 37);
        }
    }];
}

-(void)numberTextFieldDidChange:(UITextField*)numberTextField
{
    NSInteger number = [numberTextField.text integerValue];
    if (number > 1000) {
        number = redPaperNumber;
    }
    else if(number > 500)
    {
        _numberTextField.textColor = RGB_COLOR(250, 114, 111);
        
        redPaperNumber = [numberTextField.text integerValue];
        
        _topTintLabel.text = @"红包数量不能大于500个";
        
        [UIView animateWithDuration:0.25 animations:^{
            _topTintLabel.frame = CGRectMake(0,self.contentOffset.y, SCREEN_WIDTH, 29);
            isInputValid = NO;
        }];
    }
    else
    {
        _numberTextField.textColor = [UIColor wordColor];
        
        redPaperNumber = [numberTextField.text integerValue];
        
        if (type == 1) {
            if (redPaperNumber != 0) {
                totalMoney = [NSString stringWithFormat:@"%.2f",[_singleMoneyTextField.text floatValue] * redPaperNumber];
            }
            else
            {
                totalMoney = [NSString stringWithFormat:@"%.2f",[_singleMoneyTextField.text floatValue]];
            }
        }
        
        if ([totalMoney floatValue] > 10000) {
            _topTintLabel.text = @"红包总金额不能大于10000元";
            isInputValid = NO;
            [UIView animateWithDuration:0.25 animations:^{
                _topTintLabel.frame = CGRectMake(0, self.contentOffset.y, SCREEN_WIDTH, 29);
            }];
        }
        else
        {
            isInputValid = YES;
            [UIView animateWithDuration:0.5 animations:^{
                _topTintLabel.frame = CGRectMake(0,  self.contentOffset.y - 29 , SCREEN_WIDTH, 29);
            }];
        }
    }
    numberTextField.text = [NSString stringWithFormat:@"%ld",number];
}


-(void)totalMoneyTextFieldDidChange:(UITextField*)totalMoneyTextField
{
    if([totalMoneyTextField.text rangeOfString:@"."].location !=NSNotFound)//_roaldSearchText
    {
        
        NSString *str = totalMoneyTextField.text;
        
        NSInteger pointNumber = 0;
        
        for(int i = 0; i < [str length]; i++)
        {
            unichar temp = [str characterAtIndex:i];
            if (temp == '.') {
                pointNumber++;
            }
            if (pointNumber == 1) {
                if ([str length] > i + 3) {
                    totalMoneyTextField.text = [totalMoneyTextField.text substringToIndex:[totalMoneyTextField.text length] - 1];
                    break;
                }
            }
            if (pointNumber > 1) {
                totalMoneyTextField.text = [totalMoneyTextField.text substringToIndex:[totalMoneyTextField.text length] - 1];
                break;
            }
        }
    }
    
    float number = [totalMoneyTextField.text floatValue];
    if (number > 100000) {
        totalMoneyTextField.text = totalMoney;
    }
    else if(number > 10000)
    {
        _totalMoneyTextField.textColor = RGB_COLOR(250, 114, 111);
        
        totalMoney = totalMoneyTextField.text;
        isInputValid = NO;
        
        _topTintLabel.text = @"红包总金额不能大于10000元";
        
        [UIView animateWithDuration:0.25 animations:^{
            _topTintLabel.frame = CGRectMake(0, self.contentOffset.y, SCREEN_WIDTH, 29);
        }];
    }
    else
    {
        _totalMoneyTextField.textColor = [UIColor wordColor];
        
        totalMoney = totalMoneyTextField.text;
        
        if([_numberTextField.text integerValue] <= 500)
        {
            isInputValid = YES;
            [UIView animateWithDuration:0.5 animations:^{
                _topTintLabel.frame = CGRectMake(0, self.contentOffset.y - 29, SCREEN_WIDTH, 29);
            }];
        }
        else
        {
            _topTintLabel.text = @"红包数量不能大于500个";
        }
    }
}

-(void)singleMoneyTextFieldDidChange:(UITextField*)singleMoneyTextField
{
    if([singleMoneyTextField.text rangeOfString:@"."].location !=NSNotFound)//_roaldSearchText
    {
        NSString *str = singleMoneyTextField.text;
        
        NSInteger pointNumber = 0;
        
        for(int i = 0; i < [str length]; i++)
        {
            unichar temp = [str characterAtIndex:i];
            if (temp == '.') {
                pointNumber++;
            }
            if (pointNumber == 1) {
                if ([str length] > i + 3) {
                    singleMoneyTextField.text = [singleMoneyTextField.text substringToIndex:[singleMoneyTextField.text length] - 1];
                    break;
                }
            }
            if (pointNumber > 1) {
                singleMoneyTextField.text = [singleMoneyTextField.text substringToIndex:[singleMoneyTextField.text length] - 1];
                break;
            }
        }
    }
    
    float number;
    
    if (redPaperNumber != 0) {
        number = [singleMoneyTextField.text floatValue] * redPaperNumber;
    }
    else
    {
        number = [singleMoneyTextField.text floatValue];
    }
    
    if ([singleMoneyTextField.text floatValue] > 100000) {
        singleMoneyTextField.text = singleMoney;
    }
    else if(number > 10000)
    {
        singleMoney = singleMoneyTextField.text;
        isInputValid = NO;
        
        _topTintLabel.text = @"红包总金额不能大于10000元";
        
        [UIView animateWithDuration:0.25 animations:^{
            _topTintLabel.frame = CGRectMake(0, self.contentOffset.y, SCREEN_WIDTH, 29);
        }];
    }
    else
    {
        singleMoney = singleMoneyTextField.text;
        
        if([_numberTextField.text integerValue] <= 500)
        {
            isInputValid = YES;
            [UIView animateWithDuration:0.5 animations:^{
                _topTintLabel.frame = CGRectMake(0, self.contentOffset.y - 29, SCREEN_WIDTH, 29);
            }];
        }
        else
        {
            _topTintLabel.text = @"红包数量不能大于500个";
        }
    }
    
    if ([singleMoneyTextField.text floatValue] > 10000) {
        _singleMoneyTextField.textColor = RGB_COLOR(250, 114, 111);
    }
    else
    {
        _singleMoneyTextField.textColor = [UIColor wordColor];
    }
}



- (void)keyboardWillShow:(NSNotification *)aNotification
{
    NSDictionary *userInfo = [aNotification userInfo];
    NSValue *aValue = [userInfo objectForKey:UIKeyboardFrameEndUserInfoKey];
    CGRect keyboardRect = [aValue CGRectValue];
    int height = keyboardRect.size.height;
    
    [self setContentOffset:CGPointMake(0,height)];
    _topTintLabel.frame = CGRectMake(0, isInputValid? -29 :self.contentOffset.y, SCREEN_WIDTH, 29);
    
    
    _baseScrollView.frame = CGRectMake(0,self.contentOffset.y, SCREEN_WIDTH, SCREEN_HEIGHT - self.contentOffset.y - 108);
    _baseScrollView.contentOffset = CGPointMake(0, self.contentOffset.y);
}

//当键退出时调用
- (void)keyboardWillHide:(NSNotification *)aNotification
{
    [self setContentOffset:CGPointMake(0,0)];
    _baseScrollView.frame = self.bounds;
    _topTintLabel.frame = CGRectMake(0, isInputValid?-29:self.contentOffset.y, SCREEN_WIDTH, 29);
    
}

@end
