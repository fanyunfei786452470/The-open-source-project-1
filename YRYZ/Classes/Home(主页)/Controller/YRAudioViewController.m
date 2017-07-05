//
//  YRAudioViewController.m
//  YRYZ
//
//  Created by 易超 on 16/8/4.
//  Copyright © 2016年 yryz. All rights reserved.
//

#import "YRAudioViewController.h"
#import "YRListenAndSayCell.h"
#import "YRAudioDetailController.h"
#import "YRSearchController.h"
#import "YRProductListModel.h"
#import "YRRedPaperPaymentViewController.h"
#import "YRRedPaperView.h"
#import "YRRedPaperReceiveViewController.h"
#import "RewardGiftView.h"
#import "YRRedListModel.h"
#import "YRRedPaperListViewController.h"
#import "YRSearchResultController.h"

#import "YRAdListUserInfoController.h"
static NSString *cellID = @"ListenAndSayCellID";
@interface YRAudioViewController ()<UITableViewDelegate,UITableViewDataSource,UISearchBarDelegate,UISearchControllerDelegate,
YRListenAndSayCellDelegate,DZNEmptyDataSetSource, DZNEmptyDataSetDelegate>

@property (strong, nonatomic) UITableView              *tableView;

@property (strong, nonatomic) UISearchController       *searchController;

@property (strong, nonatomic) NSMutableArray           *dataArray;

@property (nonatomic, strong) RewardGiftView            *rewardGiftView;

@property (nonatomic, assign) NSInteger                  start;

@property (nonatomic ,strong)YRProductListModel         *productModel;

@end

@implementation YRAudioViewController

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
- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    if (self.searchController.active) {
        self.searchController.active = NO;
        [self.searchController.searchBar removeFromSuperview];
    }
}
-(void)setupTableView{
    
    self.tableView = [[UITableView alloc]initWithFrame:CGRectZero style:UITableViewStylePlain];
    self.tableView.backgroundColor = RGB_COLOR(245, 245, 245);
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.contentInset = UIEdgeInsetsMake(0, 0, 150, 0);
    self.tableView.emptyDataSetSource = self;
    self.tableView.emptyDataSetDelegate = self;
    [self.view addSubview:self.tableView];
    [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass([YRListenAndSayCell class]) bundle:nil] forCellReuseIdentifier:cellID];
    
    self.searchController = [[UISearchController alloc] initWithSearchResultsController:nil];
//    self.searchController.searchResultsUpdater = self;
    self.searchController.dimsBackgroundDuringPresentation = NO;
    self.searchController.hidesNavigationBarDuringPresentation = NO;
    self.searchController.searchBar.frame = CGRectMake(self.searchController.searchBar.frame.origin.x, self.searchController.searchBar.frame.origin.y, self.searchController.searchBar.frame.size.width, 44.0);
    self.searchController.searchBar.placeholder = @"搜索关键字";
    self.searchController.searchBar.barTintColor = [UIColor colorWithRed:245/255.0 green:245/255.0 blue:245/255.0 alpha:1];
    self.searchController.searchBar.tintColor = Global_Color;
    self.searchController.searchBar.layer.borderWidth = 1;
    self.searchController.searchBar.layer.borderColor = RGB_COLOR(245, 245, 245).CGColor;
    
    self.searchController.delegate = self;
    self.searchController.definesPresentationContext = YES;
    self.searchController.searchBar.delegate = self;
    //        UIImageView *view = [[[self.searchController.searchBar.subviews objectAtIndex:0] subviews] firstObject];
    //        view.layer.borderColor = [UIColor colorWithRed:245/255.0 green:245/255.0 blue:245/255.0 alpha:1].CGColor;
    //        view.layer.borderWidth = 1;
    
    //         self.headView = [[UIView alloc]initWithFrame:CGRectMake(0,0, SCREEN_WIDTH, 44)];
    //        [self.headView  setBackgroundColor:[UIColor whiteColor]];
    //        [self.searchController.searchBar setBackgroundColor:[UIColor redColor]];
    //        [self.headView  addSubview:self.searchController.searchBar];
    self.tableView.tableHeaderView = self.searchController.searchBar;
    
    @weakify(self);
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        @strongify(self);
        make.edges.equalTo(self.view).insets(UIEdgeInsetsMake(0, 0, 0, 0));
    }];
    
    [self.tableView jk_addGifFooterWithRefreshingTarget:self refreshingAction:@selector(footRefresh)];
    [self.tableView jk_addGifHeaderWithRefreshingTarget:self refreshingAction:@selector(headRefresh)];
    [self.tableView.header beginRefreshing];
    

}
- (void)headRefresh{
    self.start = 0;
    [self fectData];
}
- (void)footRefresh{
    self.start += kListPageSize;
    [self fectData];
}
- (void)fectData{
    @weakify(self);
    [YRHttpRequest productList:kInfoTypeVoice authorid:@"" categroy:self.model.uid start:self.start limit:kListPageSize success:^(NSArray *data) {
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
        [MBProgressHUD showError:data];
    }];
    
}

#pragma mark --- UISearchBarDelegate

-(BOOL)searchBarShouldBeginEditing:(UISearchBar *)searchBar{
    YRSearchResultController *search = [[YRSearchResultController alloc]init];
    [self.navigationController pushViewController:search animated:YES];
    return NO;
}

#pragma mark - UITableViewDelegate & UITableViewDataSource
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataArray.count;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    YRListenAndSayCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    [cell setProductModel:self.dataArray[indexPath.row]];
    cell.delegate = self;
    return cell;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 198;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    YRAudioDetailController *audioVc = [[YRAudioDetailController alloc] init];
    audioVc.productListModel = self.dataArray[indexPath.row];
    [self.navigationController pushViewController:audioVc animated:YES];
}
- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    
    if (_rewardGiftView) {
        [UIView beginAnimations:nil context:nil];
        [UIView setAnimationDuration:0.25];
        self.rewardGiftView.frame = CGRectMake(0,SCREEN_HEIGHT, self.rewardGiftView.frame.size.width, self.rewardGiftView.frame.size.height);
        [UIView commitAnimations];
        _rewardGiftView = nil;
    }
}
#pragma mark DZNEmptyDataSetSource
- (UIImage*)imageForEmptyDataSet:(UIScrollView *)scrollView{
    return [UIImage imageNamed:@"r_cry"];
}

- (NSAttributedString *)titleForEmptyDataSet:(UIScrollView *)scrollView{
    NSString *text = @"暂无相关信息";
    
    NSDictionary *attributes = @{NSFontAttributeName: [UIFont systemFontOfSize:14.0f],
                                 NSForegroundColorAttributeName: [UIColor lightGrayColor]};
    
    return [[NSAttributedString alloc] initWithString:text attributes:attributes];
}

- (NSAttributedString *)descriptionForEmptyDataSet:(UIScrollView *)scrollView{
    NSString *text = @"点击屏幕继续加载";
    
    NSMutableParagraphStyle *paragraph = [NSMutableParagraphStyle new];
    paragraph.lineBreakMode = NSLineBreakByWordWrapping;
    paragraph.alignment = NSTextAlignmentCenter;
    
    NSDictionary *attributes = @{NSFontAttributeName: [UIFont systemFontOfSize:14.0f],
                                 NSForegroundColorAttributeName: [UIColor lightGrayColor],
                                 NSParagraphStyleAttributeName: paragraph};
    
    return [[NSAttributedString alloc] initWithString:text attributes:attributes];
}

- (void)emptyDataSet:(UIScrollView *)scrollView didTapView:(UIView *)view{
    [self.tableView.header beginRefreshing];
}

- (CGFloat)spaceHeightForEmptyDataSet:(UIScrollView *)scrollView{
    return 10.0f;
}

#pragma mark YRListenAndSayCell 代理
- (void)listenAndSayCellDelegate:(BasicAction)basicAction productModel:(YRProductListModel *)productModel{
    switch (basicAction) {
        case kTran:
        {
            YRRedPaperPaymentViewController *imageTextController = [[YRRedPaperPaymentViewController alloc]init];
            imageTextController.productModel = productModel;
            [self.navigationController pushViewController:imageTextController animated:YES];
            
        }
            break;
        case kRedBag:
        {
            [YRRedPaperView showRedPaperViewWithName:@"xxxx" OpenBlock:^(){
                YRRedPaperListViewController *viewController = [[YRRedPaperListViewController alloc]init];
                [self.navigationController pushViewController:viewController animated:NO];
            }];
            
        }
            break;
        case kReward:
        {
            self.productModel = productModel;
            
            RewardGiftView *rewardGiftView = [[RewardGiftView alloc] initWithFrame:CGRectMake(0,SCREEN_HEIGHT, self.rewardGiftView.frame.size.width, self.rewardGiftView.frame.size.height)];
            [rewardGiftView showGiftView];
        }
            break;
        case kCollection:
        {
        
            
        }
            break;
        case kHeadImage:
        {
            YRAdListUserInfoController *adList = [[YRAdListUserInfoController alloc]init];
//            adList.uid = productModel.uid;
            adList.custId = productModel.custId;
            [self.navigationController pushViewController:adList animated:YES];
            
        }
            break;
            
        default:
            break;
    }
}

- (void)cannelBtnClick:(UIButton*)b{
    
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:0.25];
    self.rewardGiftView.frame = CGRectMake(0,SCREEN_HEIGHT, self.rewardGiftView.frame.size.width, self.rewardGiftView.frame.size.height);
    [UIView commitAnimations];
}

@end
