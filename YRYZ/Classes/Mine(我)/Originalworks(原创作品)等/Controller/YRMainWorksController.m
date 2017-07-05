//
//  YRMainWorksController.m
//  YRYZ
//
//  Created by Sean on 16/9/27.
//  Copyright © 2016年 yryz. All rights reserved.
//

#import "YRMainWorksController.h"
#import "RRZMineMyInfoController.h"
#import "YRMyWorksController.h"
@interface YRMainWorksController ()

@end

@implementation YRMainWorksController
- (void)viewDidLoad {
    [super viewDidLoad];
    //    [self setTitle:@"原创作品"];
    //    [self loadData];
    [self configHeader];
    [self configController];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.hidden = YES;
}
- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    self.navigationController.navigationBar.hidden = NO;
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
    title.text = @"原创作品";
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
    userName.text = @"珊惬意苏黎世";
    userName.textColor = [UIColor whiteColor];
    userName.backgroundColor = RGB_COLOR(254, 208, 48);
    [bgImage addSubview:userName];
    
    [userName mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(userImage);
        make.top.equalTo(userImage.mas_bottom).mas_offset(10);
        make.size.mas_equalTo(CJSizeMake(150, 30));
    }];
    userName.layer.cornerRadius = 15*SCREEN_POINT;
    userName.clipsToBounds = YES;
    
    UILabel *allMoney = [[UILabel alloc]init];
    allMoney.textAlignment = NSTextAlignmentCenter;
    //    allMoney.text = @"坚持减肥,加油胜利就在眼前,加油坚持减肥";
    allMoney.textColor = [UIColor whiteColor];
    //    allMoney.font = [UIFont boldSystemFontOfSize:15];
    allMoney.font = [UIFont systemFontOfSize:15];
    [bgImage addSubview:allMoney];
    [allMoney mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(userName);
        make.top.equalTo(userName.mas_bottom).mas_offset(5);
        make.size.mas_equalTo(CGSizeMake(SCREEN_WIDTH-50, 30));
    }];
    UserModel *model = [YRUserInfoManager manager].currentUser;
    [userImage setImageWithURL:[NSURL URLWithString:model.custImg] placeholder:[UIImage defaultHead]];
    userName.text = model.custNname;
    allMoney.text = model.custDesc;
    userImage.userInteractionEnabled = YES;
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(doTap:)];
    [userImage addGestureRecognizer:tap];
}
- (void)doTap:(UITapGestureRecognizer *)tap{
    
    RRZMineMyInfoController *userInfo = [[RRZMineMyInfoController alloc]init];
    [self.navigationController pushViewController:userInfo animated:YES];
    
    
}

- (void)leftButtonClick:(UIButton *)sender{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)configController{
    
    YRMyWorksController *through = [[YRMyWorksController alloc]init];
    through.title = @"通过";
    [self addChildViewController:through];
    
    YRMyWorksController *pass = [[YRMyWorksController alloc]init];
    pass.title = @"未通过";
    [self addChildViewController:pass];
    
    YRMyWorksController *audit = [[YRMyWorksController alloc]init];
    audit.title = @"审核中";
    [self addChildViewController:audit];
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
