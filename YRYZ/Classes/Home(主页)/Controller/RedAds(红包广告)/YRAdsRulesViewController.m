//
//  YRAdsRulesViewController.m
//  YRYZ
//
//  Created by Sean on 16/8/11.
//  Copyright © 2016年 yryz. All rights reserved.
//

#import "YRAdsRulesViewController.h"
#import "YRAdsRulesTableViewCell.h"
#import "YRMyRedPackViewController.h"
#import "YRRealseAdsViewController.h"


@interface YRAdsRulesViewController ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic,strong) NSMutableArray *array;

@property (nonatomic,strong) NSArray *titles;

@property (nonatomic,strong) NSArray *subtitles;
@end

@implementation YRAdsRulesViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    NSArray *titles = @[@"什么是平台广告费",@"费用金额以及收取频次",@"费用来源",@"广告的生效时间",@"平台费用能够退还吗?"];
    NSArray *subtitles = @[@"发布者想在悠然一指发布广告到达商业目的,须向悠然一指平台支付广告费用",@"每天30元/条,最少购买天数为7天",@"发布者缴纳的平台广告费直接从其消费账户中扣除,如果消费账户中余额不足,就需要发布者自行充值",@"缴纳平台费的第二个自然日算开始时间,到期后,需要再重新缴纳",@"平台费缴纳之后,费用是交给悠然一指平台,原则上是不允许退还的"];
    self.title = @"广告发布规则";
    _titles = titles;
    _subtitles = subtitles;
    [self configUI];
}
- (void)configUI{
    UITableView *tabel = [[UITableView alloc]initWithFrame:CGRectMake(0,0, SCREEN_WIDTH, SCREEN_HEIGHT-190) style:UITableViewStyleGrouped];
    [tabel registerNib:[UINib nibWithNibName:@"YRAdsRulesTableViewCell" bundle:nil] forCellReuseIdentifier:@"cell"];
    tabel.delegate = self;
    tabel.dataSource = self;
    tabel.separatorStyle = UITableViewCellSeparatorStyleNone;
    tabel.estimatedRowHeight = 80;
    
    [self.view addSubview:tabel];
    
    UIButton *next = [UIButton buttonWithType:UIButtonTypeSystem];
    next.tag = 111;
    [next setTitle:@"下一步" forState:UIControlStateNormal];
    [next setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self.view addSubview:next];
    [next mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(tabel.mas_bottom).mas_offset(15);
        make.centerX.equalTo(self.view);
        make.size.mas_equalTo(CJSizeMake(SCREEN_WIDTH - 100, 40));
    }];
    next.layer.cornerRadius = 20;
    next.clipsToBounds = YES;
    next.backgroundColor = RGB_COLOR(43, 193, 183);
    
    UIButton *isYes = [UIButton buttonWithType:UIButtonTypeCustom];
    //    isYes.backgroundColor = [UIColor redColor];
    [isYes setBackgroundImage:[UIImage imageNamed:@"yr_yesBtn_nor"] forState:UIControlStateSelected];
    [isYes setBackgroundImage:[UIImage imageNamed:@"yr_yesBtn_sel"] forState:UIControlStateNormal];
    
    isYes.tag = 222;
    UILabel *label = [[UILabel alloc]init];
    label.text = @"我已阅读并同意";
    label.font = [UIFont systemFontOfSize:14];
    label.textColor = RGB_COLOR(187, 187, 187);
    UIButton *guize = [UIButton buttonWithType:UIButtonTypeSystem];
    [guize setTitle:@"《悠然一指广告发布规则》" forState:UIControlStateNormal];
    [guize setTitleColor:RGB_COLOR(70, 207, 199) forState:UIControlStateNormal];
    guize.tag = 333;
    [self.view addSubview:isYes];
    [self.view addSubview:label];
    [self.view addSubview:guize];
    
    [isYes mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(next.mas_bottom).mas_offset(5);
        make.left.equalTo(self.view.mas_left).mas_offset(15);
        make.size.mas_equalTo(CGSizeMake(20, 20));
    }];
    
    [label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(isYes);
        make.left.equalTo(isYes.mas_right).mas_offset(5);
        make.size.mas_equalTo(CGSizeMake(100, 20));
    }];
    
    
    [guize mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(isYes);
        make.left.equalTo(label.mas_right).mas_offset(5);
        make.size.mas_equalTo(CGSizeMake(180, 20));
    }];
    
    [next addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
    [isYes addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
    [guize addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
}
- (void)btnClick:(UIButton *)sender{
    if (sender.tag == 111) {
        YRRealseAdsViewController *realseVc = [[YRRealseAdsViewController alloc] init];
        realseVc.isPhone = YES;
        [self.navigationController pushViewController:realseVc animated:YES];
    }else if (sender.tag==222) {
        sender.selected = !sender.selected;
    }else if(sender.tag==333){
        DLog(@"点击了规则按钮");
    }

}



- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return 1;
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 5;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if (section==0) {
        return 0.1;
    }else{
        return 10;
    }
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    //    if (section==4) {
    //        return 5;
    //    }
    return 0.01;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    YRAdsRulesTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    cell.title.text = self.titles[indexPath.section];
    cell.subtitle.text = self.subtitles[indexPath.section];
    cell.back.backgroundColor = RGB_COLOR(4, 181, 170);
    cell.subtitle.numberOfLines = 0;
    [cell.subtitle sizeToFit];
    cell.title.font = [UIFont boldSystemFontOfSize:17];
    if (indexPath.section==1) {
        NSMutableAttributedString *str = [[NSMutableAttributedString alloc]initWithString:@"每天" attributes:nil];
        NSMutableAttributedString *str2 = [[NSMutableAttributedString alloc]initWithString:@"30" attributes:@{NSForegroundColorAttributeName:[UIColor redColor]}];
        [str appendAttributedString:str2];
        
        NSMutableAttributedString *str3 = [[NSMutableAttributedString alloc]initWithString:@"元/条,最少购买天数为"attributes:@{NSForegroundColorAttributeName:[UIColor blackColor]}];
        [str appendAttributedString:str3];
        
        NSMutableAttributedString *str4 = [[NSMutableAttributedString alloc]initWithString:@"7" attributes:@{NSForegroundColorAttributeName:[UIColor redColor]}];
        
        [str appendAttributedString:str4];
        
        NSMutableAttributedString *str5 = [[NSMutableAttributedString alloc]initWithString:@"天"attributes:@{NSForegroundColorAttributeName:[UIColor blackColor]}];
        
        [str appendAttributedString:str5];
        
        cell.subtitle.attributedText = str;
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
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
}




@end
