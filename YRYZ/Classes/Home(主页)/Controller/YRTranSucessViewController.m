//
//  YRTranSucessViewController.m
//  YRYZ
//
//  Created by 易超 on 16/8/22.
//  Copyright © 2016年 yryz. All rights reserved.
//

#import "YRTranSucessViewController.h"
#import "YRMyShareView.h"

@interface YRTranSucessViewController ()
@property (nonatomic,strong) YRMyShareView                  *shareView;
@end

@implementation YRTranSucessViewController

- (YRLotteryModel*)lotteryModel{

    if (!_lotteryModel) {
        _lotteryModel = [[YRLotteryModel alloc] init];
    }
    return _lotteryModel;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"转发成功";


    UIImageView *topImageView       = [[UIImageView alloc] initWithFrame:CJRectMake((375-100)/2, 30, 100, 100)];
    topImageView.image              = [UIImage imageNamed:@"yr_circle_repeatSuccess"];
    topImageView.layer.cornerRadius = topImageView.height/2;
    topImageView.clipsToBounds      = YES;
    [self.view addSubview:topImageView];
    
    UILabel *labOne      = [[UILabel alloc] initWithFrame:CJRectMake((375-150)/2, 145, 150, 18)];
    labOne.text          = @"转发成功";
    labOne.font          = [UIFont systemFontOfSize:20.f];
    labOne.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:labOne];

    UILabel *labTwo      = [[UILabel alloc] initWithFrame:CJRectMake((375-300)/2, 193, 300, 22)];
    labTwo.text          = @"跟转越多，收益越大";
    labTwo.font          = [UIFont systemFontOfSize:23.f];
    labTwo.textColor     = [UIColor lightGrayColor];
    labTwo.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:labTwo];
    
    UIButton *askBtn          = [UIButton buttonWithType:UIButtonTypeCustom];
    askBtn.frame              = CJRectMake(45, 235, (375-90), 40);
    askBtn.backgroundColor    = [UIColor themeColor];
    askBtn.layer.cornerRadius = askBtn.height/2;
    askBtn.clipsToBounds      = YES;
    askBtn.titleLabel.font    = [UIFont systemFontOfSize:20.f];
    [askBtn setTitle:@"邀请好友转发挣收益" forState:UIControlStateNormal];
    [askBtn addTarget:self action:@selector(askAction) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:askBtn];
    
    UIButton *redPaperBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    redPaperBtn.frame     = CJRectMake((375-52)/2, 295, 52, 60);
    [redPaperBtn setImage:[UIImage imageNamed:@"yr_circle_redPaper"] forState:UIControlStateNormal];
    [redPaperBtn addTarget:self action:@selector(redPaperAction) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:redPaperBtn];
    
    UILabel *labThree      = [[UILabel alloc] initWithFrame:CJRectMake((375-300)/2, 365, 300, 22)];
    labThree.text          = @"奖励你一个红包";
    labThree.font          = [UIFont systemFontOfSize:20.f];
    labThree.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:labThree];

    UIImageView *congratImageView    = [[UIImageView alloc] initWithFrame:CJRectMake(45, 415, 375-90, 135)];
    congratImageView.image           = [UIImage imageNamed:@"yr_circle_draw_bk"];
    [self.view addSubview:congratImageView];
    
    UILabel *labFour = [[UILabel alloc] initWithFrame:CJRectMake((375-70)/2, 425, 70, 25)];
    labFour.textColor = [UIColor themeColor];
    labFour.text = @"恭喜";
    labFour.textAlignment = NSTextAlignmentCenter;
    labFour.font = [UIFont boldSystemFontOfSize:22.f];
    [self.view addSubview:labFour];
    
    UILabel *labFive = [[UILabel alloc] initWithFrame:CJRectMake((375-200)/2, 457, 200, 20)];
    labFive.text = @"你获得一枚抽奖码";
    labFive.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:labFive];
    
    UILabel *labSix = [[UILabel alloc] initWithFrame:CJRectMake((375-150)/2, 488, 150, 20)];
    labSix.text = self.lotteryModel.lotteryId;
    labSix.textColor = [UIColor themeColor];
    labSix.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:labSix];
    
    UILabel *labSeven = [[UILabel alloc] initWithFrame:CJRectMake((375-270)/2, 520, 270, 20)];
    labSeven.text = [NSString stringWithFormat:@"离第%@期开奖还差%@次转发",self.lotteryModel.lotteryPeriod , self.lotteryModel.lotteryNumber];
    labSeven.textAlignment = NSTextAlignmentCenter;
    labSeven.textColor = [UIColor lightGrayColor];
    [self.view addSubview:labSeven];
  
    [self setRightNavButtonWithImage:[UIImage imageNamed:@"yr_navButton_more"]];
    [self setLeftNavButtonWithImage:[UIImage imageNamed:@"backIndicatorImage"]];
}

- (void)askAction{
   
    [MBProgressHUD showError:@"邀请好友按钮"];

}
- (void)redPaperAction{
    
    [MBProgressHUD showError:@"红包按钮"];

}

- (void)rightNavAction:(UIButton*)button{
    [self.shareView  show];
}

- (void)leftNavAction:(UIButton *)button{

    [self.navigationController popViewControllerAnimated:YES];
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
