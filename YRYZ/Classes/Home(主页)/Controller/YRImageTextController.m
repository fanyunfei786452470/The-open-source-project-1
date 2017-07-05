//
//  YRImageTextController.m
//  YRYZ
//
//  Created by 易超 on 16/7/15.
//  Copyright © 2016年 yryz. All rights reserved.
//

#import "YRImageTextController.h"
#import "YRImageTextCell.h"
#import "YRImageTextDetailsViewController.h"
#import "YRRedPaperPaymentViewController.h"
#import "YRRedPaperView.h"
#import "YRRedPaperReceiveViewController.h"
#import "RewardGiftView.h"
#import "YRRedListModel.h"
static NSString *cellID = @"ImageTextCellID";
@interface YRImageTextController ()<UITableViewDelegate,UITableViewDataSource,YRImageTextCellDelegate,DZNEmptyDataSetSource, DZNEmptyDataSetDelegate>

@property (strong, nonatomic) UITableView              *tableView;
@property (nonatomic,strong) RewardGiftView            *rewardGiftView;


@property (strong, nonatomic) NSMutableArray           *dataArray;
@property (nonatomic, assign)NSInteger                 start;
@property (nonatomic ,strong)YRProductListModel        *productModel;

@end

@implementation YRImageTextController

- (NSMutableArray*)dataArray{
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

- (YRInfoProductTypeModel*)model{

    if (!_model) {
        _model = [[YRInfoProductTypeModel alloc] init];
    }
    return _model;
}



- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupTableView];
}

-(void)setupTableView{
    
    self.tableView = [[UITableView alloc]initWithFrame:CGRectZero style:UITableViewStylePlain];
    self.tableView.backgroundColor = RGB_COLOR(245, 245, 245);
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.contentInset = UIEdgeInsetsMake(0, 0, 150, 0);
    self.tableView.emptyDataSetDelegate = self;
    self.tableView.emptyDataSetSource = self;
    [self.view addSubview:self.tableView];
    [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass([YRImageTextCell class]) bundle:nil] forCellReuseIdentifier:cellID];
    
    
    @weakify(self);
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        @strongify(self);
        make.edges.equalTo(self.view).insets(UIEdgeInsetsMake(0, 0, 0, 0));
    }];
    
    
    [self.tableView jk_addGifFooterWithRefreshingTarget:self refreshingAction:@selector(footRefresh)];
    [self.tableView jk_addGifHeaderWithRefreshingTarget:self refreshingAction:@selector(headRefresh)];
    [self.tableView.header beginRefreshing];
}

- (void)headRefresh
{
    self.start = 0;
    [self fectData];
}

- (void)footRefresh
{
    self.start += kListPageSize;
    [self fectData];
}

- (void)fectData{
    @weakify(self);
    [YRHttpRequest productList:kInfoTypePictureWord authorid:@"" categroy:self.model.uid start:self.start limit:kListPageSize success:^(NSArray *data) {
        @strongify(self);
        NSArray  *array =  [YRProductListModel mj_objectArrayWithKeyValuesArray:data];
        if (self.start == 0) {
            [self.dataArray removeAllObjects];
            [self.view  addSubview:[self  addUpdateNumTodo:array.count]];
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
        [MBProgressHUD showError:NetworkError];
    }];
    
}



#pragma mark - UITableViewDelegate & UITableViewDataSource
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataArray.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    YRImageTextCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    cell.redButton.hidden = YES;
    cell.delegate = self;
    [cell setProductModel:self.dataArray[indexPath.row]];
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 217;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    YRImageTextDetailsViewController  *imageTextVc = [[YRImageTextDetailsViewController alloc] init];
    imageTextVc.productListModel = self.dataArray[indexPath.row];
    [self.navigationController pushViewController:imageTextVc animated:YES];
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

- (void)imageTextCellDelegate:(BasicAction)basicAction productModel:(YRProductListModel *)productModel{
    switch (basicAction) {
        case kTran:
        {
            YRRedPaperPaymentViewController *redVc = [[YRRedPaperPaymentViewController alloc]init];
            redVc.productModel = productModel;
            [self.navigationController pushViewController:redVc animated:YES];

        }
            break;
        case kRedBag:
        {
            
                      

        }
            break;
        case kReward:
        {
            
            self.productModel = productModel;
//            UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
//            btn.backgroundColor = [UIColor colorWithRed:0.0 green:0.0 blue:0.0 alpha:0.35];
//            btn.frame = CGRectMake(0, -100, SCREEN_WIDTH, SCREEN_HEIGHT);
//            [btn addTarget:self action:@selector(cannelBtnClick:) forControlEvents:UIControlEventTouchUpInside];
//            [self.view addSubview:btn];

        
            RewardGiftView *rewardGiftView = [[RewardGiftView alloc] initWithFrame:CGRectMake(0,SCREEN_HEIGHT, self.rewardGiftView.frame.size.width, self.rewardGiftView.frame.size.height)];
            [rewardGiftView showGiftView];
        
        }
            break;
        case kCollection:
        {
        }
            break;
        case kHeadImage:
        {    //好友详情跳转
            [self pushUserInfoViewController:productModel.uid withIsFriend:YES];
        }
            break;
        default:
            break;
    }
}


@end
