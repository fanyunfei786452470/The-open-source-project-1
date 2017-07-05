//
//  LuckyDrawController.m
//  LuckyDraw
//
//  Created by Sean on 16/8/9.
//  Copyright © 2016年 Sean. All rights reserved.
//

#import "LuckyDrawController.h"
#import <Masonry.h>
#import "LotteryYardsView.h"
#import <TYAttributedLabel.h>
#import "LotteryView.h"
#import "YRCountdownView.h"
#import "YRBingoController.h"
#import "YRBeforePrizeViewController.h"
#import "YRLuckDrawModel.h"
#import "YRCircleMainViewController.h"

#import "YRLoginController.h"
@interface LuckyDrawController ()<UIScrollViewDelegate>

@property (nonatomic,weak) UIImageView *contentView;

@property (nonatomic,weak) UIScrollView *scroll;

@property (nonatomic,strong) YRLuckDrawModel *model;

@property (nonatomic,copy) NSString *number;

@property (nonatomic,assign) NSInteger time;

@property (nonatomic,strong) LotteryView *openView;

@property (nonatomic,weak) UILabel *firstLabel;

@property (nonatomic,weak) UILabel *scendLabel;

@property (nonatomic,assign) CGFloat height;

@property (nonatomic,weak) UILabel *Flabel;

@property (nonatomic,weak) UILabel *Slabel;

@end

@implementation LuckyDrawController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"趣味抽奖";
  
    self.isComming = [YRUserInfoManager manager].currentUser.isOpenLottery;
    self.isUser = [YRUserInfoManager manager].currentUser?YES:NO;
    
    
    if (kDevice_Is_iPhone5) {
        DLog(@"555");
    }
    [self configUI];
//    [self loadData];
//    self.view.backgroundColor = RGB_COLOR(56, 208, 197);//[UIColor colorWithPatternImage:[UIImage imageNamed:@"yr_back_bg"]];
    
//    UIImageView *image = [[UIImageView alloc]initWithFrame:self.view.bounds];
//    image.image = [UIImage imageNamed:@"yr_back_bg"];
//    [self.view addSubview:image];
    [self setRightNavButtonWithTitle:@"往期开奖"];
}
- (void)rightNavAction:(UIButton *)button{
    YRBeforePrizeViewController *before = [[YRBeforePrizeViewController alloc]init];
    [self.navigationController pushViewController:before animated:YES];
}

- (void)loadData{
    [YRHttpRequest detailsForLuckyDrawsuccess:^(NSDictionary *data) {
        self.model = [YRLuckDrawModel mj_objectWithKeyValues:data];
        self.number = self.model.maxstage;
        [self.scroll removeAllSubviews];
        [self.scroll removeFromSuperview];
         self.isUser = [YRUserInfoManager manager].currentUser?YES:NO;
        [self configUI];
        
    } failure:^(NSString *eCorrorInfo) {
        [MBProgressHUD showError:eCorrorInfo];
     }];
}
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self loadData];
}
#pragma mark ---配置ui
- (void)configUI{
    NSInteger num = self.model.mycodes.count%2==0?self.model.mycodes.count/2:(self.model.mycodes.count/2)+1;
    NSInteger limts = num>=4 ? 4:num;;
    self.height = SCREEN_HEIGHT+120+limts*44 ;
   
    if (self.isComming) {
        UIScrollView *scroll = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
        [self.view addSubview:scroll];
        scroll.contentSize = CGSizeMake(0, self.height);
        _scroll =scroll;
        scroll.delegate = self;
        UIImageView *contentView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, self.height)];
        contentView.image = [UIImage imageNamed:@"yr_back_bg"];
        [scroll addSubview:contentView];
//        scroll.bounces = NO;
        [self configHeader:scroll];
    }else{
        UIScrollView *scroll = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
        [self.view addSubview:scroll];
        scroll.contentSize = CGSizeMake(0, self.height);
        _scroll =scroll;
        scroll.delegate = self;
        UIImageView *contentView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, self.height)];
        contentView.image = [UIImage imageNamed:@"yr_back_bg"];
        [scroll addSubview:contentView];
//        scroll.bounces = NO;
        [self configHeader:scroll];
    }    
}
#pragma mark ---配置头部
- (void)configHeader:(UIScrollView *)scroll{
    
    
    if (_isComming ) {
        UIImageView *headerView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"yr_will_open"]];
        CGFloat Hbl = 480/750.0;
        headerView.frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_WIDTH*Hbl);
            [scroll addSubview:headerView];
        UIImageView *nextImage = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"yr_next_one"]];
        [scroll addSubview:nextImage];
        [nextImage mas_makeConstraints:^(MASConstraintMaker *make) {
            make.size.equalTo(headerView);
            make.left.equalTo(scroll.mas_left).mas_offset(0);
            make.top.equalTo(headerView.mas_bottom).mas_offset(10);
            
        }];
        
        
        UILabel *Ftitle = [[UILabel alloc]init];
        Ftitle.textAlignment = NSTextAlignmentCenter;
        Ftitle.text = [NSString stringWithFormat:@"第%@期",self.number?self.number:@"0"];
        Ftitle.frame = CGRectMake(0, 0, 100, 30);
        Ftitle.center = CGPointMake(headerView.center.x, 70*SCREEN_H_POINT);
        
        [headerView addSubview:Ftitle];
        
        UILabel *FfristOne = [[UILabel alloc]init];
         FfristOne.text = @"一等奖";
        self.Flabel = FfristOne;
        UILabel *FfristTwo = [[UILabel alloc]init];
        FfristTwo.text = [NSString stringWithFormat:@"%ld积分",self.model.amount1?self.model.amount1/100:0];;
        self.firstLabel = FfristTwo;
        FfristTwo.textColor = [UIColor redColor];
        FfristTwo.font = [UIFont boldSystemFontOfSize:17];
        UILabel *FfristThree = [[UILabel alloc]init];
        FfristThree.text = @"1名";
        
        [headerView addSubview:FfristOne];
        [headerView addSubview:FfristTwo];
        [headerView addSubview:FfristThree];
        
        [FfristOne mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(Ftitle.mas_bottom).mas_offset(0);
            make.size.mas_equalTo(CGSizeMake(70, 30));
            make.left.equalTo(Ftitle.mas_left).mas_offset(-60);
        }];
        [FfristTwo mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(Ftitle.mas_bottom).mas_offset(0);
            make.size.mas_equalTo(CGSizeMake(80, 30));
            make.left.equalTo(FfristOne.mas_right).mas_offset(0);
        }];
        [FfristThree mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(Ftitle.mas_bottom).mas_offset(0);
            make.size.mas_equalTo(CGSizeMake(80, 30));
            make.left.equalTo(FfristTwo.mas_right).mas_offset(0);
        }];
        FfristThree.textAlignment = NSTextAlignmentCenter;
        UILabel *FTwoOne = [[UILabel alloc]init];
        
        FTwoOne.text = @"二等奖";
        self.Slabel = FTwoOne;
        UILabel *FTwoTwo = [[UILabel alloc]init];
        FTwoTwo.text =[NSString stringWithFormat:@"%ld积分",self.model.amount2?self.model.amount2/100:0];;
        FTwoTwo.textColor = [UIColor redColor];
        FTwoTwo.font = [UIFont boldSystemFontOfSize:17];
        self.scendLabel = FTwoTwo;
        UILabel *FTwoThree = [[UILabel alloc]init];
        FTwoThree.text = @"2名";
        
        [headerView addSubview:FTwoOne];
        [headerView addSubview:FTwoTwo];
        [headerView addSubview:FTwoThree];
        
        
        [FTwoOne mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(FfristOne.mas_bottom).mas_offset(0);
            make.size.mas_equalTo(CGSizeMake(70, 30));
            make.left.equalTo(Ftitle.mas_left).mas_offset(-60);
        }];
        [FTwoTwo mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(FfristOne.mas_bottom).mas_offset(0);
            make.size.mas_equalTo(CGSizeMake(80, 30));
            make.left.equalTo(FTwoOne.mas_right).mas_offset(0);
        }];
        [FTwoThree mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(FfristOne.mas_bottom).mas_offset(0);
            make.size.mas_equalTo(CGSizeMake(80, 30));
            make.left.equalTo(FTwoTwo.mas_right).mas_offset(0);
        }];
        FTwoThree.textAlignment = NSTextAlignmentCenter;
          //开奖倒计时的view
          YRCountdownView *Countdown = [[YRCountdownView alloc]init];
        
                Countdown.backgroundColor = [UIColor clearColor];
                [headerView addSubview:Countdown];
        
        Countdown.mytime = ^(BOOL isFinsh){
            if (isFinsh) {
                
                  YRBingoController *binggo = [[YRBingoController alloc]init];
                [self.navigationController pushViewController:binggo animated:YES];
            }
            
        };
        
                [Countdown mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.top.equalTo(FTwoThree.mas_bottom).mas_equalTo(20*SCREEN_H_POINT);
                    make.size.mas_equalTo(YRSizeMake(160,60));
                    make.centerX.equalTo(headerView);
                }];
  
                UILabel *title = [[UILabel alloc]init];
                title.textAlignment = NSTextAlignmentCenter;
                title.text =  [NSString stringWithFormat:@"第%d期",[self.number intValue] -1];
                title.frame = CGRectMake(0, 0, 100, 30);
                title.center = CGPointMake(headerView.center.x, 65*SCREEN_H_POINT);
                title.textColor = [UIColor whiteColor];
                [nextImage addSubview:title];
                
                UILabel *fristOne = [[UILabel alloc]init];
                fristOne.textColor = [UIColor whiteColor];
                fristOne.text = @"一等奖";
                UILabel *fristTwo = [[UILabel alloc]init];
                fristTwo.text = [NSString stringWithFormat:@"%ld积分",self.model.amount1?self.model.amount1/100:0];;
                fristTwo.textColor = [UIColor redColor];
                fristTwo.font = [UIFont boldSystemFontOfSize:17];
                UILabel *fristThree = [[UILabel alloc]init];
                fristThree.text = @"1名";
                 fristThree.textColor = [UIColor whiteColor];
                [nextImage addSubview:fristOne];
                [nextImage addSubview:fristTwo];
                [nextImage addSubview:fristThree];
                
                [fristOne mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.top.equalTo(title.mas_bottom).mas_offset(3);
                    make.size.mas_equalTo(CGSizeMake(70, 30));
                    make.left.equalTo(title.mas_left).mas_offset(-60);
                }];
                [fristTwo mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.top.equalTo(title.mas_bottom).mas_offset(3);
                    make.size.mas_equalTo(CGSizeMake(80, 30));
                    make.left.equalTo(fristOne.mas_right).mas_offset(0);
                }];
                [fristThree mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.top.equalTo(title.mas_bottom).mas_offset(3);
                    make.size.mas_equalTo(CGSizeMake(80, 30));
                    make.left.equalTo(fristTwo.mas_right).mas_offset(0);
                }];
                fristThree.textAlignment = NSTextAlignmentCenter;
                UILabel *TwoOne = [[UILabel alloc]init];
                TwoOne.textColor = [UIColor whiteColor];
                TwoOne.text = @"二等奖";
                UILabel *TwoTwo = [[UILabel alloc]init];
                TwoTwo.text = [NSString stringWithFormat:@"%ld积分",self.model.amount2?self.model.amount2/100:0];;
                TwoTwo.textColor = [UIColor redColor];
                TwoTwo.font = [UIFont boldSystemFontOfSize:17];
                
                UILabel *TwoThree = [[UILabel alloc]init];
                TwoThree.text = @"2名";
                  TwoThree.textColor = [UIColor whiteColor];
                [nextImage addSubview:TwoOne];
                [nextImage addSubview:TwoTwo];
                [nextImage addSubview:TwoThree];
                
                
                [TwoOne mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.top.equalTo(fristOne.mas_bottom).mas_offset(3);
                    make.size.mas_equalTo(CGSizeMake(70, 30));
                    make.left.equalTo(title.mas_left).mas_offset(-60);
                }];
                [TwoTwo mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.top.equalTo(fristOne.mas_bottom).mas_offset(3);
                    make.size.mas_equalTo(CGSizeMake(80, 30));
                    make.left.equalTo(TwoOne.mas_right).mas_offset(0);
                }];
                [TwoThree mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.top.equalTo(fristOne.mas_bottom).mas_offset(3);
                    make.size.mas_equalTo(CGSizeMake(80, 30));
                    make.left.equalTo(TwoTwo.mas_right).mas_offset(0);
                }];
            TwoThree.textAlignment = NSTextAlignmentCenter;
        
        
            UILabel *more = [[UILabel alloc]init];
            [scroll addSubview:more];
            more.font = [UIFont systemFontOfSize:15];
            more.textColor = [UIColor whiteColor];
            more.textAlignment = NSTextAlignmentCenter;
            more.text = @"每成功付费转发一次作品，获得一个抽奖码，抽奖码越多，中奖机会越大哦！";
            more.numberOfLines = 0;
            
            [more mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.equalTo(nextImage.mas_bottom).mas_offset(8);
                make.centerX.equalTo(nextImage);
                make.size.mas_equalTo(CGSizeMake(SCREEN_WIDTH-100, 60));
            }];
        
        
        
        UILabel *price = [[UILabel alloc]init];
        price.text = @"距离开奖";
        [nextImage addSubview:price];
        [price mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(TwoTwo.mas_bottom).mas_offset(8*SCREEN_H_POINT);
            make.left.equalTo(TwoTwo.mas_left).mas_offset(-8*SCREEN_POINT);
            make.size.mas_equalTo(CGSizeMake(80, 30));
        }];
//        剩余转发次数的view
        
        
        
        NSString *count =[NSString stringWithFormat:@"%ld",self.model.needcount - self.model.count] ;
         LotteryView *openView = [[LotteryView alloc]initWithNeedCount:count];
        self.openView = openView;
        
        [nextImage addSubview:openView];
        //    openView.backgroundColor = [UIColor redColor];
        [openView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(price.mas_bottom).mas_offset(5);
            make.centerX.equalTo(scroll.mas_centerX);
            make.size.mas_equalTo(CGSizeMake(SCREEN_WIDTH-50, 40));
        }];
       /* UILabel *pourOut = [[UILabel alloc]init];
//        pourOut.backgroundColor = [UIColor redColor];
        pourOut.text = @"本抽奖活动与苹果公司无关";
        pourOut.textColor = RGB_COLOR(205, 205, 205);
        pourOut.font = [UIFont boldSystemFontOfSize:13];
        [headerView addSubview:pourOut];
        [pourOut mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(openView.mas_bottom).mas_offset(5);
            make.centerX.equalTo(headerView);
        }];*/
        
        [self configBottom:more];
    }
    else{
            UIImageView *headerView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"yr_bottom"]];
            CGFloat Hbl = 480/750.0;
            headerView.frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_WIDTH*Hbl);
            
            [scroll addSubview:headerView];
            
            UILabel *title = [[UILabel alloc]init];
            title.textAlignment = NSTextAlignmentCenter;
            title.text =  [NSString stringWithFormat:@"第%@期",self.number?self.number:@"0"];
            title.frame = CGRectMake(0, 0, 100, 30);
            title.center = CGPointMake(headerView.center.x, 48*SCREEN_H_POINT);
            
            [headerView addSubview:title];
            
            UILabel *fristOne = [[UILabel alloc]init];
            fristOne.text = @"一等奖";
            self.Flabel = fristOne;
            UILabel *fristTwo = [[UILabel alloc]init];
            fristTwo.text = [NSString stringWithFormat:@"%ld积分",self.model.amount1?self.model.amount1/100:0];;
            self.firstLabel = fristTwo;
            fristTwo.textColor = [UIColor redColor];
            fristTwo.font = [UIFont boldSystemFontOfSize:17];
            UILabel *fristThree = [[UILabel alloc]init];
            fristThree.text = @"1名";
            
            [headerView addSubview:fristOne];
            [headerView addSubview:fristTwo];
            [headerView addSubview:fristThree];
            NSInteger left = kDevice_Is_iPhone5 ? -50:-60;
            [fristOne mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.equalTo(title.mas_bottom).mas_offset(3);
                make.size.mas_equalTo(CGSizeMake(70, 30));
                make.left.equalTo(title.mas_left).mas_offset(left);
            }];
            [fristTwo mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.equalTo(title.mas_bottom).mas_offset(3);
                make.size.mas_equalTo(CGSizeMake(80, 30));
                make.left.equalTo(fristOne.mas_right).mas_offset(0);
            }];
            [fristThree mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.equalTo(title.mas_bottom).mas_offset(3);
                make.size.mas_equalTo(CGSizeMake(80, 30));
                make.left.equalTo(fristTwo.mas_right).mas_offset(0);
            }];
            fristThree.textAlignment = NSTextAlignmentCenter;
            UILabel *TwoOne = [[UILabel alloc]init];
            TwoOne.text = @"二等奖";
            self.Slabel = TwoOne;
            UILabel *TwoTwo = [[UILabel alloc]init];
            TwoTwo.text = [NSString stringWithFormat:@"%ld积分",self.model.amount2?self.model.amount2/100:0];;
            self.scendLabel = TwoTwo;
            TwoTwo.textColor = [UIColor redColor];
            TwoTwo.font = [UIFont boldSystemFontOfSize:17];
            
            UILabel *TwoThree = [[UILabel alloc]init];
            TwoThree.text = @"2名";
            [headerView addSubview:TwoOne];
            [headerView addSubview:TwoTwo];
            [headerView addSubview:TwoThree];
            
            
            [TwoOne mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.equalTo(fristOne.mas_bottom).mas_offset(3);
                make.size.mas_equalTo(CGSizeMake(70, 30));
                make.left.equalTo(title.mas_left).mas_offset(left);
            }];
            [TwoTwo mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.equalTo(fristOne.mas_bottom).mas_offset(3);
                make.size.mas_equalTo(CGSizeMake(80, 30));
                make.left.equalTo(TwoOne.mas_right).mas_offset(0);
            }];
            [TwoThree mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.equalTo(fristOne.mas_bottom).mas_offset(3);
                make.size.mas_equalTo(CGSizeMake(80, 30));
                make.left.equalTo(TwoTwo.mas_right).mas_offset(0);
            }];
            TwoThree.textAlignment = NSTextAlignmentCenter;
            UILabel *price = [[UILabel alloc]init];
            price.text = @"距离开奖";
            [headerView addSubview:price];
            [price mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.equalTo(TwoTwo.mas_bottom).mas_offset(8*SCREEN_H_POINT);
                make.left.equalTo(TwoTwo.mas_left).mas_offset(-8*SCREEN_POINT);
                make.size.mas_equalTo(CGSizeMake(80, 30));
            }];
            NSString *count =[NSString stringWithFormat:@"%ld",self.model.needcount - self.model.count] ;
            LotteryView *openView = [[LotteryView alloc]initWithNeedCount:count];
            self.openView = openView;
//            openView.needcount = self.model.needcount;
        
            [headerView addSubview:openView];
        //    openView.backgroundColor = [UIColor redColor];
            [openView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.equalTo(price.mas_bottom).mas_offset(5);
                make.centerX.equalTo(scroll.mas_centerX);
                make.size.mas_equalTo(CGSizeMake(SCREEN_WIDTH-50, 40));
            }];
        
            UILabel *pourOut = [[UILabel alloc]init];
            pourOut.text = @"本抽奖活动与苹果公司无关";
            pourOut.font = [UIFont boldSystemFontOfSize:13];
            pourOut.textColor = RGB_COLOR(102, 102, 102);
            [headerView addSubview:pourOut];
            [pourOut mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.equalTo(openView.mas_bottom).mas_offset(5);
                make.centerX.equalTo(headerView);
                
            }];

            UILabel *more = [[UILabel alloc]init];
            [scroll addSubview:more];
            more.font = [UIFont systemFontOfSize:14];
            more.textColor = [UIColor whiteColor];
            more.textAlignment = NSTextAlignmentCenter;
            more.text = @"每成功付费转发一次作品，获得一个抽奖码，抽奖码越多，中奖机会越大哦！";
            more.numberOfLines = 0;
            
            [more mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.equalTo(headerView.mas_bottom).mas_offset(8);
                make.centerX.equalTo(headerView);
                make.size.mas_equalTo(CGSizeMake(SCREEN_WIDTH-60, 60));
            }];
            [self configBottom:more];
    }
}

- (void)configBottom:(UILabel *)label{
    if (self.isUser) {

            // 由num决定tableyou多少行
        NSInteger num = self.model.mycodes.count%2==0?self.model.mycodes.count/2:(self.model.mycodes.count/2)+1;
        
        LotteryYardsView *LotteryYards = [[LotteryYardsView alloc]initWithNum:num withArray:self.model.mycodes];
       
        [self.scroll addSubview:LotteryYards];
        [LotteryYards mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(label.mas_bottom).mas_offset(20);
            make.centerX.equalTo(label);
            make.size.mas_equalTo(CGSizeMake(SCREEN_WIDTH-60, 60+LotteryYards.num*44));
        }];
        [self bottomBtn:LotteryYards];
 
    }
    else{
        [self bottomBtn:label];
    }

}
#pragma mark ---配置按钮
- (void)bottomBtn:(UIView *)view{
    
    NSString *str ;
    if ([view isKindOfClass:[UILabel class]]) {
        str = @"登录查看我的抽奖码";
    }else{
        str = @"转发领取抽奖码";
    }
  
    UIButton *login = [UIButton buttonWithType:UIButtonTypeSystem];
    [login setTitle:str forState:UIControlStateNormal];
    login.titleLabel.font = [UIFont boldSystemFontOfSize:18];
    [login setTitleColor:RGBA_COLOR(55, 197, 187, 1) forState:UIControlStateNormal];
    login.backgroundColor = [UIColor whiteColor];
    [_scroll addSubview:login];
    [login mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(view.mas_bottom).mas_offset(20);
        make.size.mas_equalTo(CGSizeMake(SCREEN_WIDTH-100, 40));
        make.centerX.equalTo(view);
    }];
    login.layer.cornerRadius = 20;
    login.clipsToBounds = YES;
    [login addTarget:self action:@selector(loginBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    
    [self bottomLabel:login];
    

}
- (void)bottomLabel:(UIButton *)btn{
    TYAttributedLabel *label = [[TYAttributedLabel alloc]init];
    NSString *text = @"\n\t  抽奖规则\n\t  ❶ 每次成功付费转发获得一个抽奖码\n\t  ❷ 根据平台当期规定的转发总数开奖\n\t  ❸ 开奖时在抽奖码中任选三个作为中奖号码\n\t  ❹ 获奖积分会发至中奖者的“奖励积分”账户";
//    label.paragraphSpacing = 1;
        
    
    label.backgroundColor = RGBA_COLOR(67, 202, 191, 1);
    CGFloat height =  180*(586/SCREEN_HEIGHT)-15*SCREEN_H_POINT;
    if (SYSTEMVERSION<9.0) {
        height =height+20*(586/SCREEN_HEIGHT);
    }
    
    [self.scroll addSubview:label];
    [label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(btn.mas_bottom).mas_offset(20);
        make.size.mas_equalTo(CGSizeMake(SCREEN_WIDTH-60,height));
        make.centerX.equalTo(btn);
    }];
    
    
    NSArray *textArray = [text componentsSeparatedByString:@"\n\t"];
 
    for (int i = 0; i<textArray.count; i++) {
        NSString *text = textArray[i];
        NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc]initWithString:text];
        [attributedString addAttributeTextColor:[UIColor whiteColor]];
        CGFloat font = i==1?17:13;
        
        [attributedString addAttributeFont:[UIFont boldSystemFontOfSize:font]];
        [label appendTextAttributedString:attributedString];
        [label appendText:@"\n"];
        
    }

    label.layer.borderWidth = 1;
    label.layer.borderColor = RGBA_COLOR(255, 255, 255, 0.6).CGColor;
}

- (void)loginBtnClick:(UIButton *)sender{
    if (self.isUser) {
        YRCircleMainViewController *circleVc = [[YRCircleMainViewController alloc] init];
        [self.navigationController pushViewController:circleVc animated:YES];
        
    }else{
        YRLoginController  *login = [[YRLoginController alloc]init];
        [self.navigationController pushViewController:login animated:YES];
    }
    NSLog(@"点击登陆按钮");
}
//-(void)viewWillLayoutSubviews{
//    [super viewWillLayoutSubviews];
//    if (kDevice_Is_iPhone5) {
//        CGRect x1 = self.Flabel.frame;
//        CGRect x2 = self.Slabel.frame;
//        
//        x1.origin.x-=100;
//        x2.origin.x-=100;
//        self.Flabel.frame = x1;
//        self.Slabel.frame = x2;
//    }
//}
- (void)dealloc{


}
-(void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    if (scrollView.contentOffset.y < 0) {
        scrollView.backgroundColor = [UIColor whiteColor];
    }else if(scrollView.contentOffset.y > 0){
        scrollView.backgroundColor = RGB_COLOR(51, 204, 193);
    }
}

//-(void)viewWillLayoutSubviews{
//    [super viewWillLayoutSubviews];
//    if (kDevice_Is_iPhone5) {
//        self.openView.centerX = self.view.centerX - 25;
//    }
//}


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
