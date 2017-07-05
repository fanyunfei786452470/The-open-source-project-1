//
//  YRAccountController.m
//  YRYZ
//
//  Created by 易超 on 16/7/20.
//  Copyright © 2016年 yryz. All rights reserved.
//

#import "YRAccountController.h"
#import "YRAccountCell.h"
#import "YRBuyAccountController.h"
#import "YRRedBagController.h"
#import "YRRedPaperRecordViewController.h"
#import "YRRewardIntegralViewController.h"

//#import "YRAccountModel.h"
static NSString *cellID = @"YRAccountControllerID";


@interface YRAccountController ()<UITableViewDelegate,UITableViewDataSource>

@property (strong, nonatomic) UITableView       *tableView;
@property (strong, nonatomic) NSArray           *titles;
@property (strong, nonatomic) NSArray           *images;

@property (nonatomic,strong) YRAccountModel     *accountModel;


@end

@implementation YRAccountController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setTitle:@"我的账户"];
    [self setupTableView];
//    [self loadData];
}
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self loadData];
}
- (void)loadData{
    
    [YRHttpRequest AccountBalanceQuerySuccess:^(NSDictionary *data) {
        self.accountModel = [YRAccountModel mj_objectWithKeyValues:data];
        

        
    } failure:^(NSString *error) {
        [MBProgressHUD showError:error];
    }];
    
}

-(void)setupTableView{
    self.titles = @[@"消费账户",@"奖励积分",@"红包记录"];
    self.images = @[@"yr_buyAccount",@"yr_integral",@"yr_redBagList"];
    self.tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT) style:UITableViewStyleGrouped];
    self.tableView.backgroundColor = RGB_COLOR(245, 245, 245);
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.contentInset = UIEdgeInsetsMake(0, 0, 64, 0);
    [self.view addSubview:self.tableView];
    
}

#pragma mark - UITableViewDelegate & UITableViewDataSource
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 3;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    YRAccountCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    if (!cell) {
        cell = [[YRAccountCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
        cell.imageView.image = [UIImage imageNamed:self.images[indexPath.row]];
        cell.textLabel.text = self.titles[indexPath.row];
    }
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 45;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 10;
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 0.1;
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UIView *headView = [[UIView alloc]init];
    headView.backgroundColor = RGB_COLOR(245, 245, 245);
    return headView;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if (indexPath.row == 0) {
        YRBuyAccountController *buyAccountVC = [[YRBuyAccountController alloc]init];
         [self.navigationController pushViewController:buyAccountVC animated:YES];
    }else if (indexPath.row == 1){
        YRRewardIntegralViewController *rewardVc = [[YRRewardIntegralViewController alloc] init];
        [self.navigationController pushViewController:rewardVc animated:YES];
    }else if (indexPath.row == 2){
        YRRedBagController *rebBagVC = [[YRRedBagController alloc]init];
        rebBagVC.accountModel = self.accountModel;
        [self.navigationController pushViewController:rebBagVC animated:YES];
    }
}


@end
