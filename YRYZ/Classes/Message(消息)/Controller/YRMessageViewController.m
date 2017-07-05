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
#import "SPUtil.h"
#import "SPKitExample.h"
#import "YRTranSucessViewController.h"

static const CGFloat navigationBarH = 64;

@interface YRMessageViewController ()<UIScrollViewDelegate>
@property (nonatomic,strong) UIScrollView *scrollView;
@property (nonatomic,strong) YRMsgNavgationView *msgNavBar;
@end

@implementation YRMessageViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    //应用登陆成功后，调用SDK
    [[SPKitExample sharedInstance] callThisAfterISVAccountLoginSuccessWithYWLoginId:@"visitor89"
                                                passWord:@"taobao1234"
    preloginedBlock:^{
             
    } successBlock:^{
             
    } failedBlock:^(NSError *aError) {
        
    if (aError.code == YWLoginErrorCodePasswordError || aError.code == YWLoginErrorCodePasswordInvalid || aError.code == YWLoginErrorCodeUserNotExsit) {
                                                                            
           }
    }];
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"发起聊天" style:UIBarButtonItemStylePlain target:self action:@selector(sendMsgAction)];

    self.navigationItem.title = NSLocalizedString(@"tabbar.button.message", nil);
    self.view.backgroundColor = [UIColor whiteColor];
   
    
    [self setNavBarView];
    
    UIScrollView *scrollView = [[UIScrollView alloc]init];
    scrollView.frame         = CGRectMake(0,CGRectGetMaxY(self.msgNavBar.frame),SCREEN_WIDTH, SCREEN_HEIGHT-kNavigationBarHeight-navigationBarH-50);
    scrollView.bounces       = NO;
    scrollView.pagingEnabled = YES;
    scrollView.delegate      = self;
    scrollView.scrollEnabled = NO;
    
    scrollView.contentSize   = CGSizeMake(3*SCREEN_WIDTH, 0);
    scrollView.showsHorizontalScrollIndicator = NO;
    self.automaticallyAdjustsScrollViewInsets = NO;
    
//    UIViewController *msgVc   = [[UIViewController alloc] init];
    
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
    
    
    if (scrollView.contentOffset.x == 0) {
        
    }else if (scrollView.contentOffset.x == SCREEN_WIDTH){

    }
}

- (void)addCustomConversation
{
    [[SPKitExample sharedInstance] exampleAddOrUpdateCustomConversation];
}
/**
 *  @author ZX, 16-07-11 10:07:43
 *
 *  发起聊天响应事件
 */
- (void)sendMsgAction{
    
    [MBProgressHUD showError:@"发起聊天"];
    
    YWTribeDescriptionParam *param = [[YWTribeDescriptionParam alloc] init];
    param.tribeName = @"yryz";
    param.tribeNotice = @"无";
    param.tribeType = YWTribeTypeNormal;
    
    
//    NSString *indicatorKey = self.description;
//    [[SPUtil sharedInstance] setWaitingIndicatorShown:YES withKey:indicatorKey];
    
//    @weakify(self);
    [self.ywTribeService createTribeWithDescription:param completion:^(YWTribe *tribe, NSError *error) {
//        @strongify(self);
//        [[SPUtil sharedInstance] setWaitingIndicatorShown:NO withKey:indicatorKey];
        
        if( error == nil ) {
            [MBProgressHUD showError:@"创建成功！"];
        }
        else {
            
            [MBProgressHUD showError:@"创建失败"];
//            [[SPUtil sharedInstance] showNotificationInViewController:weakSelf.navigationController
//                                                                title:@"创建失败"
//                                                             subtitle:[NSString stringWithFormat:@"%@", error]
//                                                                 type:SPMessageNotificationTypeError];
        }
    }];
    
}
- (void)deleteMsgAction{
    
    YRAlertView *alertView = [[YRAlertView alloc] initWithTitle:@"确定清空所有信息" cancelButtonText:@"取消" confirmButtonText:@"确定"];
    
    alertView.addCancelAction = ^{
        
    };
    alertView.addConfirmAction = ^{
        
        [[NSNotificationCenter defaultCenter] postNotificationName:MsgClear_Notification_Key object:nil];
    };
    [alertView show];

}
/**
 *  @author ZX, 16-07-11 11:07:03
 *
 *  聊天，好友动态，我的动态
 */
- (void)setNavBarView{
    
    
    YRMsgNavgationView *msgBarView = [[YRMsgNavgationView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_WIDTH == kDevice_Is_iPhone5?40:50)];
    msgBarView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:msgBarView];
    self.msgNavBar = msgBarView;
    msgBarView.msgBlock = ^{
        self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"发起聊天" style:UIBarButtonItemStylePlain target:self action:@selector(sendMsgAction)];
        [self.scrollView setContentOffset:CGPointMake(0, 0) animated:YES];
    };
    msgBarView.friendsShowBlock = ^{
        self.navigationItem.rightBarButtonItem = nil;
        [self.scrollView setContentOffset:CGPointMake(SCREEN_WIDTH, 0) animated:YES];
    };
    msgBarView.myShowBlock = ^{
        self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"清空" style:UIBarButtonItemStylePlain target:self action:@selector(deleteMsgAction)];
        [self.scrollView setContentOffset:CGPointMake(SCREEN_WIDTH*2, 0) animated:YES];

    };
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

#pragma mark - Utility
- (YWIMCore *)ywIMCore {
    return [SPKitExample sharedInstance].ywIMKit.IMCore;
}

- (id<IYWTribeService>)ywTribeService {
    return [[self ywIMCore] getTribeService];
}

- (void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];

}

@end
