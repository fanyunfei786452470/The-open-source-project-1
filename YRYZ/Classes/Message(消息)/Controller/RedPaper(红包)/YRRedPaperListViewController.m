//
//  YRRedPaperListViewController.m
//  YRYZ
//
//  Created by Rongzhong on 16/7/11.
//  Copyright © 2016年 yryz. All rights reserved.
//

#import "YRRedPaperListViewController.h"

#import "YRRedPaperListView.h"

#define cellHeight 60

@interface YRRedPaperListViewController ()

@property(strong,nonatomic) UINavigationBar *bar;

@property(strong,nonatomic) UILabel *titleLabel;

@property(strong,nonatomic) UIButton *leftButton;


@property(strong,nonatomic) NSMutableArray   *dataList;

@end

@implementation YRRedPaperListViewController

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES animated:NO];
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:NO];
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault];
}


- (NSMutableArray*)dataList{

    if(!_dataList){
        _dataList = @{}.mutableCopy;
    }
    return _dataList;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self setNavbar];
    [self initUI];
    
    [self fectRedList];
}

-(void)setNavbar{
    _titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 0, 44)];
    _titleLabel.textColor = RGB_COLOR(255, 226, 159);
    _titleLabel.textAlignment = NSTextAlignmentCenter;
    _titleLabel.text = @"圈子红包";
    
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

-(void)initUI
{
    YRRedPaperListView *redPaperListView = [[YRRedPaperListView alloc]init];
    redPaperListView.frame = CGRectMake(0, 64, SCREEN_WIDTH, SCREEN_HEIGHT -64);
    [self.view addSubview:redPaperListView];

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

- (void)back{
    [self.navigationController popViewControllerAnimated:YES];
}

/**
 *  @author weishibo, 16-08-26 17:08:30
 *
 *  查看红包领取详情
 */
- (void)fectRedList{

    [YRHttpRequest getRedDetail:@"d1fbd2d483bc47f9844dec485a792595" pageNumber:0 pageSize:100 success:^(id data) {
        
    } failure:^(id data) {
        [MBProgressHUD showError:data];
    }];
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
