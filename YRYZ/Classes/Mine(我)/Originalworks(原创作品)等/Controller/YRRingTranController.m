//
//  YRRingTranController.m
//  YRYZ
//
//  Created by 易超 on 16/7/19.
//  Copyright © 2016年 yryz. All rights reserved.
//

#import "YRRingTranController.h"
#import "YRRingTranCell.h"
#import "YRMyWorksCell.h"

#import "YRRingNextTranCell.h"
#import "YRCirleDetailViewController.h"
#import "YRAddNewGroupViewController.h"
#import "RRZMineMyInfoController.h"
static NSString *myWorksCellID = @"MyWorksCellID2";
static NSString *ringTranCellID = @"YRRingTranCellID";
@interface YRRingTranController ()
<UITableViewDelegate,UITableViewDataSource>

@property (strong, nonatomic) UITableView       *tableView;

@property (nonatomic,assign) NSInteger start;

@property (nonatomic,strong) NSMutableArray *dataArray;
/***首转发**/
@property (nonatomic,copy) NSNumber *forwardCount;
/**被转发**/
@property (nonatomic,copy) NSNumber *toForwardCount;
/*收益额***/
@property (nonatomic,copy) NSNumber *toForwardBonud;
@end

@implementation YRRingTranController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationController.navigationBar.hidden = YES;
    [self configHeader];
    [self setTitle:@"圈子转发"];

    [self setupTableView];
    [self loadFirstData];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    //    self.navigationController.navigationBar.hidden = YES;
    [self.navigationController setNavigationBarHidden:YES animated:YES];
}
- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    //    self.navigationController.navigationBar.hidden = NO;
    [self.navigationController setNavigationBarHidden:NO animated:YES];
}
- (void)loadFirstData{
    [YRHttpRequest getkUserForwardMoneyCustId:[YRUserInfoManager manager].currentUser.custId success:^(NSDictionary *data) {
        self.forwardCount = data[@"forwardCount"];
        self.toForwardCount = data[@"toForwardCount"];
        self.toForwardBonud = data[@"toForwardBonud"];
        [self.tableView reloadData];
    } failure:^(NSString *error) {
        
    }];
    
    
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
    title.text = @"圈子转发";
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
    
    UserModel *model = [YRUserInfoManager manager].currentUser;
    NSInteger width =150;
    if (model.custNname.length>=8) {
        width = 180;
        userName.font = [UIFont systemFontOfSize:15];
    }else{
        userName.font = [UIFont titleFont16];
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
    allMoney.text = @"";
    [userImage setImageWithURL:[NSURL URLWithString:model.custImg] placeholder:[UIImage defaultHead]];
    userName.text = model.custNname;
    userImage.userInteractionEnabled = YES;
    
//    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(doTap:)];
//    [userImage addGestureRecognizer:tap];
    userName.font = [UIFont titleFont16];
}
- (void)doTap:(UITapGestureRecognizer *)tap{
    
    RRZMineMyInfoController *userInfo = [[RRZMineMyInfoController alloc]init];
    [self.navigationController pushViewController:userInfo animated:YES];
}

- (void)leftButtonClick:(UIButton *)sender{
    [self.navigationController popViewControllerAnimated:YES];
}
- (void)loadData{
    
    NSString *sat = [NSString stringWithFormat:@"%ld",self.start];
    NSString *limit = [NSString stringWithFormat:@"%d",kListPageSize];
    @weakify(self);
    [YRHttpRequest getForMyFnformationByWhatType:kForwardingTheCircle start:sat  limin:limit  custId:[YRUserInfoManager manager].currentUser.custId success:^(NSDictionary *data) {
        
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
        
    }];
}

-(void)setupTableView{
    self.tableView = [[UITableView alloc]initWithFrame:CGRectMake(0,210, SCREEN_WIDTH, SCREEN_HEIGHT-210) style:UITableViewStylePlain];
    self.tableView.backgroundColor = RGB_COLOR(245, 245, 245);
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.contentInset = UIEdgeInsetsMake(0, 0, 64, 0);
    [self.view addSubview:self.tableView];
    
    [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass([YRRingTranCell class]) bundle:nil] forCellReuseIdentifier:ringTranCellID];
    [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass([YRRingNextTranCell class]) bundle:nil] forCellReuseIdentifier:myWorksCellID];
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
    return self.dataArray.count+1;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row == 0) {
        YRRingTranCell *cell = [tableView dequeueReusableCellWithIdentifier:ringTranCellID];
        if (self.forwardCount) {
            cell.fristTranLabel.text = [NSString stringWithFormat:@"%@",self.forwardCount];
            cell.byTranLabel.text = [NSString stringWithFormat:@"%.2f",[self.toForwardBonud floatValue]/100];
            cell.lucreLabel.text = [NSString stringWithFormat:@"%@",self.toForwardCount];
            
            
        }
        return cell;
    }else{
        YRRingNextTranCell *cell = [tableView dequeueReusableCellWithIdentifier:myWorksCellID];
        YRCircleListModel *model = self.dataArray[indexPath.row-1];
        cell.chooseBtn = ^(BOOL isChoose){
            if (isChoose) {
                YRAddNewGroupViewController *newChatVc = [[YRAddNewGroupViewController alloc] init];
                newChatVc.title = @"邀请转发";
                newChatVc.infoId = model.clubId;
                newChatVc.type = 2;
                [self.navigationController pushViewController:newChatVc animated:YES];
            }
        };
        [cell setUIWithModel:model];
        return cell;
    }
    
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row == 0) {
        return 60;
    }else{
        return 145;
    }
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (self.dataArray.count>0) {
        if (indexPath.row == 0) {
            
        }
        else{
            YRCircleListModel *model = self.dataArray[indexPath.row-1];
            if (model.auditStatus==4) {
                [MBProgressHUD showError:@"该作品已下架"];
            }else{
                YRCirleDetailViewController *cirleVc = [[YRCirleDetailViewController alloc] init];
                cirleVc.circleListModel = model;
                NSString *title = cirleVc.circleListModel.infoIntroduction;
                CGFloat h = [title heightForStringfontSize:18.f];
                cirleVc.commentHeigt = h;
                [self.navigationController pushViewController:cirleVc animated:YES];
            }
        }
    }
}

- (NSMutableArray *)dataArray
{
    if (!_dataArray) {
        _dataArray = [[NSMutableArray alloc]init];
    }
    return _dataArray;
}
- (void)viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:animated];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"deleteAudioNotifier" object:nil];
}

- (void)dealloc{
    
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

@end
