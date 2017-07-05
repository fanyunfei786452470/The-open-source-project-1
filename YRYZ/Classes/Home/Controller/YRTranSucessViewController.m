//
//  YRTranSucessViewController.m
//  YRYZ
//
//  Created by 易超 on 16/8/22.
//  Copyright © 2016年 yryz. All rights reserved.
//

#import "YRTranSucessViewController.h"
#import "YRMyShareView.h"
#import "YRRedPaperView.h"
#import "YRRedPaperReceiveViewController.h"
#import "YRAddNewGroupViewController.h"
#import "YRLuckDrawModel.h"
#import "YRRedPaperListViewController.h"
#import "YRRedPaperClearView.h"
@interface YRTranSucessViewController ()<UIGestureRecognizerDelegate>
@property (nonatomic,strong) YRMyShareView                  *shareView;
@property (nonatomic,strong) YRLuckDrawModel                *model;
@property (nonatomic ,strong)YRRedListModel                 *redModel;
@property (nonatomic,strong)  UILabel                       *labSeven;

@property BOOL                                              isCanSideBack;

@end

@implementation YRTranSucessViewController

- (YRLotteryModel*)lotteryModel{
    
    if (!_lotteryModel) {
        _lotteryModel = [[YRLotteryModel alloc] init];
    }
    return _lotteryModel;
}

- (YRLuckDrawModel *)model{
    if (!_model) {
        _model = [[YRLuckDrawModel alloc] init];
    }
    return _model;
}

- (YRRedListModel *)redModel{
    if (!_redModel) {
        _redModel = [[YRRedListModel alloc] init];
    }
    return _redModel;
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    self.isCanSideBack = NO;
    //关闭ios右滑返回
    if([self.navigationController respondsToSelector:@selector(interactivePopGestureRecognizer)]) {
        self.navigationController.interactivePopGestureRecognizer.delegate = self;
    }
}

- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer*)gestureRecognizer {
    return self.isCanSideBack;
}

- (void)viewDidDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    // 开启返回手势
    [self resetSideBack];
}

- (void)resetSideBack {
    self.isCanSideBack = YES;
    if([self.navigationController respondsToSelector:@selector(interactivePopGestureRecognizer)]) {
        self.navigationController.interactivePopGestureRecognizer.delegate = nil;
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    self.title = @"转发成功";
    
    [self configUI];
    
    
    if (!self.model.maxstage) {
        [self detailsForLuckyDrawsuccess];
    }
    
}

- (void)configUI{
    
    [self setLeftNavButtonWithImage:[UIImage imageNamed:@"yr_return"]];
    
    
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
    [askBtn setTitle:@"邀请好友转发得奖励" forState:UIControlStateNormal];
    [askBtn addTarget:self action:@selector(askAction) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:askBtn];
    
    if (self.clubRedId.length > 0) {
        
        UIButton *redPaperBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        redPaperBtn.frame     = CJRectMake((375-52)/2, 295, 52, 60);
        [redPaperBtn setImage:[UIImage imageNamed:@"yr_circle_redPaper"] forState:UIControlStateNormal];
        [redPaperBtn addTarget:self action:@selector(redPaperAction) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:redPaperBtn];
        
        UILabel *labThree      = [[UILabel alloc] initWithFrame:CJRectMake((375-300)/2, 365, 300, 22)];
        labThree.text          = @"请领取圈子红包";
        labThree.font          = [UIFont systemFontOfSize:20.f];
        labThree.textAlignment = NSTextAlignmentCenter;
        [self.view addSubview:labThree];
        
    }
    
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
    [labSix sizeToFit];
    labSix.backgroundColor = [UIColor whiteColor];
    labSix.centerX = congratImageView.centerX;
    labSix.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:labSix];
    
    self.labSeven = [[UILabel alloc] initWithFrame:CJRectMake((375-270)/2, 520, 270, 20)];
    self.labSeven .text = [NSString stringWithFormat:@"离第%@期开奖还差%@次转发",self.lotteryModel.lotteryPeriod , self.lotteryModel.lotteryNumber];
    self.labSeven .textAlignment = NSTextAlignmentCenter;
    self.labSeven .textColor = [UIColor lightGrayColor];
    [self.view addSubview:self.labSeven ];
    
    NSString *str = [NSString stringWithFormat:@"yryz_lottery_open_%@",self.model.maxstage];
    NSSet *set = [NSSet setWithObjects:str, nil];
    [JPUSHService setTags:set alias:[YRUserInfoManager manager].currentUser.custId fetchCompletionHandle:^(int iResCode, NSSet *iTags, NSString *iAlias){
        DLog(@"rescode: %d, \ntags: %@, \nalias: %@\n", iResCode, iTags, iAlias);
    }];
}

- (void)askAction{
    YRAddNewGroupViewController *newChatVc = [[YRAddNewGroupViewController alloc] init];
    newChatVc.title = @"选择联系人";
    newChatVc.type = 2;
    newChatVc.infoId = self.lotteryModel.uid;
    [self.navigationController pushViewController:newChatVc animated:YES];
    
}


- (void)detailsForLuckyDrawsuccess{
    
    [YRHttpRequest detailsForLuckyDrawsuccess:^(NSDictionary *data) {
        self.model = [YRLuckDrawModel mj_objectWithKeyValues:data];
        //        self.labSeven.text = [NSString stringWithFormat:@"离第%@期开奖还差%ld次转发",self.model.maxstage , (long)(self.model.needcount - self.model.count)];
        NSString *str = [NSString stringWithFormat:@"yryz_lottery_open_%@",self.model.maxstage];
        NSSet *set = [NSSet setWithObjects:str, nil];
        [JPUSHService setTags:set alias:[YRUserInfoManager manager].currentUser.custId fetchCompletionHandle:^(int iResCode, NSSet *iTags, NSString *iAlias){
            DLog(@"rescode: %d, \ntags: %@, \nalias: %@\n", iResCode, iTags, iAlias);
        }];
        
    } failure:^(NSString *eCorrorInfo) {
        [MBProgressHUD showError:eCorrorInfo];
    }];
}
- (void)redPaperAction{
    
    [self fectRobRed];
    
}


- (void)fectRobRed{
    
    
    if (!self.clubRedId) {
        [MBProgressHUD showError:@"无效红包"];
        return;
    }
    [MBProgressHUD showMessage:@""];
    [YRHttpRequest robRed:self.clubRedId  success:^(NSDictionary  *data) {
        [MBProgressHUD hideHUD];
    
        YRRedListModel  *model =  [YRRedListModel mj_objectWithKeyValues:data];
        NSUInteger code = [data[@"code"] integerValue];
        //1:成功，3:失败,22:已拆 21:已过期 23:已抢光 24:自己的红包 20:广告红包没有审核
        
        switch (code) {
            case 1:
            {
                [self fectOpenRed];
            }
                break;
            case 3:
            {
                [MBProgressHUD showSuccess:@"失败"];
            }
                break;
            case 21:
            {
                [YRRedPaperClearView showRedPaperClearViewWithName:@"redPaperOverImage"];
            }
                break;
            case 22:
            {
                
                YRRedPaperReceiveViewController *redVc = [[YRRedPaperReceiveViewController alloc] init];
                redVc.redModel = model;
                [self.navigationController pushViewController:redVc animated:YES];
                
            }
                break;
            case 23:
            {
                [YRRedPaperClearView showRedPaperClearViewWithName:@"redPaperClearImage"];
                
            }
                break;
            case 24:
            {
                YRRedPaperListViewController  *redRecordVc = [[YRRedPaperListViewController alloc] init];
                redRecordVc.redId = self.lotteryModel.redpackId;
                [self.navigationController pushViewController:redRecordVc animated:YES];
            }
                break;
            case 20:
                
                break;
            default:
                break;
        }
    } failure:^(id data) {
        [MBProgressHUD hideHUD];
        [MBProgressHUD showError:data];
    }];
    
    
    
    
}


- (void)fectOpenRed{
    @weakify(self);
    [YRRedPaperView showRedPaperViewWithName:self.clubRedCustName ? self.clubRedCustName :@"" OpenBlock:^(){
        @strongify(self);
        
        [YRHttpRequest openRed:self.clubRedId friendStatus:1 success:^(NSDictionary *data) {
            self.redModel = [YRRedListModel mj_objectWithKeyValues:data];
            if (self.redModel) {
                
                YRRedPaperReceiveViewController *viewController = [[YRRedPaperReceiveViewController alloc]init];
                viewController.redModel = self.redModel;
                [self.navigationController pushViewController:viewController animated:NO];
            }
            
        } failure:^(id data) {
            [MBProgressHUD showError:data];
        }];
    }];
    
}


- (void)rightNavAction:(UIButton*)button{
    [self.shareView  show];
}

- (void)leftNavAction:(UIButton *)button{
    
    
    if (self.msgTrans) {
        [self.navigationController popViewControllerAnimated:YES];
    }else{
        NSInteger count = self.navigationController.viewControllers.count;
        if (self.delegate) {
            [self.delegate infoReadStatus];
        }
        [self.navigationController popToViewController:self.navigationController.viewControllers[count-3] animated:YES];
    }
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}


@end
