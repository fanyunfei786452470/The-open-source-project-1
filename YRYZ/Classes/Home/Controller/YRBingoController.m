//
//  YRBingoController.m
//  YRYZ
//
//  Created by Sean on 16/8/10.
//  Copyright © 2016年 yryz. All rights reserved.
//

#import "YRBingoController.h"
#import <TYAttributedLabel.h>
#import "YRBeforePrizeModel.h"

@interface YRBingoController ()

@property (nonatomic,strong) NSMutableArray *array;

@property (nonatomic,strong) YRBeforeArray *model;

@end

@implementation YRBingoController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.num = 2;
    
    
//    [self loadData];
    [self configHeader];

}
- (void)loadData{
    [YRHttpRequest detailsForLuckyDrawsuccess:^(NSDictionary *data) {

            YRBeforeArray *model = [[YRBeforeArray alloc]mj_setKeyValues:data[@"lotto"]];
           self.title = [NSString stringWithFormat:@"第%@期",model.no];
        
            self.model = model;
            [self configHeader];
        
    } failure:^(NSString *eCorrorInfo) {
        
        
    }];
}
- (void)configHeader{
    YRBeforePrizeModel *modelF = self.model.list.firstObject;
    YRBeforePrizeModel *modelS1 = self.model.list[1];
    YRBeforePrizeModel *modelS2 = self.model.list.lastObject;
    
    
    UIImageView *headerImage = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"yr_yellow"]];
    
    CGFloat BL = 1080/1140.0;
    [self.view addSubview:headerImage];
    [headerImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view.mas_top).mas_offset(0);
        make.size.mas_equalTo(CGSizeMake(SCREEN_WIDTH, SCREEN_WIDTH*BL));
        make.centerX.equalTo(self.view);
    }];
   
    UILabel *first = [[UILabel alloc]init];
    first.text = @"一等奖 200积分";
    first.textAlignment = NSTextAlignmentCenter;
    first.font = [UIFont systemFontOfSize:20];
    [headerImage addSubview:first];
    [first mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(headerImage);
        make.size.mas_equalTo(YRSizeMake(180, 30));
        make.top.equalTo(headerImage.mas_top).mas_offset(8*SCREEN_H_POINT);
        
    }];
    
    TYAttributedLabel *label1 = [[TYAttributedLabel alloc]init];
    label1.backgroundColor = [UIColor clearColor];
    [headerImage addSubview:label1];
    NSString *text = @"获奖者  ";
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc]initWithString:text];
    [attributedString addAttributeFont:[UIFont boldSystemFontOfSize:15]];
    [attributedString addAttributeTextColor:RGBA_COLOR(158, 117, 39, 1)];
    [label1 appendTextAttributedString:attributedString];
    

    NSString *text2 = modelF.nickName;
    NSMutableAttributedString *attributedString2;
    if (text2) {
        attributedString2= [[NSMutableAttributedString alloc]initWithString:text2];
    }
    
      [attributedString2 addAttributeFont:[UIFont boldSystemFontOfSize:15]];
    
    [attributedString2 addAttributeTextColor:[UIColor whiteColor]];
    [label1 appendTextAttributedString:attributedString2];
    label1.textAlignment = kCTTextAlignmentCenter;
    [label1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(first.mas_bottom).mas_offset(0);
        make.width.equalTo(first);
        make.height.mas_equalTo(20);
        make.centerX.equalTo(first);
    }];
    
    UILabel *maA = [[UILabel alloc]init];
    maA.text = modelF.number;
    maA.font = [UIFont systemFontOfSize:20];
    maA.textAlignment = NSTextAlignmentCenter;
    maA.textColor = RGBA_COLOR(250, 35, 0, 1);
    [headerImage addSubview:maA];
    [maA mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(label1.mas_bottom).mas_offset(9*SCREEN_H_POINT);
        make.size.mas_equalTo(YRSizeMake(SCREEN_WIDTH -100, 40));
        make.centerX.equalTo(first);
    }];
    
    
    UILabel *second = [[UILabel alloc]init];
    second.text = @"二等奖 50积分";
    second.textAlignment = NSTextAlignmentCenter;
    second.font = [UIFont systemFontOfSize:20];
    [headerImage addSubview:second];
    [second mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(headerImage);
        make.size.mas_equalTo(YRSizeMake(180, 30));
        make.top.equalTo(maA.mas_bottom).mas_offset(5*SCREEN_H_POINT);
        
    }];
    
    
    
    TYAttributedLabel *label2 = [[TYAttributedLabel alloc]init];
    label2.backgroundColor = [UIColor clearColor];
    [headerImage addSubview:label2];
    NSString *text3 = @"获奖者  ";
    NSMutableAttributedString *attributedString3 = [[NSMutableAttributedString alloc]initWithString:text3];
    [attributedString3 addAttributeFont:[UIFont boldSystemFontOfSize:15]];
    [attributedString3 addAttributeTextColor:RGBA_COLOR(158, 117, 39, 1)];
    [label2 appendTextAttributedString:attributedString3];
    
    
    NSString *text4 = modelS1.nickName;
    NSMutableAttributedString *attributedString4;
    if (text4) {
        attributedString4 = [[NSMutableAttributedString alloc]initWithString:text4];
    }
    [attributedString4 addAttributeFont:[UIFont boldSystemFontOfSize:15]];
    
    [attributedString4 addAttributeTextColor:[UIColor whiteColor]];
    [label2 appendTextAttributedString:attributedString4];
    label2.textAlignment = kCTTextAlignmentCenter;
    [label2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(second.mas_bottom).mas_offset(0);
        make.width.equalTo(second);
        make.height.mas_equalTo(20);
        make.centerX.equalTo(second);
    }];
    
    UILabel *maB = [[UILabel alloc]init];
    maB.text = modelS1.number;
    maB.font = [UIFont systemFontOfSize:20];
    maB.textAlignment = NSTextAlignmentCenter;
    maB.textColor = RGBA_COLOR(250, 35, 0, 1);
    [headerImage addSubview:maB];
    [maB mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(label2.mas_bottom).mas_offset(9*SCREEN_H_POINT);
        make.size.mas_equalTo(YRSizeMake(SCREEN_WIDTH -100, 40));
        make.centerX.equalTo(first);
    }];
    
    
    TYAttributedLabel *name = [[TYAttributedLabel alloc]init];
    name.backgroundColor = [UIColor clearColor];
    [headerImage addSubview:name];
    
    if (self.num==0) {
        NSString *nameText = @"获奖者...  ";
        NSMutableAttributedString *nameAttributedString = [[NSMutableAttributedString alloc]initWithString:nameText];
         name.textAlignment = kCTTextAlignmentCenter;
        [nameAttributedString addAttributeFont:[UIFont boldSystemFontOfSize:15]];
        [nameAttributedString addAttributeTextColor:RGBA_COLOR(158, 117, 39, 1)];
        [name appendTextAttributedString:nameAttributedString];
        [headerImage addSubview:name];
        [name mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(maB.mas_bottom).mas_offset(9*SCREEN_H_POINT);
            make.size.mas_equalTo(YRSizeMake(SCREEN_WIDTH -100, 20));
            make.centerX.equalTo(maB);
        }];
        
        UILabel *bingo = [[UILabel alloc]init];
        bingo.text = @"即将开奖";
        bingo.font = [UIFont boldSystemFontOfSize:20];
        bingo.textAlignment = NSTextAlignmentCenter;
        bingo.textColor = RGBA_COLOR(202, 145, 41, 1);
        [headerImage addSubview:bingo];
        [bingo mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(name.mas_bottom).mas_offset(6*SCREEN_H_POINT);
            make.size.mas_equalTo(YRSizeMake(SCREEN_WIDTH -100, 38));
            make.centerX.equalTo(first);
        }];
        
        
    }else{
        TYAttributedLabel *nameLabel = [[TYAttributedLabel alloc]init];
        nameLabel.backgroundColor = [UIColor clearColor];
        [headerImage addSubview:nameLabel];
        NSString *nameText = @"获奖者  ";
        NSMutableAttributedString *attri = [[NSMutableAttributedString alloc]initWithString:nameText];
        [attri addAttributeFont:[UIFont boldSystemFontOfSize:15]];
        [attri addAttributeTextColor:RGBA_COLOR(158, 117, 39, 1)];
        [nameLabel appendTextAttributedString:attri];
        
        
        NSString *names = modelS2.nickName;
        NSMutableAttributedString *att;
        if (names) {
            att = [[NSMutableAttributedString alloc]initWithString:names];
        }
        [att addAttributeFont:[UIFont boldSystemFontOfSize:15]];
        
        [att addAttributeTextColor:[UIColor whiteColor]];
        [nameLabel appendTextAttributedString:att];
        nameLabel.textAlignment = kCTTextAlignmentCenter;
        [nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(maB.mas_bottom).mas_offset(9*SCREEN_H_POINT);
            make.size.mas_equalTo(YRSizeMake(SCREEN_WIDTH -100, 20));
            make.centerX.equalTo(maB);
        }];
        
        UILabel *maC = [[UILabel alloc]init];
        maC.text = modelS2.number;
        maC.font = [UIFont systemFontOfSize:20];
        maC.textAlignment = NSTextAlignmentCenter;
        maC.textColor = RGBA_COLOR(250, 35, 0, 1);
        [headerImage addSubview:maC];
        [maC mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(nameLabel.mas_bottom).mas_offset(6*SCREEN_H_POINT);
            make.size.mas_equalTo(YRSizeMake(SCREEN_WIDTH -100, 38));
            make.centerX.equalTo(first);
        }];

    }
    
    [self configBottom:headerImage];
}
- (void)configBottom:(UIImageView*)image{
    UIImageView *boottomView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"yr_white bottom"]];
    [self.view addSubview:boottomView];
    
    [boottomView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(image.mas_bottom).mas_offset(0);
        make.left.bottom.equalTo(self.view);
        make.right.equalTo(self.view.mas_right).mas_offset(0);
    }];
    
   
    UILabel *lableright = [[UILabel alloc]init];
    lableright.backgroundColor =RGBA_COLOR(234, 234, 234, 1);
   
    UILabel *center = [[UILabel alloc]init];
    center.text = @"我的抽奖结果";
    center.textAlignment = NSTextAlignmentCenter;
    center.font = [UIFont systemFontOfSize:20];
    
    UILabel *lableleft = [[UILabel alloc]init];
    lableleft.backgroundColor =RGBA_COLOR(234, 234, 234, 1);
    
    [boottomView addSubview:center];
    [boottomView addSubview:lableleft];
    [boottomView addSubview:lableright];
    
    
    [center mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(boottomView.mas_top).mas_offset(75*SCREEN_H_POINT);
        make.size.mas_equalTo(CGSizeMake(150, 30));
        make.centerX.equalTo(image);
    }];
    
    [lableleft mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(boottomView.mas_left).mas_offset(35);
        make.size.mas_equalTo(CGSizeMake(80, 1.5));
        make.centerY.equalTo(center);
    }];
    
    [lableright mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(image.mas_right).mas_offset(-35);
        make.size.mas_equalTo(CGSizeMake(80, 1.5));
        make.centerY.equalTo(center);
    }];

     UILabel *kaijiang = [[UILabel alloc]init];
      kaijiang.textColor = [UIColor redColor];
    kaijiang.textAlignment = NSTextAlignmentCenter;
    kaijiang.font = [UIFont systemFontOfSize:28];
    [boottomView addSubview:kaijiang];
    if (self.num==0) {
       kaijiang.text = @"开奖中...";
      [kaijiang mas_makeConstraints:^(MASConstraintMaker *make) {
          make.top.equalTo(center.mas_bottom).mas_offset(10*SCREEN_H_POINT);
          make.size.mas_equalTo(YRSizeMake(200, 60));
          make.centerX.equalTo(boottomView);
      }];
    }else if(self.num==1){
        kaijiang.text = @"很遗憾，没有中奖哦！";
         kaijiang.font = [UIFont systemFontOfSize:25];
        [kaijiang mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(center.mas_bottom).mas_offset(18*SCREEN_H_POINT);
            make.size.mas_equalTo(YRSizeMake(300, 30));
            make.centerX.equalTo(boottomView);
        }];
        UILabel *Nlabel = [[UILabel alloc]init];
         [boottomView addSubview:Nlabel];
        Nlabel.font = [UIFont boldSystemFontOfSize:18];
        Nlabel.text = @"再接再厉，转发越多，中奖机会越大";
        Nlabel.textAlignment = NSTextAlignmentCenter;
        Nlabel.textColor = RGB_COLOR(155, 155, 155);
        [Nlabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(kaijiang.mas_bottom).mas_offset(0);
            make.size.mas_equalTo(YRSizeMake(300, 30));
            make.centerX.equalTo(kaijiang);
        }];
        
    } else{
         kaijiang.text = @"恭喜你";
        kaijiang.font = [UIFont systemFontOfSize:20];
        [kaijiang mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(center.mas_bottom).mas_offset(0);
            make.size.mas_equalTo(YRSizeMake(200, 25));
            make.centerX.equalTo(boottomView);
        }];
        UILabel *jiang = [[UILabel alloc]init];
       jiang.text = @"获得一等奖、二等奖";
          jiang.font = [UIFont boldSystemFontOfSize:25];
         jiang.textAlignment = NSTextAlignmentCenter;
             jiang.textColor = [UIColor redColor];
        [boottomView addSubview:jiang];
        [jiang mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(kaijiang.mas_bottom).mas_offset(0);
            make.size.mas_equalTo(YRSizeMake(250, 30));
            make.centerX.equalTo(kaijiang);
        }];
        UILabel *moreText = [[UILabel alloc]init];
        moreText.text = @"奖金发放至您的奖励积分账户，请关注系统消息!";
        moreText.font =[UIFont boldSystemFontOfSize:15];
        moreText.numberOfLines = 0;
        moreText.textAlignment = NSTextAlignmentCenter;
        [boottomView addSubview:moreText];
        moreText.textColor = RGB_COLOR(153, 153, 153);
        [moreText mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(jiang.mas_bottom).mas_offset(0);
            make.size.mas_equalTo(YRSizeMake(210, 40));
            make.centerX.equalTo(jiang);
        }];
        
    }
}

- (NSMutableArray *)array
{
    if (!_array) {
        _array = [[NSMutableArray alloc]init];
    }
    return _array;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
