//
//  YRMessageViewController.m
//  YRYZ
//
//  Created by 易超 on 16/6/29.
//  Copyright © 2016年 yryz. All rights reserved.
//

#import "YRMessageViewController.h"
#import "YRMsgNavgationView.h"
#import "YRFriendsShowViewController.h"
#import "YRMineShowViewController.h"
#import "YRTranSucessViewController.h"
#import "YRAddNewGroupViewController.h"
#import "YRGroupListViewController.h"
#import "YRLoginController.h"
#import "SPKitExample.h"
#import "UITabBar+badge.h"
#import "YRTabBarController.h"
#import "YRMineAddressListController.h"
static const CGFloat navigationBarH = 64;

@interface YRMessageViewController ()<UIScrollViewDelegate>
@property (nonatomic,weak) UIScrollView *scrollView;
@property (nonatomic,weak) YRMsgNavgationView *msgNavBar;
@property (nonatomic,copy) NSString *msgCount;

@property (nonatomic,strong) UIBarButtonItem *rightBarBtn;

@end

@implementation YRMessageViewController

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"deleteAudioNotifier" object:nil];
}

- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    
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
    }
     [[SPKitExample sharedInstance].ywIMKit setUnreadCountChangedBlock:^(NSInteger aCount) {
         @strongify(self);
        [YRUserInfoManager manager].currentUser.msgCount = aCount;
        [[NSNotificationCenter defaultCenter] postNotificationName:MsgMyShowCount_Notification_Key object:nil];
         [self setBadge];
    }];
}
- (void)setBadge{
    
    NSInteger fCount = [YRUserInfoManager manager].currentUser.friendsShowCount;
    NSInteger mineCount = [YRUserInfoManager manager].currentUser.mineShowCount;
    NSInteger msgCount = [YRUserInfoManager manager].currentUser.msgCount;
    
    if ((fCount + mineCount + msgCount) == 0) {
        [self.navigationController.tabBarController.tabBar hideBadgeOnItemIndex:1];
    }
    
    if ((fCount + mineCount + msgCount) > 0) {
        [self.navigationController.tabBarController.tabBar showBadgeOnItemIndex:1];
    }
    
}
- (void)viewDidLoad {
    [super viewDidLoad];

    UIButton *rightBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 45, 30)];

//    [rightBtn setImage:[UIImage imageNamed:@"yr_msg_sendChat"] forState:UIControlStateNormal];
    [rightBtn setTitle:@"聊天" forState:UIControlStateNormal];
    rightBtn.titleLabel.font = [UIFont systemFontOfSize:19.f];
    rightBtn.titleLabel.textColor = [UIColor whiteColor];
    [rightBtn addTarget:self action:@selector(sendMsgAction) forControlEvents:UIControlEventTouchUpInside];
    self.rightBarBtn = [[UIBarButtonItem alloc] initWithCustomView:rightBtn];
    self.navigationItem.rightBarButtonItem = self.rightBarBtn;
    
    self.navigationItem.title = NSLocalizedString(@"tabbar.button.message", nil);
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self setNavBarView];
    
    UIScrollView *scrollView = [[UIScrollView alloc]init];
    scrollView.frame         = CGRectMake(0,CGRectGetMaxY(self.msgNavBar.frame),SCREEN_WIDTH, SCREEN_HEIGHT-kNavigationBarHeight-navigationBarH-40);
    scrollView.bounces       = NO;
    scrollView.pagingEnabled = YES;
    scrollView.delegate      = self;
    scrollView.scrollEnabled = NO;
    
    scrollView.contentSize   = CGSizeMake(3*SCREEN_WIDTH, 0);
    scrollView.showsHorizontalScrollIndicator = NO;
    self.automaticallyAdjustsScrollViewInsets = NO;
        
    YWConversationListViewController *conversationListController = [[SPKitExample sharedInstance].ywIMKit makeConversationListViewController];
    [[SPKitExample sharedInstance] exampleCustomizeConversationCellWithConversationListController:conversationListController];
    
    __weak __typeof(conversationListController) weakConversationListController = conversationListController;
    
     conversationListController.didSelectItemBlock = ^(YWConversation *aConversation) {
         
        if ([aConversation isKindOfClass:[YWCustomConversation class]]) {
            YWCustomConversation *customConversation = (YWCustomConversation *)aConversation;
            [customConversation markConversationAsRead];
            
            if ([customConversation.conversationId isEqualToString:SPTribeSystemConversationID]) {
                UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Tribe" bundle:nil];
                UIViewController *controller = [storyboard instantiateViewControllerWithIdentifier:@"SPTribeSystemConversationViewController"];
                [weakConversationListController.navigationController pushViewController:controller animated:YES];
                
            }
            else if ([customConversation.conversationId isEqualToString:kSPCustomConversationIdForFAQ]) {
                YWWebViewController *controller = [YWWebViewController makeControllerWithUrlString:@"http://bbs.aliyun.com/searcher.php?step=2&method=AND&type=thread&verify=d26d3c6e63c0b37d&sch_area=1&fid=285&sch_time=all&keyword=汇总" andImkit:[SPKitExample sharedInstance].ywIMKit];
                [controller setHidesBottomBarWhenPushed:YES];
                [controller setTitle:@"云旺iOS精华问题"];
                [weakConversationListController.navigationController pushViewController:controller animated:YES];
            }
            else {
                YWWebViewController *controller = [YWWebViewController makeControllerWithUrlString:@"http://im.baichuan.taobao.com/" andImkit:[SPKitExample sharedInstance].ywIMKit];
                [controller setHidesBottomBarWhenPushed:YES];
                [controller setTitle:@"功能介绍"];
                [weakConversationListController.navigationController pushViewController:controller animated:YES];
            }
        }else {
            [[SPKitExample sharedInstance] exampleOpenConversationViewControllerWithConversation:aConversation
                                                                        fromNavigationController:weakConversationListController.navigationController];
        }
    };
    
    // 会话列表空视图
    if (conversationListController)
    {
        CGRect frame = CGRectMake(0, 0, 100, 100);
        UIView *viewForNoData = [[UIView alloc] initWithFrame:frame];
        UIImageView *imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"login_logo"]];
        imageView.center = CGPointMake(viewForNoData.frame.size.width/2, viewForNoData.frame.size.height/2);
        [imageView setAutoresizingMask:UIViewAutoresizingFlexibleTopMargin|UIViewAutoresizingFlexibleRightMargin|UIViewAutoresizingFlexibleLeftMargin|UIViewAutoresizingFlexibleBottomMargin];
        
        [viewForNoData addSubview:imageView];
        
        conversationListController.viewForNoData = viewForNoData;
    }
    
    YRFriendsShowViewController *friendsShowVc = [[YRFriendsShowViewController alloc] init];
    YRMineShowViewController *myShowVc = [[YRMineShowViewController alloc] init];
    conversationListController.view.frame = CGRectMake(0, 0, SCREEN_WIDTH, scrollView.height);
    friendsShowVc.view.frame = CGRectMake(SCREEN_WIDTH, 0, SCREEN_WIDTH, scrollView.height);
    myShowVc.view.frame = CGRectMake(SCREEN_WIDTH*2, 0, SCREEN_WIDTH, scrollView.height);
    
    [self addChildViewController:conversationListController];
    [self addChildViewController:friendsShowVc];
    [self addChildViewController:myShowVc];
    
    [scrollView addSubview:conversationListController.view];
    [scrollView addSubview:friendsShowVc.view];
    [scrollView addSubview:myShowVc.view];
    
    [self.view addSubview:scrollView];
    self.scrollView = scrollView;
}

/**
 *  @author ZX, 16-07-11 10:07:43
 *
 *  发起聊天响应事件
 */
- (void)sendMsgAction{
    
    if ([YRUserInfoManager manager].currentUser.custId) {
//        YRAddNewGroupViewController *newChatVc = [[YRAddNewGroupViewController alloc] init];
//        newChatVc.title = @"选择联系人";
//        [self.navigationController pushViewController:newChatVc animated:YES];
        YRMineAddressListController *addressVc = [[YRMineAddressListController alloc] init];
        addressVc.isChat = YES;
        [self.navigationController pushViewController:addressVc animated:YES];
    }else{
        @weakify(self);
        YRAlertView *alertView = [[YRAlertView alloc] initWithTitle:@"请登录进行后续操作" cancelButtonText:@"再逛逛" confirmButtonText:@"登录"];
        alertView.addCancelAction = ^{
        };
        alertView.addConfirmAction = ^{
            @strongify(self);
            YRLoginController *loginVc = [[YRLoginController alloc] init];
            [self.navigationController pushViewController:loginVc animated:YES];
        };
        [alertView show];
    }
}

- (void)deleteMsgAction{
    
    YRAlertView *alertView = [[YRAlertView alloc] initWithTitle:@"确定清空所有信息" cancelButtonText:@"取消" confirmButtonText:@"确定"];
    alertView.addCancelAction = ^{
        
    };
    alertView.addConfirmAction = ^{
        [[NSNotificationCenter defaultCenter] postNotificationName:MsgClear_Notification_Key object:nil];

        [YRUserInfoManager manager].currentUser.mineShowCount = 0;
        [[NSNotificationCenter defaultCenter] postNotificationName:MsgMyShowCount_Notification_Key object:nil];

        
        NSInteger fCount = [YRUserInfoManager manager].currentUser.friendsShowCount;
        NSInteger mineCount = [YRUserInfoManager manager].currentUser.mineShowCount;
        NSInteger msgCount = [YRUserInfoManager manager].currentUser.msgCount;
        
        if ((fCount + mineCount + msgCount) == 0) {
            [self.navigationController.tabBarController.tabBar hideBadgeOnItemIndex:1];
        }


    };
    [alertView show];
}
/**
 *  @author ZX, 16-07-11 11:07:03
 *
 *  聊天，好友动态，我的动态
 */

- (void)setNavBarView{
    
    
    @weakify(self);
    YRMsgNavgationView *msgBarView = [[YRMsgNavgationView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH,40)];
    msgBarView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:msgBarView];
    self.msgNavBar = msgBarView;
    
    msgBarView.msgBlock = ^{
        @strongify(self);
        UIButton *rightBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 45, 30)];
//        [rightBtn setImage:[UIImage imageNamed:@"yr_msg_sendChat"] forState:UIControlStateNormal];
        [rightBtn setTitle:@"聊天" forState:UIControlStateNormal];
        rightBtn.titleLabel.font = [UIFont systemFontOfSize:17.f];
        rightBtn.titleLabel.textColor = [UIColor whiteColor];
        [rightBtn addTarget:self action:@selector(sendMsgAction) forControlEvents:UIControlEventTouchUpInside];
        UIBarButtonItem *rightBarBtn = [[UIBarButtonItem alloc] initWithCustomView:rightBtn];
        self.navigationItem.rightBarButtonItem = rightBarBtn;
        [self.scrollView setContentOffset:CGPointMake(0, 0) animated:YES];
        
        };
    msgBarView.friendsShowBlock = ^{
        @strongify(self);
        self.navigationItem.rightBarButtonItem = nil;
        [[NSNotificationCenter defaultCenter] postNotificationName:MsgMyShow_Notification_Key object:nil];
        [self.scrollView setContentOffset:CGPointMake(SCREEN_WIDTH, 0) animated:YES];
        

    };
    msgBarView.myShowBlock = ^{
        @strongify(self);
        self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"清空" style:UIBarButtonItemStylePlain target:self action:@selector(deleteMsgAction)];
        [self.scrollView setContentOffset:CGPointMake(SCREEN_WIDTH*2, 0) animated:YES];
        [[NSNotificationCenter defaultCenter] postNotificationName:MsgMyShow_Notification_Key object:nil];
    };
    
    [[SPKitExample sharedInstance].ywIMKit setUnreadCountChangedBlock:^(NSInteger aCount) {
        [YRUserInfoManager manager].currentUser.msgCount = aCount;
        [[NSNotificationCenter defaultCenter] postNotificationName:MsgMyShowCount_Notification_Key object:nil];
    }];
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.25 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
    [[NSNotificationCenter defaultCenter] postNotificationName:MsgMyShowCount_Notification_Key object:nil];
    });
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    
    if (scrollView.contentOffset.x == 0) {
  
        [[NSNotificationCenter defaultCenter] postNotificationName:@"scrollNotifierCenter" object:@"messageNotifier"];
        
    }else if(scrollView.contentOffset.x == SCREEN_WIDTH){
        
        [[NSNotificationCenter defaultCenter] postNotificationName:@"scrollNotifierCenter" object:@"friendsShowNotifier"];
    }else{

        [[NSNotificationCenter defaultCenter] postNotificationName:@"scrollNotifierCenter" object:@"mineShowNotifier"];
    }
}

- (void)dealloc{
    
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];

}

@end
