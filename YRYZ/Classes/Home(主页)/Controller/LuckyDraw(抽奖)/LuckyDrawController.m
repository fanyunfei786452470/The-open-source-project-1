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




@interface LuckyDrawController ()

@property (nonatomic,weak) UIImageView *contentView;

@property (nonatomic,weak) UIScrollView *scroll;

@end

@implementation LuckyDrawController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"抽奖夺宝";
    self.isComming = YES;
    self.isUser = YES;

    [self setRightNavButtonWithTitle:@"往期开奖"];
    [self configUI];

}


- (void)rightNavAction:(UIButton *)button{
    YRBeforePrizeViewController *before = [[YRBeforePrizeViewController alloc]init];
    [self.navigationController pushViewController:before animated:YES];
}

#pragma mark ---配置ui
- (void)configUI{
    if (self.isComming) {
        UIScrollView *scroll = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
        [self.view addSubview:scroll];
        scroll.contentSize = CGSizeMake(0, SCREEN_HEIGHT*2);
        _scroll =scroll;
        
        UIImageView *contentView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT*2)];
        contentView.image = [UIImage imageNamed:@"yr_back_bg"];
        [scroll addSubview:contentView];
        scroll.bounces = NO;
        [self configHeader:scroll];
        
        
    }else{
        UIScrollView *scroll = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
        [self.view addSubview:scroll];
        scroll.contentSize = CGSizeMake(0, SCREEN_HEIGHT*2);
        _scroll =scroll;
        
        UIImageView *contentView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT*2)];
        contentView.image = [UIImage imageNamed:@"yr_back_bg"];
        [scroll addSubview:contentView];
        scroll.bounces = NO;
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
        Ftitle.text = @"第189期";
        Ftitle.frame = CGRectMake(0, 0, 100, 30);
        Ftitle.center = CGPointMake(headerView.center.x, 70*SCREEN_H_POINT);
        

      
        [headerView addSubview:Ftitle];
        
        UILabel *FfristOne = [[UILabel alloc]init];
         FfristOne.text = @"一等奖";
        UILabel *FfristTwo = [[UILabel alloc]init];
        FfristTwo.text = @"3000积分";
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
        UILabel *FTwoTwo = [[UILabel alloc]init];
        FTwoTwo.text = @"1000积分";
        FTwoTwo.textColor = [UIColor redColor];
        FTwoTwo.font = [UIFont boldSystemFontOfSize:17];
        
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
                title.text = @"第189期";
                title.frame = CGRectMake(0, 0, 100, 30);
                title.center = CGPointMake(headerView.center.x, 65*SCREEN_H_POINT);
                title.textColor = [UIColor whiteColor];
                [nextImage addSubview:title];
                
                UILabel *fristOne = [[UILabel alloc]init];
                fristOne.textColor = [UIColor whiteColor];
                fristOne.text = @"一等奖";
                UILabel *fristTwo = [[UILabel alloc]init];
                fristTwo.text = @"3000积分";
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
                TwoTwo.text = @"1000积分";
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
        LotteryView *openView = [[LotteryView alloc]init];
        [nextImage addSubview:openView];
        //    openView.backgroundColor = [UIColor redColor];
        [openView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(price.mas_bottom).mas_offset(5);
            make.centerX.equalTo(scroll);
            make.size.mas_equalTo(CGSizeMake(SCREEN_WIDTH-60, 40));
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
            title.text = @"第189期";
            title.frame = CGRectMake(0, 0, 100, 30);
            title.center = CGPointMake(headerView.center.x, 48*SCREEN_H_POINT);
            
            [headerView addSubview:title];
            
            UILabel *fristOne = [[UILabel alloc]init];
            fristOne.text = @"一等奖";
            UILabel *fristTwo = [[UILabel alloc]init];
            fristTwo.text = @"3000积分";
            fristTwo.textColor = [UIColor redColor];
            fristTwo.font = [UIFont boldSystemFontOfSize:17];
            UILabel *fristThree = [[UILabel alloc]init];
            fristThree.text = @"1名";
            
            [headerView addSubview:fristOne];
            [headerView addSubview:fristTwo];
            [headerView addSubview:fristThree];
            
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
            TwoOne.text = @"二等奖";
            UILabel *TwoTwo = [[UILabel alloc]init];
            TwoTwo.text = @"1000积分";
            TwoTwo.textColor = [UIColor redColor];
            TwoTwo.font = [UIFont boldSystemFontOfSize:17];
            
            UILabel *TwoThree = [[UILabel alloc]init];
            TwoThree.text = @"2名";
            [headerView addSubview:TwoOne];
            [headerView addSubview:TwoTwo];
            [headerView addSubview:TwoThree];
            
            
            [TwoOne mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.equalTo(fristOne.mas_bottom).mas_offset(3);
                make.size.mas_equalTo(CGSizeMake(80, 30));
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
            UILabel *price = [[UILabel alloc]init];
            price.text = @"距离开奖";
            [headerView addSubview:price];
            [price mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.equalTo(TwoTwo.mas_bottom).mas_offset(8*SCREEN_H_POINT);
                make.left.equalTo(TwoTwo.mas_left).mas_offset(-8*SCREEN_POINT);
                make.size.mas_equalTo(CGSizeMake(80, 30));
            }];
            
            LotteryView *openView = [[LotteryView alloc]init];
            [headerView addSubview:openView];
        //    openView.backgroundColor = [UIColor redColor];
            [openView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.equalTo(price.mas_bottom).mas_offset(5);
                make.centerX.equalTo(scroll);
                make.size.mas_equalTo(CGSizeMake(SCREEN_WIDTH-100, 40));
            }];
        
            UILabel *pourOut = [[UILabel alloc]init];
            pourOut.text = @"本抽奖活动与苹果公司无关";
            pourOut.font = [UIFont boldSystemFontOfSize:13];
            pourOut.textColor = RGB_COLOR(205, 205, 205);
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
        LotteryYardsView *LotteryYards = [[LotteryYardsView alloc]initWithNum:3];
       
        [self.scroll addSubview:LotteryYards];
        [LotteryYards mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(label.mas_bottom).mas_offset(20);
            make.centerX.equalTo(label);
            make.size.mas_equalTo(CGSizeMake(SCREEN_WIDTH-80, 60+LotteryYards.num*44));
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
        str = @"登陆查看我的抽奖码";
    }else{
        str = @"转发领取抽奖码";
    }
  
    UIButton *login = [UIButton buttonWithType:UIButtonTypeSystem];
    [login setTitle:str forState:UIControlStateNormal];
    login.titleLabel.font = [UIFont systemFontOfSize:18];
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
    NSString *text = @"\n\t  抽奖规则\n\t  ❶ 每次成功付费转发获得一个抽奖码\n\t  ❷ 满10000次转发即可开奖\n\t  ❸ 开奖时在抽奖码中任选三个作为中奖号码\n\t  ❹ 获奖积分会发至中奖者的“奖励积分”账户";

    label.backgroundColor = RGBA_COLOR(67, 202, 191, 1);
    [self.scroll addSubview:label];
    [label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(btn.mas_bottom).mas_offset(20);
        make.size.mas_equalTo(CGSizeMake(SCREEN_WIDTH-80, 180));
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
    label.layer.borderColor = [UIColor whiteColor].CGColor;
   

}

- (void)loginBtnClick:(UIButton *)sender{
    
    NSLog(@"点击登陆按钮");
}

- (void)dealloc{


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
