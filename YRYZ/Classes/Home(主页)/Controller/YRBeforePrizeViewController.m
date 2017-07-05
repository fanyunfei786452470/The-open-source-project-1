//
//  YRBeforePrizeViewController.m
//  YRYZ
//
//  Created by Sean on 16/8/10.
//  Copyright © 2016年 yryz. All rights reserved.
//

#import "YRBeforePrizeViewController.h"
#import "YRBeforePrizeTableViewCell.h"


@interface YRBeforePrizeViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic,strong)NSMutableArray *array;

@property (nonatomic,strong) UITableView *tabel ;
@end

@implementation YRBeforePrizeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
//    [self initNavigationBarWithTitle:@"第128期"];
    self.title = @"往期开奖";
    [self loadData];
    [self configUI];
    
}
- (void)loadData{
    
   /* NSDictionary *dic = @{@"whatNum":@"188期",@"time":@"开奖日期：2016-7-12 10:40:40",@"firstKey":@"SG1234566DGS47W50",@"firstName":@"刘雨薇百公里元",@"secondOneKey":@"SG1234566DGS47W50",@"secondOneName":@"似懂非懂",@"secondTwoKey":@"SG1234566DGS47W50",@"secondTwoName":@"angelababy"};
    
    for (int i = 0; i<3; i++) {
        YRBeforePrizeModel *model = [[YRBeforePrizeModel alloc]init];
        [model setValuesForKeysWithDictionary:dic];
        [self.array addObject:model];
    }*/

    [YRHttpRequest getPastTheLotteryInformationBypageNow:@"0" pageSize:@"10" success:^(NSDictionary *data) {
        
        for (NSDictionary *dic in data) {
            YRBeforeArray *model = [[YRBeforeArray alloc]mj_setKeyValues:dic];
            [self.array addObject:model];
  
        }
        [self.tabel reloadData];
        
        
        
    } failure:^(NSString *eCorrorInfo) {
        
        
        
    }];
    
    
    
    
}
- (void)configUI{
    
    UITableView *tabel = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT-10) style:UITableViewStyleGrouped];
    [tabel registerNib:[UINib nibWithNibName:@"YRBeforePrizeTableViewCell" bundle:nil] forCellReuseIdentifier:@"cell"];
    tabel.delegate = self;
    tabel.dataSource = self;
    tabel.separatorStyle = UITableViewCellSeparatorStyleNone;
    _tabel = tabel;
    [self.view addSubview:tabel];
    
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return 200;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return self.array.count;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 1;
}

//- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
//    return 5;
//}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    YRBeforePrizeTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
   // YRBeforePrizeModel *model = self.array[indexPath.row];
//    cell.whatNum.text = model.whatNum;
    
//    [cell.whatNum setTitle:model.whatNum forState:UIControlStateNormal];
//    cell.time.text = model.time;
    if (self.array.count>0) {
         [cell setUIWithModel:self.array[indexPath.row]];
    }
    return cell;
}






- (NSMutableArray *)array
{
    if (!_array) {
        _array = [[NSMutableArray alloc]init];
    }
    return _array;
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
