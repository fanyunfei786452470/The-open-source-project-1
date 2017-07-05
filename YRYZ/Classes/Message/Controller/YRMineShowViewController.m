//
//  YRMineShowViewController.m
//  
//
//  Created by Mrs_zhang on 16/7/12.
//
//  消息-->我的动态

#import "YRMineShowViewController.h"
#import "YRMineShowTableViewCell.h"
#import "RRZAdListRegardMeController.h"
#import "YRSunTextDetailViewController.h"
#import "YRBuyAccountController.h"
#import "YRRedPaperRecordViewController.h"
#import "YRRedAdsMainViewController.h"
#import "YRImageTextDetailsViewController.h"
#import "YRVidioDetailController.h"
#import "YRAudioDetailController.h"
#import "YRCirleDetailViewController.h"
#import "YRTranSucessViewController.h"
#import "YRAddNewGroupViewController.h"
#import "LuckyDrawController.h"
#import "YRBingLuckController.h"
#import "YRImageTextMainViewController.h"
#import "YRVideoMainViewController.h"
#import "YRAudioMainViewController.h"
#import "LuckyDrawController.h"
#import "YRBeforePrizeViewController.h"
#import "YRRedBagController.h"

#import "YRNewAudioDetailViewController.h"
#import "YRNewVideoDetailViewController.h"
#import "YRMyWorksController.h"
#import "YRMyRedPackViewController.h"
#import "YRLoginController.h"
#import "UITabBar+badge.h"
#import "YRTabBarController.h"

#import "YRNewAudioDetailViewController.h"
#import "YRNewVideoDetailViewController.h"

#import "YRRewardIntegralViewController.h"


static NSString *yrMineShowCellIdentifier = @"yrMineShowCellIdentifier";
@interface YRMineShowViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic,weak) UITableView *tb_View;
@property (nonatomic,strong) NSMutableArray *dataSource;

@property (nonatomic,assign) NSInteger start;

@end

@implementation YRMineShowViewController

- (void)setStart:(NSInteger)start{
    if (start < 0) {
        _start = 0;
        return;
    }
    _start = start;
}

- (NSMutableArray *)dataSource{

    if (!_dataSource) {
      _dataSource = [NSMutableArray array];
    }
    return _dataSource;
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    if (![YRUserInfoManager manager].currentUser.custId) {
        [self.dataSource removeAllObjects];
        [self.tb_View reloadData];
    }

    

}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    UITableView *table = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT-64-40-49) style:UITableViewStylePlain];
    table.delegate = self;
    table.dataSource = self;
    table.estimatedRowHeight = 80;
    table.rowHeight = UITableViewAutomaticDimension;
    table.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:table];
    self.tb_View = table;

    [table registerNib:[UINib nibWithNibName:@"YRMineShowTableViewCell" bundle:nil] forCellReuseIdentifier:yrMineShowCellIdentifier];
    
    [table jk_addGifFooterWithRefreshingTarget:self refreshingAction:@selector(footRefresh)];
//    [table jk_addGifHeaderWithRefreshingTarget:self refreshingAction:@selector(headRefresh)];

    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(clearMsgNotification:) name:MsgClear_Notification_Key object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(refreshMyShow:) name:MsgMyShow_Notification_Key object:nil];
}

- (void)clearMsgNotification:(NSNotification *)notification{

    [self.dataSource removeAllObjects];
    [[YRYYCache share].yyCache removeObjectForKey:MsgMyShow_Notification_Key];
    [self.tb_View reloadData];
}

- (void)refreshMyShow:(NSNotification *)notification{
    
    [self headRefresh];
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.25 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self setBadge];
    });
}

- (void)footRefresh{
    
    self.start += kListPageSize;
    NSArray *msgContent = (NSArray *)[[YRYYCache share].yyCache objectForKey:MsgMyShow_Notification_Key];
    NSInteger count = msgContent.count%kListPageSize;
    
    if (msgContent.count>(self.start + kListPageSize)) {
        NSArray *arr = [msgContent subarrayWithRange:NSMakeRange(self.start, kListPageSize)];
        [_dataSource addObjectsFromArray:arr];
        [self.tb_View.footer endRefreshing];
    }else{
        if (_dataSource.count == msgContent.count) {
            [self.tb_View.footer endRefreshingWithNoMoreData];
        }else{
            NSArray *arr = [msgContent subarrayWithRange:NSMakeRange(self.start, count)];
            [_dataSource addObjectsFromArray:arr];
            [self.tb_View.footer endRefreshingWithNoMoreData];
        }
    }
    [self.tb_View reloadData];
}
- (void)headRefresh{
    self.start = 0;
    
    [_dataSource removeAllObjects];
      if ([YRUserInfoManager manager].currentUser.custId) {
    NSArray *msgContent = (NSArray *)[[YRYYCache share].yyCache objectForKey:MsgMyShow_Notification_Key];
    if (msgContent.count>kListPageSize) {
        NSArray *arr = [msgContent subarrayWithRange:NSMakeRange(0, kListPageSize)];
        [_dataSource addObjectsFromArray:arr];
        [self.tb_View.header endRefreshing];
        [self.tb_View.footer endRefreshing];

    }else{
        NSArray *arr = [msgContent subarrayWithRange:NSMakeRange(0, msgContent.count)];
        [_dataSource addObjectsFromArray:arr];
        [self.tb_View.header endRefreshing];
        [self.tb_View.footer endRefreshingWithNoMoreData];

    }
   }
    [self.tb_View reloadData];
}
#pragma mark -  UITableViewDelegate

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return self.dataSource.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    YRMineShowTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:yrMineShowCellIdentifier forIndexPath:indexPath];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;

    NSDictionary *dataDic = self.dataSource[indexPath.row];
    NSString *context;
    if (dataDic[@"data"][@"context"] != nil && dataDic[@"data"][@"context"]) {
        context = dataDic[@"data"][@"context"];
    }else{
        context = @"";
    }
    NSString *time = dataDic[@"data"][@"sendTime"];
    NSString *tampTime = [self timesTampWithTime:time?time:@""];
    NSString *sendTime = [NSString getMsgTimeFormatterWithString:tampTime];
    
    cell.contextLab.text = [NSString stringWithFormat:@"%@",context?context:@" "];
    cell.timeLab.text = [NSString stringWithFormat:@"%@",sendTime?sendTime:@""];
    cell.contextLab.numberOfLines = 3;
    [self setMsgTypeWith:cell IndexPath:indexPath];
    
    return cell;
}

- (void)setMsgTypeWith:(YRMineShowTableViewCell *)cell IndexPath:(NSIndexPath *)indexPath{
    
    NSDictionary *msgContent = self.dataSource[indexPath.row];
    NSInteger msgType = [msgContent[@"msgType"] integerValue];
    switch (msgType) {
        case kNewFollowType://新关注
        {
            cell.typeImg.image = [UIImage imageNamed:@"yr_msg_follow"];
        }
            break;
        case kForwardType://转发
        {
            cell.typeImg.image = [UIImage imageNamed:@"yr_msg_tran"];
        }
            break;
        case kGoForwardType://跟转
        {
            cell.typeImg.image = [UIImage imageNamed:@"yr_msg_Turn"];
        }
            break;
        case kSPlayTourType://打赏(晒一晒)
        {
            cell.typeImg.image = [UIImage imageNamed:@"yr_msg_ reward"];
        }
            break;
        case kThransPlayTourType://打赏(转发)
        {
            cell.typeImg.image = [UIImage imageNamed:@"yr_msg_ reward"];
        }
            break;
        case kWorksPlayTourType://打赏(作品)
        {
            cell.typeImg.image = [UIImage imageNamed:@"yr_msg_ reward"];
        }
            break;
        case kAskThransType://邀请转发
        {
            cell.typeImg.image = [UIImage imageNamed:@"yr_msg_askTran"];
        }
            break;
        case kRewardOutDataType://红包到期
        {
            cell.typeImg.image = [UIImage imageNamed:@"yr_msg_redPaper"];
        }
            break;
        case kRewardGetDownType://红包领完
        {
            cell.typeImg.image = [UIImage imageNamed:@"yr_msg_redPaper"];
        }
            break;
        case kWorksApproveType://审核通过(作品)
        {
            cell.typeImg.image = [UIImage imageNamed:@"yr_msg_Approve"];
        }
            break;
        case kWorksAuditFailType://审核失败(作品)
        {
            cell.typeImg.image = [UIImage imageNamed:@"yr_msg_fail"];
        }
            break;
        case kAdvertApproveType://审核通过(广告)
        {
            cell.typeImg.image = [UIImage imageNamed:@"yr_msg_Approve"];
        }
            break;
        case kAdvertAuditFailType://审核失败(广告)
        {
            cell.typeImg.image = [UIImage imageNamed:@"yr_msg_fail"];
        }
            break;
        case kGetThransLotteryCodeType://获得抽奖码(转发)
        {
            cell.typeImg.image = [UIImage imageNamed:@"yr_msg_ lucky"];
        }
            break;
        case kGetActivityLotteryCodeType://获得抽奖码(活动)
        {
            cell.typeImg.image = [UIImage imageNamed:@"yr_msg_ lucky"];
        }
            break;
        case kGetCashCouponType://获得现金券
        {
            cell.typeImg.image = [UIImage imageNamed:@"yr_msg_money"];
        }
            break;
        case kGetPayCashCouponType://获得现金券(充值)
        {
            cell.typeImg.image = [UIImage imageNamed:@"yr_msg_money"];
        }
        case kMineIsWinnersCodeType://开奖消息（中奖人)
        {
            cell.typeImg.image = [UIImage imageNamed:@"yr_msg_ lucky"];
        }
        case kBeginCountdownCodeType://开奖消息 (非中奖人) 开始倒计时
        {
            cell.typeImg.image = [UIImage imageNamed:@"yr_msg_ lucky"];
        }
            break;
        default:
            break;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    @weakify(self);
    if (![YRUserInfoManager manager].currentUser.custId) {
        YRAlertView *alertView = [[YRAlertView alloc] initWithTitle:@"请登录进行后续操作" cancelButtonText:@"再逛逛" confirmButtonText:@"登录"];
        
        alertView.addCancelAction = ^{
            
        };
        alertView.addConfirmAction = ^{
            @strongify(self);
            YRLoginController *loginVc = [[YRLoginController alloc] init];
            [self.navigationController pushViewController:loginVc animated:YES];
        };
        [alertView show];
    }else{
    
    NSDictionary *msgContent = self.dataSource[indexPath.row];
    NSInteger msgType = [msgContent[@"msgType"] integerValue];
        
    switch (msgType) {
        case kNewFollowType://新关注
        {  
            RRZAdListRegardMeController *newGoodFriendVC = [[RRZAdListRegardMeController alloc]init];
            [self.navigationController pushViewController:newGoodFriendVC animated:YES];
        }
            break;
        case kForwardType://转发
        {
            InfoProductType   infoType = [msgContent[@"data"][@"infoType"] integerValue];
            NSString          *pid = msgContent[@"data"][@"pid"];
            [self toDetailsViewController:infoType infoId:pid];
        }
            break;
        case kGoForwardType://跟转
        {
            InfoProductType   infoType = [msgContent[@"data"][@"infoType"] integerValue];
            NSString          *pid = msgContent[@"data"][@"infoId"];
            NSString         *cid = msgContent[@"data"][@"clubId"];
            
            YRCirleDetailViewController  *cirleVc = [[YRCirleDetailViewController alloc] init];
            cirleVc.productType = infoType;
            cirleVc.circleListModel.infoId = pid?pid:@"";
            cirleVc.circleListModel.clubId = cid?cid:@"";
            [self.navigationController pushViewController:cirleVc animated:YES];
        }
            break;
        case kSPlayTourType://打赏(晒一晒)
        {
            YRSunTextDetailViewController *sunVc = [[YRSunTextDetailViewController alloc] init];
            sunVc.sid = [msgContent[@"data"][@"sid"] intValue];
            [self.navigationController pushViewController:sunVc animated:YES];
        }
            break;
        case kThransPlayTourType://打赏(转发)
        {
//            InfoProductType   infoType = [msgContent[@"data"][@"infoType"] integerValue];
            NSString          *infoId = msgContent[@"data"][@"pid"];
            NSString         *cid = msgContent[@"data"][@"clubId"];
            
            YRCirleDetailViewController  *cirleVc = [[YRCirleDetailViewController alloc] init];
//            cirleVc.productType = infoType;
            cirleVc.circleListModel.infoId = infoId?infoId:@"";
            cirleVc.circleListModel.clubId = cid?cid:@"";
            [self.navigationController pushViewController:cirleVc animated:YES];
        }
            break;
        case kWorksPlayTourType://打赏(作品)
        {
            NSInteger   infoType = [msgContent[@"data"][@"infoType"] integerValue];
            NSString          *pid = msgContent[@"data"][@"pid"];
            
            [self toDetailsViewController:infoType infoId:pid];
        }
            break;
        case kAskThransType://邀请转发
        {
            NSString          *pid = msgContent[@"data"][@"pid"];
            NSString         *cid = msgContent[@"data"][@"clubId"];//此处缺乏clubId
//
            YRCirleDetailViewController  *cirleVc = [[YRCirleDetailViewController alloc] init];
            cirleVc.circleListModel.infoId = pid?pid:@"";
            cirleVc.circleListModel.clubId = cid?cid:@"";
            [self.navigationController pushViewController:cirleVc animated:YES];
        }
            break;
        case kRewardOutDataType://红包到期
        {
            YRBuyAccountController *buyAccountVc = [[YRBuyAccountController alloc] init];
            [self.navigationController pushViewController:buyAccountVc animated:YES];
        }
            break;
        case kRewardGetDownType://红包领完
        {

            YRRedBagController *redVc = [[YRRedBagController alloc] init];
            [self.navigationController pushViewController:redVc animated:YES];
        }
            break;
        case kWorksApproveType://审核通过(作品)
        {

            YRMyWorksController *myWorkVc = [[YRMyWorksController alloc] init];
            [self.navigationController pushViewController:myWorkVc animated:YES];
        }
            break;
        case kWorksAuditFailType://审核失败(作品)
        {
            InfoProductType   infoType = [msgContent[@"data"][@"infoType"] integerValue];

            switch (infoType) {
                case kInfoTypePictureWord:
                {
                    YRImageTextMainViewController *imageTextController = [[YRImageTextMainViewController alloc]init];
                    [self.navigationController pushViewController:imageTextController animated:YES];
                }
                    break;
                case kInfoTypeVideo:
                {
                    YRVideoMainViewController *imageTextController = [[YRVideoMainViewController alloc]init];
                    [self.navigationController pushViewController:imageTextController animated:YES];
                }
                    break;
                case kInfoTypeVoice:
                {
                    YRAudioMainViewController *audioVc = [[YRAudioMainViewController alloc] init];
                    audioVc.typeDataSource = (NSMutableArray *)[[YRYYCache share].yyCache objectForKey:@"voicedataSource"];
                    [self.navigationController pushViewController:audioVc animated:YES];
                }
                    break;
                default:
                    break;
            }
        }
            break;
        case kAdvertApproveType://审核通过(广告)
        {
            
            YRMyRedPackViewController *redAds = [[YRMyRedPackViewController alloc]initWithMyFrame:CGRectMake(1, 1, 1, 1)];
            [self.navigationController pushViewController:redAds animated:YES];
        }
            break;
        case kAdvertAuditFailType://审核失败(广告)
        {
            YRMyRedPackViewController *redAds = [[YRMyRedPackViewController alloc]initWithMyFrame:CGRectMake(1, 1, 1, 1)];
            [self.navigationController pushViewController:redAds animated:YES];
        }
            break;
        case kGetThransLotteryCodeType://获得抽奖码(转发)
        {
            
            LuckyDrawController *tranVc = [[LuckyDrawController alloc] init];
            [self.navigationController pushViewController:tranVc animated:YES];

        }
            break;
        case kGetActivityLotteryCodeType://获得抽奖码(活动)
        {
            [MBProgressHUD showError:@"获得抽奖码(活动)"];
        }
            break;
        case kGetCashCouponType://获得现金券
        {
            [MBProgressHUD showError:@"获得现金券"];
        }
            break;
        case kGetPayCashCouponType://获得现金券(充 值)
        {
            [MBProgressHUD showError:@"获得现金券(充值)"];
        }
        case kMineIsWinnersCodeType://开奖消息（中奖人)
        {
            YRRewardIntegralViewController *redMoney = [[YRRewardIntegralViewController alloc]init];
              [self.navigationController pushViewController:redMoney animated:YES];
        }
             break;
        case kBeginCountdownCodeType://开奖消息 (非中奖人) 开始倒计时
        {
            if ([YRUserInfoManager manager].openDic) {
                YRBingLuckController *luck = [[YRBingLuckController alloc]init];
                [self.navigationController pushViewController:luck animated:YES];
            }else{
//                 [MBProgressHUD showError:@"已开奖,请在往期开奖中查看"];
                YRBeforePrizeViewController *luck = [[YRBeforePrizeViewController alloc]init];
                [self.navigationController pushViewController:luck animated:YES];
            }
        }
            break;
        default:
            break;
    }
        
    }
}

- (void)toDetailsViewController:(InfoProductType)infotype  infoId:(NSString*)infoId{
    switch (infotype) {
        case kInfoTypePictureWord:
        {
            YRImageTextDetailsViewController  *textViewVc = [[YRImageTextDetailsViewController alloc] init];
            textViewVc.productListModel.uid = infoId?infoId:@"";
            [self.navigationController pushViewController:textViewVc animated:YES];
        }
            break;
        case kInfoTypeVideo:
        {
//            YRVidioDetailController  *textViewVc = [[YRVidioDetailController alloc] init];
//                textViewVc.productListModel.infoId = infoId?infoId:@"";
//            [self.navigationController pushViewController:textViewVc animated:YES];
            YRNewVideoDetailViewController  *newVc = [[YRNewVideoDetailViewController alloc] init];
            newVc.productId = infoId?infoId:@"";;
            [self.navigationController pushViewController:newVc animated:YES];
            
        }
            break;
        case kInfoTypeVoice:
        {
//            YRAudioDetailController  *textViewVc = [[YRAudioDetailController alloc] init];
//            textViewVc.productListModel.infoId = infoId?infoId:@"";
//            [self.navigationController pushViewController:textViewVc animated:YES];
            YRNewAudioDetailViewController  *newVc = [[YRNewAudioDetailViewController alloc] init];
            newVc.productId = infoId?infoId:@"";
            [self.navigationController pushViewController:newVc animated:YES];
        }
            break;
        default:
            break;
    }
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    
    return YES;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        
        [self.dataSource removeObjectAtIndex:indexPath.row];
        
        [[YRYYCache share].yyCache setObject:self.dataSource forKey:MsgMyShow_Notification_Key];

        // Delete the row from the data source.
        [self.tb_View deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view.
    }
}
- (void)dealloc{
 
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}
- (void)setBadge{
    
    NSInteger fCount = [YRUserInfoManager manager].currentUser.friendsShowCount;
    NSInteger mineCount = [YRUserInfoManager manager].currentUser.mineShowCount;
    NSInteger msgCount = [YRUserInfoManager manager].currentUser.msgCount;
    
    if ((fCount + mineCount + msgCount) == 0) {
        [self.navigationController.tabBarController.tabBar hideBadgeOnItemIndex:1];
    }
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}


@end
