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
#import "YRSearchResultController.h"
#import "RRZSaveMoneyController.h"
#import "YRPaymentPasswordView.h"
#import "YRAddNewGroupViewController.h"
#import "YRChangePayPassWordController.h"
#import "YRRedPaperListViewController.h"
#import "YRLoginController.h"
#import "YRCircleEarningsView.h"
#import "YRCircleFriendEarningView.h"
#import "NSMutableDictionary+Extension.h"
#import "YC_ScrollNav.h"
static NSString *cellID = @"CircleViewCellID";
@interface YRCircleViewController ()
<UITableViewDelegate,UITableViewDataSource,YRImageTextCircleCellDelegate,DZNEmptyDataSetSource, DZNEmptyDataSetDelegate,UISearchBarDelegate,UISearchControllerDelegate,LoginSuccessDelegate,TranSuccessDelegate,YRCircleEarningsViewDelegate,YRCircleFriendEarningViewDelegate,BaseScrollNavDelegate>

@property (strong, nonatomic) UITableView               *tableView;
@property (nonatomic,strong) RewardGiftView             *rewardGiftView;
@property (strong, nonatomic) NSMutableArray            *dataArray;
@property (nonatomic, assign)NSInteger                  start;
@property (nonatomic ,strong)YRRedListModel             *redModel;
@property (nonatomic ,assign)BOOL                       isLogin;
@property (nonatomic ,assign)FriendsType                friendsType;
@property (nonatomic ,strong)UISearchController         *searchController;
//是否设置支付密码
@property (nonatomic, assign) BOOL                      havePassword;
//小额免密开关
@property (nonatomic, assign) BOOL                      smallNopass;


@property (nonatomic, assign) NSInteger                 indexId;
@property (nonatomic,copy) void  (^isHavePassword)(BOOL isHavePassword);
@property (nonatomic,strong)YRProductListModel          *productModel;


@property (nonatomic,assign) NSInteger     baseSelectController;

//@property (nonatomic,weak) UIButton         *tranBtn;

@property (nonatomic,weak) UITableViewCell *tranCell;

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


- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"deleteAudioNotifier" object:nil];

}


- (void)baseScrollNavDelegate:(NSInteger)obj{

}

-(void)changeData:(NSNotification *)text{
//    NSMutableArray *newDataArray = [[NSMutableArray alloc]init];
    for (YRCircleListModel *circleModel in _dataArray) {
        if ([circleModel.clubId isEqualToString:text.object]) {
            [self fectChannelNum];
            //circleModel.forwardStatus = 1;
        }
    }

    [_tableView reloadData];
}

-(void)changeUserData{
    NSString *key = [NSString stringWithFormat:@"%@%@%ld",NSStringFromClass([self class]),[YRUserInfoManager manager].currentUser.custId,(long)self.friendsType];
    self.dataArray = (NSMutableArray *)[[YRYYCache share].yyCache objectForKey:key];
    //如果没有缓存重新拉取数据
    if (self.dataArray.count == 0) {
        [self.tableView.header beginRefreshing];
    }else{
    [_tableView reloadData];
}
}
-(void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}


- (void)setIsLogin:(BOOL)isLogin{
    
    _isLogin = isLogin;
    
    if (isLogin) {
        if (self.friendsType != kAllFriends) {
            [self setupTableView];
        }else{
            [self.tableView reloadData];
        }
    }else{
        if (self.friendsType != kAllFriends) {
            [self.tableView removeAllSubviews];
            self.tableView = nil;
            [self touristsView];
        }else{
            [self.tableView reloadData];
        }
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    NSNotificationCenter * center = [NSNotificationCenter defaultCenter];
    //添加当前类对象为一个观察者，name和object设置为nil，表示接收一切通知
    [center addObserver:self selector:@selector(changeData:) name:@"123" object:nil];
    [center addObserver:self selector:@selector(changeUserData) name:@"changeCircleData" object:nil];
    
    
    [self setRightNavButtonWithImage:[UIImage imageNamed:@"yr_navButton_more"]];
    
    
    if ([self.title isEqualToString:@"全部"]) {
        self.friendsType = kAllFriends;
        [self setupTableView];
        [self fectChannelNum];
    } else if ([self.title isEqualToString:@"好友"]) {
        [self fectChannelNum];
        self.friendsType = kGoodFriend;
        if ([YRUserInfoManager manager].currentUser.custId){
            [self setupTableView];
        }else{
            [self touristsView];
        }
    }else if ([self.title isEqualToString:@"关注"]) {
        self.friendsType = KRegard;
        [self fectChannelNum];
        if ([YRUserInfoManager manager].currentUser.custId){
            [self setupTableView];
        }else{
            [self touristsView];
        }
        
    }
    
    
    @weakify(self);
    [[[NSNotificationCenter defaultCenter] rac_addObserverForName:TranSuccess_Cirle_Notification_Key object:nil] subscribeNext:^(NSNotification *notification) {
        @strongify(self);
        [self fectChannelNum];
    }];
    
    
    //    [[[NSNotificationCenter defaultCenter] rac_addObserverForName:BaseSelectControllerIndex object:@()] subscribeNext:^(NSNotification *notification) {
    //
    //    }];
    
}

/*
 - (void)changeData{
 NSString *key = [NSString stringWithFormat:@"%@%ld",NSStringFromClass([self class]),(long)self.friendsType];
 [[YRYYCache share].yyCache setObject:nil forKey:key];
 self.dataArray = (NSMutableArray *)[[YRYYCache share].yyCache objectForKey:key];
 }*/



//改变的字段

- (void)fectChannelNum{
    
    NSMutableArray *arr =@[].mutableCopy;
    
    
    NSString *key = [NSString stringWithFormat:@"%@%@%ld",NSStringFromClass([self class]),[YRUserInfoManager manager].currentUser.custId,(long)self.friendsType];
    self.dataArray = (NSMutableArray *)[[YRYYCache share].yyCache objectForKey:key];
    
    
    [self.dataArray enumerateObjectsUsingBlock:^(YRCircleListModel *circleModel, NSUInteger idx, BOOL * _Nonnull stop) {
        [arr addObject:circleModel.clubId];
    }];
    
    [YRHttpRequest circleClubBonud:arr success:^(NSArray   *data) {
        NSArray  *array =  [YRCircleListModel mj_objectArrayWithKeyValuesArray:data];
        [array enumerateObjectsUsingBlock:^(YRCircleListModel *newCircleModel, NSUInteger idx, BOOL * _Nonnull stop) {
            [self.dataArray enumerateObjectsUsingBlock:^(YRCircleListModel *circleModel, NSUInteger idx, BOOL * _Nonnull stop) {
                if ([newCircleModel.clubId isEqualToString:circleModel.clubId]) {
                    circleModel.transferBonud = newCircleModel.transferBonud;
                    circleModel.transferCount = newCircleModel.transferCount;
                    circleModel.forwardStatus = newCircleModel.forwardStatus;
                }
            }];
            
        }];
        
        [[YRYYCache share].yyCache removeObjectForKey:key];
        [[YRYYCache share].yyCache setObject:self.dataArray forKey:key];
        
        [self.tableView reloadData];
    } failure:^(id data) {
        [MBProgressHUD showError:data];
    }];
    
}
-(void)setupTableView{
    
    self.tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT - 104) style:UITableViewStylePlain];
    self.tableView.backgroundColor = RGB_COLOR(245, 245, 245);
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.emptyDataSetSource = self;
    self.tableView.emptyDataSetDelegate = self;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:self.tableView];
    [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass([YRImageTextCell class]) bundle:nil] forCellReuseIdentifier:cellID];

    
    [self.tableView jk_addGifFooterWithRefreshingTarget:self refreshingAction:@selector(footRefresh)];
    [self.tableView jk_addGifHeaderWithRefreshingTarget:self refreshingAction:@selector(headRefresh)];
    [self.tableView.header beginRefreshing];
    
    
    self.searchController = [[UISearchController alloc] initWithSearchResultsController:nil];
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
    self.tableView.tableHeaderView = self.searchController.searchBar;
    
}


- (void)headRefresh
{
    self.start = 0;
    NSString *key = [NSString stringWithFormat:@"%@%@%ld",NSStringFromClass([self class]),[YRUserInfoManager manager].currentUser.custId,(long)self.friendsType];
    self.dataArray = (NSMutableArray *)[[YRYYCache share].yyCache objectForKey:key];
    YRCircleListModel *model = self.dataArray.firstObject;
    self.indexId = model.indexId;
    [self fectCircleList];
}

- (void)footRefresh
{
    
    self.start = self.dataArray.count;
    self.indexId = 0;
    [self fectCircleList];
}

/**
 *  @author weishibo, 16-09-08 17:09:04
 *
 *  新数据
 */
- (void)fectCircleList{
    @weakify(self);
    [YRHttpRequest circleList:self.friendsType  start:self.start limit:kListPageSize indexId:self.indexId success:^(NSArray *data) {
        @strongify(self);
        NSArray  *array =  [YRCircleListModel mj_objectArrayWithKeyValuesArray:data];
        if(self.start ==0){
            [self.view  addSubview:[self  addUpdateNumTodo:array.count]];
            
               NSString *key = [NSString stringWithFormat:@"%@%@%ld",NSStringFromClass([self class]),[YRUserInfoManager manager].currentUser.custId,(long)self.friendsType];
            self.dataArray = (NSMutableArray *)[[YRYYCache share].yyCache objectForKey:key];
            if (array.count > 0) {
                [self.dataArray insertObjects:array atIndex:0];
            }
        }
        if (self.start  > 0) {
            {
                if ([array count] < kListPageSize) {
                    self.start -= kListPageSize;
                    [self.tableView.footer endRefreshingWithNoMoreData];
                }else{
                    [self.tableView.footer endRefreshing];
                }
                [self.dataArray addObjectsFromArray:array];
            }
        }
        
        [self.tableView reloadData];
        [self.tableView.header endRefreshing];
        
        
        NSString *key = [NSString stringWithFormat:@"%@%@%ld",NSStringFromClass([self class]),[YRUserInfoManager manager].currentUser.custId,(long)self.friendsType];
        [[YRYYCache share].yyCache setObject:self.dataArray forKey:key];
        
        
    } failure:^(NSString *error) {
        [MBProgressHUD showError:error];
        [self.tableView.header endRefreshing];
        [self.tableView.footer endRefreshing];
    }];
    
}


- (void)queryPassWord{
    
    [YRHttpRequest QueryThePaymentPasswordSuccess:^(NSDictionary *data) {
        //是否设置支付密码
        self.havePassword = [data[@"isPayPassword"] boolValue];
        //小额免密开关
        self.smallNopass = [data[@"smallNopass"] boolValue];
        
        if (!self.havePassword) {
            
            YRAlertView *alertView = [[YRAlertView alloc] initWithTitle:@"请先设置支付密码" cancelButtonText:@"取消" confirmButtonText:@"确认"];
            
            alertView.addCancelAction = ^{
                
            };
            alertView.addConfirmAction = ^{
                YRChangePayPassWordController *payVc = [[YRChangePayPassWordController alloc]init];
                payVc.title = @"设置支付密码";
                [self.navigationController pushViewController:payVc animated:YES];
            };
            [alertView show];
            self.tranCell.userInteractionEnabled = YES;
            return;
        }else{
            if (self.isHavePassword) {
                self.isHavePassword(YES);
            }
        }
        
    } failure:^(NSString *error) {
        
        [MBProgressHUD showError:error];
    }];
    
}

- (void)loginSuccessDelegate:(UserModel *)userModel{
    NSString *custId = userModel.custId;
    if (custId.length > 0) {
        self.isLogin = YES;
    }else{
        self.isLogin = NO;
    }
}


#pragma mark --- tranSuccessDelegate

- (void)tranSuccessDelegate:(YRProductListModel *)productListModel circleListModel:(YRCircleListModel *)circleListModel indexPosition:(NSInteger)indexPosition{

    NSString *key = [NSString stringWithFormat:@"%@%@%ld",NSStringFromClass([self class]),[YRUserInfoManager manager].currentUser.custId,(long)self.friendsType];
    if (indexPosition >= 0 && circleListModel) {
        [[YRYYCache share].yyCache removeObjectForKey:key];
        [self.dataArray replaceObjectAtIndex:indexPosition withObject:circleListModel];
        [[YRYYCache share].yyCache setObject:self.dataArray forKey:key];
        
    }
    
    
    circleListModel.transferCount = circleListModel.transferCount + 1;
    circleListModel.transferBonud = circleListModel.transferBonud + 0.83 * 100;
    
    [self.tableView reloadData];
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
    YRImageTextCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    cell.circledelegate = self;
    if (self.dataArray.count > 0) {
        [cell setCircleModel:self.dataArray[indexPath.row] indexPosition:indexPath.row];
        YRCircleListModel *model = self.dataArray[indexPath.row];
        model.indexPath = indexPath;
    }
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 217;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];


        YRCircleListModel *model = self.dataArray[indexPath.row];
        YRCirleDetailViewController *cirleVc = [[YRCirleDetailViewController alloc] init];
        cirleVc.circleListModel =model;
        [self.navigationController pushViewController:cirleVc animated:YES];

}

#pragma mark DZNEmptyDataSetSource

- (NSAttributedString *)titleForEmptyDataSet:(UIScrollView *)scrollView
{
    NSString *text = @"";
    if (self.friendsType == KRegard) {
        text = @"去我的-通讯录关注一些人，这里会大不同哦";
    }else if (self.friendsType == kGoodFriend){
        text = @"互相关注后,好友动态会呈现在这里哦";
    }
    
    NSDictionary *attributes = @{NSFontAttributeName: [UIFont systemFontOfSize:14.0f],
                                 NSForegroundColorAttributeName: [UIColor lightGrayColor]};
    
    return [[NSAttributedString alloc] initWithString:text attributes:attributes];
}

- (CGFloat)spaceHeightForEmptyDataSet:(UIScrollView *)scrollView
{
    return 100.0f;
}
#pragma marl  imageTextCell Delegate

- (void)imageTextCellDelegate:(BasicAction)basicAction circleModel:(YRCircleListModel *)circleModel indexPosition:(NSInteger)indexPosition{
    
    if (![YRUserInfoManager manager].currentUser.custId  && basicAction!=kHeadImage ) {
        [self noLoginTip];
        return;
    }
    
    switch (basicAction) {
        case kTran:
        {
            YRImageTextCell *cell = [self.tableView cellForRowAtIndexPath:circleModel.indexPath];
            cell.userInteractionEnabled = NO;
            self.tranCell = cell;
            @weakify(self);
            self.isHavePassword = ^(BOOL isHavePassword){
                @strongify(self);
                if (isHavePassword) {
                    YRRedPaperPaymentViewController *redVC = [[YRRedPaperPaymentViewController alloc]init];
                    redVC.refreshBlock = ^{
                        NSNotification * notice = [NSNotification notificationWithName:@"123" object:circleModel.clubId userInfo:nil];
                        //发送消息
                        [[NSNotificationCenter defaultCenter]postNotification:notice];
                    };
                    
                    redVC.circleModel = circleModel;
                    redVC.type = 1;
                    redVC.tranSuccessDelegate = self;
                    redVC.indexPosition = indexPosition;
                    [self.navigationController pushViewController:redVC animated:YES];
                    self.tranCell.userInteractionEnabled = YES;
                    self.tranCell = nil;
                }
            };
            [self queryPassWord];
            
            
        }
            break;
        case kRedBag:
        {
            
            if (!circleModel.redpacketId) {
                [MBProgressHUD showError:@"无效红包"];
            }
            
            
            if ([circleModel.custId isEqualToString:[YRUserInfoManager manager].currentUser.custId]) {
                YRRedPaperListViewController  *redRecordVc = [[YRRedPaperListViewController alloc] init];
                redRecordVc.redId = circleModel.redpacketId;
                [self.navigationController pushViewController:redRecordVc animated:YES];
            }else{
                [MBProgressHUD showSuccess:@"跟转该作品方可抢红包"];
            }
            
        }
            break;
        case kEarningsRule:
        {
            if ([[YRUserInfoManager manager].currentUser.custId isEqualToString:circleModel.custId]) {
                [YRHttpRequest getFriendsCircleEarningStatisticscustId:circleModel.custId clubId:circleModel.clubId success:^(NSDictionary *data) {
                    NSMutableDictionary * dict = [[NSMutableDictionary alloc]init];
                    dispatch_async(dispatch_get_main_queue(),^{
                        YRCircleEarningsView * circle = [[YRCircleEarningsView alloc]init];
                        circle.delegate = self;
                        circle.circleModel = circleModel;
                        [circle showWithFaceInfo:[dict getDict:data] advertisementImage:[UIImage imageNamed:@"CircleImage"] borderColor:nil circle:circleModel];
                    });
                    
                } failure:^(NSString *eCorrorInfo) {
                    [MBProgressHUD showError:eCorrorInfo];
                }];
            }else{
                [YRHttpRequest getFriendsCircleEarningStatisticscustId:circleModel.custId clubId:circleModel.clubId success:^(NSDictionary *data) {
                    NSMutableDictionary * dict = [[NSMutableDictionary alloc]init];
                    dispatch_async(dispatch_get_main_queue(),^{
                        YRCircleFriendEarningView * circle = [[YRCircleFriendEarningView alloc]init];
                        circle.delegate = self;
                        circle.circleModel = circleModel;
                        [circle showWithFaceInfo:[dict getDict:data] advertisementImage:[UIImage imageNamed:@"CircleImage"] borderColor:nil circle:circleModel];
                    });
                } failure:^(NSString *eCorrorInfo) {
                    [MBProgressHUD showError:eCorrorInfo];
                }];
            }
        }
            break;
        case kReward:
        {
            
            
            @weakify(self);
            self.isHavePassword = ^(BOOL isHavePassword){
                @strongify(self);
                if (isHavePassword) {
                    
                    self.rewardGiftView = [[RewardGiftView alloc] initWithFrame:CGRectMake(0,SCREEN_HEIGHT, self.rewardGiftView.frame.size.width, self.rewardGiftView.frame.size.height)];
                    @weakify(self);
                    self.rewardGiftView.rewardBlock = ^(RewardGiftModel *giftModel ,float money){
                        @strongify(self);
                        NSString *allMoneyStr = [NSString stringWithFormat:@"%.2f",money];
                        
                        //小额免密打开并总支付小于50
                        if (self.smallNopass && [allMoneyStr floatValue] * 0.01 <= 50) {
                            
                            [YRHttpRequest sendReward:giftModel.giftid touserid:circleModel.custId type:0 infoId:circleModel.clubId giftNum:1 password:@"" infoType:circleModel.infoType infoTitle:circleModel.infoTitle pid:circleModel.infoId success:^(id data) {
                                [MBProgressHUD showSuccess:@"打赏成功"];
                            } failure:^(NSString *data) {
                                [MBProgressHUD showError:data];
                            }];
                            return ;
                        }
                        
                        
                        [self sendReward:allMoneyStr giftid:giftModel.giftid touserid:circleModel.custId pid:circleModel.infoId infoTitle:circleModel.infoTitle infoType:circleModel.infoType infoId:circleModel.clubId];
                        
                        
                    };
                    [self.rewardGiftView.rechargeButton addTarget:self action:@selector(rechargeButtonClick) forControlEvents:UIControlEventTouchUpInside];
                    [self.rewardGiftView showGiftView];
                    
                }
            };
            [self queryPassWord];
            
        }
            break;
            //邀请转发
        case kInvitationForwarding:
        {
            YRAddNewGroupViewController *newChatVc = [[YRAddNewGroupViewController alloc] init];
            newChatVc.title = @"选择联系人";
            newChatVc.type = 2;
            newChatVc.infoId = circleModel.clubId;
            [self.navigationController pushViewController:newChatVc animated:YES];
        }
            break;
        case kHeadImage:{
            
            [self pushUserInfoViewController:circleModel.custId withIsFriend:YES];
        }
            break;
        default:
            break;
    }
}

#pragma mark  弹出框代理



- (void)invitateRransmitcircle:(YRCircleListModel *)circle{
    
    YRAddNewGroupViewController *newChatVc = [[YRAddNewGroupViewController alloc] init];
    newChatVc.title = @"选择联系人";
    newChatVc.type = 2;
    newChatVc.infoId = circle.clubId;
    [self.navigationController pushViewController:newChatVc animated:YES];
    
}
- (void)followRransmitcircle:(YRCircleListModel *)circle{
    
    
    @weakify(self);
    self.isHavePassword = ^(BOOL isHavePassword){
        @strongify(self);
        if (isHavePassword) {
            YRRedPaperPaymentViewController *redVC = [[YRRedPaperPaymentViewController alloc]init];
            redVC.circleModel = circle;
            redVC.tranSuccessDelegate = self;
            [self.navigationController pushViewController:redVC animated:YES];
        }
    };
    [self queryPassWord];
}

/**
 *  @author weishibo, 16-09-12 10:09:38
 *
 *  充值
 */
- (void)rechargeButtonClick{
    RRZSaveMoneyController  *saveVc = [[RRZSaveMoneyController alloc] init];
    [self.navigationController pushViewController:saveVc animated:YES];
}


/**
 *  @author weishibo, 16-09-12 17:09:13
 *
 *  发送打赏
 */
- (void)sendReward:(NSString*)allMoneyStr giftid:(NSString*)giftid touserid:(NSString*)touserid pid:(NSString*)pid  infoTitle:(NSString*)infoTitle infoType:(InfoProductType)productType infoId:(NSString*)infoid{
    
    @weakify(self);
    [YRPaymentPasswordView showPaymentViewWithMoney:allMoneyStr  paymentBlock:^(NSString  *password){
        @strongify(self);
        [YRPaymentPasswordView hidePaymentPasswordView];
        [YRHttpRequest sendReward:giftid touserid:touserid type:0 infoId:infoid giftNum:1 password:password  infoType:0 infoTitle:@"" pid:pid success:^(id data) {
            [MBProgressHUD showSuccess:@"打赏成功"];
        } failure:^(NSString *data) {
            if ([data isEqualToString:@"支付密码错误"]) {
                [YRPaymentPasswordView hidePaymentPasswordView];
                
                YRAlertView *alertView = [[YRAlertView alloc] initWithTitle:@"支付密码错误，请重试" cancelButtonText:@"确定"  ];
                
                alertView.addCancelAction = ^{
                    
                    [self sendReward:allMoneyStr giftid:giftid touserid:touserid pid:pid infoTitle:infoTitle infoType:productType infoId:infoid];
                };
                [alertView show];
                return ;
            }
            [MBProgressHUD showError:data];
            
        }];
        
    }];
    
}
- (void)viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:animated];
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"deleteAudioNotifier" object:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}


@end
