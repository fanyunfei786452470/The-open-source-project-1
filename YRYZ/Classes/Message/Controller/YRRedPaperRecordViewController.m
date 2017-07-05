//
//  YRRedPaperRecordViewController.m
//  YRYZ
//
//  Created by Rongzhong on 16/7/14.
//  Copyright © 2016年 yryz. All rights reserved.
//

#import "YRRedPaperRecordViewController.h"
#import "YRRedPaperRecordView.h"

@interface YRRedPaperRecordViewController ()

@end

@implementation YRRedPaperRecordViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initUI];
    [self setTitle:@"红包记录"];
}

-(void)initUI{
    YRRedPaperRecordView *recordView = [[YRRedPaperRecordView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
    [self.view addSubview:recordView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
