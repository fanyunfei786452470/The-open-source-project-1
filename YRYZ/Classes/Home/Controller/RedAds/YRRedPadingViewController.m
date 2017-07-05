//
//  YRRedPadingViewController.m
//  YRYZ
//
//  Created by Sean on 16/8/11.
//  Copyright © 2016年 yryz. All rights reserved.
//

#import "YRRedPadingViewController.h"
#import "YRRedPackingTableViewCell.h"

#import "YRRedAdsModel.h"
@interface YRRedPadingViewController ()<UITableViewDelegate,UITableViewDataSource>
//padOrPass YES为审核中界面 NO为未通过界面
@property (nonatomic,assign) BOOL padOrPass;
//state==0 退款中  state==1 退款完成 state==2 显示两个按钮 红包退款和修改按钮
@property (nonatomic,assign) NSInteger state;

@property (nonatomic,strong) UITableView *tableView;

@property (nonatomic,assign) NSInteger start;

@property (nonatomic,strong) NSMutableArray *dataArray;
@end

@implementation YRRedPadingViewController
- (instancetype)initWithPadOrPass:(BOOL)padOrPass
{
    self = [super init];
    if (self) {
        _padOrPass = padOrPass;
    }
    return self;
}

- (void)viewDidLoad {
    //    self.state = 2;
    [super viewDidLoad];
    self.view.backgroundColor = RGB_COLOR(245, 245, 245);
    [self configUI];
}

- (void)configUI{
    
    self.tableView  = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT-210-44) style:UITableViewStyleGrouped];
    self.tableView .backgroundColor = RGB_COLOR(245, 245, 245);
    [self.tableView  registerNib:[UINib nibWithNibName:@"YRRedPackingTableViewCell" bundle:nil] forCellReuseIdentifier:@"mycell"];
    self.tableView .delegate = self;
    self.tableView .dataSource = self;
    self.tableView .separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.tableView setExtraCellLineHidden];
    [self.tableView jk_addGifFooterWithRefreshingTarget:self refreshingAction:@selector(footRefresh)];
    [self.tableView jk_addGifHeaderWithRefreshingTarget:self refreshingAction:@selector(headRefresh)];
     [self.tableView.header beginRefreshing];
    [self.view addSubview:self.tableView ];
    
}
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
}
- (void)headRefresh{
    self.start = 0;
    [self loadData];
}
- (void)footRefresh{
    self.start += kListPageSize;
    [self loadData];
}
- (void)loadData{
    @weakify(self);
    NSString *type = self.padOrPass?@"1":@"2";
    [YRHttpRequest getMineRedPadingListToadsType:type start:self.start limit:kListPageSize success:^(NSDictionary *data) {
        @strongify(self);
        
        NSArray  *array =  [YRRedAdsModel mj_objectArrayWithKeyValuesArray:data[@"details"]];
        
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
        
        
    } failure:^(NSString *error) {
        [self.tableView.header endRefreshing];
        [MBProgressHUD showError:error];
    }];
    
    
}


-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return 140;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return 1;
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return self.dataArray.count;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 10;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 0.01;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    YRRedPackingTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"mycell"];
    //    cell.myImage.image = [UIImage imageNamed:@"cLINSHI"];
    //
    //    cell.titles.text = @"周五,中国将在人们对中国经济放缓和中国金融体系健康状态的担忧之中体系健康状态不";
    //    cell.time.text =@" 审核时间: 2016-07-28 17:20";
    YRRedAdsModel *model = self.dataArray[indexPath.section];
    if (self.padOrPass) {
        
        [cell.myImage setImageWithURL:[NSURL URLWithString:model.smallPic] placeholder:[UIImage imageNamed:@"yr_pic_default"]];
        cell.adsNumber.text = [NSString stringWithFormat:@"广告编号: %@",model.code];
        cell.adsNumber.textColor = RGB_COLOR(102, 102, 102);
        cell.adsNumber.font = [UIFont titleFont15];
        
        cell.time.text = [NSString stringWithFormat:@"提交时间: %@",[NSString getDateStringWithTimestamp:model.submitTime]];
        cell.time.font = [UIFont titleFont15];
        cell.time.textColor = RGB_COLOR(102, 102, 102);
        cell.titles.text = model.title;
        cell.titles.text = model.title;
        cell.titles.font = [UIFont titleFont17];
        cell.titles.textColor = RGB_COLOR(51, 51, 51);
        
        cell.isBacking.backgroundColor = [UIColor clearColor];
        cell.redBack.backgroundColor = [UIColor clearColor];
        [cell.redBack setTitle:@"   购买了:" forState:UIControlStateNormal];
        [cell.redBack setTitleColor:RGB_COLOR(102, 102, 102) forState:UIControlStateNormal];
        cell.redBack.titleEdgeInsets = UIEdgeInsetsMake(0, 15, 0, 0);
        [cell.isBacking setTitle:[NSString stringWithFormat:@"%@天",model.payDays] forState:UIControlStateNormal];
        cell.isBacking.titleLabel.font = [UIFont titleFont15];
        [cell.isBacking setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [cell.isBacking setTitleColor:[UIColor themeColor] forState:UIControlStateNormal];
    }else{
        //        if (_state==0||_state==1) {
        //            cell.redBack.hidden = YES;
        //            cell.isBacking.backgroundColor = [UIColor clearColor];
        //            if (_state==0) {
        //                     [cell.isBacking setTitle:@"退款中" forState:UIControlStateNormal];
        //            }else{
        //                [cell.isBacking setTitle:@"退款完成" forState:UIControlStateNormal];
        //
        //            }
        //        }else{
        //            cell.redBack.hidden = NO;
        //            cell.redBack.backgroundColor = RGB_COLOR(246, 246, 246);
        //            [cell.redBack setTitle:@"红包退款" forState:UIControlStateNormal];
        //            [cell.redBack setTitleColor:RGB_COLOR(43, 193, 183) forState:UIControlStateNormal];
        //
        //            cell.isBacking.backgroundColor = RGB_COLOR(43, 193, 183);
        //            [cell.isBacking setTitle:@"修改" forState:UIControlStateNormal];
        //             [cell.isBacking setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        //        }
        
        
        [self setUIPadWithIndexPath:indexPath cell:cell model:model];
        
    }
    
    return cell;
}
- (void)setUIPadWithIndexPath:(NSIndexPath *)indexPath cell:(YRRedPackingTableViewCell *)cell model:(YRRedAdsModel *)model{
    [cell.myImage setImageWithURL:[NSURL URLWithString:model.smallPic] placeholder:[UIImage imageNamed:@"yr_pic_default"]];
    cell.adsNumber.text = [NSString stringWithFormat:@"广告编号: %@",model.code];
    cell.adsNumber.textColor = RGB_COLOR(102, 102, 102);
    cell.adsNumber.font = [UIFont titleFont15];
    cell.time.text = [NSString stringWithFormat:@"审核时间: %@",[NSString getDateStringWithTimestamp:model.auditTime]];
    cell.time.font = [UIFont titleFont15];
    cell.time.textColor = RGB_COLOR(102, 102, 102);
    cell.titles.text = model.title;
    cell.titles.font = [UIFont titleFont17];
    cell.titles.textColor = RGB_COLOR(51, 51, 51);
    cell.redBack.hidden = YES;
    
    
    if ([model.advertStatus integerValue]==5) {
        cell.isBacking.backgroundColor = [UIColor clearColor];
        [cell.isBacking setTitleColor:[UIColor themeColor] forState:UIControlStateNormal];
        [cell.isBacking setTitle:@"退款完成" forState:UIControlStateNormal];
//        cell.isBacking.titleLabel.font = [UIFont titleFont17];
    }else if ([model.advertStatus integerValue]==0||[model.advertStatus integerValue]==4){
        [cell.isBacking setTitle:@"放弃并退款" forState:UIControlStateNormal];
        cell.isBacking.backgroundColor = RGB_COLOR(245, 245, 245);
        [cell.isBacking setTitleColor:[UIColor themeColor] forState:UIControlStateNormal];
//        cell.isBacking.titleLabel.font = [UIFont titleFont17];
        cell.backMoney = ^(BOOL isBack){
            [self backMoneyWithIndexPath:indexPath model:model];
        };
        cell.isBacking.bounds = CGRectMake(0, 0, 110, 25);
    }
    else{
        cell.isBacking.backgroundColor = [UIColor clearColor];
        [cell.isBacking setTitleColor:[UIColor themeColor] forState:UIControlStateNormal];
        [cell.isBacking setTitle:@" " forState:UIControlStateNormal];
      }
    
    
    /*  else{
     cell.redBack.hidden = NO;
     cell.redBack.backgroundColor = RGB_COLOR(245, 245, 245);
     [cell.redBack setTitleColor:[UIColor themeColor] forState:UIControlStateNormal];
     [cell.redBack setTitle:@"放弃并退款" forState:UIControlStateNormal];
     //退款
     cell.backMoney = ^(BOOL isBack){
     [self backMoneyWithIndexPath:indexPath model:model];
     };
     cell.isBacking.backgroundColor = [UIColor themeColor];
     cell.change = ^(BOOL isChange){
     [self changeWithIndexPath:indexPath model:model];
     };
     [cell.isBacking setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
     [cell.isBacking setTitle:@"修改" forState:UIControlStateNormal];
     
     }*/
    
    
}
//退款
- (void)backMoneyWithIndexPath:(NSIndexPath *)indexPath model:(YRRedAdsModel *)model{
    YRAlertView *alertView = [[YRAlertView alloc] initWithTitle:@"是否确认退款" cancelButtonText:@"取消" confirmButtonText:@"确认"];
    alertView.addConfirmAction = ^(){
        [YRHttpRequest backMoneyForAdsId:model.adsId success:^(NSDictionary *data) {
            [MBProgressHUD showSuccess:@"退款成功"];
            model.advertStatus = @"5";
            [self.tableView reloadData];
        } failure:^(NSString *error) {
            [MBProgressHUD showSuccess:error];
        }];
    };
    [alertView show];
    
}
//修改
- (void)changeWithIndexPath:(NSIndexPath *)indexPath model:(YRRedAdsModel *)model{
    
    
    
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}




- (NSMutableArray *)dataArray
{
    if (!_dataArray) {
        _dataArray = [[NSMutableArray alloc]init];
    }
    return _dataArray;
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
