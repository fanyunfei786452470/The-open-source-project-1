//
//  YRMyRedPackViewController.m
//  YRYZ
//
//  Created by Sean on 16/8/11.
//  Copyright © 2016年 yryz. All rights reserved.
//

#import "YRMyRedPackViewController.h"
#import "YRRedUpOldViewController.h"
#import "YRRedPadingViewController.h"
#import "RRZMineMyInfoController.h"
@interface YRMyRedPackViewController ()

@end

@implementation YRMyRedPackViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self configHeader];
    [self configUI];
    
}
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    //    self.navigationController.navigationBar.hidden = YES;
    [self.navigationController setNavigationBarHidden:YES animated:YES];
}
- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    //    self.navigationController.navigationBar.hidden = NO;
    [self.navigationController setNavigationBarHidden:NO animated:YES];
}
- (void)configHeader{
//    self.view.backgroundColor = [UIColor redColor];
    UIImageView *bgImage = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 210)];
//    bgImage.backgroundColor = [UIColor randomColor];
    
    bgImage.image = [UIImage imageNamed:@"yr_red_user_bg"];
    [self.view addSubview:bgImage];
    bgImage.userInteractionEnabled = YES;

    UIButton *leftButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [leftButton setImage:[UIImage imageNamed:@"backIndicatorImage"] forState:UIControlStateNormal];
    [bgImage addSubview:leftButton];
    [leftButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view).mas_offset(5);
        make.top.equalTo(self.view).mas_offset(20);
        make.size.mas_equalTo(CGSizeMake(40, 40));
    }];
    
    [leftButton addTarget:self action:@selector(leftButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    
    UILabel *title = [[UILabel alloc]init];
    title.text = @"我的红包广告";
    title.font = [UIFont systemFontOfSize:19];
    title.textAlignment = NSTextAlignmentCenter;
    title.textColor = [UIColor whiteColor];
    [bgImage addSubview:title];
    
    [title mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(leftButton);
        make.centerX.equalTo(self.view);
        make.size.mas_equalTo(CGSizeMake(150, 40));
    }];
    
    UIImageView *userImage =[[UIImageView alloc]init];
    userImage.backgroundColor = [UIColor randomColor];
    [bgImage addSubview:userImage];
    [userImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(title);
        make.top.equalTo(title.mas_bottom).mas_offset(10);
        make.size.mas_equalTo(CJSizeMake(60, 60));
    }];
    userImage.layer.cornerRadius = 30*SCREEN_POINT;
    userImage.clipsToBounds = YES;
    
    
    UILabel *userName = [[UILabel alloc]init];
    userName.textAlignment = NSTextAlignmentCenter;
    userName.text = @"";
    userName.font = [UIFont titleFont16];
    userName.textColor = [UIColor whiteColor];
    userName.backgroundColor = RGBA_COLOR(0, 71, 70, 0.75);
    [bgImage addSubview:userName];
    
    UserModel *model = [YRUserInfoManager manager].currentUser;
    NSInteger width =150;
    if (model.custNname.length>=8) {
        width = 180;
        userName.font = [UIFont systemFontOfSize:15];
    }
    
    [userName mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(userImage);
        make.top.equalTo(userImage.mas_bottom).mas_offset(10);
        make.size.mas_equalTo(CJSizeMake(width, 30));
    }];
    userName.layer.cornerRadius = 15*SCREEN_POINT;
    userName.clipsToBounds = YES;
    
    UILabel *allMoney = [[UILabel alloc]init];
    self.allMoney = allMoney;
    allMoney.textAlignment = NSTextAlignmentCenter;
//    allMoney.text = @"广告红包总额: 0.00元";
    allMoney.textColor = [UIColor whiteColor];
    allMoney.font = [UIFont titleFont14];
    [bgImage addSubview:allMoney];
    [allMoney mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(userName);
        make.top.equalTo(userName.mas_bottom).mas_offset(5);
//        make.size.mas_equalTo(CJSizeMake(180, 30));
        make.height.mas_equalTo(30);
    }];
   
   
    [userImage setImageWithURL:[NSURL URLWithString:model.custImg] placeholder:[UIImage defaultHead]];
    userName.text = model.custNname;
    allMoney.text = model.custDesc;
    userImage.userInteractionEnabled = YES;
    
//    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(doTap:)];
//    [userImage addGestureRecognizer:tap];
    
}
- (void)doTap:(UITapGestureRecognizer *)tap{
    
    RRZMineMyInfoController *userInfo = [[RRZMineMyInfoController alloc]init];
    [self.navigationController pushViewController:userInfo animated:YES];
    
    
}
- (void)leftButtonClick:(UIButton *)sender{
    [self.navigationController popViewControllerAnimated:YES];
}


- (void)configUI{
    
        YRRedUpOldViewController *RedA = [[YRRedUpOldViewController alloc]initWithOldOrNew:YES];
        RedA.delegate = self;
        RedA.title = @"通过";
        [self addChildViewController:RedA];
        
       YRRedPadingViewController *RedB = [[YRRedPadingViewController alloc]initWithPadOrPass:YES];
        RedB.delegate = self;
       RedB.title = @"审核中";
       [self addChildViewController:RedB];
    
        YRRedPadingViewController *RedC = [[YRRedPadingViewController alloc]initWithPadOrPass:NO];
        RedC.delegate = self;
        RedC.title = @"未通过";
        [self addChildViewController:RedC];
    
        YRRedUpOldViewController *RedD = [[YRRedUpOldViewController alloc]initWithOldOrNew:NO];
        RedD.delegate = self;
        RedD.title = @"过期";
        [self addChildViewController:RedD];
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
