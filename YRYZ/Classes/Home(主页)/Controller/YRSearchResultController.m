//
//  YRSearchResultController.m
//  YRYZ
//
//  Created by Sean on 16/8/31.
//  Copyright © 2016年 yryz. All rights reserved.
//

#import "YRSearchResultController.h"
#import "RRZNavSearchView.h"

@interface YRSearchResultController ()<UITextFieldDelegate>
@property (weak, nonatomic) UITextField *seachTextField;
@end

@implementation YRSearchResultController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self configNav];
}
- (void)configNav{
    RRZNavSearchView *searchView = [[RRZNavSearchView alloc]init];
    searchView.frame = CGRectMake(0, 6, SCREEN_WIDTH - 95, 32);
   
    self.seachTextField = searchView.seachTextField;
    self.seachTextField.delegate = self;
    [self.seachTextField becomeFirstResponder];
    self.navigationItem.titleView = searchView;

    UIButton *rightButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [rightButton setTitle:@"搜索" forState:UIControlStateNormal];
    rightButton.titleLabel.font = [UIFont systemFontOfSize:15];
    [rightButton sizeToFit];
    [rightButton addTarget:self action:@selector(searchItemClick) forControlEvents:UIControlEventTouchUpInside];
    
    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc]initWithCustomView:rightButton];
    self.navigationItem.rightBarButtonItem = rightItem;
}
- (void)searchItemClick{
    [self.seachTextField endEditing:YES];
    
}

-(void)viewWillDisappear:(BOOL)animated{
    [self.seachTextField endEditing:YES];
}
-(void)dealloc{
    [self.seachTextField endEditing:YES];
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
