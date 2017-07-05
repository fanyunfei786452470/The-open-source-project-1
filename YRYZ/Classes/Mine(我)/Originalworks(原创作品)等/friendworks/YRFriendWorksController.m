//
//  YRFriendWorksController.m
//  YRYZ
//
//  Created by Sean on 16/9/20.
//  Copyright © 2016年 yryz. All rights reserved.
//

#import "YRFriendWorksController.h"
#import "YRMyWorksController.h"
#import "YRMyWorksCell.h"
#import "YRMyWorksHeadView.h"


#import "YRImageTextDetailsViewController.h"
#import "YRVidioDetailController.h"
#import "YRAudioDetailController.h"
#import "RRZMineMyInfoController.h"
static NSString *cellID = @"YRMyWorksCellID";
@interface YRFriendWorksController ()<UITableViewDelegate,UITableViewDataSource>
@property (strong, nonatomic) UITableView       *tableView;

@property (nonatomic,assign) NSInteger start;

@property (nonatomic,strong) NSMutableArray *dataArray;
@end

@implementation YRFriendWorksController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self configHeader];
    [self setupTableView];
}
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.tableView reloadData];
     [self.navigationController setNavigationBarHidden:YES animated:YES];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"deleteAudioNotifier" object:nil];

}
- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
   [self.navigationController setNavigationBarHidden:NO animated:YES];
}
- (void)loadData{
    
    @weakify(self);
    
    NSString *sta = [NSString stringWithFormat:@"%ld",(NSInteger)self.start];
    
    NSString *limt = [NSString stringWithFormat:@"%d",kListPageSize];
    [YRHttpRequest listOfWorksForStart:sta limit:limt custId:self.custId success:^(id data) {
        
        @strongify(self);
        DLog(@"%@",data);
        //NSArray  *array =  [YRProductListModel mj_objectArrayWithKeyValuesArray:data];
        NSMutableArray *array = [[NSMutableArray alloc]init];
        for (int i = 0; i<[(NSArray *)data count]; i++) {
            YRProductListModel *model = [[YRProductListModel alloc]mj_setKeyValues:(NSArray *)data[i]];
            if (model.auditStatus==3) {
                [array addObject:model];
            }
        }
        
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
- (void)headRefresh{
    self.start = 0;
    [self loadData];
}
- (void)footRefresh{
    self.start += kListPageSize;
    [self loadData];
}
- (void)configHeader{
    //    self.view.backgroundColor = [UIColor redColor];
    UIImageView *bgImage = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 210)];
    //    bgImage.backgroundColor = [UIColor randomColor];
    
    bgImage.image = [UIImage imageNamed:@"yr_red_user_bg"];
    [self.view addSubview:bgImage];
    bgImage.userInteractionEnabled = YES;
    
    UIButton *leftButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [leftButton setImage:[UIImage imageNamed:@"backIndicatorImage"] forState:UIControlStateNormal];
    [bgImage addSubview:leftButton];
    [leftButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view).mas_offset(5);
        make.top.equalTo(self.view).mas_offset(20);
        make.size.mas_equalTo(CGSizeMake(40, 40));
    }];
    
    [leftButton addTarget:self action:@selector(leftButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    
    UILabel *title = [[UILabel alloc]init];
    title.text = @"原创作品";
    title.textAlignment = NSTextAlignmentCenter;
    title.textColor = [UIColor whiteColor];
    title.font = [UIFont systemFontOfSize:19];
    [bgImage addSubview:title];
    
    [title mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(leftButton);
        make.centerX.equalTo(self.view);
        make.size.mas_equalTo(CGSizeMake(150, 40));
    }];
    
    UIImageView *userImage =[[UIImageView alloc]init];
    userImage.backgroundColor = [UIColor randomColor];
    [bgImage addSubview:userImage];
    [userImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(title);
        make.top.equalTo(title.mas_bottom).mas_offset(10);
        make.size.mas_equalTo(CJSizeMake(60, 60));
    }];
    userImage.layer.cornerRadius = 30*SCREEN_POINT;
    userImage.clipsToBounds = YES;
    
    
    UILabel *userName = [[UILabel alloc]init];
    userName.textAlignment = NSTextAlignmentCenter;
    userName.text = @"珊惬意苏黎世";
    userName.textColor = [UIColor whiteColor];
    userName.backgroundColor = RGBA_COLOR(0, 71, 70, 0.75);
    [bgImage addSubview:userName];
    
    NSInteger width =150;
    NSString *str =  self.model.nameNotes?(self.model.nameNotes):(self.model.custNname);
    if (str.length>=8) {
        width = 180;
        userName.font = [UIFont systemFontOfSize:15];
    }
    
    
    [userName mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(userImage);
        make.top.equalTo(userImage.mas_bottom).mas_offset(10);
        make.size.mas_equalTo(CJSizeMake(width, 30));
    }];
    userName.layer.cornerRadius = 15*SCREEN_POINT;
    userName.clipsToBounds = YES;
    
    UILabel *allMoney = [[UILabel alloc]init];
    allMoney.textAlignment = NSTextAlignmentCenter;
    //    allMoney.text = @"坚持减肥,加油胜利就在眼前,加油坚持减肥";
    allMoney.textColor = [UIColor whiteColor];
    //    allMoney.font = [UIFont boldSystemFontOfSize:15];
    allMoney.font = [UIFont systemFontOfSize:15];
    [bgImage addSubview:allMoney];
    [allMoney mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(userName);
        make.top.equalTo(userName.mas_bottom).mas_offset(5);
        make.size.mas_equalTo(CGSizeMake(SCREEN_WIDTH-50, 30));
    }];
    self.model.nameNotes?(userName.text = self.model.nameNotes):(userName.text = self.model.custNname);
    [userImage setImageWithURL:[NSURL URLWithString:self.model.custImg] placeholder:[UIImage defaultHead]];
    allMoney.text = self.model.custDesc;
     allMoney.text = @"";
     userName.font = [UIFont titleFont16];
}
 

- (void)leftButtonClick:(UIButton *)sender{
    [self.navigationController popViewControllerAnimated:YES];
}


-(void)setupTableView{
    self.tableView = [[UITableView alloc]initWithFrame:CGRectMake(0,210, SCREEN_WIDTH, SCREEN_HEIGHT-210) style:UITableViewStylePlain];
    self.tableView.backgroundColor = RGB_COLOR(245, 245, 245);
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.contentInset = UIEdgeInsetsMake(0, 0, 64, 0);
    [self.view addSubview:self.tableView];
    //    [self setHeaderView];
    [self.tableView jk_addGifFooterWithRefreshingTarget:self refreshingAction:@selector(footRefresh)];
    [self.tableView jk_addGifHeaderWithRefreshingTarget:self refreshingAction:@selector(headRefresh)];
    [self.tableView.header beginRefreshing];
    [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass([YRMyWorksCell class]) bundle:nil] forCellReuseIdentifier:cellID];
}

-(void)setHeaderView{
    YRMyWorksHeadView *headView = [[YRMyWorksHeadView alloc]init];
    headView.height = 86;
    self.tableView.tableHeaderView = headView;
}

#pragma mark - UITableViewDelegate & UITableViewDataSource
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return self.dataArray.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    YRMyWorksCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    YRProductListModel *model = self.dataArray[indexPath.row ];
    [cell setUIWithModle:model];
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 110;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (self.dataArray.count>0) {
        YRProductListModel *model  = self.dataArray[indexPath.row];
        if (model.auditStatus==4) {
            [MBProgressHUD showError:@"该作品已下架"];
        }else{
            switch (model.type) {
                case kInfoTypePictureWord:
                {
                    YRImageTextDetailsViewController  *textViewVc = [[YRImageTextDetailsViewController alloc] init];
                    textViewVc.productListModel = model;
                    [self.navigationController pushViewController:textViewVc animated:YES];
                }
                    break;
                case kInfoTypeVideo:
                {
                    YRVidioDetailController  *textViewVc = [[YRVidioDetailController alloc] init];
                    textViewVc.productListModel = model;
                    CGFloat h = [model.infoIntroduction heightForStringfontSize:18.f];
                    textViewVc.commentHeigt = h;
                    [self.navigationController pushViewController:textViewVc animated:YES];
                }
                    break;
                case kInfoTypeVoice:
                {
                    YRAudioDetailController  *textViewVc = [[YRAudioDetailController alloc] init];
                    
                    textViewVc.productListModel = model;
                    CGFloat h = [model.infoIntroduction heightForStringfontSize:18.f];
                    textViewVc.commentHeigt = h;
                    [self.navigationController pushViewController:textViewVc animated:YES];
                }
                    break;
                default:
                    break;
            }
        }
    }
}
- (void)viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:animated];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"deleteAudioNotifier" object:nil];
}

- (void)dealloc{
    
    [[NSNotificationCenter defaultCenter] removeObserver:self];
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

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
