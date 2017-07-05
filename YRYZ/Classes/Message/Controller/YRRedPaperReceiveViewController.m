//
//  YRRedPaperReceiveViewController.m
//  YRYZ
//
//  Created by Rongzhong on 16/7/14.
//  Copyright © 2016年 yryz. All rights reserved.
//

#import "YRRedPaperReceiveViewController.h"
#import "YRRedPaperReceiveView.h"
#import "YRRedPaperRecordViewController.h"
#import "YRRedPaperClearView.h"
#import "YRPaymentPasswordView.h"
#import "YRRedPaperView.h"
#import "YRRedBagController.h"
@interface YRRedPaperReceiveViewController ()

@property(strong,nonatomic) YRRedPaperReceiveView *redPaperReceiveView;

@property(strong,nonatomic) UILabel *titleLabel;

@property(strong,nonatomic) UIButton *leftButton;

@property(strong,nonatomic) UINavigationBar *bar;

@end

@implementation YRRedPaperReceiveViewController

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES animated:YES];
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:YES];
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault];
}


- (YRRedListModel *)redModel{
    if (!_redModel) {
        _redModel = [[YRRedListModel alloc] init];
    }
    return _redModel;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    [self setNavbar];
    [self initUI];
}

-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    
    [self performSelector:@selector(delayMethod) withObject:nil afterDelay:0.6f];
}

-(void)delayMethod{
    
    [_redPaperReceiveView showAnimation];
}

-(void)setNavbar{
    _titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 0, 44)];
    _titleLabel.textColor = RGB_COLOR(255, 226, 159);
    _titleLabel.textAlignment = NSTextAlignmentCenter;
    _titleLabel.text = @"红包";
    
    _leftButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [_leftButton setFrame:CGRectMake(0, 0, 11, 18)];
    [_leftButton setImage:[UIImage imageNamed:@"backIndicatorImage"] forState:UIControlStateNormal];
    
    [self initNavBar];
}

- (void)initNavBar{
    
    [self.navigationController setNavigationBarHidden:YES];
    
    _bar = [[UINavigationBar alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 64)];
    
    [_bar setBackgroundImage:[UIImage imageNamed:@"navigationbarBg"] forBarMetrics:UIBarMetricsDefault];
    
    [self performSelector:@selector(delayMethod2) withObject:nil afterDelay:0.5f];
    
    [self.view addSubview:_bar];
}

-(void)delayMethod2
{
    UINavigationItem *item = [[UINavigationItem alloc] init];
    if (_titleLabel) {
        item.titleView = _titleLabel;
    }
    
    if (_leftButton) {
        [_leftButton addTarget:self action:@selector(back) forControlEvents:UIControlEventTouchUpInside];
        UIBarButtonItem *leftItem = [[UIBarButtonItem alloc] initWithCustomView:_leftButton];
        [item setLeftBarButtonItem:leftItem];
    }
    
    [_bar pushNavigationItem:item animated:YES];
}


-(void)initUI{
    @weakify(self);
    _redPaperReceiveView = [[YRRedPaperReceiveView alloc]initWithFrame:CGRectMake(0, 64, SCREEN_WIDTH, SCREEN_HEIGHT - 64) redModel:self.redModel] ;
    _redPaperReceiveView.lookRecordBlock = ^{
        @strongify(self);
        YRRedBagController *rebBagVC = [[YRRedBagController alloc]init];
        [self.navigationController pushViewController:rebBagVC animated:YES];
    };
    [self.view addSubview:_redPaperReceiveView];
}



- (void)back{
    [self.navigationController popViewControllerAnimated:YES];
}


@end
