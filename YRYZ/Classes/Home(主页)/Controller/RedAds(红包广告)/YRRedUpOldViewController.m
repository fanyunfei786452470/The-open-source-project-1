//
//  YRRedUpOldViewController.m
//  YRYZ
//
//  Created by Sean on 16/8/11.
//  Copyright © 2016年 yryz. All rights reserved.
//

#import "YRRedUpOldViewController.h"
#import "YRUpOldTableViewCell.h"

@interface YRRedUpOldViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic,assign) BOOL oldOrNew;

@property (nonatomic,strong) NSMutableArray *array;
@end

@implementation YRRedUpOldViewController

- (instancetype)initWithOldOrNew:(BOOL)OldOrNew
{
    self = [super init];
    if (self) {
        _oldOrNew = OldOrNew;
    }
    return self;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    [self configUI];
}

- (void)configUI{
    
    UITableView *tabel = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT-210*SCREEN_POINT-44) style:UITableViewStyleGrouped];
    [tabel registerNib:[UINib nibWithNibName:@"YRUpOldTableViewCell" bundle:nil] forCellReuseIdentifier:@"mycell"];
    tabel.delegate = self;
    tabel.dataSource = self;
    tabel.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:tabel];
    
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return 140;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return 1;
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 5;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 10;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 0.01;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    YRUpOldTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"mycell"];

    
    
    cell.myImage.image = [UIImage imageNamed:@"cLINSHI"];
    
    cell.titles.text = @"周五,中国将在人们对中国经济放缓和中国金融体系健康状态的担忧之中体系健康状态不";
    cell.time.text = @"上线时间: 2016-06-24 17:20";

    NSMutableAttributedString *overStr1 = [[NSMutableAttributedString alloc]initWithString:@"有效期:" attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:13],NSForegroundColorAttributeName:RGB_COLOR(15, 15, 15)}];
       NSMutableAttributedString *overStr2 = [[NSMutableAttributedString alloc]initWithString:@"2016-07-28" attributes:@{NSForegroundColorAttributeName:RGB_COLOR(104, 209, 203),NSFontAttributeName:[UIFont systemFontOfSize:13]}];
    
    [overStr1 appendAttributedString:overStr2];
     cell.overTime.attributedText = overStr1;
    
 
    if (self.oldOrNew) {
        cell.redNum.text = @"红包个数: 70/100";
        cell.redNum.textColor = RGB_COLOR(104, 209, 203);
    }else{
        NSMutableAttributedString *str = [[NSMutableAttributedString alloc]initWithString:@"红包被领取" attributes:nil];
        
        NSMutableAttributedString *str2 = [[NSMutableAttributedString alloc]initWithString:@"70/100" attributes:@{NSForegroundColorAttributeName:RGB_COLOR(104, 209, 203),NSFontAttributeName:[UIFont boldSystemFontOfSize:15]}];
        [str appendAttributedString:str2];
        cell.redNum.attributedText = str;
        
    }
    [cell.seeNum setTitle:@"  800" forState:UIControlStateNormal];

    
    return cell;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
