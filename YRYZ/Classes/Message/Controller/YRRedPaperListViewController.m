//
//  YRRedPaperListViewController.m
//  YRYZ
//
//  Created by Rongzhong on 16/7/11.
//  Copyright © 2016年 yryz. All rights reserved.
//

#import "YRRedPaperListViewController.h"

#import "YRRedPaperListView.h"

#import "YRRedListModel.h"

#define cellHeight 60

@interface YRRedPaperListViewController ()
<UITableViewDelegate,UITableViewDataSource,UIScrollViewDelegate>

@property(strong,nonatomic) UINavigationBar *bar;

@property(strong,nonatomic) UILabel *titleLabel;

@property(strong,nonatomic) UIButton *leftButton;


@property(strong,nonatomic) NSMutableArray          *dataList;

@property(strong,nonatomic) UITableView             *redPaperListTableView;
@property(strong,nonatomic) UIView                  *tableHeaderView;
@property(strong,nonatomic) UIImageView             *topBgView;
@property(strong,nonatomic) UILabel                 *tintLabel;

@property (nonatomic,assign) NSInteger              start;
@end

@implementation YRRedPaperListViewController

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES animated:YES];
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:YES];
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault];
}
- (void)setStart:(NSInteger)start{
    if (start < 0) {
        _start = 0;
        return;
    }
    _start = start;
}

- (NSMutableArray*)dataList{
    
    if(!_dataList){
        _dataList = @[].mutableCopy;
    }
    return _dataList;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];

    [self fectRedList];

    [self setupView];
    
    [self setNavbar];
    
}

-(void)setNavbar{
    
    
    _bar = [[UINavigationBar alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 64)];
    
    [_bar setBackgroundImage:[UIImage imageNamed:@"navigationbarBg"] forBarMetrics:UIBarMetricsDefault];
    
    
    _bar.backgroundColor = [UIColor yellowColor];
    
    
    _titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 0, 44)];
    _titleLabel.textColor = RGB_COLOR(255, 226, 159);
    _titleLabel.textAlignment = NSTextAlignmentCenter;
    _titleLabel.text = @"红包";
    [_bar addSubview:_titleLabel];
    
    _leftButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [_leftButton setFrame:CGRectMake(0, 0, 11, 18)];
    [_leftButton setImage:[UIImage imageNamed:@"yr_return"] forState:UIControlStateNormal];
    [_bar addSubview:_leftButton];
        [self initNavBar];
    
    [self.view addSubview:_bar];
}

- (void)initNavBar{
    [self.navigationController setNavigationBarHidden:YES];
    
    _bar = [[UINavigationBar alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 64)];
    
    [_bar setBackgroundImage:[UIImage imageNamed:@"navigationbarBg"] forBarMetrics:UIBarMetricsDefault];
    
    [self performSelector:@selector(delayMethod2) withObject:nil afterDelay:0.5f];
    
    [self.view addSubview:_bar];

}

-(void)delayMethod2
{
    UINavigationItem *item = [[UINavigationItem alloc] init];
    if (_titleLabel) {
        item.titleView = _titleLabel;
    }
    
    if (_leftButton) {
        [_leftButton addTarget:self action:@selector(back) forControlEvents:UIControlEventTouchUpInside];
        UIBarButtonItem *leftItem = [[UIBarButtonItem alloc] initWithCustomView:_leftButton];
        [item setLeftBarButtonItem:leftItem];
    }
    
    [_bar pushNavigationItem:item animated:YES];
}

- (void)back{
    [self.navigationController popViewControllerAnimated:YES];
}


- (void)footRefresh{
    self.start += kListPageSize;
    [self fectRedList];
}


/**
 *  @author weishibo, 16-08-26 17:08:30
 *
 *  查看红包领取详情
 */
- (void)fectRedList{
    
    [YRHttpRequest getRedDetail:self.redId pageNumber:self.start pageSize:kListPageSize success:^(NSDictionary *data) {
        NSArray  *array = [YRRedListModel mj_objectArrayWithKeyValuesArray:data[@"redpackets"]];
        DLog(@"%@",data);
        [self.dataList addObjectsFromArray:array];
        if ([array count] < kListPageSize) {
            self.start -= kListPageSize;
            [self.redPaperListTableView.footer endRefreshingWithNoMoreData];
        }else{
            [self.redPaperListTableView.footer endRefreshing];
        }

        
        if (_dataList.count * cellHeight + 298 < SCREEN_HEIGHT) {
            UIView *tableFooterView = [[UIView alloc]init];
            tableFooterView.frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT - 298 - cellHeight * _dataList.count);
            tableFooterView.backgroundColor = [UIColor whiteColor];
            _redPaperListTableView.tableFooterView = tableFooterView;
        }else{
            _redPaperListTableView.tableFooterView = nil;
        }

        NSInteger  totalCount = [data[@"totalCount"] integerValue];//红包总个数
        NSInteger  reCount = [data[@"reCount"] integerValue];//已录取
        CGFloat  totalAmount = [data[@"totalAmount"] floatValue] * 0.01;
        CGFloat  reAmount = [data[@"reAmount"] floatValue] * 0.01;
        NSString  *str = [NSString stringWithFormat:@"已领取%ld/%ld，共%.2f/%.02f",reCount,totalCount,reAmount,totalAmount];
        self.tintLabel .text =  str;
        [self.redPaperListTableView reloadData];
        [self.redPaperListTableView.header endRefreshing];
        
    } failure:^(id data) {
        [MBProgressHUD showError:data];
    }];
}




-(void)setupView
{
    _tableHeaderView = [[UIView alloc]init];
    _tableHeaderView.frame = CGRectMake(0, 0, SCREEN_WIDTH, 234);
    _tableHeaderView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:_tableHeaderView];
    
    _topBgView = [[UIImageView alloc]init];
    _topBgView.userInteractionEnabled = YES;
    _topBgView.frame = CGRectMake(0 , 0 ,SCREEN_WIDTH, 130);
    _topBgView.image = [UIImage imageNamed:@"topBgImage"];
    [_tableHeaderView addSubview:_topBgView];
    
    
    UIImageView *userPhoteImageView = [[UIImageView alloc]init];
    userPhoteImageView.userInteractionEnabled = YES;
    [userPhoteImageView setImageWithURL:[NSURL URLWithString:[YRUserInfoManager manager].currentUser.custImg] placeholder:[UIImage imageNamed:@"walletImage"]];
    userPhoteImageView.frame = CGRectMake(SCREEN_WIDTH/2.0f -34, 56, 68, 68);
    [userPhoteImageView setCircleHeadWithPoint:CGPointMake(68, 68) radius:34];
    [_topBgView addSubview:userPhoteImageView];
    
    
    NSString *nickName = [YRUserInfoManager manager].showUserName;
    NSMutableAttributedString *nameString= [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"%@的红包",nickName]];
    
    [nameString addAttribute:NSForegroundColorAttributeName
                       value:[UIColor themeColor]
                       range:NSMakeRange(0, nickName.length)];
    
    
    UILabel *nameLabel = [[UILabel alloc]init];
    nameLabel.frame = CGRectMake(0, 146, SCREEN_WIDTH, 18);
    nameLabel.textColor = [UIColor wordColor];
    nameLabel.attributedText = nameString;
    nameLabel.textAlignment = NSTextAlignmentCenter;
    nameLabel.font = [UIFont titleFont18];
    [_tableHeaderView addSubview:nameLabel];
    
    UIView *listTintView = [[UIView alloc]init];
    listTintView.frame = CGRectMake(0, 194, SCREEN_WIDTH, 40);
    listTintView.backgroundColor = [UIColor colorWithR:246 g:246 b:246 a:1.0];
    [_tableHeaderView addSubview:listTintView];
    
    
    self.tintLabel = [[UILabel alloc]init];
    self.tintLabel .frame = CGRectMake(10, 13, SCREEN_WIDTH - 10, 14);
    self.tintLabel .text = @"已领取红包0/0，共0/0.00";
    self.tintLabel .textColor = [UIColor grayColorTwo];
    self.tintLabel .font = [UIFont titleFont14];
    [listTintView addSubview:self.tintLabel ];
    
    _redPaperListTableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 64, SCREEN_WIDTH, SCREEN_HEIGHT - 64)];
    _redPaperListTableView.backgroundColor = [UIColor clearColor];
    _redPaperListTableView.delegate = self;
    _redPaperListTableView.showsVerticalScrollIndicator = NO;
    _redPaperListTableView.dataSource = self;
    _redPaperListTableView.tableHeaderView = _tableHeaderView;
    _redPaperListTableView.separatorStyle = NO;
    [self.view addSubview:_redPaperListTableView];
    
    
//    @weakify(self);
//    [_redPaperListTableView mas_makeConstraints:^(MASConstraintMaker *make) {
//        @strongify(self);
//        make.edges.equalTo(self.view).insets(UIEdgeInsetsMake(64, 0, 0, 0));
//    }];
    

    [_redPaperListTableView jk_addGifFooterWithRefreshingTarget:self refreshingAction:@selector(footRefresh)];
}

#pragma mark - Table view data source

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return cellHeight;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataList.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellWithIdentifier = @"Cell";
    
    YRRedListModel  *model = self.dataList[indexPath.row];

    UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellWithIdentifier];
   
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:CellWithIdentifier];
        cell.accessoryType = UITableViewCellAccessoryNone;
        cell.backgroundColor = [UIColor whiteColor];
        
        UIImageView *userImageView = [[UIImageView alloc]init];
        userImageView.userInteractionEnabled = YES;
        [userImageView setImageWithURL:[NSURL URLWithString:model.headImg] placeholder:[UIImage defaultHead]];
        userImageView.frame = CGRectMake(10, 12, 36, 36);
        [userImageView setCircleHeadWithPoint:CGPointMake(36, 36) radius:4];
        [cell.contentView addSubview:userImageView];
        
        UILabel *nameLabel = [[UILabel alloc]init];
        nameLabel.frame = CGRectMake(55, 12, 200, 17);
        nameLabel.text = model.nickName;
        nameLabel.textColor = [UIColor wordColor];
        nameLabel.font = [UIFont titleFont17];
        [cell.contentView addSubview:nameLabel];
        
        UILabel *timeLabel = [[UILabel alloc]init];
        timeLabel.frame = CGRectMake(55, 35, 150, 15);
        timeLabel.text = [NSString getTimeFormatterWithString:model.rsTime];
        timeLabel.textColor = [UIColor grayColorTwo];
        timeLabel.font = [UIFont titleFont15];
        [cell.contentView addSubview:timeLabel];
        
        UILabel *moneyLabel = [[UILabel alloc]init];
        moneyLabel.frame = CGRectMake(SCREEN_WIDTH - 160, 0, 150, 60);
        float   fee = model.fee *0.01;
        moneyLabel.text = [NSString stringWithFormat:@"%.2f",fee];
        moneyLabel.textColor = [UIColor wordColor];
        moneyLabel.textAlignment = NSTextAlignmentRight;
        moneyLabel.font = [UIFont titleFont17];
        [cell.contentView addSubview:moneyLabel];
        
        UILabel *lineLabel = [[UILabel alloc]init];
        lineLabel.frame = CGRectMake(0, cellHeight - 0.5, SCREEN_WIDTH, 0.5);
        lineLabel.backgroundColor = RGB_COLOR(221, 221, 221);
        [cell.contentView addSubview:lineLabel];
 
//    _redPaperListTableView.contentSize = CGSizeMake(SCREEN_WIDTH, 234 + cellHeight * 3);
    return cell;
}


-(void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    
    
    if (scrollView.contentOffset.y < 0 ) {
        
        scrollView.backgroundColor = RGB_COLOR(226, 57, 46);
        
    }else if(scrollView.contentOffset.y > 0){
        scrollView.backgroundColor = [UIColor whiteColor];
    }
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
   [tableView deselectRowAtIndexPath:indexPath animated:YES];
    YRRedListModel  *model = self.dataList[indexPath.row];
    [self pushUserInfoViewController:model.custId withIsFriend:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
