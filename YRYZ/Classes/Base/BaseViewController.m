//
//  BaseViewController.m
//  Rrz
//
//  Created by weishibo on 16/2/19.
//  Copyright © 2016年 rongzhongwang. All rights reserved.
//

#import "BaseViewController.h"
#import "YRLoginController.h"
#import "YRAdListUserInfoController.h"

@interface BaseViewController()
<LoginSuccessDelegate>
@property (strong, nonatomic) UINavigationBar   *bar;
@property (strong, nonatomic) NSString          *tip;

@property (nonatomic ,strong)UILabel            *tipLabel;//数目提醒

@end


@implementation BaseViewController


- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    //    [self.navigationController setNavigationBarHidden:NO animated:YES];
}

-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    //    [self.navigationController setNavigationBarHidden:NO animated:YES];
}
- (void)loginSuccessDelegate:(UserModel *)userModel{

}

- (void)setRightNavButtonWithImage:(UIImage*)rightImage{
    self.navigationItem.rightBarButtonItem = nil;
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithImage:rightImage style:UIBarButtonItemStylePlain target:self action:@selector(rightNavAction:)];
    
}

- (void)setRightNavButtonWithTitle:(NSString*)rightTitle{
    NSString *title = [NSString stringWithFormat:@"%@",rightTitle];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:title style:UIBarButtonItemStylePlain target:self action:@selector(rightNavAction:)];
}



- (void)setRightNavButtonWithImage:(NSString *)imageName title:(NSString*)title{

    UIButton *rightBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 65, 30)];
    [rightBtn setImage:[UIImage imageNamed:imageName] forState:UIControlStateNormal];
    [rightBtn setTitle:[NSString stringWithFormat:@" %@",title] forState:UIControlStateNormal];
    rightBtn.titleLabel.font = [UIFont systemFontOfSize:19.f];
    rightBtn.titleLabel.textColor = [UIColor whiteColor];
    [rightBtn addTarget:self action:@selector(rightNavAction:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem     *rightBarBtn = [[UIBarButtonItem alloc] initWithCustomView:rightBtn];
    self.navigationItem.rightBarButtonItem = rightBarBtn;

}
- (void)setLeftNavButtonWithTitle:(NSString*)leftTitle{
    NSString *title = [NSString stringWithFormat:@"%@",leftTitle];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:title style:UIBarButtonItemStylePlain target:self action:@selector(leftNavAction:)];
}

- (void)setLeftNavButtonWithImage:(UIImage*)leftImage{
    
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:leftImage style:UIBarButtonItemStylePlain target:self action:@selector(leftNavAction:)];
    
}
- (void)leftNavAction:(UIButton *)button{
    [self.navigationController popViewControllerAnimated:YES];
}
- (void)rightNavAction:(UIButton*)button{
    [self.view endEditing:YES];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.edgesForExtendedLayout = UIRectEdgeNone;
    self.extendedLayoutIncludesOpaqueBars = NO;
    self.modalPresentationCapturesStatusBarAppearance = NO;
    self.automaticallyAdjustsScrollViewInsets = YES;
    self.view.backgroundColor = [UIColor whiteColor];
    self.navigationController.interactivePopGestureRecognizer.delegate = (id)self;
    
    [self setLeftNavButtonWithImage:[UIImage imageNamed:@"yr_return"]];
    
}

- (void)initNavigationBarWithTitle:(NSString*)title{
    
    [self.navigationController setNavigationBarHidden:YES];
    
    _bar = [[UINavigationBar alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 64)];
    
    [_bar setBackgroundImage:[UIImage imageNamed:@"theme_navbar_bg"] forBarMetrics:UIBarMetricsDefault];
    
    UINavigationItem *item = [[UINavigationItem alloc] init];
    
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 0, 44)];
    titleLabel.textAlignment = NSTextAlignmentCenter;
    titleLabel.text = title;
    titleLabel.textColor = [UIColor whiteColor];
    item.titleView = titleLabel;
    
    
    UIButton *leftButton = [UIButton buttonWithType:UIButtonTypeCustom];
    leftButton.tag = 2;
    [leftButton setFrame:CGRectMake(0, 0, 11, 18)];
    [leftButton setImage:[UIImage imageNamed:@"backIndicatorImage"] forState:UIControlStateNormal];
    [leftButton addTarget:self action:@selector(back) forControlEvents:UIControlEventTouchUpInside];
    
    UIButton *rightButton = [UIButton buttonWithType:UIButtonTypeCustom];
    rightButton.tag = 3;
    [rightButton setFrame:CGRectMake(0, 0, 11, 18)];
    [rightButton addTarget:self action:@selector(rightButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    
    
    UIBarButtonItem *leftItem = [[UIBarButtonItem alloc] initWithCustomView:leftButton];
    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc] initWithCustomView:rightButton];
    
    [item setLeftBarButtonItem:leftItem];
    [item setRightBarButtonItem:rightItem];
    
    [_bar pushNavigationItem:item animated:NO];
    [self.view addSubview:_bar];
}

-(void)hideLeftButton
{
    UIButton *leftButton = [_bar viewWithTag:2];
    leftButton.hidden = YES;
}

- (void)initNavBarWithBgImage:(UIImage*)image TitleLabel:(UIView*)titleView LeftButton:(UIButton*)leftButton RightButton:(UIButton*)rightButton{
    
    [self.navigationController setNavigationBarHidden:YES];
    
    UINavigationBar *bar = [[UINavigationBar alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 64)];
    
    //    [bar setBackgroundImage:image forBarMetrics:UIBarMetricsDefault];
    [bar setBackgroundColor:[UIColor themeColor]];
    
    UINavigationItem *item = [[UINavigationItem alloc] init];
    
    
    if (titleView) {
        item.titleView = titleView;
    }
    
    if (leftButton) {
        [leftButton addTarget:self action:@selector(back) forControlEvents:UIControlEventTouchUpInside];
        UIBarButtonItem *leftItem = [[UIBarButtonItem alloc] initWithCustomView:leftButton];
        [item setLeftBarButtonItem:leftItem];
    }
    
    if (rightButton) {
        [rightButton addTarget:self action:@selector(rightButtonAction:) forControlEvents:UIControlEventTouchUpInside];
        UIBarButtonItem *rightItem = [[UIBarButtonItem alloc] initWithCustomView:rightButton];
        [item setRightBarButtonItem:rightItem];
    }
    
    [bar pushNavigationItem:item animated:NO];
    [self.view addSubview:bar];
}

- (void)back{
    [self.navigationController popViewControllerAnimated:YES];
}

- (UIStatusBarStyle)preferredStatusBarStyle {
    return UIStatusBarStyleLightContent;
}


-(void)rightButtonAction:(UIButton*)button{
    
}

- (UIInterfaceOrientation)interfaceOrientation
{
    return [[UIApplication sharedApplication] statusBarOrientation];
}

- (BOOL)prefersStatusBarHidden
{
    return NO;
}

/**
 *  @author weishibo, 16-08-03 14:08:36
 *
 *  游客页面
 */
- (void)touristsView{
    
    
    UILabel *label = [[UILabel alloc] init];
    label.frame = CGRectMake(0, (SCREEN_HEIGHT - 64 -44)/2 - 100, SCREEN_WIDTH, 20);
    label.text = @"登录后看看ta们都在干嘛";
    label.textColor = RGB_COLOR(153, 153, 153);
    label.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:label];
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button setBackgroundImage:[UIImage imageNamed:@"yr_button_Bg"] forState:UIControlStateNormal];
    [button setTitle:@"登录" forState:UIControlStateNormal];
    button.frame = CGRectMake((SCREEN_WIDTH - 120)/2, label.mj_y + label.mj_h + 50, 120, 30);
    [button addTarget:self action:@selector(loginClcik) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:button];
    
}

- (void)loginClcik{
    YRLoginController  *loginVc = [[YRLoginController alloc] init];
    loginVc.loginSuccessDelegate = self;
    [self.navigationController pushViewController:loginVc animated:YES];
}

- (UILabel *)tipLabel{
    
    if (!_tipLabel) {
        _tipLabel = [[UILabel alloc] init];
    }
    return _tipLabel;
}

- (UILabel*)addUpdateNumTodo:(NSInteger)num{
    self.tip = @"";
    if (num == 0) {
        self.tip = @"暂无更新，休息一会";
    }else{
        self.tip =  [NSString stringWithFormat:@"%ld条新消息",(long)num];
    }
    
    self.tipLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 26)];
    self.tipLabel.backgroundColor =  RGB_COLOR(255, 209, 2);
    self.tipLabel.text = self.tip;
    self.tipLabel.font = [UIFont systemFontOfSize:12];
    self.tipLabel.textColor = [UIColor whiteColor];
    self.tipLabel.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:self.tipLabel];
    
    
    [UIView animateWithDuration:2 animations:^{
        self.tipLabel.frame = CGRectMake(0, -26, SCREEN_WIDTH, 26);
    }];
    
    return self.tipLabel;
}

- (void)pushUserInfoViewController:(NSString *)userID  withIsFriend:(BOOL)isFriend {
    
    YRAdListUserInfoController *adList = [[YRAdListUserInfoController alloc]init];
    adList.isFriend = isFriend;
    //    adList.uid = userID;
    adList.custId = userID;
    [self.navigationController pushViewController:adList animated:YES];

}

- (void)noLoginTip{

        YRAlertView *alertView = [[YRAlertView alloc] initWithTitle:@"请登录进行后续操作" cancelButtonText:@"再逛逛" confirmButtonText:@"登录"];
        
        alertView.addCancelAction = ^{
            
        };
        alertView.addConfirmAction = ^{
            YRLoginController  *loginVc = [[YRLoginController alloc] init];
            loginVc.loginSuccessDelegate = self;
            [self.navigationController pushViewController:loginVc animated:YES];
        };
        [alertView show];
}
- (void)saveModelInfoToDisk{
    
//    NSDictionary *dic = (NSDictionary *)[[YRYYCache share].yyCache objectForKey:[YRUserInfoManager manager].currentUser.custId];
    NSDictionary *userDic = [[YRUserInfoManager manager].currentUser mj_keyValues];
    DLog(@"%@",userDic);
    [[YRYYCache share].yyCache setObject:userDic forKey:[YRUserInfoManager manager].currentUser.custId];
}


-(void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event{
    [self touchesMoved:touches withEvent:event];
}
@end
