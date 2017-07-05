//
//  YRFriendsShowViewController.m
//  YRYZ
//
//  Created by Mrs_zhang on 16/7/12.
//  Copyright © 2016年 yryz. All rights reserved.
//  消息-->好友动态

#import "YRFriendsShowViewController.h"
#import "YRFriendsshowTableViewCell.h"
#import "YRSunTextDetailViewController.h"
#import "YRImageTextDetailsViewController.h"
#import "YRVidioDetailController.h"
#import "YRAudioDetailController.h"
#import "YRCirleDetailViewController.h"
#import "YRNewAudioDetailViewController.h"
#import "YRNewVideoDetailViewController.h"
#import "YRLoginController.h"
#import "UITabBar+badge.h"
#import "YRTabBarController.h"
static NSString *yrFriendsShowCellIdentifier = @"yrFriendsShowCellIdentifier";

@interface YRFriendsShowViewController ()<UITableViewDataSource,UITableViewDelegate>
@property (nonatomic,weak) UITableView *tb_View;

@property (nonatomic,strong) NSMutableArray *dataSource;
@property (nonatomic,assign) NSInteger start;

@end

@implementation YRFriendsShowViewController

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
    table.estimatedRowHeight = 95;
    table.rowHeight = UITableViewAutomaticDimension;

    table.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:table];
    self.tb_View = table;
    
    [table registerNib:[UINib nibWithNibName:@"YRFriendsshowTableViewCell" bundle:nil] forCellReuseIdentifier:yrFriendsShowCellIdentifier];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(refreshMyShow:) name:MsgMyShow_Notification_Key object:nil];

    [table jk_addGifFooterWithRefreshingTarget:self refreshingAction:@selector(footRefresh)];
//    [table jk_addGifHeaderWithRefreshingTarget:self refreshingAction:@selector(headRefresh)];
}

- (void)refreshMyShow:(NSNotification *)notification{
    
//    [self.tb_View.header beginRefreshing];
  
        [self headRefresh];
    
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.25 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self setBadge];
    });

}

- (void)footRefresh{
    
    self.start += kListPageSize;
    NSArray *msgContent = (NSArray *)[[YRYYCache share].yyCache objectForKey:MsgMyFriendsShow_Notification_Key];
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
    NSArray *msgContent = (NSArray *)[[YRYYCache share].yyCache objectForKey:MsgMyFriendsShow_Notification_Key];
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
    
    YRFriendsshowTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:yrFriendsShowCellIdentifier forIndexPath:indexPath];
    
    YRFriendsModel *model = [[YRFriendsModel alloc] init];
    model.dic = self.dataSource[indexPath.row];
    
    cell.model = model;
    
    return cell;
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
    DLog(@"好友动态：%@",msgContent);
    
    switch (msgType) {
        case kFSendShowType://好友发布晒一晒
        {
            YRSunTextDetailViewController *sunVc = [[YRSunTextDetailViewController alloc] init];
            sunVc.sid = [msgContent[@"data"][@"infoId"] intValue];
            [self.navigationController pushViewController:sunVc animated:YES];
        }
            break;
        case kFForwardWorksType://好友转发作品
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
        case kFSendWorksOrTextType://好友发布作品(文字)
        {
            NSString *pid = msgContent[@"data"][@"pid"];

            YRImageTextDetailsViewController  *textViewVc = [[YRImageTextDetailsViewController alloc] init];
            textViewVc.productListModel.uid = pid?pid:@"";
            [self.navigationController pushViewController:textViewVc animated:YES];
        }
            break;

        case kFSendWorksOrAudioType://好友发布作品(声音)
        {
            NSString *pid = msgContent[@"data"][@"pid"];
            YRNewAudioDetailViewController  *newVc = [[YRNewAudioDetailViewController alloc] init];
            newVc.productId = pid;
            [self.navigationController pushViewController:newVc animated:YES];
        }
            break;

        case kFSendWorksOrVideoType://好友发布作品(视频)
        {
            NSString *pid = msgContent[@"data"][@"pid"];
            YRNewVideoDetailViewController  *newVc = [[YRNewVideoDetailViewController alloc] init];
            newVc.productId = pid?pid:@"";;
            [self.navigationController pushViewController:newVc animated:YES];
        }
            break;
        default:
            break;
    }
    }
}


- (void)toDetailsViewController:(InfoProductType)infotype  infoId:(NSString*)infoId {
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
//            textViewVc.productListModel.infoId = infoId?infoId:@"";
//            [self.navigationController pushViewController:textViewVc animated:YES];
       
            YRNewVideoDetailViewController  *newVc = [[YRNewVideoDetailViewController alloc] init];
            newVc.productId = infoId;
            [self.navigationController pushViewController:newVc animated:YES];
        }
            break;
        case kInfoTypeVoice:
        {
            YRNewAudioDetailViewController  *newVc = [[YRNewAudioDetailViewController alloc] init];
            newVc.productId = infoId;
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
        
        [[YRYYCache share].yyCache setObject:self.dataSource forKey:MsgMyFriendsShow_Notification_Key];
        
        // Delete the row from the data source.
        [self.tb_View deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }
    else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view.
    }
}

#pragma mark - 将时间转化为时间戳
- (NSString *)timesTampWithTime:(NSString *)time{
    
    NSDateFormatter* collectFormatter = [[NSDateFormatter alloc]init];
    [collectFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSDate *collecDate = [collectFormatter dateFromString:time];
    
    NSString *timeSp = [NSString stringWithFormat:@"%ld", (long)[collecDate timeIntervalSince1970]];
    
    return timeSp;
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
    // Dispose of any resources that can be recreated.
}


@end
