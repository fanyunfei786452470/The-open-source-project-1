//
//  YRRedPaperAdPayment.m
//  YRYZ
//
//  Created by Rongzhong on 16/8/18.
//  Copyright © 2016年 yryz. All rights reserved.
//

#import "YRRedPaperAdPayment.h"
#import "YRPaymentScrollView.h"
#import "YRAccountModel.h"
#import "RewardGiftModel.h"


//广告红包最小个数
#define MinAdRedPaperNumber 30
//广告红包最大个数
#define MaxAdRedPaperNumber 500
//广告红包最小总金额
#define MinAdRedPaperMoney 100
//广告红包最大总金额
#define MaxAdRedPaperMoney 3000

@interface YRRedPaperAdPayment()<UITextFieldDelegate>
{
    NSInteger   _selectedGift;
}
@property(strong,nonatomic) UILabel *topTintLabel;
@property(strong,nonatomic) YRPaymentScrollView *baseScrollView;

@property (strong,nonatomic)UITextField * transferTextField;//选择的天数
@property(strong,nonatomic) UITextField *numberTextField;
@property(strong,nonatomic) UITextField *totalMoneyTextField;
@property(strong,nonatomic) UITextField *singleMoneyTextField;
@property (nonatomic,strong) UITextField *payDays;
@property(strong,nonatomic) UILabel     *selectLineLabel;
@property(strong,nonatomic) UIView      *redPaperBgView;
@property (strong, nonatomic) NSArray *modelArray;
//账户余额
@property(strong,nonatomic)NSString                     *balanceStr;
@property(strong,nonatomic)UILabel                      *totalMoneyLabel;

@property(strong,nonatomic)UIButton                     *paymentButton;

@property (strong,nonatomic)UILabel * redtotal;//红包总额
@property (strong,nonatomic)UILabel * adstotal;//广告费
@property (strong,nonatomic)UILabel * payMoneyLabel;//支付总额
@property (nonatomic,assign)NSInteger dayNum;//广告天数
@property (nonatomic,assign)NSInteger monNum;//运气红包金额
@property (nonatomic,assign)float singleNum;//红包数量
@property (nonatomic,assign)NSInteger redNum;//运气红包数量
@property (nonatomic,assign)BOOL isLuck;//判断是否是运气红包


@property (nonatomic,strong) UILabel *dayTintLabel;
@end



@implementation YRRedPaperAdPayment
{
    NSInteger type;
    
    BOOL isAddRedPaper;
    
    BOOL isInputValid; // 输入是否合法
    NSString *singleMoney;
    float balance;
}


- (void)fectData{
    
    
    [YRHttpRequest AccountBalanceQuerySuccess:^(NSDictionary *data) {
        
        YRAccountModel  *accountModel = [YRAccountModel mj_objectWithKeyValues:data];
        
        float account = [accountModel.accountSum floatValue]*0.01;
        self.balanceStr = [NSString stringWithFormat:@"余额 %.2f",account];
        balance = account;
        
    } failure:^(NSString *error) {
        [MBProgressHUD showError:error];
    }];
    
}


- (void)setBalanceStr:(NSString *)balanceStr{
    
    _balanceStr = balanceStr;
    
    NSMutableAttributedString *moneyString= [[NSMutableAttributedString alloc] initWithString:balanceStr];
    
    [moneyString addAttribute:NSForegroundColorAttributeName
                        value:[UIColor grayColorOne]
                        range:NSMakeRange(0, 2)];
    
    [moneyString addAttribute:NSFontAttributeName
                        value:[UIFont systemFontOfSize:14]
                        range:NSMakeRange(0, 2)];
    
    self.totalMoneyLabel.attributedText = moneyString;
    
}


- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        self.userInteractionEnabled = YES;
        
        [self fectData];
        
        isAddRedPaper = NO;
        type = 0;
        
        isInputValid = YES;
        
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
    _baseScrollView.contentSize = CGSizeMake(SCREEN_WIDTH, SCREEN_HEIGHT );
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
    tintLabel.text = @"绑定广告红包";
    tintLabel.textColor = [UIColor wordColor];
    tintLabel.textAlignment = NSTextAlignmentCenter;
    tintLabel.font = [UIFont systemFontOfSize:18];
    [_baseScrollView addSubview:tintLabel];
    
    UIButton *tintButton =[UIButton buttonWithType:UIButtonTypeCustom];
    tintButton.frame = CGRectMake(SCREEN_WIDTH / 2.0f - 50, 237, 123, 18);
    [tintButton setTitleColor:[UIColor wordColor] forState:UIControlStateNormal];
    //[tintButton setTitle:@"平台广告费" forState:UIControlStateNormal];
    tintButton.titleLabel.font = [UIFont systemFontOfSize:18];
    [tintButton addTarget:self action:@selector(openAdWebPage) forControlEvents:UIControlEventTouchUpInside];
    [_baseScrollView addSubview:tintButton];
    
    UIImageView *tintImageView = [[UIImageView alloc]init];
    tintImageView.frame = CGRectMake(103, 0, 18, 18);
    tintImageView.image = [UIImage imageNamed:@"ad_profit"];
    [tintButton addSubview:tintImageView];
    
    UILabel *tintLabel2 = [[UILabel alloc]init];
    tintLabel2.frame = CGRectMake(0, 0, 100, 18);
    tintLabel2.text = @"平台广告费";
    tintLabel2.textColor = [UIColor wordColor];
    tintLabel2.textAlignment = NSTextAlignmentCenter;
    tintLabel2.font = [UIFont systemFontOfSize:18];
    [tintButton addSubview:tintLabel2];
    
    UIView *moneyBgView = [[UIView alloc]init];
    moneyBgView.frame = CGRectMake(10, 272, SCREEN_WIDTH - 20, 67);
    moneyBgView.backgroundColor = [UIColor colorWithR:246 g:246 b:246 a:1.0];
    moneyBgView.layer.borderWidth = 0.5;
    moneyBgView.layer.borderColor= [UIColor colorWithR:221 g:221 b:221 a:1.0].CGColor;
    moneyBgView.layer.cornerRadius = 5;
    [_baseScrollView addSubview:moneyBgView];
    
    
    _transferTextField = [[UITextField alloc]init];
    _transferTextField.frame = CGRectMake(10, 15, SCREEN_WIDTH - 40, 37);
    _transferTextField.backgroundColor = [UIColor whiteColor];
    _transferTextField.layer.borderWidth = 0.5;
    _transferTextField.layer.borderColor= [UIColor colorWithR:229 g:229 b:229 a:1.0].CGColor;
    _transferTextField.layer.cornerRadius = 4;
    _transferTextField.keyboardType = UIKeyboardTypeNumberPad;
    _transferTextField.textAlignment = NSTextAlignmentRight;
    _transferTextField.placeholder = @"至少7";
    _transferTextField.delegate =self;
    [_transferTextField addTarget:self action:@selector(transferTextFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
    _transferTextField.textColor = [UIColor themeColor];
    self.payDays = _transferTextField;
    [moneyBgView addSubview:_transferTextField];
    
    
    NSMutableAttributedString *dayString= [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"购买天数（每天%.0f%@",_adsPrice,@"元/条）"]];
    
    [dayString addAttribute:NSForegroundColorAttributeName
                      value:[UIColor wordColor]
                      range:NSMakeRange(0, 4)];
    
    _dayTintLabel = [[UILabel alloc]init];
    _dayTintLabel.frame = CGRectMake(0, 0, 200, 37);
    _dayTintLabel.textColor = [UIColor themeColor];
    _dayTintLabel.attributedText = dayString;
    _dayTintLabel.textAlignment = NSTextAlignmentCenter;
    _dayTintLabel.font = [UIFont systemFontOfSize:16];
    
    UILabel *elementLabel1 = [[UILabel alloc]init];
    elementLabel1.frame = CGRectMake(0, 0, 28, 37);
    elementLabel1.text = @"天";
    elementLabel1.textColor = [UIColor wordColor];
    elementLabel1.textAlignment = NSTextAlignmentCenter;
    elementLabel1.font = [UIFont systemFontOfSize:16];
    
    _transferTextField.leftView = _dayTintLabel;
    _transferTextField.leftViewMode = UITextFieldViewModeAlways;
    
    _transferTextField.rightView = elementLabel1;
    _transferTextField.rightViewMode = UITextFieldViewModeAlways;
    
    
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
    for(int i=0;i<2;i++){
        UILabel *tintLabel = [[UILabel alloc]init];
        tintLabel.frame = CGRectMake((SCREEN_WIDTH / 2.0f - 55) * i, 10, (SCREEN_WIDTH / 2.0f - 55), 15);
        tintLabel.textColor = [UIColor grayColorOne];
        tintLabel.text = [titleArray objectAtIndex:i];
        tintLabel.textAlignment = NSTextAlignmentCenter;
        tintLabel.font = [UIFont systemFontOfSize:15];
        [totalMoneyBgView addSubview:tintLabel];
    }
    _redtotal = [[UILabel alloc]init];
    _redtotal.frame = CGRectMake((SCREEN_WIDTH / 2.0f - 55) * 0, 29, (SCREEN_WIDTH / 2.0f - 55), 15);
    _redtotal.textColor = [UIColor grayColorOne];
    _redtotal.text = @"0.00元";
    _redtotal.textAlignment = NSTextAlignmentCenter;
    _redtotal.font = [UIFont systemFontOfSize:15];
    [totalMoneyBgView addSubview:_redtotal];
    
    _adstotal = [[UILabel alloc]init];
    _adstotal.frame = CGRectMake((SCREEN_WIDTH / 2.0f - 55) * 1, 29, (SCREEN_WIDTH / 2.0f - 55), 15);
    _adstotal.textColor = [UIColor grayColorOne];
    _adstotal.text = @"0.00元";
    _adstotal.textAlignment = NSTextAlignmentCenter;
    _adstotal.font = [UIFont systemFontOfSize:15];
    [totalMoneyBgView addSubview:_adstotal];
    
    UILabel *tintLabel3 = [[UILabel alloc]init];
    tintLabel3.frame = CGRectMake(0, 443, SCREEN_WIDTH, 18);
    tintLabel3.text = @"支付总额";
    tintLabel3.textColor = [UIColor wordColor];
    tintLabel3.textAlignment = NSTextAlignmentCenter;
    tintLabel3.font = [UIFont systemFontOfSize:18];
    [_baseScrollView addSubview:tintLabel3];
    
    
    _payMoneyLabel = [[UILabel alloc]init];
    _payMoneyLabel.frame = CGRectMake(0, 478, SCREEN_WIDTH, 25);
    _payMoneyLabel.textColor = [UIColor themeColor];
    _payMoneyLabel.text = @"0.00元";
    _payMoneyLabel.textAlignment = NSTextAlignmentCenter;
    _payMoneyLabel.font = [UIFont systemFontOfSize:25];
    [_baseScrollView addSubview:_payMoneyLabel];
    
    UIView *bottomView = [[UIView alloc]init];
    bottomView.frame = CGRectMake(0, SCREEN_HEIGHT - 44 - 64, SCREEN_WIDTH, 44);
    bottomView.backgroundColor = [UIColor colorWithR:246 g:246 b:246 a:1.0];
    [self addSubview:bottomView];
    
    
    
    NSMutableAttributedString *moneyString= [[NSMutableAttributedString alloc] initWithString:@"余额 0"];
    self.totalMoneyLabel = [[UILabel alloc]init];
    self.totalMoneyLabel.frame = CGRectMake(10, 0, 180, 44);
    self.totalMoneyLabel.textColor = [UIColor themeColor];
    self.totalMoneyLabel.font = [UIFont systemFontOfSize:18];
    self.totalMoneyLabel.attributedText = moneyString;
    [bottomView addSubview:self.totalMoneyLabel];
    
    UIButton *rechargeButton =[UIButton buttonWithType:UIButtonTypeCustom];
    rechargeButton.frame = CGRectMake(SCREEN_WIDTH - 170, 5, 60, 34);
    rechargeButton.layer.cornerRadius = 17;
    rechargeButton.layer.borderWidth = 0.5;
    rechargeButton.layer.borderColor = RGB_COLOR(191, 191, 191).CGColor;
    [rechargeButton setTitleColor:[UIColor themeColor] forState:UIControlStateNormal];
    [rechargeButton setTitle:@"充值" forState:UIControlStateNormal];
    [rechargeButton addTarget:self action:@selector(rechargeAction) forControlEvents:UIControlEventTouchUpInside];
    [bottomView addSubview:rechargeButton];
    
    
    self.paymentButton =[UIButton buttonWithType:UIButtonTypeCustom];
    self.paymentButton.frame = CGRectMake(SCREEN_WIDTH - 100, 5, 90, 34);
    self.paymentButton.layer.cornerRadius = 17;
    self.paymentButton.backgroundColor = [UIColor themeColor];
    [self.paymentButton setTitle:@"支付" forState:UIControlStateNormal];
    [self.paymentButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self.paymentButton addTarget:self action:@selector(paymentAction) forControlEvents:UIControlEventTouchUpInside];
    [bottomView addSubview:self.paymentButton];
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
                             action:@selector(moneyTextFieldDidChange:)
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
                              action:@selector(moneyTextFieldDidChange:)
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

//充值
-(void)rechargeAction
{
    if (_rechargeRedAdsBlock) {
        _rechargeRedAdsBlock();
    }
}

-(void)paymentAction
{
    if (_payRedAdsMentBlock) {
        
        NSUInteger      number = [self.numberTextField.text integerValue];
        float      total = [self.totalMoneyTextField.text floatValue] *100;
        float      single = [self.singleMoneyTextField.text floatValue] *100;
        float  tranBaseMoney = _adsPrice * 100 * [self.payDays.text intValue];
        if (self.dayNum==0) {
            [MBProgressHUD showError:@"请选择广告天数"];
            return;
        }else{
            if (type==0) {
                if (balance>=(total+tranBaseMoney)*0.01) {
                    _payRedAdsMentBlock(number,total,single,type,self.payDays.text);
                    
                }else{
                    [MBProgressHUD showError:@"余额不足,请充值"];
                    return;
                }
            } if (type==1) {
                if (balance>(number*single+tranBaseMoney)*0.01) {
                    _payRedAdsMentBlock(number,total,single,type,self.payDays.text);
                }else{
                    [MBProgressHUD showError:@"余额不足,请充值"];
                    return;
                }
            }
        }
    }
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
    
    NSInteger redPaperNumber = [_numberTextField.text integerValue];
    
    //拼手气 type = 0
    if (type == 0) {
        if (redPaperNumber != 0) {
            _totalMoneyTextField.text = [NSString stringWithFormat:@"%.2f",[_singleMoneyTextField.text floatValue] * redPaperNumber];
        }
        else
        {
            _totalMoneyTextField.text = [NSString stringWithFormat:@"%.2f",[_singleMoneyTextField.text floatValue]];
        }
        
        float total = [_totalMoneyTextField.text floatValue];
        
        _redtotal.text = [NSString stringWithFormat:@"%.2f元",total];
        _payMoneyLabel.text = [NSString stringWithFormat:@"%.2f元",total + _dayNum * _adsPrice];
    }
    else{
        if (redPaperNumber != 0) {
            _singleMoneyTextField.text = [NSString stringWithFormat:@"%.2f",[_totalMoneyTextField.text floatValue] / redPaperNumber];
        }
        else
        {
            _singleMoneyTextField.text = [NSString stringWithFormat:@"%.2f",[_totalMoneyTextField.text floatValue]];
        }
        
        float total = [_singleMoneyTextField.text floatValue] * [_numberTextField.text integerValue];
        
        _redtotal.text = [NSString stringWithFormat:@"%.2f元",total];
        _payMoneyLabel.text = [NSString stringWithFormat:@"%.2f元",total + _dayNum * _adsPrice];
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


- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    return YES;
}
- (void)transferTextFieldDidChange:(UITextField *)transferTextField{
    _dayNum = [transferTextField.text integerValue];
    
    if (_dayNum > 100) {
        transferTextField.text = [NSString stringWithFormat:@"%ld",_dayNum/10];
    }else{
        if (!_isLuck) {
            _redtotal.text = [NSString stringWithFormat:@"%ld元",(long)_monNum];
            _adstotal.text = [NSString stringWithFormat:@"%ld元",(long)_adsPrice*_dayNum];
            _payMoneyLabel.text = [NSString stringWithFormat:@"%ld元",(long)_monNum+(long)_adsPrice*_dayNum];
        }if (_isLuck) {
            _redtotal.text = [NSString stringWithFormat:@"%.2f元",(float)_singleNum*(long)_redNum];
            _adstotal.text = [NSString stringWithFormat:@"%ld元",(long)_adsPrice*_dayNum];
            _payMoneyLabel.text = [NSString stringWithFormat:@"%.2f元",(float)_singleNum*(long)_redNum+(long)_adsPrice*_dayNum];
        }
        [self checkInputIsValid];
    }
}

-(void)numberTextFieldDidChange:(UITextField*)numberTextField
{
    //不让输入
    NSInteger number = [numberTextField.text integerValue];
    if (number > 1000) {
        numberTextField.text = [NSString stringWithFormat:@"%ld",number/10];
    }else{
        [self checkInputIsValid];
    }
}


-(void)moneyTextFieldDidChange:(UITextField*)textField
{
    if([textField.text rangeOfString:@"."].location !=NSNotFound)//_roaldSearchText
    {
        
        NSString *str = textField.text;
        
        NSInteger pointNumber = 0;
        
        for(int i = 0; i < [str length]; i++)
        {
            unichar temp = [str characterAtIndex:i];
            if (temp == '.') {
                pointNumber++;
            }
            if (pointNumber == 1) {
                if ([str length] > i + 3) {
                    textField.text = [textField.text substringToIndex:[textField.text length] - 1];
                    break;
                }
            }
            if (pointNumber > 1) {
                textField.text = [textField.text substringToIndex:[textField.text length] - 1];
                break;
            }
        }
    }
    
    float totalMoney = [textField.text floatValue];
    if (totalMoney >= 10000) {
        NSInteger money = [textField.text integerValue];
        textField.text = [NSString stringWithFormat:@"%ld",money/10];
    }
    [self checkInputIsValid];
}

-(void)refreshData{
    NSMutableAttributedString *dayString= [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"购买天数（每天%.0f%@",_adsPrice,@"元/条）"]];
    [dayString addAttribute:NSForegroundColorAttributeName
                      value:[UIColor wordColor]
                      range:NSMakeRange(0, 4)];
    
    _dayTintLabel.attributedText = dayString;
}



-(void)checkInputIsValid{
    isInputValid = NO;
    [self.paymentButton setBackgroundColor:RGB_COLOR(175, 175, 175)];
    self.paymentButton.enabled = NO;
    NSInteger number = [_numberTextField.text integerValue];
    float totalMoney = [_totalMoneyTextField.text floatValue];
    float perMoney = [_singleMoneyTextField.text floatValue];
    
    NSInteger minRedPaperNumber = MinAdRedPaperNumber;
    NSInteger maxRedPaperNumber = MaxAdRedPaperNumber;
    NSInteger minRedPaperMoney = MinAdRedPaperMoney;
    NSInteger maxRedPaperMoney = MaxAdRedPaperMoney;
    
    _transferTextField.textColor = [UIColor wordColor];
    
    float total = 0;
    //     0拼手气 1普通红包
    if (type == 1) {
        total = number *perMoney;
        _redtotal.text = [NSString stringWithFormat:@"%.2f元",total];
        _payMoneyLabel.text = [NSString stringWithFormat:@"%.2f元",total + _dayNum * _adsPrice];
        
        
        if (number < minRedPaperNumber) {
            _numberTextField.textColor = RGB_COLOR(250, 114, 111);
            _singleMoneyTextField.textColor = [UIColor wordColor];
            _topTintLabel.text = [NSString stringWithFormat:@"红包个数最少为%ld个",minRedPaperNumber];
            [UIView animateWithDuration:0.25 animations:^{
                _topTintLabel.frame = CGRectMake(0, self.contentOffset.y, SCREEN_WIDTH, 29);
            }];
        }else if (number > maxRedPaperNumber){
            _numberTextField.textColor = RGB_COLOR(250, 114, 111);
            _singleMoneyTextField.textColor = [UIColor wordColor];
            _topTintLabel.text = [NSString stringWithFormat:@"红包个数最多为%ld个",maxRedPaperNumber];
            [UIView animateWithDuration:0.25 animations:^{
                _topTintLabel.frame = CGRectMake(0, self.contentOffset.y, SCREEN_WIDTH, 29);
            }];
        }else if(total < minRedPaperMoney){
            if ([_singleMoneyTextField.text isEqualToString:@""]) {
                isInputValid = YES;
                _numberTextField.textColor = [UIColor wordColor];
                [UIView animateWithDuration:0.25 animations:^{
                    _topTintLabel.frame = CGRectMake(0, self.contentOffset.y - 29, SCREEN_WIDTH, 29);
                }];
            }else{
                _numberTextField.textColor = [UIColor wordColor];
                _singleMoneyTextField.textColor = RGB_COLOR(250, 114, 111);
                _topTintLabel.text = [NSString stringWithFormat:@"红包总金额不能小于%ld元",minRedPaperMoney];
                [UIView animateWithDuration:0.25 animations:^{
                    _topTintLabel.frame = CGRectMake(0, self.contentOffset.y, SCREEN_WIDTH, 29);
                }];
            }
            
        }else if(total > maxRedPaperMoney){
            _numberTextField.textColor = [UIColor wordColor];
            _singleMoneyTextField.textColor = RGB_COLOR(250, 114, 111);
            _topTintLabel.text = [NSString stringWithFormat:@"红包总金额不能大于%ld元",maxRedPaperMoney];
            [UIView animateWithDuration:0.25 animations:^{
                _topTintLabel.frame = CGRectMake(0, self.contentOffset.y, SCREEN_WIDTH, 29);
            }];
        }else if (_dayNum < 7) {
            _topTintLabel.text = @"广告天数不能低于7天";
            _transferTextField.textColor = RGB_COLOR(250, 114, 111);
            _numberTextField.textColor = [UIColor wordColor];
            _singleMoneyTextField.textColor = [UIColor wordColor];
            [UIView animateWithDuration:0.1 animations:^{
                _topTintLabel.frame = CGRectMake(0, self.contentOffset.y, SCREEN_WIDTH, 29);
            }];
        }else if(_dayNum > 30){
            _topTintLabel.text = @"广告天数不能大于30天";
            _transferTextField.textColor = RGB_COLOR(250, 114, 111);
            _numberTextField.textColor = [UIColor wordColor];
            _singleMoneyTextField.textColor = [UIColor wordColor];
            [UIView animateWithDuration:0.1 animations:^{
                _topTintLabel.frame = CGRectMake(0, self.contentOffset.y, SCREEN_WIDTH, 29);
            }];
        }else{
            
            isInputValid = YES;
            _numberTextField.textColor = [UIColor wordColor];
            _singleMoneyTextField.textColor = [UIColor wordColor];
            _transferTextField.textColor = [UIColor wordColor];
            [UIView animateWithDuration:0.25 animations:^{
                _topTintLabel.frame = CGRectMake(0, self.contentOffset.y - 29, SCREEN_WIDTH, 29);
            }];
            [self.paymentButton setBackgroundColor:[UIColor themeColor]];
            self.paymentButton.enabled = YES;
        }
    }else{
        total = totalMoney;
        
        _redtotal.text = [NSString stringWithFormat:@"%.2f元",total];
        _payMoneyLabel.text = [NSString stringWithFormat:@"%.2f元",total + _dayNum * _adsPrice];
        
        
        if (number < minRedPaperNumber) {
            _numberTextField.textColor = RGB_COLOR(250, 114, 111);
            _totalMoneyTextField.textColor = [UIColor wordColor];
            _topTintLabel.text = [NSString stringWithFormat:@"红包个数最少为%ld个",minRedPaperNumber];
            [UIView animateWithDuration:0.25 animations:^{
                _topTintLabel.frame = CGRectMake(0, self.contentOffset.y, SCREEN_WIDTH, 29);
            }];
        }else if (number > maxRedPaperNumber){
            _numberTextField.textColor = RGB_COLOR(250, 114, 111);
            _totalMoneyTextField.textColor = [UIColor wordColor];
            _topTintLabel.text = [NSString stringWithFormat:@"红包个数最多为%ld个",maxRedPaperNumber];
            [UIView animateWithDuration:0.25 animations:^{
                _topTintLabel.frame = CGRectMake(0, self.contentOffset.y, SCREEN_WIDTH, 29);
            }];
        }else if(total < minRedPaperMoney){
            if ([_totalMoneyTextField.text isEqualToString:@""]) {
                isInputValid = YES;
                _numberTextField.textColor = [UIColor wordColor];
                [UIView animateWithDuration:0.25 animations:^{
                    _topTintLabel.frame = CGRectMake(0, self.contentOffset.y - 29, SCREEN_WIDTH, 29);
                }];
            }else{
                _numberTextField.textColor = [UIColor wordColor];
                _totalMoneyTextField.textColor = RGB_COLOR(250, 114, 111);
                _topTintLabel.text = [NSString stringWithFormat:@"红包总金额不能小于%ld元",minRedPaperMoney];
                [UIView animateWithDuration:0.25 animations:^{
                    _topTintLabel.frame = CGRectMake(0, self.contentOffset.y, SCREEN_WIDTH, 29);
                }];
            }
        }else if(total > maxRedPaperMoney){
            _numberTextField.textColor = [UIColor wordColor];
            _totalMoneyTextField.textColor = RGB_COLOR(250, 114, 111);
            _topTintLabel.text = [NSString stringWithFormat:@"红包总金额不能大于%ld元",maxRedPaperMoney];
            [UIView animateWithDuration:0.25 animations:^{
                _topTintLabel.frame = CGRectMake(0, self.contentOffset.y, SCREEN_WIDTH, 29);
            }];
        }else if (_dayNum < 7) {
            _topTintLabel.text = @"广告天数不能低于7天";
            _transferTextField.textColor = RGB_COLOR(250, 114, 111);
            _numberTextField.textColor = [UIColor wordColor];
            _totalMoneyTextField.textColor = [UIColor wordColor];
            [UIView animateWithDuration:0.1 animations:^{
                _topTintLabel.frame = CGRectMake(0, self.contentOffset.y, SCREEN_WIDTH, 29);
            }];
        }else if(_dayNum > 30){
            _topTintLabel.text = @"广告天数不能大于30天";
            _transferTextField.textColor = RGB_COLOR(250, 114, 111);
            _numberTextField.textColor = [UIColor wordColor];
            _totalMoneyTextField.textColor = [UIColor wordColor];
            [UIView animateWithDuration:0.1 animations:^{
                _topTintLabel.frame = CGRectMake(0, self.contentOffset.y, SCREEN_WIDTH, 29);
            }];
        }else{
            isInputValid = YES;
            _numberTextField.textColor = [UIColor wordColor];
            _totalMoneyTextField.textColor = [UIColor wordColor];
            _transferTextField.textColor = [UIColor wordColor];
            [UIView animateWithDuration:0.25 animations:^{
                _topTintLabel.frame = CGRectMake(0, self.contentOffset.y - 29, SCREEN_WIDTH, 29);
            }];
            [self.paymentButton setBackgroundColor:[UIColor themeColor]];
            self.paymentButton.enabled = YES;
        }
    }
}

-(void)openAdWebPage{
    
    if (_openUrlBlock) {
        _openUrlBlock();
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

- (void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}
@end
