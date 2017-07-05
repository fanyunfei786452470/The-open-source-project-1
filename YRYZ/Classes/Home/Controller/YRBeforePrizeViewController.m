//
//  YRBeforePrizeViewController.m
//  YRYZ
//
//  Created by Sean on 16/8/10.
//  Copyright © 2016年 yryz. All rights reserved.
//

#import "YRBeforePrizeViewController.h"
#import "YRBeforePrizeTableViewCell.h"
#import "YRAdListUserInfoController.h"

@interface YRBeforePrizeViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic,strong)NSMutableArray *array;

@property (nonatomic,strong) UITableView *tabel ;

@property (nonatomic,assign) NSInteger start;
@end

@implementation YRBeforePrizeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
//    [self initNavigationBarWithTitle:@"第128期"];
    self.title = @"往期开奖";
//    [self loadData];
    [self configUI];
    
}
- (void)loadData{

   [YRHttpRequest getPastTheLotteryInformationByStart:self.start limit:kListPageSize success:^(NSDictionary *data) {
       
       
       NSMutableArray *array = [[NSMutableArray alloc]init];
       for (NSDictionary *dic in data) {
           YRBeforeArray *model = [[YRBeforeArray alloc]mj_setKeyValues:dic];
           [array addObject:model];
       }
       if (self.start == 0) {
           [self.array removeAllObjects];
       }
       [self.array addObjectsFromArray:array];
       if ([array count] < kListPageSize) {
           self.start -= kListPageSize;
           [self.tabel.footer endRefreshingWithNoMoreData];
       }else{
           [self.tabel.footer endRefreshing];
       }
       
       [self.tabel reloadData];
       [self.tabel.header endRefreshing];
   } failure:^(NSString *eCorrorInfo) {
       
       
   }];
 
}
- (void)headRefresh{
    self.start = 0;
    [self loadData];
}
- (void)footRefresh{
    self.start += kListPageSize;
    [self loadData];
}
- (void)configUI{
    
    UITableView *tabel = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT-10) style:UITableViewStyleGrouped];
    [tabel registerNib:[UINib nibWithNibName:@"YRBeforePrizeTableViewCell" bundle:nil] forCellReuseIdentifier:@"cell"];
    tabel.delegate = self;
    tabel.dataSource = self;
    tabel.separatorStyle = UITableViewCellSeparatorStyleNone;
    _tabel = tabel;
    [self.tabel jk_addGifFooterWithRefreshingTarget:self refreshingAction:@selector(footRefresh)];
    [self.tabel jk_addGifHeaderWithRefreshingTarget:self refreshingAction:@selector(headRefresh)];
    [self.tabel.header beginRefreshing];
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
        YRBeforeArray *model = self.array[indexPath.row];
        @weakify(self);
         [cell setUIWithModel:model];
        cell.chooseName = ^(NSString *custId){
            @strongify(self);
            YRAdListUserInfoController *userInfo = [[YRAdListUserInfoController alloc]init];
            userInfo.custId = custId;
            [self.navigationController pushViewController:userInfo animated:YES];
        };
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
