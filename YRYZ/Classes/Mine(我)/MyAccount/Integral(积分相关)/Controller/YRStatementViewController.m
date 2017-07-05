//
//  YRStatementViewController.m
//  YRYZ
//
//  Created by weishibo on 16/8/9.
//  Copyright © 2016年 yryz. All rights reserved.
//

#import "YRStatementViewController.h"
#import "YRStatementTableViewCell.h"
#import "YRPointsChangeController.h"
#import "YRStatementModel.h"

@interface YRStatementViewController ()<UITableViewDelegate,UITableViewDataSource>



@property (nonatomic,assign) BOOL isRed;


@property (nonatomic,strong) NSMutableArray *array;

@property (nonatomic,strong) NSArray *ary;
@property (nonatomic,assign) NSInteger start;

@property (nonatomic,strong) UITableView *tableView;

@end

@implementation YRStatementViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    if (self.isPrize) {
        self.title = @"积分明细";
        _ary = @[@"日转发奖励",@"作品奖励",@"兑换积分",@"收到礼物",@"关联至银行卡"];
    }
    else{
         [self setTitle:@"消费明细"];
           _ary = @[@"充值",@"积分兑换",@"转发",@"阅读",@"赠送礼物",@"发红包",@"收到红包"];
    }
//    [self loadData];
    [self configUI];
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    [btn setImage:[UIImage imageNamed:@"yr_msg_search"] forState:UIControlStateNormal];
    btn.frame = CGRectMake(0, 0, 40, 40);
}
- (void)loadData{
    
    NSString *start = [NSString stringWithFormat:@"%ld",self.start];
    NSString *limt = [NSString stringWithFormat:@"%d",kListPageSize];
    if ([self.title isEqualToString:@"消费明细"]) {
        
        [YRHttpRequest AccountInformationByBillingDetails:@"1" start:start limit:limt success:^(NSDictionary *data) {
            
            NSArray *array =  [YRStatementModel mj_objectArrayWithKeyValuesArray:data];
            if (self.start == 0) {
                [self.array removeAllObjects];
            }
            [self.array addObjectsFromArray:array];
            if ([array count] < kListPageSize) {
                self.start -= kListPageSize;
                [self.tableView.footer endRefreshingWithNoMoreData];
            }else{
                [self.tableView.footer endRefreshing];
            }
            [self.tableView reloadData];
            [self.tableView.header endRefreshing];
        } failure:^(NSString *error) {
            
        }];
    }else{
        [YRHttpRequest AccountInformationByBillingDetails:@"2" start:start limit:limt success:^(NSDictionary *data) {
//            DLog(@"%@",data);
            NSArray *array =  [YRStatementModel mj_objectArrayWithKeyValuesArray:data];
            if (self.start == 0) {
                [self.array removeAllObjects];
            }
            [self.array addObjectsFromArray:array];
            if ([array count] < kListPageSize) {
                self.start -= kListPageSize;
                [self.tableView.footer endRefreshingWithNoMoreData];
            }else{
                [self.tableView.footer endRefreshing];
            }
            [self.tableView reloadData];
            [self.tableView.header endRefreshing];
        } failure:^(NSString *error) {
            
        }];
        
    }
}

-(void)rightNavAction:(UIButton *)button{
    if ([self.title isEqualToString:@"积分明细"]) {
        YRPointsChangeController *change = [[YRPointsChangeController alloc]init];
        [self.navigationController pushViewController:change animated:YES];
    }
}

- (void)configUI{
    
    UITableView *tabel = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT-30) style:UITableViewStylePlain];
    [tabel registerNib:[UINib nibWithNibName:@"YRStatementTableViewCell" bundle:nil] forCellReuseIdentifier:@"cell"];
    tabel.delegate = self;
    tabel.dataSource = self;
    tabel.separatorStyle = UITableViewCellSeparatorStyleNone;
    tabel.separatorColor = [UIColor redColor];
    [self.view addSubview:tabel];
    UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 30)];
    tabel.backgroundColor = [UIColor whiteColor];
    
    UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(5, 0, 100, 30)];
    label.textColor =RGB_COLOR(153, 153, 153);
    label.font = [UIFont systemFontOfSize:15];
    label.text = @"名称";
    [view addSubview:label];
    
    UILabel *textL = [[UILabel alloc]initWithFrame:CGRectMake(100, 0, 70, 30)];
      textL.textColor =RGB_COLOR(153, 153, 153);
    textL.font = [UIFont systemFontOfSize:15];
    textL.text = @"收支";
    textL.textAlignment = NSTextAlignmentRight;
    
    UILabel *time = [[UILabel alloc]initWithFrame:CGRectMake(200, 0, SCREEN_WIDTH-205, 30)];
      time.textColor =RGB_COLOR(153, 153, 153);
    time.font = [UIFont systemFontOfSize:15];
    time.text = @"时间";
    time.textAlignment = NSTextAlignmentRight;
    
    [view addSubview:textL];
    [view addSubview:time];
    view.backgroundColor = RGB_COLOR(245,245, 245);
    tabel.tableHeaderView = view;
    self.tableView = tabel;
    [self.tableView jk_addGifFooterWithRefreshingTarget:self refreshingAction:@selector(footRefresh)];
    [self.tableView jk_addGifHeaderWithRefreshingTarget:self refreshingAction:@selector(headRefresh)];
    [self.tableView.header beginRefreshing];
}
- (void)headRefresh{
    self.start = 0;
    [self loadData];
}
- (void)footRefresh{
    self.start += kListPageSize;
    [self loadData];
}
//-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
//    
//    return 190;
//}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return self.array.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    YRStatementTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    YRStatementModel *model = self.array[indexPath.row];
    
    cell.title.text = model.productDesc;
    cell.title.textColor = RGB_COLOR(94, 94, 94);

    if ([model.orderType isEqualToString:@"0"]) {
        CGFloat money = [model.cost floatValue]*0.01;
        
        NSString *desc = [NSString stringWithFormat:@"-%.2f",money];
         cell.money.text = desc;
         cell.money.textColor = RGB_COLOR(47, 199, 199);
    }else{
        CGFloat money = [model.cost floatValue]*0.01;
       NSString *desc = [NSString stringWithFormat:@"+%.2f",money];
        cell.money.text = desc;
        cell.money.textColor = RGB_COLOR(253, 103, 105);
    }
    cell.money.textAlignment = NSTextAlignmentRight;
    NSMutableString *time = [[NSMutableString alloc]initWithString:[model.createTime substringToIndex:16]];
    [time insertString:@" " atIndex:10];
    cell.time.text = time;
    cell.time.textAlignment =NSTextAlignmentRight;
      cell.time.textColor = RGB_COLOR(94, 94, 94);
    return cell;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.

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
