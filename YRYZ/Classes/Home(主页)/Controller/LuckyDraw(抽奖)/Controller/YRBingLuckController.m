//
//  YRBingLuckController.m
//  YRYZ
//
//  Created by Sean on 16/9/19.
//  Copyright © 2016年 yryz. All rights reserved.
//

#import "YRBingLuckController.h"
#import <TYAttributedLabel.h>

#import "YRBingView.h"
#import "SDCycleScrollView.h"
#import "YROpenLuckModel.h"
@interface YRBingLuckController ()<SDCycleScrollViewDelegate>
@property (nonatomic,strong) NSMutableArray *array;
@property (nonatomic,assign) NSInteger num;

@property (nonatomic,strong) SDCycleScrollView *maA;

@property (nonatomic,strong) SDCycleScrollView *maB;

@property (nonatomic,strong) SDCycleScrollView *maC;

@property (nonatomic,weak) UILabel *label1;
@property (nonatomic,weak) UILabel *label2;
@property (nonatomic,weak) UILabel *label3;

@property (nonatomic,weak) UIImageView *headerView;

@property (nonatomic,weak) UIImageView *bottomView;

@property (nonatomic,strong) NSMutableArray *modelArray;


@property (nonatomic,strong) NSMutableArray *code1;
@property (nonatomic,strong) NSMutableArray *code2;
@property (nonatomic,strong) NSMutableArray *code3;



@end

@implementation YRBingLuckController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    for (int i = 0; i <11; i++) {
        [self.code1 addObject:[self randomString]];
        [self.code2 addObject:[self randomString]];
        [self.code3 addObject:[self randomString]];
    }
    
    self.num = 0;
    self.dic = [YRUserInfoManager manager].openDic;
    [YRUserInfoManager manager].openDic = nil;
    self.title = [NSString stringWithFormat:@"第%@期",self.dic[@"data"][@"stage"]];
    self.modelArray = [YROpenLuckModel mj_objectArrayWithKeyValuesArray:self.dic[@"data"][@"lottoDetail"]];
  
//    YROpenLuckModel *model3 = [[YROpenLuckModel alloc]init];
//    model3.code = @"11D2F31T23H12321";
//    model3.nickName = @"你好啊";
//    YROpenLuckModel *model2 = [[YROpenLuckModel alloc]init];
//    model2.code = @"1WD2F31423H12H21";
//    model2.nickName = @"我好啊";
//    YROpenLuckModel *model1 = [[YROpenLuckModel alloc]init];
//    model1.code = @"11D2F31DE3H123HD";
//    model1.nickName = @"他好啊";
//    [self.modelArray addObject:model3];
//    [self.modelArray addObject:model2];
//    [self.modelArray addObject:model1];
        YROpenLuckModel *model3 = self.modelArray.lastObject;
        YROpenLuckModel *model2 = self.modelArray[1];
        YROpenLuckModel *model1 = self.modelArray.firstObject;
    
        [self.code1 addObject:model1.code];
        [self.code2 addObject:model2.code];
        [self.code3 addObject:model3.code];
    

    
    [self configHeader];
    NSSet *set = [NSSet setWithObjects:@"", nil];
    
    [JPUSHService setTags:set alias:[YRUserInfoManager manager].currentUser.custId fetchCompletionHandle:^(int iResCode, NSSet *iTags, NSString *iAlias){
        DLog(@"rescode: %d, \ntags: %@, \nalias: %@\n", iResCode, iTags, iAlias);
    }];
    
}
- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
//    [self.maA starAnimation];
}

- (NSString *)randomString{
    NSMutableString *string = [[NSMutableString alloc]init];
    for (int i = 0; i<16; i++) {
        if (arc4random_uniform(2)) {
              [string appendString:[NSString stringWithFormat:@"%d",arc4random_uniform(10)]];
        }else{
            [string appendString:[NSString stringWithFormat:@"%c",arc4random_uniform(26)+65]];
        }
    }
    return string;
}

- (void)configHeader{
 
    YROpenLuckModel *model2 = self.modelArray[1];
    YROpenLuckModel *model1 = self.modelArray.firstObject;
    
    UIImageView *headerImage = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"yr_yellow"]];
    self.headerView = headerImage;
    headerImage.userInteractionEnabled = YES;
    CGFloat BL = 1080/1140.0;
    [self.view addSubview:headerImage];
    [headerImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view.mas_top).mas_offset(0);
        make.size.mas_equalTo(CGSizeMake(SCREEN_WIDTH, SCREEN_WIDTH*BL));
        make.centerX.equalTo(self.view);
    }];
    
    UILabel *first = [[UILabel alloc]init];
    
    first.text = [NSString stringWithFormat:@"一等奖 %ld积分",[model1.amount integerValue]/100];
    first.textAlignment = NSTextAlignmentCenter;
    first.font = [UIFont systemFontOfSize:20];
    [headerImage addSubview:first];
    [first mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(headerImage);
        make.size.mas_equalTo(YRSizeMake(180, 30));
        make.top.equalTo(headerImage.mas_top).mas_offset(8*SCREEN_H_POINT);
        
    }];
    
    UILabel *label1 = [[UILabel alloc]init];
    self.label1 = label1;
    label1.backgroundColor = [UIColor clearColor];
    [headerImage addSubview:label1];
    label1.font = [UIFont boldSystemFontOfSize:15];
    label1.textColor = RGB_COLOR(158, 117, 39);
    label1.text = @"获奖者...";
    
//    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc]initWithString:text];
//    [attributedString addAttributeFont:[UIFont boldSystemFontOfSize:15]];
//    [attributedString addAttributeTextColor:RGBA_COLOR(158, 117, 39, 1)];
//    [label1 appendTextAttributedString:attributedString];
    
    
   
//    NSMutableAttributedString *attributedString2= [[NSMutableAttributedString alloc]initWithString:@"FDF"];
//  
//    
//    [attributedString2 addAttributeFont:[UIFont boldSystemFontOfSize:15]];
//    
//    [attributedString2 addAttributeTextColor:[UIColor whiteColor]];
//    [label1 appendTextAttributedString:attributedString2];
    label1.textAlignment = NSTextAlignmentCenter;
    [label1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(first.mas_bottom).mas_offset(0);
        make.width.mas_equalTo(SCREEN_WIDTH-100);
        make.height.mas_equalTo(20);
        make.centerX.equalTo(first);
    }];
    
//    UILabel *maA = [[UILabel alloc]init];
//    maA.text = @"DWDWEWE";
//    maA.font = [UIFont systemFontOfSize:20];
//    maA.textAlignment = NSTextAlignmentCenter;
//    maA.textColor = RGBA_COLOR(250, 35, 0, 1);
//    [headerImage addSubview:maA];
    
    SDCycleScrollView *maA = [SDCycleScrollView cycleScrollViewWithFrame:CGRectMake(0, 750, 100, 40) delegate:self placeholderImage:nil];
    maA.isAnimation = YES;
    maA.tag = 1001;
    maA.titleLabelBackgroundColor = [UIColor clearColor];
    maA.backgroundColor = [UIColor clearColor];
    maA.scrollDirection = UICollectionViewScrollDirectionVertical;
    maA.onlyDisplayText = YES;
    maA.autoScrollTimeInterval = 0.2;
    maA.titleLabelTextColor = [UIColor redColor];
    maA.titleLabelTextFont = [UIFont systemFontOfSize:25];
    if (kDevice_Is_iPhone5) {
        maA.titleLabelTextFont = [UIFont systemFontOfSize:18];
    }

    [headerImage addSubview:maA];
    maA.titlesGroup = _code1;
    maA.userInteractionEnabled = NO;
    [maA mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(label1.mas_bottom).mas_offset(5*SCREEN_H_POINT);
        make.size.mas_equalTo(YRSizeMake(SCREEN_WIDTH -100, 40));
//        make.centerX.equalTo(first);
         make.left.mas_equalTo(40*YRSCREEN_POINT);
    }];
    
    self.maA = maA;
   
    
    UILabel *second = [[UILabel alloc]init];
    second.text =[NSString stringWithFormat:@"二等奖 %ld积分",[model2.amount integerValue]/100];
    second.textAlignment = NSTextAlignmentCenter;
    second.font = [UIFont systemFontOfSize:20];
    [headerImage addSubview:second];
    [second mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(headerImage);
        make.size.mas_equalTo(YRSizeMake(180, 30));
        make.top.equalTo(maA.mas_bottom).mas_offset(5*SCREEN_H_POINT);
        
    }];
    
    
    
//    TYAttributedLabel *label2 = [[TYAttributedLabel alloc]init];
//    label2.backgroundColor = [UIColor clearColor];
//    [headerImage addSubview:label2];
//    NSString *text3 = @"获奖者  ";
//    NSMutableAttributedString *attributedString3 = [[NSMutableAttributedString alloc]initWithString:text3];
//    [attributedString3 addAttributeFont:[UIFont boldSystemFontOfSize:15]];
//    [attributedString3 addAttributeTextColor:RGBA_COLOR(158, 117, 39, 1)];
//    [label2 appendTextAttributedString:attributedString3];
//    
//    
//    
//    NSMutableAttributedString *attributedString4  = [[NSMutableAttributedString alloc]initWithString:@"IIIII"];
//    
//    [attributedString4 addAttributeFont:[UIFont boldSystemFontOfSize:15]];
//    
//    [attributedString4 addAttributeTextColor:[UIColor whiteColor]];
//    [label2 appendTextAttributedString:attributedString4];
//    label2.textAlignment = kCTTextAlignmentCenter;
    
    UILabel *label2 = [[UILabel alloc]init];
    self.label2 = label2;
    label2.backgroundColor = [UIColor clearColor];
    [headerImage addSubview:label2];
    label2.font = [UIFont boldSystemFontOfSize:15];
    label2.textColor = RGB_COLOR(158, 117, 39);
    label2.text = @"获奖者...";
    label2.textAlignment = NSTextAlignmentCenter;
    
    [label2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(second.mas_bottom).mas_offset(0);
        make.width.equalTo(label1);
        make.height.mas_equalTo(20);
        make.centerX.equalTo(second);
    }];
    
//    UILabel *maB = [[UILabel alloc]init];
//    maB.text = @"BBBBBB";
//    maB.font = [UIFont systemFontOfSize:20];
//    maB.textAlignment = NSTextAlignmentCenter;
//    maB.textColor = RGBA_COLOR(250, 35, 0, 1);
//    [headerImage addSubview:maB];
    
    SDCycleScrollView *maB = [SDCycleScrollView cycleScrollViewWithFrame:CGRectMake(0, 750, 100, 40) delegate:self placeholderImage:nil];
    self.maB = maB;
    maB.isAnimation = YES;
    maB.tag = 1002;
    maB.titleLabelBackgroundColor = [UIColor clearColor];
    maB.backgroundColor = [UIColor clearColor];
    maB.scrollDirection = UICollectionViewScrollDirectionVertical;
    maB.onlyDisplayText = YES;
    maB.autoScrollTimeInterval = 0.2;
    maB.titleLabelTextColor = [UIColor redColor];
    maB.titleLabelTextFont = [UIFont systemFontOfSize:25];
    if (kDevice_Is_iPhone5) {
        maB.titleLabelTextFont = [UIFont systemFontOfSize:18];
    }
    
    maB.userInteractionEnabled = NO;
//    self.maB.titlesGroup = self.array;
    [headerImage addSubview:maB];
    [maB mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(label2.mas_bottom).mas_offset(12*SCREEN_H_POINT);
        make.size.mas_equalTo(YRSizeMake(SCREEN_WIDTH -100, 40));
//        make.centerX.equalTo(first);
        make.left.mas_equalTo(40*YRSCREEN_POINT);
    }];
    

    TYAttributedLabel *name = [[TYAttributedLabel alloc]init];
    name.backgroundColor = [UIColor clearColor];
    [headerImage addSubview:name];
    
 
//        TYAttributedLabel *nameLabel = [[TYAttributedLabel alloc]init];
//        nameLabel.backgroundColor = [UIColor clearColor];
//        [headerImage addSubview:nameLabel];
//        NSString *nameText = @"获奖者  ";
//        NSMutableAttributedString *attri = [[NSMutableAttributedString alloc]initWithString:nameText];
//        [attri addAttributeFont:[UIFont boldSystemFontOfSize:15]];
//        [attri addAttributeTextColor:RGBA_COLOR(158, 117, 39, 1)];
//        [nameLabel appendTextAttributedString:attri];
//        
//        
//        
//        NSMutableAttributedString *att = [[NSMutableAttributedString alloc]initWithString:@"QQQQQQ"];
//       
//        [att addAttributeFont:[UIFont boldSystemFontOfSize:15]];
//        
//        [att addAttributeTextColor:[UIColor whiteColor]];
//        [nameLabel appendTextAttributedString:att];
//        nameLabel.textAlignment = kCTTextAlignmentCenter;
    
    UILabel *nameLabel = [[UILabel alloc]init];
    self.label3 = nameLabel;
    nameLabel.backgroundColor = [UIColor clearColor];
    [headerImage addSubview:nameLabel];
    nameLabel.font = [UIFont boldSystemFontOfSize:15];
    nameLabel.textColor = RGB_COLOR(158, 117, 39);
    nameLabel.text = @"获奖者...";
    nameLabel.textAlignment = NSTextAlignmentCenter;
    
        [nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(maB.mas_bottom).mas_offset(9*YRSCREEN_H_POINT);
            make.size.mas_equalTo(YRSizeMake(SCREEN_WIDTH -100, 20));
            make.centerX.equalTo(second);
        }];
        
//        UILabel *maC = [[UILabel alloc]init];
//        maC.text = @"CCCC";
//        maC.font = [UIFont systemFontOfSize:20];
//        maC.textAlignment = NSTextAlignmentCenter;
//        maC.textColor = RGBA_COLOR(250, 35, 0, 1);
//        [headerImage addSubview:maC];
    SDCycleScrollView *maC = [SDCycleScrollView cycleScrollViewWithFrame:CGRectMake(0, 750, 100, 40) delegate:self placeholderImage:nil];
    maC.isAnimation = YES;
    self.maC = maC;
    maC.tag = 1003;
    maC.userInteractionEnabled = NO;
    maC.titleLabelBackgroundColor = [UIColor clearColor];
    maC.backgroundColor = [UIColor clearColor];
    maC.scrollDirection = UICollectionViewScrollDirectionVertical;
    maC.onlyDisplayText = YES;
    maC.autoScrollTimeInterval = 0.2;
    maC.titleLabelTextColor = [UIColor redColor];
    maC.titleLabelTextFont = [UIFont systemFontOfSize:25];
    if (kDevice_Is_iPhone5) {
        maC.titleLabelTextFont = [UIFont systemFontOfSize:18];
    }
    [headerImage addSubview:maC];
        [maC mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(nameLabel.mas_bottom).mas_offset(3*SCREEN_H_POINT);
            make.size.mas_equalTo(YRSizeMake(SCREEN_WIDTH -100, 38));
//            make.centerX.equalTo(first);
             make.left.mas_equalTo(40*YRSCREEN_POINT);
        }];
        
    [self configBottom:headerImage];
}
- (void)configBottom:(UIImageView*)image{
    UIImageView *boottomView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"yr_white bottom"]];
    self.bottomView = boottomView;
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
        make.size.mas_equalTo(CJSizeMake(150, 30));
        make.centerX.equalTo(image);
    }];
    
    [lableleft mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(boottomView.mas_left).mas_offset(35);
        make.size.mas_equalTo(CJSizeMake(80, 1.5));
        make.centerY.equalTo(center);
    }];
    
    [lableright mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(image.mas_right).mas_offset(-35);
        make.size.mas_equalTo(CJSizeMake(80, 1.5));
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
        kaijiang.text = @"恭喜您";
        kaijiang.font = [UIFont systemFontOfSize:20];
        [kaijiang mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(center.mas_bottom).mas_offset(0);
            make.size.mas_equalTo(YRSizeMake(200, 25));
            make.centerX.equalTo(boottomView);
        }];
        UILabel *jiang = [[UILabel alloc]init];
        YROpenLuckModel *model3 = self.modelArray.lastObject;
        YROpenLuckModel *model2 = self.modelArray[1];
        YROpenLuckModel *model1 = self.modelArray.firstObject;
        NSString *price;
        NSString *custId = [YRUserInfoManager manager].currentUser.custId;
//        ||[custId isEqualToString:model2.custId]||[custId isEqualToString:model3.custId]
        if (([custId isEqualToString:model1.custId])&&([custId isEqualToString:model2.custId]||[custId isEqualToString:model3.custId])){
            price = @"获得一等奖、二等奖";
        }else if ([custId isEqualToString:model2.custId]||[custId isEqualToString:model3.custId]){
            price = @"获得二等奖";
        }else if([custId isEqualToString:model1.custId]) {
            price = @"获得一等奖";
        }        
        jiang.text = price;
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

- (void)cycleScrollView:(SDCycleScrollView *)cycleScrollView didScrollToIndex:(NSInteger)index
{
    NSLog(@">>>>>> 滚动到第%ld张图", (long)index);
    if (index==10) {
        if (cycleScrollView.tag==1001) {
            [cycleScrollView.timer setFireDate:[NSDate distantFuture]];
            [self fristLabel];
            self.maB.titlesGroup = self.code2;
            
        }else if (cycleScrollView.tag == 1002){
              [cycleScrollView.timer setFireDate:[NSDate distantFuture]];
            self.maC.titlesGroup = self.code3;
             [self twoLabel];
            
        }else{
            [cycleScrollView.timer setFireDate:[NSDate distantFuture]];
            [self threeLabel];
            [self.bottomView removeAllSubviews];
            [self.bottomView removeFromSuperview];
            YROpenLuckModel *model3 = self.modelArray.lastObject;
            YROpenLuckModel *model2 = self.modelArray[1];
            YROpenLuckModel *model1 = self.modelArray.firstObject;
            NSString *custId = [YRUserInfoManager manager].currentUser.custId;
            if ([custId isEqualToString:model1.custId]||[custId isEqualToString:model2.custId]||[custId isEqualToString:model3.custId]) {
                self.num = 2;
            }else{
                self.num = 1;
            }
            [self configBottom:self.headerView];
        }
    }
}
- (void)fristLabel{
    YROpenLuckModel *model1 = self.modelArray.firstObject;
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc]initWithString:@"获奖者  "];
    [attributedString addAttributeFont:[UIFont boldSystemFontOfSize:15]];
    [attributedString addAttributeTextColor:RGBA_COLOR(158, 117, 39, 1)];
  
    
    NSMutableAttributedString *attributedString2= [[NSMutableAttributedString alloc]initWithString:model1.nickName attributes:@{NSForegroundColorAttributeName:[UIColor whiteColor]}];
    [attributedString appendAttributedString:attributedString2];
    self.label1.attributedText = attributedString;
    
}
- (void)twoLabel{
    YROpenLuckModel *model2 = self.modelArray[1];
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc]initWithString:@"获奖者  "];
    [attributedString addAttributeFont:[UIFont boldSystemFontOfSize:15]];
    [attributedString addAttributeTextColor:RGBA_COLOR(158, 117, 39, 1)];
    
    
    NSMutableAttributedString *attributedString2= [[NSMutableAttributedString alloc]initWithString:model2.nickName attributes:@{NSForegroundColorAttributeName:[UIColor whiteColor]}];
    [attributedString appendAttributedString:attributedString2];
    self.label2.attributedText = attributedString;
}
- (void)threeLabel{
    YROpenLuckModel *model3 = self.modelArray.lastObject;
 
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc]initWithString:@"获奖者  "];
    [attributedString addAttributeFont:[UIFont boldSystemFontOfSize:15]];
    [attributedString addAttributeTextColor:RGBA_COLOR(158, 117, 39, 1)];
    
    
    NSMutableAttributedString *attributedString2= [[NSMutableAttributedString alloc]initWithString:model3.nickName attributes:@{NSForegroundColorAttributeName:[UIColor whiteColor]}];
    [attributedString appendAttributedString:attributedString2];
    self.label3.attributedText = attributedString;
}


- (NSMutableArray *)array
{
    if (!_array) {
        _array = [[NSMutableArray alloc]init];
    }
    return _array;
}
- (NSMutableArray *)code1
{
    if (!_code1) {
        _code1 = [[NSMutableArray alloc]init];
    }
    return _code1;
}
- (NSMutableArray *)code2
{
    if (!_code2) {
        _code2 = [[NSMutableArray alloc]init];
    }
    return _code2;
}
- (NSMutableArray *)code3
{
    if (!_code3) {
        _code3 = [[NSMutableArray alloc]init];
    }
    return _code3;
}

- (NSMutableArray *)modelArray
{
    if (!_modelArray) {
        _modelArray = [[NSMutableArray alloc]init];
    }
    return _modelArray;
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
