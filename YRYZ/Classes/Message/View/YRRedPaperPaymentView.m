//
//  YRRedPaperPaymentView.m
//  YRYZ
//
//  Created by Rongzhong on 16/7/12.
//  Copyright © 2016年 yryz. All rights reserved.
//

#import "YRRedPaperPaymentView.h"
#import "YRPaymentScrollView.h"
#import "YRAccountModel.h"

//广告红包最小个数
#define MinAdRedPaperNumber 10
//广告红包最大个数
#define MaxAdRedPaperNumber 500
//广告红包最小总金额
#define MinAdRedPaperMoney 100
//广告红包最大总金额
#define MaxAdRedPaperMoney 3000

//圈子红包最小个数
#define MinLineRedPaperNumber 10
//圈子红包最大个数
#define MaxLineRedPaperNumber 500
//圈子红包最小总金额
#define MinLineRedPaperMoney 1
//圈子红包最大总金额
#define MaxLineRedPaperMoney 3000




@interface YRRedPaperPaymentView()<UITextFieldDelegate>

@property(strong,nonatomic) UILabel *topTintLabel;
@property(strong,nonatomic) YRPaymentScrollView *baseScrollView;

@property(strong,nonatomic) UITextField                 *numberTextField;
@property(strong,nonatomic) UITextField                 *totalMoneyTextField;
@property(strong,nonatomic) UITextField                 *singleMoneyTextField;
@property(strong,nonatomic) UILabel                     *selectLineLabel;
@property(strong,nonatomic) UITextField                 *allTextField;//支付总额
@property(strong,nonatomic) UIView                      *redPaperBgView;

//账户余额
@property(strong,nonatomic)NSString                     *balanceStr;
@property(strong,nonatomic)UILabel                      *totalMoneyLabel;
@property(assign,nonatomic) float                       allMoney;//需支付总余额

@property (strong ,nonatomic)UIButton                   *paymentButton;





@end


@implementation YRRedPaperPaymentView
{
    NSInteger type;
    BOOL isAddRedPaper;
    BOOL isInputValid; // 输入是否合法
}



- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        self.userInteractionEnabled = YES;
        [self fectData];
        isAddRedPaper = NO;
        type = 0;
        _allMoney = 3.00f;
        isInputValid = YES;
        [self setupView];
    }
    return self;
}


- (void)fectData{
    
    
    [YRHttpRequest AccountBalanceQuerySuccess:^(NSDictionary *data) {
        
        YRAccountModel  *accountModel = [YRAccountModel mj_objectWithKeyValues:data];
        
        self.account = [accountModel.accountSum floatValue]*0.01;
        self.balanceStr = [NSString stringWithFormat:@"余额 %.2f",self.account];
        
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


- (void)setAllMoney:(float)allMoney{
    
    _allMoney = allMoney;;
    self.allTextField.text = [NSString stringWithFormat:@"%.2f",allMoney];
    
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
    _baseScrollView.frame =  self.bounds;
    _baseScrollView.contentSize = CGSizeMake(SCREEN_WIDTH, 650);
    [self addSubview:_baseScrollView];
    
    
    
    [self setRedPaperBgView];
    
    UIImageView *walletImageView = [[UIImageView alloc]init];
    walletImageView.userInteractionEnabled = YES;
    walletImageView.image = [UIImage imageNamed:@"walletImage"];
    walletImageView.center = CGPointMake(SCREEN_WIDTH/2.0f, 72);
    walletImageView.bounds = CGRectMake(0, 0, 99, 99);
    [_baseScrollView addSubview:walletImageView];
    
    
    _topTintLabel = [[UILabel alloc]init];
    _topTintLabel.frame = CGRectMake(0, -29, SCREEN_WIDTH, 29);
    _topTintLabel.text = @"红包金额不能高于3000.00元";
    _topTintLabel.textColor = [UIColor whiteColor];
    _topTintLabel.backgroundColor = RGB_COLOR(250, 114, 110);
    _topTintLabel.textAlignment = NSTextAlignmentCenter;
    _topTintLabel.font = [UIFont systemFontOfSize:14];
    
    [self addSubview:_topTintLabel];
    
    
    UIView *moneyBgView = [[UIView alloc]init];
    moneyBgView.frame = CGRectMake(10, 142, SCREEN_WIDTH - 20, 116);
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
    transferTextField.textAlignment = NSTextAlignmentRight;
    transferTextField.text = @"3.00";
    transferTextField.textColor = [UIColor themeColor];
    transferTextField.userInteractionEnabled = NO;
    [moneyBgView addSubview:transferTextField];
    
    UILabel *moneyTintLabel = [[UILabel alloc]init];
    moneyTintLabel.frame = CGRectMake(0, 0, 80, 37);
    moneyTintLabel.text = @"转发金额";
    moneyTintLabel.textColor = [UIColor wordColor];
    moneyTintLabel.textAlignment = NSTextAlignmentCenter;
    moneyTintLabel.font = [UIFont systemFontOfSize:16];
    
    UILabel *elementLabel1 = [[UILabel alloc]init];
    elementLabel1.frame = CGRectMake(0, 0, 28, 37);
    elementLabel1.text = @"元";
    elementLabel1.textColor = [UIColor wordColor];
    elementLabel1.textAlignment = NSTextAlignmentCenter;
    elementLabel1.font = [UIFont systemFontOfSize:16];
    
    transferTextField.leftView = moneyTintLabel;
    transferTextField.leftViewMode = UITextFieldViewModeAlways;
    
    transferTextField.rightView = elementLabel1;
    transferTextField.rightViewMode = UITextFieldViewModeAlways;
    
    
    self.allTextField = [[UITextField alloc]init];
    self.allTextField.frame = CGRectMake(10, 64, SCREEN_WIDTH - 40, 37);
    self.allTextField.backgroundColor = [UIColor whiteColor];
    self.allTextField.layer.borderWidth = 0.5;
    self.allTextField.layer.borderColor= [UIColor colorWithR:229 g:229 b:229 a:1.0].CGColor;
    self.allTextField.layer.cornerRadius = 4;
    self.allTextField.textAlignment = NSTextAlignmentRight;
    self.allTextField.text = [NSString stringWithFormat:@"%.2f",_allMoney];
    self.allTextField.textColor = [UIColor themeColor];
    self.allTextField.userInteractionEnabled = NO;
    [moneyBgView addSubview:self.allTextField];
    
    UILabel *totalTintLabel = [[UILabel alloc]init];
    totalTintLabel.frame = CGRectMake(0, 0, 80, 37);
    totalTintLabel.text = @"支付总额";
    totalTintLabel.textColor = [UIColor wordColor];
    totalTintLabel.textAlignment = NSTextAlignmentCenter;
    totalTintLabel.font = [UIFont systemFontOfSize:16];
    
    UILabel *elementLabel2 = [[UILabel alloc]init];
    elementLabel2.frame = CGRectMake(0, 0, 28, 37);
    elementLabel2.text = @"元";
    elementLabel2.textColor = [UIColor wordColor];
    elementLabel2.textAlignment = NSTextAlignmentCenter;
    elementLabel2.font = [UIFont systemFontOfSize:16];
    
    self.allTextField.leftView = totalTintLabel;
    self.allTextField.leftViewMode = UITextFieldViewModeAlways;
    
    self.allTextField.rightView = elementLabel2;
    self.allTextField.rightViewMode = UITextFieldViewModeAlways;
    
    
    
    UIButton *addRedPaperButton =[UIButton buttonWithType:UIButtonTypeCustom];
    addRedPaperButton.center = CGPointMake(SCREEN_WIDTH / 2.0f, 300);
    addRedPaperButton.bounds = CGRectMake(0, 0, 110, 30);
    addRedPaperButton.backgroundColor = RGB_COLOR(255, 209, 0);
    addRedPaperButton.layer.cornerRadius = 15;
    [addRedPaperButton addTarget:self action:@selector(addRedPaperAction:) forControlEvents:UIControlEventTouchUpInside];
    [_baseScrollView addSubview:addRedPaperButton];
    
    UILabel *addRedPaperLabel = [[UILabel alloc]init];
    addRedPaperLabel.tag = 1;
    addRedPaperLabel.frame = CGRectMake(0, 0, 92, 30);
    addRedPaperLabel.text = @"添加红包";
    addRedPaperLabel.textColor = [UIColor whiteColor];
    addRedPaperLabel.textAlignment = NSTextAlignmentCenter;
    addRedPaperLabel.font = [UIFont systemFontOfSize:16];
    [addRedPaperButton addSubview:addRedPaperLabel];
    
    UIImageView *addRedPaperImageView = [[UIImageView alloc]init];
    addRedPaperImageView.tag = 2;
    addRedPaperImageView.frame = CGRectMake(86, 12, 13, 7);
    addRedPaperImageView.image = [UIImage imageNamed:@"addRedPaperSpread"];
    [addRedPaperButton addSubview:addRedPaperImageView];
    
    
    UIButton *readRuleButton =[UIButton buttonWithType:UIButtonTypeCustom];
    readRuleButton.center = CGPointMake(SCREEN_WIDTH / 2.0f, 334);
    readRuleButton.bounds = CGRectMake(0, 0, 200, 30);
    [readRuleButton setTitle:@"查看什么是圈子红包" forState:UIControlStateNormal];
    [readRuleButton setTitleColor:RGB_COLOR(148, 148, 148) forState:UIControlStateNormal];
    readRuleButton.titleLabel.font = [UIFont systemFontOfSize:14];
    [readRuleButton addTarget:self action:@selector(readRuleAction) forControlEvents:UIControlEventTouchUpInside];
    [_baseScrollView addSubview:readRuleButton];
    
    
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
    _redPaperBgView.frame = CGRectMake(10, 360, SCREEN_WIDTH - 20, 155);
    _redPaperBgView.backgroundColor = [UIColor colorWithR:246 g:246 b:246 a:1.0];
    _redPaperBgView.layer.borderWidth = 0.5;
    _redPaperBgView.layer.borderColor= [UIColor colorWithR:221 g:221 b:221 a:1.0].CGColor;
    _redPaperBgView.layer.cornerRadius = 5;
    [_baseScrollView addSubview:_redPaperBgView];
    
    _redPaperBgView.hidden = YES;
    
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
    _numberTextField.delegate =self;
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
    _totalMoneyTextField.delegate = self;
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


-(void)addRedPaperAction:(UIButton*)button
{
    UILabel *addRedPaperLabel = (UILabel*)[button viewWithTag:1];
    UIImageView *addRedPaperImageView = (UIImageView*)[button viewWithTag:2];
    
//    if (isAddRedPaper) {
//        isAddRedPaper = NO;
//        addRedPaperLabel.text = @"添加红包";
//        _redPaperBgView.hidden = YES;
//        [_baseScrollView setContentOffset:CGPointMake(0, 0) animated:YES];
//        [UIView animateWithDuration:0.3 animations:^{
//            addRedPaperImageView.transform=CGAffineTransformMakeRotation(M_PI * 2);
//        }];
//    }
    if(!isAddRedPaper){
        isAddRedPaper = YES;
        addRedPaperLabel.text = @"添加红包";
        _redPaperBgView.hidden = NO;
        
        if(650 > SCREEN_HEIGHT)
        {
            [_baseScrollView setContentOffset:CGPointMake(0, 650 - SCREEN_HEIGHT) animated:YES];
        }
        [UIView animateWithDuration:0.3 animations:^{
            addRedPaperImageView.transform = CGAffineTransformMakeRotation(M_PI);
        }];
    }
    
}

//什么时候是圈子红包
-(void)readRuleAction
{
    
    if (self.readRuleActionBlock) {
        self.readRuleActionBlock();
    }
    
}

-(void)rechargeAction
{
    if (self.rechargeBlock) {
        self.rechargeBlock();
    }
}


-(void)paymentAction
{
    if (type == 0) {
        if ([self.numberTextField.text integerValue] > [self.totalMoneyTextField.text floatValue] * 100) {
            UIAlertView * alert = [[UIAlertView alloc]initWithTitle:nil message:[NSString stringWithFormat:@"%.2f元最多只能发送%d个红包",[self.totalMoneyTextField.text floatValue],(int)([self.totalMoneyTextField.text floatValue] * 100)] delegate:self cancelButtonTitle:@"确定" otherButtonTitles: nil];
            [alert show];
            return;
        }
    }
    
    if (type == 1) {
        if ([_singleMoneyTextField.text doubleValue] < 0.1) {
            UIAlertView * alert = [[UIAlertView alloc]initWithTitle:nil message:[NSString stringWithFormat:@"单个普通红包不能小于0.1元"] delegate:self cancelButtonTitle:@"确定" otherButtonTitles: nil];
            [alert show];
            return;
        }
    }
    
    
    if (_paymentBlock) {
        NSUInteger      number = [self.numberTextField.text integerValue];
        float      totalMoney = [self.totalMoneyTextField.text floatValue] *100;
        float      singleMoney = [self.singleMoneyTextField.text floatValue] *100;
        _paymentBlock(number,totalMoney,singleMoney,type,self.account);
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
    
    if (type == 0) {
        if (redPaperNumber != 0) {
            _totalMoneyTextField.text = [NSString stringWithFormat:@"%.2f",[_singleMoneyTextField.text floatValue] * redPaperNumber];
        }
        else
        {
            //            不需要显示0.00元
            //            _totalMoneyTextField.text = [NSString stringWithFormat:@"%.2f",[_singleMoneyTextField.text floatValue]];
        }
        
        self.allTextField.text = [NSString stringWithFormat:@"%.2f",[_totalMoneyTextField.text floatValue] + 3];
    }
    else{
        
        if (redPaperNumber != 0) {
            _singleMoneyTextField.text = [NSString stringWithFormat:@"%.2f",[_totalMoneyTextField.text floatValue] / redPaperNumber];
        }
        else
        {
            //            不需要显示0.00元
            //            _singleMoneyTextField.text = [NSString stringWithFormat:@"%.2f",[_totalMoneyTextField.text floatValue]];
        }
        
        self.allTextField.text = [NSString stringWithFormat:@"%.2f",[_singleMoneyTextField.text floatValue] * [_numberTextField.text integerValue] + 3];
        
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


-(void)checkInputIsValid{
    isInputValid = NO;
    [self.paymentButton setBackgroundColor:RGB_COLOR(175, 175, 175)];
    self.paymentButton.enabled = NO;
    NSInteger number = [_numberTextField.text integerValue];
    float totalMoney = [_totalMoneyTextField.text floatValue];
    float perMoney = [_singleMoneyTextField.text floatValue];
    
    
    NSInteger minRedPaperNumber = MinLineRedPaperNumber;
    NSInteger maxRedPaperNumber = MaxLineRedPaperNumber;
    NSInteger minRedPaperMoney = MinLineRedPaperMoney;
    NSInteger maxRedPaperMoney = MaxLineRedPaperMoney;
    
    
    
    float total = 0;
    //     0拼手气 1普通红包
    if (type == 1) {
        total = number *perMoney;
        
        self.allTextField.text = [NSString stringWithFormat:@"%.2f",total + 3];

        if ([_numberTextField.text isEqualToString:@""]&&[_singleMoneyTextField.text isEqualToString:@""]) {
            isInputValid = YES;
            _numberTextField.textColor = [UIColor wordColor];
            _singleMoneyTextField.textColor = [UIColor wordColor];
            [UIView animateWithDuration:0.25 animations:^{
                _topTintLabel.frame = CGRectMake(0, self.contentOffset.y - 29, SCREEN_WIDTH, 29);
            }];
            [self.paymentButton setBackgroundColor:[UIColor themeColor]];
            self.paymentButton.enabled = YES;
        }else if (number < minRedPaperNumber) {
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
        }else{
            
            isInputValid = YES;
            
            _numberTextField.textColor = [UIColor wordColor];
            _singleMoneyTextField.textColor = [UIColor wordColor];
            [UIView animateWithDuration:0.25 animations:^{
                _topTintLabel.frame = CGRectMake(0, self.contentOffset.y - 29, SCREEN_WIDTH, 29);
            }];
            [self.paymentButton setBackgroundColor:[UIColor themeColor]];
            self.paymentButton.enabled = YES;
        }
    }else{
        total = totalMoney;

        self.allTextField.text = [NSString stringWithFormat:@"%.2f",total + 3];
        
        
        if ([_numberTextField.text isEqualToString:@""]&&[_totalMoneyTextField.text isEqualToString:@""]) {
            isInputValid = YES;
            _numberTextField.textColor = [UIColor wordColor];
            _totalMoneyTextField.textColor = [UIColor wordColor];
            [UIView animateWithDuration:0.25 animations:^{
                _topTintLabel.frame = CGRectMake(0, self.contentOffset.y - 29, SCREEN_WIDTH, 29);
            }];
            [self.paymentButton setBackgroundColor:[UIColor themeColor]];
            self.paymentButton.enabled = YES;
        }else if (number < minRedPaperNumber) {
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
        }else{
            
            isInputValid = YES;
            
            _numberTextField.textColor = [UIColor wordColor];
            _totalMoneyTextField.textColor = [UIColor wordColor];
            [UIView animateWithDuration:0.25 animations:^{
                _topTintLabel.frame = CGRectMake(0, self.contentOffset.y - 29, SCREEN_WIDTH, 29);
            }];
            [self.paymentButton setBackgroundColor:[UIColor themeColor]];
            self.paymentButton.enabled = YES;
        }
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
    
    _baseScrollView.frame = CGRectMake(0,self.contentOffset.y, SCREEN_WIDTH, SCREEN_HEIGHT - self.contentOffset.y);
    _baseScrollView.contentOffset = CGPointMake(0, self.contentOffset.y + 44);
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
/*
 -(void)keyboardDown
 {
 [self endEditing:YES];
 }*/

@end
