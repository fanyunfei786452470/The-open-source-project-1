//
//  YRVideoViewController.m
//  YRYZ
//
//  Created by weishibo on 16/8/3.
//  Copyright © 2016年 yryz. All rights reserved.
//

#import "YRVideoViewController.h"
#import "YRVideoCollectionViewCell.h"
#import "YRVidioDetailController.h"
#import "waterCollectionLayout.h"
#import "YRProductListModel.h"

@interface YRVideoViewController()<UICollectionViewDelegateFlowLayout,UICollectionViewDataSource,UICollectionViewDelegate,waterCollectionLayoutDelegate,DZNEmptyDataSetSource, DZNEmptyDataSetDelegate>
@property (nonatomic , strong) UICollectionView         *collectionView;
@property (strong, nonatomic) NSMutableArray            *dataArray;
@property (nonatomic, assign)NSInteger                  start;

@property (strong, nonatomic) NSMutableArray            *arr;

@end

@implementation YRVideoViewController

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

- (void)viewDidLoad{
    
    [super viewDidLoad];
    
    self.arr = @[].mutableCopy;
    
    for (int i = 0 ; i<100; i++) {
        NSInteger b = arc4random_uniform(100)+100;
        NSString *str = [NSString stringWithFormat:@"%ld",b];
        [self.arr addObject:str];
    }
    
    waterCollectionLayout *water = [[waterCollectionLayout alloc]init];
    water.delegate = self;
    
    self.collectionView = [[UICollectionView alloc]initWithFrame:CGRectMake(0,-10, SCREEN_WIDTH, SCREEN_HEIGHT - 64) collectionViewLayout:water];
    self.collectionView.delegate=self;
    self.collectionView.dataSource=self;
    self.collectionView.emptyDataSetDelegate = self;
    self.collectionView.emptyDataSetSource = self;
    [self.view addSubview:self.collectionView];
    self.collectionView.backgroundColor = RGB_COLOR(245, 245, 245);
    
    [self.collectionView registerNib:[UINib nibWithNibName:@"YRVideoCollectionViewCell" bundle:nil] forCellWithReuseIdentifier:@"collCell"];
    
    [self.collectionView jk_addGifFooterWithRefreshingTarget:self refreshingAction:@selector(footRefresh)];
    [self.collectionView jk_addGifHeaderWithRefreshingTarget:self refreshingAction:@selector(headRefresh)];
    [self.collectionView.header beginRefreshing];
    
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
    [YRHttpRequest productList:kInfoTypeVideo authorid:@"" categroy:self.model.uid start:self.start limit:kListPageSize success:^(NSArray *data) {
        @strongify(self);
        NSArray  *array =  [YRProductListModel mj_objectArrayWithKeyValuesArray:data];
        if (self.start == 0) {
            [self.dataArray removeAllObjects];
            [self.view  addSubview:[self  addUpdateNumTodo:array.count]];
        }
        [self.dataArray addObjectsFromArray:array];
        if ([array count] < kListPageSize) {
            self.start -= kListPageSize;
            [self.collectionView.footer endRefreshingWithNoMoreData];
        }else{
            [self.collectionView.footer endRefreshing];
        }
        [self.collectionView reloadData];
        [self.collectionView.header endRefreshing];
    } failure:^(id data) {
        [MBProgressHUD showError:NetworkError];
    }];
    
}


- (CGSize)waterCollectionLayout:(waterCollectionLayout *)layout heightForWidth:(CGFloat)width withIndexPath:(NSIndexPath *)indexPath{
    return CGSizeMake(width, [self.arr[indexPath.item] integerValue]);
}


#pragma mark-实现代理方法

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return self.dataArray.count;
}
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    YRVideoCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"collCell" forIndexPath:indexPath];
    YRProductListModel *model = self.dataArray[indexPath.row];
    [cell setProductModel:model];
    cell.choose = ^(BOOL isChoose){
        if (isChoose) {
            [self pushUserInfoViewController:model.uid withIsFriend:YES];
        }
    };
    return cell;
}



- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    
    YRVidioDetailController *videoVc = [[YRVidioDetailController alloc] init];
    videoVc.productListModel = self.dataArray[indexPath.row];
    [self.navigationController pushViewController:videoVc animated:YES];
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
    [self.collectionView.header beginRefreshing];
}
- (CGFloat)spaceHeightForEmptyDataSet:(UIScrollView *)scrollView
{
    return 10.0f;
}




@end














