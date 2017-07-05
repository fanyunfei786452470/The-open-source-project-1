//
//  YRImageTextController.m
//  YRYZ
//
//  Created by 易超 on 16/7/15.
//  Copyright © 2016年 yryz. All rights reserved.
//

#import "YRImageTextController.h"
#import "YRImageTextDetailsViewController.h"
#import "YRRedPaperPaymentViewController.h"
#import "YRRedPaperView.h"
#import "YRRedPaperReceiveViewController.h"
#import "RewardGiftView.h"
#import "YRPlainTextCell.h"
#import "YRRedListModel.h"
#import "YRCircleEarningsView.h"
#import "YRSearchResultController.h"
#import "RRZSaveMoneyController.h"
#import "YRPaymentPasswordView.h"
#import "YRAddNewGroupViewController.h"
#import "YRChangePayPassWordController.h"
#import "YRReleaseImageTextViewController.h"
#import "YRSearchWorksController.h"
#import "YRTransmitAlert.h"
#import "YRLoginController.h"
static NSString * cellID = @"ImageTextCellID";
static NSString * plainID = @"PlainTextCellID";


@interface YRImageTextController ()<UITableViewDelegate,UITableViewDataSource,DZNEmptyDataSetSource, DZNEmptyDataSetDelegate,UISearchBarDelegate,UISearchControllerDelegate,TranSuccessDelegate,YRPlainTextCellDelegate,LoginSuccessDelegate,DetaiSuccessDelegate>

@property (strong, nonatomic) UITableView              *tableView;
@property (nonatomic,strong) RewardGiftView            *rewardGiftView;


@property (strong, nonatomic) NSMutableArray           *dataArray;
@property (nonatomic, assign)NSInteger                 start;
@property (nonatomic ,strong)YRProductListModel        *productModel;
@property(nonatomic ,assign)ProuductRankType           rankType;
@property(nonatomic ,strong)UISearchController         *searchController;


//是否设置支付密码
@property (nonatomic, assign) BOOL          havePassword;
//小额免密开关
@property (nonatomic, assign) BOOL          smallNopass;

@property (nonatomic,weak) UIButton         *tranBtn;

/// 是否设置支付密码  是否开启小额免密
@property (nonatomic,copy) void  (^isHavePasswordAndisSmallNopass)(BOOL isHavePassword  ,BOOL isSmallNopass);

@end

@implementation YRImageTextController

- (NSMutableArray*)dataArray{
    if (!_dataArray) {
        _dataArray = @[].mutableCopy;
        NSString *key = [NSString stringWithFormat:@"%@%ld",NSStringFromClass([self class]),(long)self.rankType];
        [_dataArray addObjectsFromArray:(NSMutableArray *)[[YRYYCache share].yyCache objectForKey:key]];
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
    
    
    if ([self.title isEqualToString:@"最新"]) {
        self.rankType = kProuductRankNew;
    }else  if ([self.title isEqualToString:@"最热"]) {
        self.rankType = kProuductRankHot;
    }else  if ([self.title isEqualToString:@"转发最多"]) {
        self.rankType = kProuductRankTranMax;
    }else  if ([self.title isEqualToString:@"收益最多"]) {
        self.rankType = kProuductRankMoneyMax;
    }
    
    [self setupTableView];
    
    
    @weakify(self);
    [[[NSNotificationCenter defaultCenter] rac_addObserverForName:TranSuccess_TextImage_Notification_Key object:nil] subscribeNext:^(NSNotification *notification) {
        @strongify(self);
        [self.tableView reloadData];
    }];
    
}

-(void)setupTableView{
    
    self.tableView = [[UITableView alloc]initWithFrame:CGRectZero style:UITableViewStylePlain];
    self.tableView.backgroundColor = RGB_COLOR(245, 245, 245);
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT - 104);
    self.tableView.emptyDataSetDelegate = self;
    self.tableView.emptyDataSetSource = self;
    [self.view addSubview:self.tableView];
    
    
    
    
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
    
    /*
    @weakify(self);
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        @strongify(self);
        make.edges.equalTo(self.view).insets(UIEdgeInsetsMake(0, 0, 0, 0));
    }];*/
    
    
    [self.tableView jk_addGifFooterWithRefreshingTarget:self refreshingAction:@selector(footRefresh)];
    [self.tableView jk_addGifHeaderWithRefreshingTarget:self refreshingAction:@selector(headRefresh)];
    [self.tableView.header beginRefreshing];
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
    [YRHttpRequest productBankList:self.rankType start:self.start limit:kListPageSize success:^(id data) {
        @strongify(self);
        NSArray  *array =  [YRProductListModel mj_objectArrayWithKeyValuesArray:data];
        if (self.start == 0) {
            [self.dataArray removeAllObjects];
            NSString *key = [NSString stringWithFormat:@"%@%ld",NSStringFromClass([self class]),(long)self.rankType];
            [[YRYYCache share].yyCache removeObjectForKey:key];
            [[YRYYCache share].yyCache setObject:array forKey:key];
        }
        [self.dataArray addObjectsFromArray:array];
        
//        if ([array count] < kListPageSize) {
//            self.start -= kListPageSize;
////            [self.tableView.footer endRefreshingWithNoMoreData];
//        }
//        else{
//            [self.tableView.footer endRefreshing];
//        }
        
//        if (array.count == 0) {
//                self.start -= kListPageSize;
//               [self.tableView.footer endRefreshing];
//        }
        if (array.count == 0) {
               [self.tableView.footer endRefreshingWithNoMoreData];
        }
         [self.tableView.footer endRefreshing];
        [self.tableView reloadData];
        [self.tableView.header endRefreshing];
        
    } failure:^(id data) {
        [MBProgressHUD showError:data];
        [self.tableView.header endRefreshing];
    }];
}


- (void)queryPassWord{
    
    [YRHttpRequest QueryThePaymentPasswordSuccess:^(NSDictionary *data) {
        //是否设置支付密码
        self.havePassword = [data[@"isPayPassword"] boolValue];
        //小额免密开关
        self.smallNopass = [data[@"smallNopass"] boolValue];
        
        if (!self.havePassword) {
            self.tranBtn.userInteractionEnabled = YES;
            YRAlertView *alertView = [[YRAlertView alloc] initWithTitle:@"请先设置支付密码" cancelButtonText:@"取消" confirmButtonText:@"确认"];
            
            alertView.addCancelAction = ^{
                
            };
            alertView.addConfirmAction = ^{
                YRChangePayPassWordController *payVc = [[YRChangePayPassWordController alloc]init];
                payVc.title = @"设置支付密码";
                [self.navigationController pushViewController:payVc animated:YES];
            };
            [alertView show];
        }else{
            if (self.isHavePasswordAndisSmallNopass) {
                self.isHavePasswordAndisSmallNopass(self.havePassword ,self.smallNopass);
            }
        }
        
    } failure:^(NSString *error) {
        
        [MBProgressHUD showError:error];
    }];
    
}


#pragma mark 转发成功代理

- (void)loginSuccessDelegate:(UserModel *)userModel{
    
    if (userModel) {
        [self LoginfectData];
    }
}
- (void)LoginfectData{
    NSInteger pageSize = self.dataArray.count;
    self.start = 0;
    @weakify(self);
    [YRHttpRequest productBankList:self.rankType start:self.start limit:pageSize success:^(id data) {
        @strongify(self);
        NSArray  *array =  [YRProductListModel mj_objectArrayWithKeyValuesArray:data];
        NSMutableArray *dic = [YRProductListModel mj_keyValuesArrayWithObjectArray:array];
        [dic enumerateObjectsUsingBlock:^(NSDictionary *obj, NSUInteger idx, BOOL * _Nonnull stop) {
            YRProductListModel *model = self.dataArray[idx];
            [model setValuesForKeysWithDictionary:obj];
        }];
        [self.tableView reloadData];
        
    } failure:^(id data) {
        [MBProgressHUD showError:data];
    }];
}
- (void)tranSuccessDelegate:(YRProductListModel *)productListModel circleListModel:(YRCircleListModel *)circleListModel indexPosition:(NSInteger)indexPosition{
    //    YRProductListModel *model = self.dataArray[indexPosition];
    NSInteger transferBonud = [productListModel.transferBonud integerValue] + 30;
    productListModel.transferBonud =[NSString stringWithFormat:@"%ld",transferBonud];
    productListModel.forwardStatus = 1;
    [self.tableView reloadData];
}

///详情页返回代理
- (void)detaiSuccessDelegate:(YRProductListModel *)productListModel{
    
    [self.tableView reloadData];
}

#pragma mark --- UISearchBarDelegate

-(BOOL)searchBarShouldBeginEditing:(UISearchBar *)searchBar{
    YRSearchWorksController *search = [[YRSearchWorksController alloc]init];
    search.type = @"1";
    [self.navigationController pushViewController:search animated:YES];
    return NO;
}
#pragma mark - UITableViewDelegate & UITableViewDataSource
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataArray.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    YRProductListModel  *model = self.dataArray[indexPath.row];
    YRPlainTextCell *cell = [tableView dequeueReusableCellWithIdentifier:plainID];
    if (!cell) {
        cell = [[YRPlainTextCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:plainID];
    }
    cell.redButton.hidden = YES;
    cell.delegate = self;
  
    model.indexPath = indexPath;
    [cell setProductModel:self.dataArray[indexPath.row]];
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 217;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    YRProductListModel  *model = self.dataArray[indexPath.row];
    YRImageTextDetailsViewController  *imageTextVc = [[YRImageTextDetailsViewController alloc] init];
    imageTextVc.productListModel = model;
    imageTextVc.detaiSuccessDelegate = self;
    [self.navigationController pushViewController:imageTextVc animated:YES];
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

- (void)imageTextCellDelegate:(BasicAction)basicAction productModel:(YRProductListModel *)productModel{
    
    
    if (![YRUserInfoManager manager].currentUser.custId  && basicAction!=kHeadImage ) {
        [self noLoginTip];
        return;
    }
    switch (basicAction) {
        case kReward:
        {
            
            
            @weakify(self);
            self.isHavePasswordAndisSmallNopass = ^(BOOL isHavePassword ,BOOL isSmallNopass) {
                @strongify(self);
                if (isHavePassword) {
                    //            打赏
                    self.productModel = productModel;
                    self.rewardGiftView = [[RewardGiftView alloc] initWithFrame:CGRectMake(0,SCREEN_HEIGHT, self.rewardGiftView.frame.size.width, self.rewardGiftView.frame.size.height)];
                    @weakify(self);
                    self.rewardGiftView.rewardBlock = ^(RewardGiftModel *giftModel ,float money){
                        @strongify(self);
                        NSString *allMoneyStr = [NSString stringWithFormat:@"%.2f",money];
                        
                        //小额免密打开并总支付小于50
                        if (isSmallNopass && [allMoneyStr floatValue] * 0.01 <= 50) {
                            
                            [YRHttpRequest sendReward:giftModel.giftid touserid:self.productModel.custId type:2 infoId:self.productModel.uid giftNum:1 password:@"" infoType:kInfoTypePictureWord infoTitle:self.productModel.desc pid:@"" success:^(id data) {
                                [MBProgressHUD showSuccess:@"打赏成功"];
                            } failure:^(NSString *data) {
                                [MBProgressHUD showError:data];
                            }];
                            return ;
                        }
                        
                        
                        [self sendReward:allMoneyStr giftid:giftModel.giftid touserid:self.productModel.custId pid:self.productModel.uid];
                        
                        
                    };
                    [self.rewardGiftView.rechargeButton addTarget:self action:@selector(rechargeButtonClick) forControlEvents:UIControlEventTouchUpInside];
                    [self.rewardGiftView showGiftView];
                    
                }
            };
            [self queryPassWord];
            
            
        }
            break;
        case kTran:
        {
            YRPlainTextCell *cell = [self.tableView cellForRowAtIndexPath:productModel.indexPath];
            cell.tranBtn.userInteractionEnabled = NO;
            self.tranBtn = cell.tranBtn;
            @weakify(self);
            self.isHavePasswordAndisSmallNopass = ^(BOOL isHavePassword ,BOOL isSmallNopass) {
                @strongify(self);
                if (isHavePassword) {
                    YRRedPaperPaymentViewController *redVC = [[YRRedPaperPaymentViewController alloc]init];
                    redVC.productModel = productModel;
                    redVC.tranSuccessDelegate = self;
                    [self.navigationController pushViewController:redVC animated:YES];
                    cell.tranBtn.userInteractionEnabled = YES;
                }
            };
            [self queryPassWord];
            
            
            
        }
            break;
        case kHeadImage:
        {    //好友详情跳转
            [self pushUserInfoViewController:productModel.custId withIsFriend:YES];
        }
            break;
        case kInvitationForwarding:{
            
            YRAddNewGroupViewController *newChatVc = [[YRAddNewGroupViewController alloc] init];
            newChatVc.title = @"邀请转发";
            newChatVc.infoId = self.productModel.uid;
            [self.navigationController pushViewController:newChatVc animated:YES];
            
        }
            break;
        case kEarningsRule:{
            YRTransmitAlert * alert = [[YRTransmitAlert alloc]init];
            [alert showForwardingruletitle:@"作品奖励规则" rule:@"用户在 “悠然一指” 平台成功发布的作品,均有机会被用户付费转发到平台“圈子”中或在“圈子”中被其他用户付费跟转。无论作品被付费转发或跟转,发布作品的用户均能按照平台规则获得 “转发定价x10%x被付费转发次数” 的奖励。"];
        }
            break;
        case kIsforwarded:{
            YRTransmitAlert * alert = [[YRTransmitAlert alloc]init];
            [alert showForwardingruletitle:@"作品奖励规则" rule:@"用户在 “悠然一指” 平台成功发布的作品,均有机会被用户付费转发到平台“圈子”中或在“圈子”中被其他用户付费跟转。无论作品被付费转发或跟转,发布作品的用户均能按照平台规则获得 “转发定价x10%x被付费转发次数” 的奖励。"];
        }
            break;
            
        default:
            break;
    }
}

/**
 *  @author weishibo, 16-09-12 17:09:13
 *
 *  发送打赏
 */
- (void)sendReward:(NSString*)allMoneyStr giftid:(NSString*)giftid touserid:(NSString*)touserid pid:(NSString*)pid{
    
    @weakify(self);
    [YRPaymentPasswordView showPaymentViewWithMoney:allMoneyStr  paymentBlock:^(NSString  *password){
        @strongify(self);
        [YRPaymentPasswordView hidePaymentPasswordView];
        [YRHttpRequest sendReward:giftid touserid:touserid type:2 infoId:pid giftNum:1 password:password infoType:kInfoTypePictureWord infoTitle:self.productModel.infoTitle  pid:@"" success:^(id data) {
            [MBProgressHUD showSuccess:@"打赏成功"];
        } failure:^(NSString *data) {
            if ([data isEqualToString:@"支付密码错误"]) {
                [YRPaymentPasswordView hidePaymentPasswordView];
                
                YRAlertView *alertView = [[YRAlertView alloc] initWithTitle:@"支付密码错误，请重试" cancelButtonText:@"确定"  ];
                
                alertView.addCancelAction = ^{
                    
                    [self sendReward:allMoneyStr giftid:giftid touserid:touserid pid:pid];
                };
                [alertView show];
                return ;
            }
            [MBProgressHUD showError:data];
            
        }];
        
    }];
    
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

@end
