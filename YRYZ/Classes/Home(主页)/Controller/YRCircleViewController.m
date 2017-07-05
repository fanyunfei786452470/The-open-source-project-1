//
//  YRCircleViewController.m
//  YRYZ
//
//  Created by weishibo on 16/8/2.
//  Copyright © 2016年 yryz. All rights reserved.
//

#import "YRCircleViewController.h"
#import "YRImageTextCell.h"
#import "YRSendRedBagController.h"
#import "YRRedPaperPaymentViewController.h"
#import "YRRedPaperView.h"
#import "YRRedPaperReceiveViewController.h"
#import "RewardGiftView.h"
#import "YRLoginController.h"
#import "YRCirleDetailViewController.h"
#import "YRCircleListModel.h"
#import "YRRedListModel.h"

static NSString *cellID = @"CircleViewCellID";
@interface YRCircleViewController ()
<UITableViewDelegate,UITableViewDataSource,YRImageTextCircleCellDelegate,DZNEmptyDataSetSource, DZNEmptyDataSetDelegate>

@property (strong, nonatomic) UITableView               *tableView;
@property (nonatomic,strong) RewardGiftView             *rewardGiftView;
@property (strong, nonatomic) NSMutableArray            *dataArray;
@property (nonatomic, assign)NSInteger                  start;
@property (nonatomic ,strong)YRRedListModel             *redModel;

@end

@implementation YRCircleViewController

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

-(YRRedListModel *)redModel{
    if(!_redModel){
        _redModel = [[YRRedListModel alloc] init];
    }
    return _redModel;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setRightNavButtonWithImage:[UIImage imageNamed:@"yr_navButton_more"]];
    
    if ([self.title isEqualToString:@"全部"]) {
        [self setupTableView];
    }else{
        if ([YRUserInfoManager manager].currentUser.custId) {
            [self setupTableView];
        }else{
            [self touristsView];
        }
    }
    
    
    [self fectCircleList];
    
}

/**
 *  @author weishibo, 16-08-26 16:08:35
 *
 *  抢红包接口
 */
- (void)fectRobRed{
    
    [YRHttpRequest robRed:@"d1fbd2d483bc47f9844dec485a792595" success:^(id data) {
        [self fectOpenRed];
    } failure:^(id data) {
        [MBProgressHUD showError:data];
    }];
}

/**
 *  @author weishibo, 16-08-26 17:08:02
 *
 *  拆红包
 */
- (void)fectOpenRed{
    
    [YRHttpRequest openRed:@"d1fbd2d483bc47f9844dec485a792595" friendStatus:1 success:^(NSDictionary *data) {
        self.redModel = [YRRedListModel mj_objectWithKeyValues:data];
    } failure:^(id data) {
        [MBProgressHUD showError:data];
    }];
}



-(void)setupTableView{
    
    self.tableView = [[UITableView alloc]initWithFrame:CGRectZero style:UITableViewStylePlain];
    self.tableView.backgroundColor = RGB_COLOR(245, 245, 245);
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.emptyDataSetSource = self;
    self.tableView.emptyDataSetDelegate = self;
    self.tableView.contentInset = UIEdgeInsetsMake(0, 0, 150, 0);
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
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
    [self fectCircleList];
}

- (void)footRefresh
{
    self.start += kListPageSize;
    [self fectCircleList];
}


- (void)fectCircleList{
    @weakify(self);
    [YRHttpRequest circleList:kAllFriends maxId:@"" start:self.start limit:kListPageSize success:^(NSArray *data) {
        @strongify(self);
        NSArray  *array =  [YRCircleListModel mj_objectArrayWithKeyValuesArray:data];
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
        [MBProgressHUD showError:error];
    }];
    
}



#pragma mark - UITableViewDelegate & UITableViewDataSource
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataArray.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    YRImageTextCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    cell.circledelegate = self;
    cell.redButton.hidden = NO;
    [cell setCircleModel:self.dataArray[indexPath.row]];
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 217;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    YRCirleDetailViewController *cirleVc = [[YRCirleDetailViewController alloc] init];
    cirleVc.circleListModel = self.dataArray[indexPath.row];
    [self.navigationController pushViewController:cirleVc animated:YES];
    
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

- (void)imageTextCellDelegate:(BasicAction)basicAction circleModel:(YRCircleListModel *)circleModel{
    switch (basicAction) {
        case kTran:
        {
            YRRedPaperPaymentViewController *redVC = [[YRRedPaperPaymentViewController alloc]init];
            redVC.circleModel = circleModel;
            [self.navigationController pushViewController:redVC animated:YES];
            
        }
            break;
        case kRedBag:
        {
            //            @weakify(self);
            //            [YRRedPaperView showRedPaperViewWithName:@"xxxx" OpenBlock:^(){
            //                @strongify(self);
            //                YRRedPaperReceiveViewController *ViewController = [[YRRedPaperReceiveViewController alloc]init];
            //                [self.navigationController pushViewController:ViewController animated:NO];
            //            }];
            
            
            [self fectRobRed];
            
            @weakify(self);
            [YRRedPaperView showRedPaperViewWithName:@"韩俊" OpenBlock:^(){
                @strongify(self);
                YRRedPaperReceiveViewController *viewController = [[YRRedPaperReceiveViewController alloc]init];
                //                viewController.redModel = redModel;
                [self.navigationController pushViewController:viewController animated:YES];
            }];
            
            
            
        }
            break;
        case kReward:
        {
            
            RewardGiftView *rewardGiftView = [[RewardGiftView alloc] initWithFrame:CGRectMake(0,SCREEN_HEIGHT, self.rewardGiftView.frame.size.width, self.rewardGiftView.frame.size.height)];
            [rewardGiftView showGiftView];
        }
            break;
        case kCollection:
        {
        }
            break;
        default:
            break;
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}


@end
