//
//  YRMineWebController.m
//  YRYZ
//
//  Created by Sean on 16/9/28.
//  Copyright © 2016年 yryz. All rights reserved.
//

#import "YRMineWebController.h"
#import "YRWebView.h"


@interface YRMineWebController ()<WKNavigationDelegate>

@end

@implementation YRMineWebController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = self.titletext;
    YRWebView *web = [[YRWebView alloc]init];
    web.userInteractionEnabled = YES;
    web.frame =CGRectMake(0,0, SCREEN_WIDTH, SCREEN_HEIGHT-40);
    
    NSString *urlStr = _url;
    NSURL *url = [NSURL URLWithString:urlStr];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    [web loadRequest:request];
    web.navigationDelegate = self;
   
    [self.view addSubview:web];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
