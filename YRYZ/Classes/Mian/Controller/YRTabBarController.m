//
//  YRTabBarController.m
//  YRYZ
//
//  Created by 易超 on 16/6/29.
//  Copyright © 2016年 yryz. All rights reserved.
//

#import "YRTabBarController.h"
#import "YRTabBar.h"
#import "BaseNavigationController.h"
#import "YRHomeViewController.h"
#import "YRMessageViewController.h"
#import "YRSunTextViewController.h"
#import "YRDiscoverViewController.h"
#import "YRMineViewController.h"
#import "YRLoginController.h"
#import "SPKitExample.h"
#import "SPUtil.h"
#import "YWConversationListViewController+UIViewControllerPreviewing.h"
#import "UITabBar+badge.h"

@interface YRTabBarController ()<YRTabBarDelegate>

@property(nonatomic, weak) YRTabBar *myTabBar;

@end

@implementation YRTabBarController

- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    
    @weakify(self);
    [[SPKitExample sharedInstance].ywIMKit setUnreadCountChangedBlock:^(NSInteger aCount) {
        [YRUserInfoManager manager].currentUser.msgCount = aCount;
        @strongify(self);
        DLog(@"消息数：%ld",aCount);
        NSInteger fCount = [YRUserInfoManager manager].currentUser.friendsShowCount;
        NSInteger mineCount = [YRUserInfoManager manager].currentUser.mineShowCount;
        NSInteger msgCount = [YRUserInfoManager manager].currentUser.msgCount;
        
        if ((fCount + mineCount + msgCount) > 0) {
            [self.tabBar showBadgeOnItemIndex:1];
        }else{
            [self.tabBar hideBadgeOnItemIndex:1];
        }
        
    }];
    
    NSMutableArray *msgArr = [NSMutableArray array];
    msgArr = (NSMutableArray *)[[YRYYCache share].yyCache objectForKey:MsgFollow_Notification_Key]?(NSMutableArray *)[[YRYYCache share].yyCache objectForKey:MsgFollow_Notification_Key]:@[].mutableCopy;
    if (msgArr.count >0) {
        [self.tabBar showBadgeOnItemIndex:4];
    }else{
        [self.tabBar hideBadgeOnItemIndex:4];
    }

}

- (void)viewDidLoad {
    [super viewDidLoad];

    // 初始化taBar
    [self setupTabBar];
    
    // 去掉tabBar上方的线条
    [self setTabBarBackGroundImage];
    
    // 初始化控制器
    [self setupChildViewControllers];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(sendMsgNotification:) name:@"sendMsgNotification" object:nil];
}

- (void)sendMsgNotification:(NSNotification *)notification{
    
    NSInteger fCount = [YRUserInfoManager manager].currentUser.friendsShowCount;
    NSInteger mineCount = [YRUserInfoManager manager].currentUser.mineShowCount;
    NSInteger msgCount = [YRUserInfoManager manager].currentUser.msgCount;
    
    if ((fCount + mineCount + msgCount) > 0) {
        [self.tabBar showBadgeOnItemIndex:1];
    }else{
        [self.tabBar hideBadgeOnItemIndex:1];
    }
    
    NSMutableArray *msgArr = [NSMutableArray array];
    msgArr = (NSMutableArray *)[[YRYYCache share].yyCache objectForKey:MsgFollow_Notification_Key]?(NSMutableArray *)[[YRYYCache share].yyCache objectForKey:MsgFollow_Notification_Key]:@[].mutableCopy;
    if (msgArr.count >0) {
        [self.tabBar showBadgeOnItemIndex:4];
    }else{
        [self.tabBar hideBadgeOnItemIndex:4];
    }
}

// 初始化taBar
- (void)setupTabBar
{
    // 删掉系统默认的tabBarItem
    for (UIView *child in self.tabBar.subviews) {
        if ([child isKindOfClass:[UIControl class]]) {
            [child removeFromSuperview];
        }
    }
    
    YRTabBar *myTabBar = [[YRTabBar alloc]initWithFrame:self.tabBar.bounds];
    myTabBar.delegate = self;
    [self.tabBar addSubview:myTabBar];
    _myTabBar = myTabBar;
}

// 初始化子控制器
- (void)setupChildViewControllers
{
    // 首页
    YRHomeViewController *homeVC = [[YRHomeViewController alloc]init];
    NSString *homeNormal = @"yr_tabBar_home";
    NSString *homeSel = @"yr_tabBar_home_sel";
    [self setupChildViewController:homeVC title:NSLocalizedString(@"tabbar.button.homepage", nil) normalImageNamed:homeNormal selImageNamed:homeSel];
    
    // 消息
    YRMessageViewController *messageVC = [[YRMessageViewController alloc]init];
    NSString *messageNormal = @"yr_tabBar_message";
    NSString *messageSel = @"yr_tabBar_message_sel";
    [self setupChildViewController:messageVC title:NSLocalizedString(@"tabbar.button.message", nil) normalImageNamed:messageNormal selImageNamed:messageSel];
    
    // 晒一晒
    YRSunTextViewController *showVC = [[YRSunTextViewController alloc]init];
    NSString *showNormal = @"yr_tabBar_show";
    NSString *showkSel = @"yr_tabBar_show";
    [self setupChildViewController:showVC title:nil normalImageNamed:showNormal selImageNamed:showkSel];
    
    // 发现
    YRDiscoverViewController *discoverVC = [[YRDiscoverViewController alloc]init];
    NSString *discoverNormal = @"yr_tabBar_discove";
    NSString *discoverSel = @"yr_tabBar_discove_sel";
    [self setupChildViewController:discoverVC title:NSLocalizedString(@"tabbar.button.find", nil) normalImageNamed:discoverNormal selImageNamed:discoverSel];
    
    // 我的
    YRMineViewController *mineVC = [[YRMineViewController alloc]init];
    NSString *mineNormal = @"yr_tabBar_mine";
    NSString *mineBuySel = @"yr_tabBar_mine_sel";
    [self setupChildViewController:mineVC title:NSLocalizedString(@"tabbar.button.mine",nil) normalImageNamed:mineNormal selImageNamed:mineBuySel];



}

-(void)setupChildViewController:(UIViewController *)controller title:(NSString *)title normalImageNamed:(NSString *)normalImage selImageNamed:(NSString *)selImage;
{
    // 创建导航控制器
    BaseNavigationController *nav = [[BaseNavigationController alloc]initWithRootViewController:controller];
    [self.myTabBar addTabBarItemWithTitle:title NormalImage:normalImage selImage:selImage];
    controller.navigationItem.title = title;
    nav.tabBarItem.enabled = NO;
    [self addChildViewController:nav];
}

#pragma mark - YRTabBarDelegate

- (void)tabBar:(YRTabBar *)tabBar didClickFrom:(NSInteger)from to:(NSInteger)to
{
    self.selectedIndex = to;
    
    @weakify(self);
    [[SPKitExample sharedInstance].ywIMKit setUnreadCountChangedBlock:^(NSInteger aCount) {
        [YRUserInfoManager manager].currentUser.msgCount = aCount;
        @strongify(self);
        DLog(@"消息数：%ld",aCount);
        NSInteger fCount = [YRUserInfoManager manager].currentUser.friendsShowCount;
        NSInteger mineCount = [YRUserInfoManager manager].currentUser.mineShowCount;
        NSInteger msgCount = [YRUserInfoManager manager].currentUser.msgCount;
        
        if ((fCount + mineCount + msgCount) > 0) {
            [self.tabBar showBadgeOnItemIndex:1];
        }else{
            [self.tabBar hideBadgeOnItemIndex:1];
        }
    }];
    
    NSInteger fCount = [YRUserInfoManager manager].currentUser.friendsShowCount;
    NSInteger mineCount = [YRUserInfoManager manager].currentUser.mineShowCount;
    NSInteger msgCount = [YRUserInfoManager manager].currentUser.msgCount;
    
    if ((fCount + mineCount + msgCount) > 0) {
        [self.tabBar showBadgeOnItemIndex:1];
    }else{
        [self.tabBar hideBadgeOnItemIndex:1];
    }

    if (self.selectedIndex == 1) {
//        [[SPKitExample sharedInstance].ywIMKit setUnreadCountChangedBlock:^(NSInteger aCount) {
//            [YRUserInfoManager manager].currentUser.msgCount = aCount;
        [[NSNotificationCenter defaultCenter] postNotificationName:MsgMyShowCount_Notification_Key object:nil];
//        }];
    }
    
    NSMutableArray *msgArr = [NSMutableArray array];
    msgArr = (NSMutableArray *)[[YRYYCache share].yyCache objectForKey:MsgFollow_Notification_Key]?(NSMutableArray *)[[YRYYCache share].yyCache objectForKey:MsgFollow_Notification_Key]:@[].mutableCopy;
    if (msgArr.count >0) {
        [self.tabBar showBadgeOnItemIndex:4];
    }else{
        [self.tabBar hideBadgeOnItemIndex:4];
    }

}
- (void)addCustomConversation
{
    [[SPKitExample sharedInstance] exampleAddOrUpdateCustomConversation];
}

/**
 *  去掉tabBar上方的线条
 */
- (void)setTabBarBackGroundImage{
    
    CGRect rect = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context, [[UIColor clearColor] CGColor]);
    CGContextFillRect(context, rect);
    NSString *tabbarImgName;
    if (SCREEN_WIDTH == 320.f) {
        tabbarImgName = @"yr_tabBar_bg_iphone5";
    }else if (SCREEN_WIDTH == 375.f){
        tabbarImgName = @"yr_tabBar_bg";
    }else{
        tabbarImgName = @"yr_tabBar_bg_iphone6p";
    }
    
    UIImage *tabbarImg = [UIImage imageNamed:tabbarImgName];
    [tabbarImg drawInRect:CGRectMake(0, SCREEN_HEIGHT - tabbarImg.size.height, SCREEN_WIDTH, tabbarImg.size.height)];
    
    UIImage *img = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    [self.tabBar setBackgroundImage:img];
    [self.tabBar setShadowImage:[UIImage new]];
}

- (void)dealloc{

    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

@end
