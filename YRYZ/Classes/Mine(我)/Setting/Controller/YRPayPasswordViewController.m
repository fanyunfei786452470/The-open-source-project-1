//
//  YRPayPasswordViewController.m
//  YRYZ
//
//  Created by weishibo on 16/8/10.
//  Copyright © 2016年 yryz. All rights reserved.
//

#import "YRPayPasswordViewController.h"
#import "YRPaymentPasswordView.h"


@interface YRPayPasswordViewController ()
@property (nonatomic ,strong)UITextField        *hideTextField;
@property (nonatomic ,strong)UITextField        *hideTextField2;

@property (nonatomic ,strong)UITextField        *hideTextField3;
@end

@implementation YRPayPasswordViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setTitle:@"修改支付密码"];
    
    [self initUI];

}


- (void)viewWillAppear:(BOOL)animated{
    
    [super viewWillAppear:animated];
    
    
}

- (void)viewWillDisappear:(BOOL)animated{
    
    [super viewWillDisappear:animated];
    
}

- (void)initUI{

    
    UILabel  *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 50)];
    titleLabel.text = @"  请输入6位数字的支付密码";
    titleLabel.backgroundColor = RGB_COLOR(245, 245, 245);
    [self.view addSubview:titleLabel];
    

    
    for (int i=0; i<6; i++) {
        UILabel* borderLabel = [[UILabel alloc]init];
        borderLabel.frame = YRRectMake(70+i*37, 117.5 -110+50, 44, 44);
        borderLabel.backgroundColor = [UIColor whiteColor];
        borderLabel.layer.borderWidth = 1;
        borderLabel.layer.borderColor = [UIColor grayColorThree].CGColor;
        [self.view addSubview:borderLabel];
        
        UIImageView* dotImageView = [[UIImageView alloc]init];
        dotImageView.frame = YRRectMake(85.5+i*37, 131.5-110+50, 10, 10);
        dotImageView.tag = 100 + i;
        dotImageView.backgroundColor = [UIColor blackColor];
        dotImageView.layer.cornerRadius = 5 * SCREEN_WIDTH /320.0f;
        dotImageView.hidden = YES;
        [self.view addSubview:dotImageView];
    }
    
    
    UILabel *tipLable = [[UILabel alloc] init];
    tipLable.frame = CGRectMake(10, 155-125+50, 70, 20);
    tipLable.text = @"输入旧密码";
    tipLable.font = [UIFont systemFontOfSize:13];
    tipLable.textAlignment = NSTextAlignmentLeft;
    [self.view addSubview:tipLable];
    
    
    
    UILabel *lineLable = [[UILabel alloc] initWithFrame:CGRectMake(10, 210-125+50, SCREEN_WIDTH - 20, 1)];
    lineLable.backgroundColor = RGB_COLOR(229, 229, 229);
    [self.view addSubview:lineLable];
    
    
    _hideTextField = [[UITextField alloc]init];
    _hideTextField.frame = YRRectMake(320, 95, 200, 20);
    _hideTextField.keyboardType = UIKeyboardTypeNumberPad;
    [_hideTextField addTarget:self action:@selector(textFieldChangeAction)  forControlEvents:UIControlEventEditingChanged];
    [_hideTextField becomeFirstResponder];
    [self.view addSubview:self.hideTextField];

    
    UILabel *tip2Lable = [[UILabel alloc] init];
    tip2Lable.frame = CGRectMake(10, 250-130+50, 70, 20);
    tip2Lable.text = @"输入新密码";
    tipLable.textAlignment = NSTextAlignmentLeft;
    tip2Lable.font = [UIFont systemFontOfSize:13];
    [self.view addSubview:tip2Lable];
    
    
    for (int i=0; i<6; i++) {
        UILabel* borderLabel = [[UILabel alloc]init];
        borderLabel.frame = YRRectMake(70+i*37, 192-110+50, 44, 44);
        borderLabel.backgroundColor = [UIColor whiteColor];
        borderLabel.layer.borderWidth = 1;
        borderLabel.layer.borderColor = [UIColor grayColorThree].CGColor;
        [self.view addSubview:borderLabel];
        
        UIImageView* dotImageView = [[UIImageView alloc]init];
        dotImageView.frame = YRRectMake(85.5+i*37, 202-110+50, 10, 10);
        dotImageView.tag = 200 + i;
        dotImageView.backgroundColor = [UIColor blackColor];
        dotImageView.layer.cornerRadius = 5 * SCREEN_WIDTH /320.0f;
        dotImageView.hidden = YES;
        [self.view addSubview:dotImageView];
    }
    
    
    
    UILabel *lineLable2 = [[UILabel alloc] initWithFrame:CGRectMake(10, 292-110+50, SCREEN_WIDTH - 20, 1)];
    lineLable2.backgroundColor = RGB_COLOR(229, 229, 229);
    [self.view addSubview:lineLable2];
    
    
    _hideTextField2 = [[UITextField alloc]init];
    _hideTextField2.frame = YRRectMake(320, 105, 200, 20);
    _hideTextField2.keyboardType = UIKeyboardTypeNumberPad;
    [_hideTextField2 addTarget:self action:@selector(textFieldChangeAction2)  forControlEvents:UIControlEventEditingChanged];
    [_hideTextField2 becomeFirstResponder];
    [self.view addSubview:self.hideTextField2];
    
    
    
    for (int i=0; i<6; i++) {
        UILabel* borderLabel = [[UILabel alloc]init];
        borderLabel.frame = YRRectMake(70+i*37, 192-110+50+(192-117)+10, 44, 44);
        borderLabel.backgroundColor = [UIColor whiteColor];
        borderLabel.layer.borderWidth = 1;
        borderLabel.layer.borderColor = [UIColor grayColorThree].CGColor;
        [self.view addSubview:borderLabel];
        
        UIImageView* dotImageView = [[UIImageView alloc]init];
        dotImageView.frame = YRRectMake(85.5+i*37, 202-110+50+(192-117), 10, 10);
        dotImageView.tag = 200 + i;
        dotImageView.backgroundColor = [UIColor blackColor];
        dotImageView.layer.cornerRadius = 5 * SCREEN_WIDTH /320.0f;
        dotImageView.hidden = YES;
        [self.view addSubview:dotImageView];
    }
    
    
    
    UILabel *lineLable3 = [[UILabel alloc] initWithFrame:CGRectMake(10, 292-110+50+(192-117)+15, SCREEN_WIDTH - 20, 1)];
    lineLable2.backgroundColor = RGB_COLOR(229, 229, 229);
    lineLable3.backgroundColor = [UIColor redColor];
    [self.view addSubview:lineLable3];
    
    
    _hideTextField3 = [[UITextField alloc]init];
    _hideTextField3.frame = YRRectMake(320, 105, 200, 20);
    _hideTextField3.keyboardType = UIKeyboardTypeNumberPad;
    [_hideTextField3 addTarget:self action:@selector(textFieldChangeAction3)  forControlEvents:UIControlEventEditingChanged];
    [_hideTextField3 becomeFirstResponder];
    [self.view addSubview:self.hideTextField3];

    
    UILabel *tip3Lable = [[UILabel alloc] init];
    tip3Lable.frame = CGRectMake(10, 250-130+50+(192-117)+25, 70, 20);
    tip3Lable.text = @"确认新密码";
    tip3Lable.textAlignment = NSTextAlignmentLeft;
    tip3Lable.font = [UIFont systemFontOfSize:13];
    [self.view addSubview:tip3Lable];
    
    
    
    
    
    UIButton *okButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [okButton setBackgroundImage:[UIImage imageNamed:@"yr_button_Bg"] forState:UIControlStateNormal];
    okButton.frame = CGRectMake((SCREEN_WIDTH - 280)/2, 352 , 280, 40);
    [okButton setTitle:@"确认" forState:UIControlStateNormal];
    [okButton addTarget:self action:@selector(okbuttonClick) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:okButton];
    
}


- (void)okbuttonClick{
    
}


-(void)textFieldChangeAction
{
    if (_hideTextField.text.length==6) {

        [self.hideTextField2 becomeFirstResponder];
    }
    if (_hideTextField.text.length>6) {
        _hideTextField.text=[_hideTextField.text substringWithRange:NSMakeRange(0, 6)];
    }
    for (int i=0; i<6; i++) {
        UIImageView* dotImageView=(UIImageView*)[self.view viewWithTag:100+i];
        if (i<_hideTextField.text.length) {
            dotImageView.hidden=NO;
        }
        else
        {
            dotImageView.hidden=YES;
        }
    }
}

- (void)textFieldChangeAction2{
    
    if (_hideTextField2.text.length==6) {
        //        if (_paymentBlock) {
        //            _paymentBlock(_hideTextField.text);
        //        }
        
        [self.hideTextField3 becomeFirstResponder];
    }
    if (_hideTextField2.text.length>6) {
        _hideTextField2.text=[_hideTextField2.text substringWithRange:NSMakeRange(0, 6)];
    }
    for (int i=0; i<6; i++) {
        UIImageView* dotImageView=(UIImageView*)[self.view viewWithTag:200+i];
        if (i<_hideTextField2.text.length) {
            dotImageView.hidden=NO;
        }
        else
        {
            dotImageView.hidden=YES;
        }
    }

}
- (void)textFieldChangeAction3{
    
    if (_hideTextField3.text.length==6) {
        //        if (_paymentBlock) {
        //            _paymentBlock(_hideTextField.text);
        //        }
        
        [self.hideTextField becomeFirstResponder];
    }
    if (_hideTextField3.text.length>6) {
        _hideTextField3.text=[_hideTextField3.text substringWithRange:NSMakeRange(0, 6)];
    }
    for (int i=0; i<6; i++) {
        UIImageView* dotImageView=(UIImageView*)[self.view viewWithTag:200+i];
        if (i<_hideTextField3.text.length) {
            dotImageView.hidden=NO;
        }
        else
        {
            dotImageView.hidden=YES;
        }
    }
    
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];

}


@end
