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
#import "YRCollectionHeaderView.h"
#import "YRSearchResultController.h"
#import "YRSearchWorksController.h"
#import "UIImageView+WebCache.h"
#import "YRNewVideoDetailViewController.h"
@interface YRVideoViewController()<UICollectionViewDelegateFlowLayout,UICollectionViewDataSource,UICollectionViewDelegate,waterCollectionLayoutDelegate,DZNEmptyDataSetSource, DZNEmptyDataSetDelegate,UISearchBarDelegate,VideoTranSucessDelegate>
@property (nonatomic , strong) UICollectionView         *collectionView;
@property (strong, nonatomic) NSMutableArray            *dataArray;
@property (nonatomic, assign)NSInteger                  start;

@property (nonatomic,weak) waterCollectionLayout *water;
@end

@implementation YRVideoViewController

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
    
    self.dataArray = [[NSMutableArray alloc]init];
    NSString *key = [NSString stringWithFormat:@"%@%ld",NSStringFromClass([self class]),(long)self.model.uid];
    [_dataArray addObjectsFromArray:(NSMutableArray *)[[YRYYCache share].yyCache objectForKey:key]];
    
    
    waterCollectionLayout *water = [[waterCollectionLayout alloc]init];
    self.water = water;
    water.delegate = self;
    self.collectionView = [[UICollectionView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT- 104) collectionViewLayout:water];
    self.collectionView.delegate=self;
    self.collectionView.dataSource=self;
    self.collectionView.emptyDataSetDelegate = self;
    self.collectionView.emptyDataSetSource = self;
    self.collectionView.backgroundColor = RGB_COLOR(245, 245, 245);
    [self.view addSubview:self.collectionView];
    
    
    [self.collectionView registerNib:[UINib nibWithNibName:@"YRVideoCollectionViewCell" bundle:nil] forCellWithReuseIdentifier:@"collCell"];
    

    UISearchBar *search = [[UISearchBar alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 44)];


    [self.collectionView addSubview:search];
    
    search.placeholder = @"搜索关键字";
    search.barTintColor = [UIColor colorWithRed:245/255.0 green:245/255.0 blue:245/255.0 alpha:1];
    search.tintColor = Global_Color;
    search.layer.borderWidth = 1;
    search.layer.borderColor = RGB_COLOR(245, 245, 245).CGColor;
    search.delegate = self;
    
    
    [self.collectionView jk_addGifFooterWithRefreshingTarget:self refreshingAction:@selector(footRefresh)];
    [self.collectionView jk_addGifHeaderWithRefreshingTarget:self refreshingAction:@selector(headRefresh)];
    [self.collectionView.header beginRefreshing];
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
    [YRHttpRequest productList:kInfoTypeVideo authorid:@"" categroy:self.model.uid start:self.start limit:kListPageSize success:^(NSArray *data) {
        @strongify(self);
        //        NSArray  *array =  [YRProductListModel mj_objectArrayWithKeyValuesArray:data];
        NSMutableArray *arrayModel = [[NSMutableArray alloc]init];
        
        for (int i =0; i < data.count; i++)
        {
            YRProductListModel *model = [YRProductListModel mj_objectWithKeyValues:data[i]];
            UIImageView *image = [[UIImageView alloc]init];
            [image setImageWithURL:[NSURL URLWithString:model.urlThumbnail] placeholder:nil options:kNilOptions completion:^(UIImage * _Nullable image, NSURL * _Nonnull url, YYWebImageFromType from, YYWebImageStage stage, NSError * _Nullable error) {
                if (!image) {
                    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                        UIImage *image = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:model.urlThumbnail]]];
                        CGSize size = image.size;
                        CGFloat bl = size.height/size.width;
                        CGFloat width = (self.collectionView.frame.size.width-4)/2;
                        CGFloat height = width*(bl);
                        //                                    CGFloat add = (60.0)/(SCREEN_POINT);
                        CGFloat add = 50;
                        if ([model.urlThumbnail isEqualToString:@""]) {
                            model.height = 0;
                        }else{
                            model.height = height+add;
                        }
                        dispatch_async(dispatch_get_main_queue(), ^{
                            
                            [UIView performWithoutAnimation:^{
                                [self.collectionView reloadItemsAtIndexPaths:@[[NSIndexPath indexPathForItem:model.indexPath.item inSection:0]]];
                            }];
                        });
                    });
                }else{
                    CGSize size = image.size;
                    CGFloat bl = size.height/size.width;
                    CGFloat width = (self.collectionView.frame.size.width-4)/2;
                    CGFloat height = width*(bl);
                    //                                CGFloat add = (60.0)/(SCREEN_POINT);
                    CGFloat add = 50;
                    if ([model.urlThumbnail isEqualToString:@""]) {
                        model.height = 0;
                    }else{
                        model.height = height+add;
                    }
                    dispatch_async(dispatch_get_main_queue(), ^{
                        [UIView performWithoutAnimation:^{
                            [self.collectionView reloadItemsAtIndexPaths:@[[NSIndexPath indexPathForItem:model.indexPath.item inSection:0]]];
                        }];
                    });
                }
            }];
            [arrayModel addObject:model];
        }
        if (self.start == 0) {
            [self.dataArray removeAllObjects];
            NSString *key = [NSString stringWithFormat:@"%@%ld",NSStringFromClass([self class]),(long)self.model.uid];
            [[YRYYCache share].yyCache removeObjectForKey:key];
            [[YRYYCache share].yyCache setObject:arrayModel forKey:key];
        }
        
        [self.dataArray addObjectsFromArray:arrayModel];
        if ([arrayModel count] < kListPageSize) {
            self.start -= kListPageSize;
            [self.collectionView.footer endRefreshingWithNoMoreData];
        }else{
            [self.collectionView.footer endRefreshing];
        }
        [self.collectionView reloadData];
        [self.collectionView.header endRefreshing];
    } failure:^(id data) {
        [MBProgressHUD showError:data];
        [self.collectionView.header endRefreshing];
    }];
    
}

- (CGSize)waterCollectionLayout:(waterCollectionLayout *)layout heightForWidth:(CGFloat)width withIndexPath:(NSIndexPath *)indexPath{
    
    if (self.dataArray.count>0) {
        YRProductListModel *model = self.dataArray[indexPath.row];
        model.indexPath = indexPath;
        CGFloat height = model.height>10?model.height:200;
        return CGSizeMake(width, height);
    }else{
        return CGSizeMake(width, 200);
    }
    
}

- (void)videoTranSucessDelegate:(NSInteger)readStatus{
    
    if (readStatus == 1) {
        [self.collectionView reloadData];
    }
}

#pragma mark-实现代理方法
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return self.dataArray.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    YRVideoCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"collCell" forIndexPath:indexPath];
    YRProductListModel *model = self.dataArray[indexPath.row];
    [cell setProductModel:model];
    @weakify(self);
    cell.choose = ^(BOOL isChoose){
        @strongify(self);
        if (isChoose) {
            [self pushUserInfoViewController:model.custId withIsFriend:YES];
        }
    };
    return cell;
}
//- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath{
//
//    UICollectionReusableView *reusableview = nil;
//
//    if (kind == UICollectionElementKindSectionHeader){
//
//        UICollectionReusableView *headerView = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"HeadView" forIndexPath:indexPath];
//
//         reusableview = headerView;
//    }
//    return reusableview;
//}


- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section{
    return CGSizeMake(SCREEN_WIDTH, 24);
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    YRProductListModel *model = self.dataArray[indexPath.row];
    
    
    //    YRNewVideoDetailViewController  *newVc = [[YRNewVideoDetailViewController alloc] init];
    //    newVc.productId = model.uid;
    //    newVc.productListModel = model;
    //    newVc.videoTranSucessDelegate = self;
    //    [self.navigationController pushViewController:newVc animated:YES];
    
    YRVidioDetailController *videoVc = [[YRVidioDetailController alloc] init];
    videoVc.productListModel = model;
    CGFloat h = [model.infoIntroduction heightForStringfontSize:18.f];
    videoVc.commentHeigt = h;
    videoVc.videoTranSucessDelegate = self;
    [self.navigationController pushViewController:videoVc animated:YES];
    //
    
}
#pragma mark --- UISearchBarDelegate
-(BOOL)searchBarShouldBeginEditing:(UISearchBar *)searchBar{
    YRSearchWorksController *search = [[YRSearchWorksController alloc]init];
    search.type = @"2";
    [self.navigationController pushViewController:search animated:YES];
    return NO;
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














