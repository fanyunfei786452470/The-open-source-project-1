//
//  YRRedUpOldViewController.m
//  YRYZ
//
//  Created by Sean on 16/8/11.
//  Copyright © 2016年 yryz. All rights reserved.
//

#import "YRRedUpOldViewController.h"
#import "YRUpOldTableViewCell.h"
#import "YRRedAdsModel.h"
#import "YRDataPickerView.h"

#import "HcdDateTimePickerView.h"
#import "YRRedPaperAdPaymemtViewController.h"
#import "YRMyRedPackViewController.h"
#import "YRRedPackDetailViewController.h"
@interface YRRedUpOldViewController ()<UITableViewDelegate,UITableViewDataSource>
/**OldOrNew YES为通过界面 NO为过期界面 **/
@property (nonatomic,assign) BOOL oldOrNew;

@property (nonatomic,strong) NSMutableArray *array;

@property (nonatomic,strong) UITableView  *tableView;

@property (nonatomic,assign) NSInteger start;
@property (nonatomic,assign) NSInteger limit;

@property (nonatomic,strong) NSMutableArray *dataArray;

@property (nonatomic,assign) BOOL isNew;

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
    self.view.backgroundColor = RGB_COLOR(245, 245, 245);
    [self configUI];
}

- (void)configUI{
    
    self.tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT-210-44) style:UITableViewStyleGrouped];
    [self.tableView registerNib:[UINib nibWithNibName:@"YRUpOldTableViewCell" bundle:nil] forCellReuseIdentifier:@"mycell"];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.backgroundColor = RGB_COLOR(245, 245, 245);
     [self.tableView setExtraCellLineHidden];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.tableView jk_addGifFooterWithRefreshingTarget:self refreshingAction:@selector(footRefresh)];
    [self.tableView jk_addGifHeaderWithRefreshingTarget:self refreshingAction:@selector(headRefresh)];
//    [self.tableView.header beginRefreshing];
    [self.view addSubview:self.tableView];
}
 
- (void)headRefresh{
    self.start = 0;
    [self loadData];
}
- (void)footRefresh{
    self.start += kListPageSize;
    [self loadData];
}
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    if (self.isNew) {
        
    }else{
          [self.tableView.header beginRefreshing];
    }
    self.isNew = YES;
}
- (void)loadData{
    @weakify(self);
     NSString *type = self.oldOrNew?@"0":@"3";
     [YRHttpRequest getMineRedPadingListToadsType:type start:self.start limit:kListPageSize success:^(NSDictionary *data) {
         @strongify(self);
//       YRMyRedPackViewController *vc  = (YRMyRedPackViewController *)self.delegate;
//         vc.allMoney.text = [NSString stringWithFormat:@"广告红包总额: %.2f元", [data[@"totalPacketAmount"] floatValue]/100];
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
    
    return 170;
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
    
    YRUpOldTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"mycell"];
 
    if (self.oldOrNew) {

        if (self.dataArray.count>0) {
            YRRedAdsModel *model = self.dataArray[indexPath.section];
            [self setPassUIWithModel:model indexPath:indexPath cell:cell];
            cell.time.hidden = NO;
        }
    }else{

        if (self.dataArray.count>0) {
            YRRedAdsModel *model = self.dataArray[indexPath.section];
            [self setOldUIWithModel:model indexPath:indexPath cell:cell];
             cell.time.hidden = YES;
        }
    }

    
    return cell;
}
- (void)setPassUIWithModel:(YRRedAdsModel *)model indexPath:(NSIndexPath *)indexPath cell:(YRUpOldTableViewCell *)cell{
    cell.rdsNumbers.text = [NSString stringWithFormat:@"广告编号 :%@",model.code];
    cell.rdsNumbers.textColor = RGB_COLOR(102, 102, 102);
    cell.rdsNumbers.font = [UIFont titleFont15];
    [cell.myImage setImageWithURL:[NSURL URLWithString:model.smallPic] placeholder:[UIImage imageNamed:@"yr_pic_default"]];
    cell.titles.text = model.title;
    cell.titles.font = [UIFont titleFont17];
    cell.titles.textColor = RGB_COLOR(51, 51, 51);
    
    cell.time.text = [NSString stringWithFormat:@"发布时间:%@",[NSString getDateStringWithTimestamp:model.upedTime]];
    cell.time.font = [UIFont titleFont15];
    cell.time.textColor = RGB_COLOR(102, 102, 102);
    NSMutableAttributedString *str = [[NSMutableAttributedString alloc]initWithString:@"红包个数" attributes:@{NSFontAttributeName:[UIFont boldSystemFontOfSize:14]}];
    NSString *redNumber = [NSString stringWithFormat:@"%ld/%ld",model.receiveNum,model.totalNum];
    NSMutableAttributedString *str2 = [[NSMutableAttributedString alloc]initWithString:redNumber attributes:@{NSForegroundColorAttributeName:RGB_COLOR(104, 209, 203),NSFontAttributeName:[UIFont boldSystemFontOfSize:14]}];
    [str appendAttributedString:str2];
    cell.redNum.attributedText = str;
    [cell.seeNum setTitle:[NSString stringWithFormat:@"%@",model.readCount] forState:UIControlStateNormal];
    cell.seeNum.titleLabel.font = [UIFont titleFont14];
    cell.seeNum.titleLabel.textColor = RGB_COLOR(153, 153, 153);
    NSMutableAttributedString *overStr1 = [[NSMutableAttributedString alloc]initWithString:@"有效期:" attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:15],NSForegroundColorAttributeName:RGB_COLOR(102, 102, 102)}];
    NSMutableAttributedString *overStr2 = [[NSMutableAttributedString alloc]initWithString:[NSString getDateStringWithTimestamp:model.expireDate] attributes:@{NSForegroundColorAttributeName:[UIColor themeColor],NSFontAttributeName:[UIFont systemFontOfSize:15]}];
    
    [overStr1 appendAttributedString:overStr2];
    cell.overTime.attributedText = overStr1;
    if (model.isRenew==1&&model.isEnableRenew==0) {
        cell.giveMoney.backgroundColor = [UIColor clearColor];
        [cell.giveMoney setTitle:@"已续费" forState:UIControlStateNormal];
//        cell.giveMoney.titleLabel.font = [UIFont titleFont17];
        [cell.giveMoney setTitleColor:[UIColor themeColor] forState:UIControlStateNormal];
        cell.giveMoney.userInteractionEnabled = NO;
    }else{
        cell.giveMoney.backgroundColor = [UIColor themeColor];
        [cell.giveMoney setTitle:@"续费" forState:UIControlStateNormal];
//        cell.giveMoney.titleLabel.font = [UIFont titleFont17];
        [cell.giveMoney setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        cell.giveMoney.userInteractionEnabled = YES;
        cell.renewalMoney = ^(BOOL isMoney){
            if (isMoney) {
                [self giveMoneyWithIndexPath:indexPath model:model];
            }
        };
    }
    
    if ([model.advertStatus intValue]==4) {
        cell.rdsState.text = @"等待上刊";
        cell.rdsState.hidden = NO;
    }else if ([model.advertStatus integerValue]==6){
        cell.rdsState.text = @"已下架";
        cell.rdsState.hidden = NO;
    }
    else{
        cell.rdsState.hidden = YES;
    }
}
- (void)setOldUIWithModel:(YRRedAdsModel *)model indexPath:(NSIndexPath *)indexPath cell:(YRUpOldTableViewCell *)cell{
    cell.rdsNumbers.text = [NSString stringWithFormat:@"广告编号 :%@",model.code];
    cell.rdsNumbers.textColor = RGB_COLOR(102, 102, 102);
    cell.rdsNumbers.font = [UIFont titleFont15];
    [cell.myImage setImageWithURL:[NSURL URLWithString:model.smallPic] placeholder:[UIImage imageNamed:@"yr_pic_default"]];
    cell.titles.text = model.title;
    cell.titles.font = [UIFont titleFont17];
    cell.titles.textColor = RGB_COLOR(51, 51, 51);
    NSMutableAttributedString *str = [[NSMutableAttributedString alloc]initWithString:@"红包被领取" attributes:@{NSFontAttributeName:[UIFont boldSystemFontOfSize:14]}];
    NSString *redNumber = [NSString stringWithFormat:@"%ld/%ld",model.receiveNum,model.totalNum];
    NSMutableAttributedString *str2 = [[NSMutableAttributedString alloc]initWithString:redNumber attributes:@{NSForegroundColorAttributeName:RGB_COLOR(104, 209, 203),NSFontAttributeName:[UIFont boldSystemFontOfSize:14]}];
    [str appendAttributedString:str2];
    cell.redNum.attributedText = str;
    [cell.seeNum setTitle:[NSString stringWithFormat:@"%@",model.readCount] forState:UIControlStateNormal];
    cell.seeNum.titleLabel.font = [UIFont titleFont14];
    cell.seeNum.titleLabel.textColor = RGB_COLOR(153, 153, 153);
    NSMutableAttributedString *overStr1 = [[NSMutableAttributedString alloc]initWithString:@"到期时间:" attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:15],NSForegroundColorAttributeName:RGB_COLOR(102, 102, 102)}];
    NSMutableAttributedString *overStr2 = [[NSMutableAttributedString alloc]initWithString:[NSString getDateStringWithTimestamp:model.expireDate] attributes:@{NSForegroundColorAttributeName:[UIColor themeColor],NSFontAttributeName:[UIFont systemFontOfSize:15]}];
    
    [overStr1 appendAttributedString:overStr2];
    cell.overTime.attributedText = overStr1;
    if (model.isRenew==1&&model.isEnableRenew==0) {
        cell.giveMoney.backgroundColor = [UIColor clearColor];
        [cell.giveMoney setTitle:@"已再次发布" forState:UIControlStateNormal];
//        cell.giveMoney.titleLabel.font = [UIFont titleFont17];
        [cell.giveMoney setTitleColor:[UIColor themeColor] forState:UIControlStateNormal];
        cell.giveMoney.userInteractionEnabled = NO;
    }else{
        cell.giveMoney.backgroundColor = [UIColor themeColor];
        [cell.giveMoney setTitle:@"再次发布" forState:UIControlStateNormal];
//        cell.giveMoney.titleLabel.font = [UIFont titleFont17];
        [cell.giveMoney setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        cell.giveMoney.userInteractionEnabled = YES;
        cell.againRelease = ^(BOOL isAgain){
            [self againReleaseWithIndexPath:indexPath model:model];
        };
    }
        cell.rdsState.hidden = YES;
}
//续费
- (void)giveMoneyWithIndexPath:(NSIndexPath *)indexPath model:(YRRedAdsModel *)model{
    self.isNew = NO;
   HcdDateTimePickerView *dateTimePickerView = [[HcdDateTimePickerView alloc] initWithDatePickerMode:DatePickerDateMode defaultDateTime:[[NSDate alloc]initWithTimeIntervalSinceNow:1000]withTitle:@"请选择续费发布时间"];
    __weak typeof(dateTimePickerView) weak = dateTimePickerView;
    
    dateTimePickerView.clickedOkBtn = ^(NSString * datetimeStr){
        NSString *myDate = [NSString stringWithFormat:@"%@ 00:00:00",datetimeStr];
        
        NSInteger oldString = [model.expireDate integerValue]/1000;
        
        NSInteger choose = [[NSString timesTampWithTime:myDate] integerValue];
        
        if (choose-oldString>=86400&&choose-oldString<86400*61) {
            [weak dismissBlock:^(BOOL Complete) {
                YRRedPaperAdPaymemtViewController *pay = [[YRRedPaperAdPaymemtViewController alloc]init];
                pay.mineModel = model;
                pay.wishUpDate = datetimeStr;
                pay.isAgainTry = YES;
                [self.navigationController pushViewController:pay animated:YES];
            }];
        }else{
             [MBProgressHUD showError:@"请选择有效期后1~60天"];
        }
         NSLog(@"%@", datetimeStr);
    };
    [self.delegate.view addSubview:dateTimePickerView];
    [dateTimePickerView showHcdDateTimePicker];
    
    DLog(@"续费啦啦啦啦案例啊%@",model);

}
//再次发布
- (void)againReleaseWithIndexPath:(NSIndexPath *)indexPath model:(YRRedAdsModel *)model{
    self.isNew = NO;
    HcdDateTimePickerView *dateTimePickerView = [[HcdDateTimePickerView alloc] initWithDatePickerMode:DatePickerDateMode defaultDateTime:[[NSDate alloc]initWithTimeIntervalSinceNow:1000]withTitle:@"请选择再次发布时间"];
     __weak typeof(dateTimePickerView) weak = dateTimePickerView;
    
    dateTimePickerView.clickedOkBtn = ^(NSString * datetimeStr){
        
//        NSInteger currentime =  [[NSString getCurrentTimestamp] integerValue]/86400000;
        NSString *myDate = [NSString stringWithFormat:@"%@ 00:00:00",datetimeStr];
        
        NSInteger currentime = [[NSString getCurrentTimestamp] integerValue];
        
        NSInteger chooseTime = [[self timesTampWithTime:myDate] integerValue];
        
        if (chooseTime-currentime>=0&&chooseTime-currentime<86400*60) {
            [weak dismissBlock:^(BOOL Complete) {
                YRRedPaperAdPaymemtViewController *pay = [[YRRedPaperAdPaymemtViewController alloc]init];
                pay.mineModel = model;
                pay.wishUpDate = datetimeStr;
                pay.isAgainTry = YES;
                [self.navigationController pushViewController:pay animated:YES];
            }];
        }else{
            [MBProgressHUD showError:@"选择时间格式不正确"];
        }
    };
    [self.delegate.view addSubview:dateTimePickerView];
    [dateTimePickerView showHcdDateTimePicker];
     DLog(@"再次发布啦啦啦啦%@",model);
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
     [tableView deselectRowAtIndexPath:indexPath animated:YES];
     YRRedAdsModel *model = self.dataArray[indexPath.section];
    if ([model.advertStatus integerValue]==0) {
         NSString *text = @"";
        if (model.type ==0) {
            text = @"图文广告";
        }else{
            text = @"视频广告";
        }
        YRRedPackDetailViewController *redpackDetailVC = [[YRRedPackDetailViewController alloc] init];
        redpackDetailVC.redPackerModel = model;
        [self.navigationController pushViewController:redpackDetailVC animated:YES];
    }
    
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



@end
