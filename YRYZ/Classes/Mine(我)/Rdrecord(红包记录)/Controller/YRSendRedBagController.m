//
//  YRSendRedBagController.m
//  YRYZ
//
//  Created by 易超 on 16/7/21.
//  Copyright © 2016年 yryz. All rights reserved.
//

#import "YRSendRedBagController.h"
#import "YRRedBagTopView.h"
#import "YRRedBagCell.h"
#import "YRMineRedBagModel.h"

static NSString *cellID = @"YRSendRedBagController";
@interface YRSendRedBagController ()<UITableViewDelegate,UITableViewDataSource>

@property (strong, nonatomic) UITableView       *tableView;

@property (nonatomic,assign) NSInteger start;

@property (nonatomic,strong) NSMutableArray *dataArray;
/** 红包总数**/
@property (nonatomic,assign) NSInteger count;
/** 总金额 (单位 分)**/
@property (nonatomic,assign) CGFloat fee;

@property (nonatomic,weak) YRRedBagTopView *headerView;

@end

@implementation YRSendRedBagController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self loadData];
    [self setupTableView];
}

-(void)setupTableView{
    self.tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT - 108) style:UITableViewStylePlain];
//    self.tableView.backgroundColor = [UIColor whiteColor];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [self.tableView setExtraCellLineHidden];
    [self.view addSubview:self.tableView];
    
    [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass([YRRedBagCell class]) bundle:nil] forCellReuseIdentifier:cellID];
    
    YRRedBagTopView *headView = [[[NSBundle mainBundle] loadNibNamed:@"YRRedBagTopView" owner:nil options:nil] lastObject];
//    YRRedBagTopView *headView = [[YRRedBagTopView alloc] init];
    headView.frame = CGRectMake(0, 0, SCREEN_WIDTH, 185);
//    headView.maneyLabel.textColor = RGB_COLOR(43, 193, 183);
//    headView.yuan.textColor = RGB_COLOR(43, 193, 183);
//    headView.height = 195;
    self.headerView = headView;
    
    [self.tableView jk_addGifFooterWithRefreshingTarget:self refreshingAction:@selector(footRefresh)];
    [self.tableView jk_addGifHeaderWithRefreshingTarget:self refreshingAction:@selector(headRefresh)];
    
    self.tableView.tableHeaderView = headView;
}
- (void)headRefresh{
    self.start = 0;
    [self loadData];
}
- (void)footRefresh{
    self.start += kListPageSize;
    [self loadData];
}
- (void)headerViewSetData{
    if ([self.title isEqualToString:@"发出的红包"]) {
        self.headerView.title.text = @"发出的红包总金额";
        self.headerView.title.font = [UIFont titleFont16];
        
        
        self.headerView.money.text = [NSString stringWithFormat:@"%.2f",self.fee/100];
        //        headView.moneyNumber.text = @"共10个";
        
        NSMutableAttributedString *atrA = [[NSMutableAttributedString alloc]initWithString:@"共" attributes:nil];
        NSAttributedString *artB = [[NSAttributedString alloc]initWithString:[NSString stringWithFormat:@"%ld",self.count] attributes:@{NSForegroundColorAttributeName:[UIColor redColor]}];
        [atrA appendAttributedString:artB];
        NSAttributedString *artC = [[NSAttributedString alloc]initWithString:@"个" attributes:@{NSForegroundColorAttributeName:RGB_COLOR(175, 175, 175)}];
        [atrA appendAttributedString:artC];
        self.headerView.moneyNumber.attributedText = atrA;
        self.headerView.moneyNumber.font = [UIFont titleFont15];
        
    }else{
        self.headerView.title.text = @"收到的红包总金额";
        self.headerView.money.text = [NSString stringWithFormat:@"%.2f",self.fee/100];
        NSMutableAttributedString *atrA = [[NSMutableAttributedString alloc]initWithString:@"共" attributes:nil];
        NSAttributedString *artB = [[NSAttributedString alloc]initWithString:[NSString stringWithFormat:@"%ld",self.count] attributes:@{NSForegroundColorAttributeName:[UIColor redColor]}];
        [atrA appendAttributedString:artB];
        NSAttributedString *artC = [[NSAttributedString alloc]initWithString:@"个" attributes:@{NSForegroundColorAttributeName:RGB_COLOR(175, 175, 175)}];
        [atrA appendAttributedString:artC];
        self.headerView.moneyNumber.attributedText = atrA;
        self.headerView.moneyNumber.font = [UIFont titleFont15];
    }
    
}
- (void)loadData{
    if ([self.title isEqualToString:@"收到的红包"]) {
         [YRHttpRequest sendRedList:1 start:(NSInteger)self.start  limit:(NSInteger)kListPageSize  success:^(id data) {
             self.count = [data[@"count"] integerValue];
             self.fee = [data[@"fee"] floatValue];
             [self headerViewSetData];
             NSArray  *array =  [YRMineRedBagModel mj_objectArrayWithKeyValuesArray:data[@"rlist"]];
             if (self.start == 0) {
                 [self.dataArray removeAllObjects];
                 
             }
             [self.dataArray addObjectsFromArray:array];
             
             if ([array count] < kListPageSize) {
                 self.start -= kListPageSize;
                 [self.tableView.footer endRefreshingWithNoMoreData];
             }else{
                 [self.tableView.footer endRefreshing];
             }
             
             [self.tableView reloadData];
             [self.tableView.header endRefreshing];
         } failure:^(id data) {
             [MBProgressHUD showError:data];
             
         }];
    }else{
        [YRHttpRequest sendRedList:0 start:(NSInteger)self.start  limit:(NSInteger)kListPageSize  success:^(id data) {
            self.count = [data[@"count"] integerValue];
            self.fee = [data[@"fee"] floatValue];
            [self headerViewSetData];
            NSArray  *array =  [YRMineRedBagModel mj_objectArrayWithKeyValuesArray:data[@"rdlist"]];
            if (self.start == 0) {
                [self.dataArray removeAllObjects];
            }
            [self.dataArray addObjectsFromArray:array];
            if ([array count] < kListPageSize) {
                self.start -= kListPageSize;
                [self.tableView.footer endRefreshingWithNoMoreData];
            }else{
                [self.tableView.footer endRefreshing];
            }
            
            [self.tableView reloadData];
            [self.tableView.header endRefreshing];
            
        } failure:^(id data) {
            
        }];
        
    }
}

#pragma mark - UITableViewDelegate & UITableViewDataSource
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return self.dataArray.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    YRRedBagCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    YRMineRedBagModel *model = self.dataArray[indexPath.row];
    
    if ([self.title isEqualToString:@"发出的红包"]) {
         [self setUIWithReceivedRedBagCell:cell indexPath:indexPath model:model];

    }
    else{
//        cell.nameLabel.text = @"拼手气红包";
//        cell.nameLabel.font = [UIFont systemFontOfSize:16];
//        cell.typeLabel.text = @"06-21";
//        cell.timeLabel.text = @"已领取0/1个";
        [self setUIWithSendRedBagCell:cell indexPath:indexPath model:model];
        
    }
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 60;
}

//-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
//    YRRedBagTopView *headView = [[YRRedBagTopView alloc]init];
//    return headView;
//}
//
//-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
//    return 185;
//}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}
- (void)setUIWithSendRedBagCell:(YRRedBagCell *)cell indexPath:(NSIndexPath *)indexPath model:(YRMineRedBagModel *)model{
    cell.nameLabel.text = model.remark.length>0?model.remark:model.nickName;
    cell.nameLabel.font = [UIFont titleFont17];
    
    cell.typeLabel.text = model.type;
    cell.typeLabel.font = [UIFont titleFont14];
    
    cell.moneyLabel.text = [NSString stringWithFormat:@"%.2f",model.fee/100];
    cell.moneyLabel.font = [UIFont titleFont17];
    
    cell.timeLabel.text = [NSString getStringWithTimestamp:[model.rctime integerValue] formatter:@"MM-dd"];
    cell.timeLabel.font = [UIFont titleFont14];
}

- (void)setUIWithReceivedRedBagCell:(YRRedBagCell *)cell indexPath:(NSIndexPath *)indexPath model:(YRMineRedBagModel *)model{
    cell.nameLabel.text = model.type;
    cell.nameLabel.font = [UIFont titleFont17];
    
    cell.typeLabel.text = [NSString getStringWithTimestamp:model.time formatter:@"MM-dd"];
    cell.typeLabel.font = [UIFont titleFont14];
    
    
    cell.moneyLabel.text = [NSString stringWithFormat:@"%.2f",model.fee/100.0];
    cell.moneyLabel.font = [UIFont titleFont17];
    
    
    if ([model.status isEqualToString:@"过期"]) {
        cell.timeLabel.text = [NSString stringWithFormat:@"已过期 领取%ld/%ld个",model.over,model.count];
    }else{
        cell.timeLabel.text = [NSString stringWithFormat:@"已领取%ld/%ld个",model.over,model.count];
    }
    cell.timeLabel.font = [UIFont titleFont14];
}
- (NSMutableArray *)dataArray
{
    if (!_dataArray) {
        _dataArray = [[NSMutableArray alloc]init];
    }
    return _dataArray;
}

@end
