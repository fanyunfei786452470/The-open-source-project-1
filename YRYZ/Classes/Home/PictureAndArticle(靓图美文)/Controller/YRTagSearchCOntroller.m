//
//  YRTagSearchCOntroller.m
//  YRYZ
//
//  Created by weishibo on 16/9/3.
//  Copyright © 2016年 yryz. All rights reserved.
//

#import "YRTagSearchCOntroller.h"
#import "YRSearchTagTableViewCell.h"
#import "YRProductListModel.h"
#import "YRImageTextDetailsViewController.h"
@interface YRTagSearchCOntroller()
<UITableViewDelegate,UITableViewDataSource,DZNEmptyDataSetSource, DZNEmptyDataSetDelegate>

@property (strong, nonatomic) UITableView       *tableView;


@property (strong, nonatomic) NSMutableArray           *dataArray;
@property (nonatomic, assign)NSInteger                 start;
@property (nonatomic ,strong)YRProductListModel        *productModel;

@end
@implementation YRTagSearchCOntroller


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

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"标签搜索";
    
    [self setupTableView];
    
}


- (void)fectData{
    
    
    @weakify(self);
    
    [YRHttpRequest getTagsInfoByList:kInfoTypePictureWord tag:self.tagId start:self.start limit:kListPageSize success:^(id data) {
        @strongify(self);
        
        NSArray  *array =  [YRProductListModel mj_objectArrayWithKeyValuesArray:data];
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
        
    } failure:^(id data) {
        [MBProgressHUD showError:data];
        [self.tableView.header beginRefreshing];
    }];
    
}

-(void)setupTableView{
    self.tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT) style:UITableViewStylePlain];
    self.tableView.backgroundColor = RGB_COLOR(245, 245, 245);
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
    self.tableView.contentInset = UIEdgeInsetsMake(0, 0, 64, 0);
    [self.view addSubview:self.tableView];
    [self.tableView setExtraCellLineHidden];
    self.tableView.emptyDataSetSource = self;
    self.tableView.emptyDataSetDelegate = self;
    
    [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass([YRSearchTagTableViewCell class]) bundle:nil] forCellReuseIdentifier:@"YRSearchTagTableViewCellID"];
    
    
    [self.tableView jk_addGifFooterWithRefreshingTarget:self refreshingAction:@selector(footRefresh)];
    [self.tableView jk_addGifHeaderWithRefreshingTarget:self refreshingAction:@selector(headRefresh)];
    [self.tableView.header beginRefreshing];
}





#pragma mark - UITableViewDelegate & UITableViewDataSource


- (UIView*)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    
    UIView *view = [[UIView alloc] init];
    view.backgroundColor = [UIColor whiteColor];
    
    
    
    UIImageView  *lineImageView = [[UIImageView alloc] initWithFrame:CGRectMake(10, 10, 2, 16)];
    lineImageView.backgroundColor = [UIColor themeColor];
    [view addSubview:lineImageView];
    
    
    
    UILabel  *label = [[UILabel alloc] initWithFrame:CGRectMake(15, 10, SCREEN_WIDTH - 25, 16)];
    NSString *tagStr = [NSString stringWithFormat:@"“%@”",self.tagStr];
    label.text = [NSString stringWithFormat:@"含有 %@ 标签的文章",tagStr];
    label.textAlignment = NSTextAlignmentLeft;
    label.textColor = RGB_COLOR(153, 153, 153);
    [view addSubview:label];
    
    
    return view;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    
    return 30;
    
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataArray.count;
}


-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    YRSearchTagTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"YRSearchTagTableViewCellID"];
    [cell setProductModel:self.dataArray[indexPath.row]];
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 95;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    YRProductListModel  *model = self.dataArray[indexPath.row];
    switch (self.productType) {
        case kInfoTypePictureWord:
        {
            YRImageTextDetailsViewController *imageVc = [[YRImageTextDetailsViewController alloc] init];
            imageVc.productListModel = model;
            [self.navigationController pushViewController:imageVc animated:YES];
        
        }
            break;
            
        default:
            break;
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
    NSString *text = @"点击加载";
    
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




@end
