//
//  YRRedAdsViewController.m
//  YRYZ
//
//  Created by Sean on 16/8/11.
//  Copyright © 2016年 yryz. All rights reserved.
//

#import "YRRedAdsViewController.h"
#import "YRRedAdsTableViewCell.h"
#import "YRAdsRulesViewController.h"
#import "YRRealseAdsViewController.h"
#import "YRRedPaperView.h"
#import "YRRedPaperReceiveViewController.h"
#import "YRRedPackDetailViewController.h"
#import "YRRedListModel.h"
#import "NSObject+Time.h"
#import "YRRedAdsModel.h"
#import "YRAdsRedPacketCell.h"
#import "YRRedPaperListViewController.h"
@interface YRRedAdsViewController ()<UITableViewDelegate,UITableViewDataSource,YRRedAdsTableViewCellDelegate,YRAdsRedPacketCellDelegate,DZNEmptyDataSetSource, DZNEmptyDataSetDelegate>

@property (nonatomic,strong) UITableView * tableView;
@property (nonatomic,strong) NSMutableArray *dataArray;
@property (nonatomic,strong) YRRedAdsModel * redPacketModel;
@property (nonatomic,assign) NSInteger start;
@property (nonatomic,assign) RedPacketAdsType RedPacketType;
@end

@implementation YRRedAdsViewController

- (NSMutableArray *)dataArray
{
    if (!_dataArray) {
        _dataArray = @[].mutableCopy;
    }
    return _dataArray;
}

- (void)setStart:(NSInteger)start{
    if (start < 0) {
        _start = 0;
        return;
    }
    _start = start;
}
- (YRRedAdsModel*)redPacketModel{
    if (!_redPacketModel) {
        _redPacketModel = [[YRRedAdsModel alloc] init];
    }
    return _redPacketModel;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    if ([self.title isEqualToString:@"全部"]) {
        self.RedPacketType = KRedPacketAllList;
    }else  if ([self.title isEqualToString:@"最热"]) {
        self.RedPacketType = KRedPacketHotList;
    }
    @weakify(self);
    [[[NSNotificationCenter defaultCenter] rac_addObserverForName:TranSuccess_TextImage_Notification_Key object:nil] subscribeNext:^(NSNotification *notification) {
        @strongify(self);
        [self.tableView reloadData];
    }];
    [self configUI];
    [self getData];
}

- (void)configUI{
    
    self.tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT) style:UITableViewStyleGrouped];
    [self.tableView registerNib:[UINib nibWithNibName:@"YRRedAdsTableViewCell" bundle:nil] forCellReuseIdentifier:@"cell"];
    [self.tableView registerClass:[YRAdsRedPacketCell class] forCellReuseIdentifier:@"CellID"];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.emptyDataSetDelegate =self;
    self.tableView.emptyDataSetSource =self;
    self.tableView.frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT - 104);
    [self.view addSubview:self.tableView];

    
    [self.tableView jk_addGifFooterWithRefreshingTarget:self refreshingAction:@selector(footRefresh)];
    [self.tableView jk_addGifHeaderWithRefreshingTarget:self refreshingAction:@selector(headRefresh)];
    [self.tableView.header beginRefreshing];
    
}

- (void)headRefresh{
    self.start = 0;
    [self getData];
}
- (void)footRefresh{
    self.start += kListPageSize;
    [self getData];
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 1;
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return self.dataArray.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    YRRedAdsModel * model = self.dataArray[indexPath.section];
    if ([model.smallPic isEqualToString:@""]&&model.picCount ==0) {
        YRAdsRedPacketCell *cell = [tableView dequeueReusableCellWithIdentifier:@"CellID"];
        [cell setRedModel:model];
        cell.delegate = self;
        return cell;
    }
    else{
        YRRedAdsTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
        [cell setRedModel:model];
        cell.delegate = self;
        return cell;
    }
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    NSString *text = @"广告详情";
    YRRedAdsModel * model = self.dataArray[indexPath.section];
    YRRedPackDetailViewController *redpackDetailVC = [[YRRedPackDetailViewController alloc] init];
    redpackDetailVC.title = text ;
    redpackDetailVC.redPackerModel = model;
    [self.navigationController pushViewController:redpackDetailVC animated:YES];
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    YRRedAdsModel * model = self.dataArray[indexPath.section];
    NSString * content = model.adsDesc;
    content = [content stringByReplacingOccurrencesOfString:@" " withString:@""];
    content = [content stringByReplacingOccurrencesOfString:@"\n" withString:@""];
    CGFloat contentH = 0.0 ;
    if (content.length>=60) {
        contentH = [self heightForString:[content substringToIndex:59] fontSize:18];
    }else{
        contentH = [self heightForString:content fontSize:18];
    }
    if ([model.smallPic isEqualToString:@""]) {
        return 120+contentH;
    }else{
        return 120 + contentH + 180;
    }
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UIView *headView = [[UIView alloc]init];
    headView.backgroundColor = RGB_COLOR(245, 245, 245);
    return headView;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 10.f;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 0.01f;
}

-(float)heightForString:(NSString *)value fontSize:(float)fontSize{
    
    NSDictionary *attribute = @{NSFontAttributeName: [UIFont systemFontOfSize:fontSize]};
    CGSize size = [value boundingRectWithSize:CGSizeMake(SCREEN_WIDTH-10, CGFLOAT_MAX) options: NSStringDrawingTruncatesLastVisibleLine | NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading attributes:attribute context:nil].size;
    return size.height;
}
#pragma mark DZNEmptyDataSetSource
- (UIImage*)imageForEmptyDataSet:(UIScrollView *)scrollView{
    return [UIImage imageNamed:@"r_cry"];
}
- (NSAttributedString *)titleForEmptyDataSet:(UIScrollView *)scrollView
{
    NSString *text = @"暂无相关信息";
    
    NSDictionary *attributes = @{NSFontAttributeName: [UIFont systemFontOfSize:14.0f],
                                 NSForegroundColorAttributeName: [UIColor lightGrayColor]};
    
    return [[NSAttributedString alloc] initWithString:text attributes:attributes];
}

- (NSAttributedString *)descriptionForEmptyDataSet:(UIScrollView *)scrollView
{
    NSString *text = @"点击屏幕继续加载";
    
    NSMutableParagraphStyle *paragraph = [NSMutableParagraphStyle new];
    paragraph.lineBreakMode = NSLineBreakByWordWrapping;
    paragraph.alignment = NSTextAlignmentCenter;
    
    NSDictionary *attributes = @{NSFontAttributeName: [UIFont systemFontOfSize:14.0f],
                                 NSForegroundColorAttributeName: [UIColor lightGrayColor],
                                 NSParagraphStyleAttributeName: paragraph};
    
    return [[NSAttributedString alloc] initWithString:text attributes:attributes];
}
- (void)emptyDataSet:(UIScrollView *)scrollView didTapView:(UIView *)view
{
    [self.tableView.header beginRefreshing];
}
- (CGFloat)spaceHeightForEmptyDataSet:(UIScrollView *)scrollView
{
    return 10.0f;
}

#pragma marl  imageTextCell Delegate

- (void)redAdsTableViewCellDelegate:(BasicAction)basicAction redModel:(YRRedAdsModel *)redModel{
    
    if (![YRUserInfoManager manager].currentUser.custId  && basicAction!=kHeadImage ) {
        [self noLoginTip];
        return;
    }
    
    
    switch (basicAction) {
        case kRedBag:
        {
            
            if (!redModel.redpacketId) {
                [MBProgressHUD showError:@"无效红包"];
                return;
            }
            
            if ([redModel.custId isEqualToString:[YRUserInfoManager manager].currentUser.custId]) {
                YRRedPaperListViewController  *redRecordVc = [[YRRedPaperListViewController alloc] init];
                redRecordVc.redId = redModel.redpacketId;
                [self.navigationController pushViewController:redRecordVc animated:YES];
            }else{
                [MBProgressHUD showSuccess:@"查看完整广告即可获得一个红包"];
            }
            
        }
            break;
        case kHeadImage:{
            [self pushUserInfoViewController:redModel.custId withIsFriend:YES];
        }
            break;
        default:
            break;
    }
    
}
#pragma mark - 获取列表书
- (void)getData{
    
    @weakify(self);
    [YRHttpRequest getRedPacketAdsListAdsType:self.RedPacketType Start:self.start Limit:kListPageSize success:^(NSDictionary *data) {
        @strongify(self);
        NSArray  *array =  [YRRedAdsModel mj_objectArrayWithKeyValuesArray:data];
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
    } failure:^(NSString *errorInfo) {
        [MBProgressHUD showError:errorInfo];
        [self.tableView.footer endRefreshing];
        [self.tableView.header endRefreshing];
    }];
    
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}


@end
