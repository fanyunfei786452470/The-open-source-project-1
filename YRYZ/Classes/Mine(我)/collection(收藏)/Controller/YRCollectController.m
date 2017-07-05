//
//  YRCollectController.m
//  YRYZ
//
//  Created by 易超 on 16/7/19.
//  Copyright © 2016年 yryz. All rights reserved.
//

#import "YRCollectController.h"
#import "YRCollectCell.h"
#import "YRProductListModel.h"
#import "YRImageTextDetailsViewController.h"
#import "YRVidioDetailController.h"
#import "YRAudioDetailController.h"
#import "YRNewVideoDetailViewController.h"
#import "YRNewAudioDetailViewController.h"
#import "YRCirleDetailViewController.h"
static NSString *collectCellID = @"YRCollectCellID";
@interface YRCollectController ()<UITableViewDelegate,UITableViewDataSource,DZNEmptyDataSetSource, DZNEmptyDataSetDelegate>

@property (strong, nonatomic) UITableView       *tableView;
@property (nonatomic,assign) NSInteger          start;
@property (nonatomic,strong) NSMutableArray     *array;

@property (nonatomic,weak) YRProductListModel       *model;

@end

@implementation YRCollectController
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"deleteAudioNotifier" object:nil];
    if ([YRModelManager manager].listModel&&[YRModelManager manager].collect) {
        [self.array removeObject:self.model];
        [self.tableView reloadData];
        [YRModelManager manager].collect = NO;
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];

    [self setTitle:@"我的收藏"];
    [self setupTableView];
}
- (void)loadData{
    
    NSString *start = [NSString stringWithFormat:@"%ld",(long)self.start];
    NSString *limt = [NSString stringWithFormat:@"%d",kListPageSize];
    
    [YRHttpRequest theUserToCollectByStart:start limit:limt success:^(NSDictionary *data) {
        
        NSArray *array =  [YRProductListModel mj_objectArrayWithKeyValuesArray:data];
        DLog(@"%@",data);
        if (self.start == 0) {
            [self.array removeAllObjects];
        }
        [self.array addObjectsFromArray:array];
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
        [self.tableView.header endRefreshing];
    }];
    
    
}
-(void)setupTableView{
    self.tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT) style:UITableViewStylePlain];
    self.tableView.backgroundColor = RGB_COLOR(245, 245, 245);
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.contentInset = UIEdgeInsetsMake(0, 0, 64, 0);
    [self.view addSubview:self.tableView];
    self.tableView.emptyDataSetSource = self;
    self.tableView.emptyDataSetDelegate = self;
    [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass([YRCollectCell class]) bundle:nil] forCellReuseIdentifier:collectCellID];
    [self.tableView jk_addGifFooterWithRefreshingTarget:self refreshingAction:@selector(footRefresh)];
    [self.tableView jk_addGifHeaderWithRefreshingTarget:self refreshingAction:@selector(headRefresh)];
    [self.tableView.header beginRefreshing];
}
- (void)headRefresh{
    self.start = 0;
    [self loadData];
}
- (void)footRefresh{
    self.start += kListPageSize;
    [self loadData];
}

#pragma mark - UITableViewDelegate & UITableViewDataSource
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.array.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    YRCollectCell *cell = [tableView dequeueReusableCellWithIdentifier:collectCellID];
    YRProductListModel *model = self.array[indexPath.row];
    [cell setUIWithModel:model];
    
    cell.cancelCollectBtnBlock = ^(UIButton *btn){
        btn.selected = !btn.selected;
        if ([model.sysType integerValue]==1) {
            if (btn.selected) {
                NSString *nameId;
                [model.sysType intValue]==1?(nameId = model.infoId):(nameId = model.clubId);
                [YRHttpRequest productAddCollect:nameId like:0 success:^(id data) {
                    [MBProgressHUD showSuccess:@"取消成功"];
                    [self.array removeObject:model];
                    [tableView reloadData];
                } failure:^(NSString *data) {
                    [MBProgressHUD showError:data];
                }];
            }else{
                NSString *nameId;
                [model.sysType intValue]==1?(nameId = model.infoId):(nameId = model.clubId);
                [YRHttpRequest productAddCollect:nameId like:1 success:^(id data) {
                    [MBProgressHUD showSuccess:@"收藏成功"];
                } failure:^(NSString *data) {
                    [MBProgressHUD showError:data];
                }];
            }
        }else{
            if (btn.selected) {
                NSString *nameId;
                [model.sysType intValue]==1?(nameId = model.infoId):(nameId = model.clubId);
                [YRHttpRequest circleAddCollect:nameId like:0 success:^(id data) {
                    [MBProgressHUD showSuccess:@"取消成功"];
                     [self.array removeObject:model];
                    [tableView reloadData];
                } failure:^(NSString *data) {
                    [MBProgressHUD showError:data];
                }];
            }else{
                NSString *nameId;
                [model.sysType intValue]==1?(nameId = model.infoId):(nameId = model.clubId);
                [YRHttpRequest circleAddCollect:nameId like:1 success:^(id data) {
                    [MBProgressHUD showSuccess:@"收藏成功"];
                } failure:^(NSString *data) {
                    [MBProgressHUD showError:data];
                }];
            }
        }
    };
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 172;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    YRProductListModel *model  = self.array[indexPath.row];
    self.model = model;
    YRModelManager *manger = [YRModelManager manager];
    manger.listModel = model;
    if (model.auditStatus==4) {
        [MBProgressHUD showError:@"该作品已下架"];
        return;
    }
    //作品
    if ([model.sysType integerValue]==1) {
        switch (model.infoType) {
            case kInfoTypePictureWord:
            {
                YRImageTextDetailsViewController  *textViewVc = [[YRImageTextDetailsViewController alloc] init];
                textViewVc.productListModel.uid = model.infoId?model.infoId:@"";
                textViewVc.productListModel.urlThumbnail = model.infoThumbnail;
                textViewVc.productListModel.desc = model.infoTitle;
                textViewVc.productListModel.infoIntroduction = model.infoIntroduction;
                
                [self.navigationController pushViewController:textViewVc animated:YES];
            }
                break;
            case kInfoTypeVideo:
            {
                //            YRVidioDetailController  *textViewVc = [[YRVidioDetailController alloc] init];
                //            textViewVc.productListModel.infoId = infoId?infoId:@"";
                //            [self.navigationController pushViewController:textViewVc animated:YES];
                
                YRNewVideoDetailViewController  *newVc = [[YRNewVideoDetailViewController alloc] init];
                newVc.productId = model.infoId?model.infoId:@"";
                newVc.productListModel.urlThumbnail = model.infoThumbnail;
                newVc.productListModel.desc = model.infoTitle;
                newVc.productListModel.infoIntroduction = model.infoIntroduction;
                [self.navigationController pushViewController:newVc animated:YES];
            }
                break;
            case kInfoTypeVoice:
            {
                YRNewAudioDetailViewController  *newVc = [[YRNewAudioDetailViewController alloc] init];
                newVc.productId = model.infoId?model.infoId:@"";;
                newVc.productListModel.urlThumbnail = model.infoThumbnail;
                newVc.productListModel.desc = model.infoTitle;
                newVc.productListModel.infoIntroduction = model.infoIntroduction;
                [self.navigationController pushViewController:newVc animated:YES];
                
            }
                break;
            default:
                break;
        }
        
        
    }else{
     
        NSString          *pid = model.infoId;
        NSString         *cid = model.clubId;
        NSString         *custid = model.custId ? model.custId : @"";
        NSString         *infoTitle = model.infoTitle ? model.infoTitle : @"";
        //
        YRCirleDetailViewController  *cirleVc = [[YRCirleDetailViewController alloc] init];
        cirleVc.circleListModel.infoId = pid?pid:@"";
        cirleVc.circleListModel.clubId = cid?cid:@"";
        cirleVc.circleListModel.custId = custid;
        cirleVc.circleListModel.infoTitle = infoTitle;
        [self.navigationController pushViewController:cirleVc animated:YES];
        
        
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
    NSString *text = @"赶快去收藏作品吧";
    
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
- (NSMutableArray *)array
{
    if (!_array) {
        _array = @[].mutableCopy;
    }
    return _array;
}
@end
