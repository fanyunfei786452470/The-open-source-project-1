//
//  AppDelegate.m
//  YRYZ
//
//  Created by 易超 on 16/6/29.
//  Copyright © 2016年 yryz. All rights reserved.
//
#import "AppDelegate.h"
#import "YRTabBarController.h"
#import "YRYZUIAppearance.h"
#import <JSPatch/JSPatch.h>
#import "UMMobClick/MobClick.h"
#import "UMSocial.h"
#import "UMSocialWechatHandler.h"
#import "UMSocialQQHandler.h"
#import "UMSocialSinaSSOHandler.h"
#import "SPKitExample.h"
#import <Bugly/Bugly.h>
#import <ALBBSDK/ALBBSDK.h>
#import "SPUtil.h"
#import "UserModel.h"
#import "Reachability.h"
#import <AdSupport/AdSupport.h>
#import "YRGuidePageController.h"
#import "MsgPlaySound.h"
#import "SPKitExample.h"
#import "LuckyDrawController.h"
#import "YRBeforePrizeViewController.h"
#import "JPUSHService.h"
#ifdef NSFoundationVersionNumber_iOS_9_x_Max
#import <UserNotifications/UserNotifications.h>
#endif
#import "YRBingLuckController.h"

//判断是否第一次登陆的KEY和value
#define  FIRSTENTRY   @"firstEntry"
@interface AppDelegate ()<JPUSHRegisterDelegate>
@property (nonatomic,strong)YRTabBarController          *tabbar;
@property (nonatomic,strong)UILabel                     *netTopLabel;

@property (nonatomic, strong) dispatch_source_t timer;

@property (nonatomic,assign) int count;

@end

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
    self.allowRotation = 0;
    
    [[SPKitExample sharedInstance] callThisInDidFinishLaunching];

    self.window = [[UIWindow alloc]initWithFrame:[UIScreen mainScreen].bounds];
    self.window.backgroundColor = [UIColor whiteColor];

    [self changeRootController];
    // 注册友盟
    [self setupMob];
    [YRYZUIAppearance customNavigationbarAppearance];
    [self setJSPatch];
    [self setBugly];
    [self setNetSate];
    [self autoLogin];
    /**
     *  登陆登出通知
     */
    @weakify(self);
    [[[NSNotificationCenter defaultCenter] rac_addObserverForName:Login_Notification_Key object:nil] subscribeNext:^(NSNotification *notification) {
        @strongify(self);
        [self autoLogin];
    }];
    
    
    [[ALBBSDK sharedInstance] asyncInit:^{
    } failure:^(NSError *error) {
    }];
    
#pragma mark - 极光推送
    [self setJpushSDK:launchOptions];
    
    return YES;
}
-(void)changeRootController{
    
    NSString *frist = [[NSUserDefaults standardUserDefaults] objectForKey:FIRSTENTRY];
    if (frist) {
        self.tabbar = [[YRTabBarController alloc]init];
        self.window.rootViewController = self.tabbar;
        [self.window makeKeyAndVisible];
    }else{
        YRGuidePageController *guidePage = [[YRGuidePageController alloc]init];
        self.window.rootViewController = guidePage;
        [self.window makeKeyAndVisible];
    }
}

-(void)setJpushSDK:(NSDictionary *)launchOptions{
    // Override point for customization after application launch.
    
    NSString *advertisingId = [[[ASIdentifierManager sharedManager] advertisingIdentifier] UUIDString];
//
    if ([[UIDevice currentDevice].systemVersion floatValue] >= 10.0) {
#ifdef NSFoundationVersionNumber_iOS_9_x_Max
        JPUSHRegisterEntity * entity = [[JPUSHRegisterEntity alloc] init];
        entity.types = UNAuthorizationOptionAlert|UNAuthorizationOptionBadge|UNAuthorizationOptionSound;
        [JPUSHService registerForRemoteNotificationConfig:entity delegate:self];
#endif
    } else if ([[UIDevice currentDevice].systemVersion floatValue] >= 8.0) {
        //可以添加自定义categories
        [JPUSHService registerForRemoteNotificationTypes:(UIUserNotificationTypeBadge |
                                                          UIUserNotificationTypeSound |
                                                          UIUserNotificationTypeAlert)
                                              categories:nil];
    }
    //如不需要使用IDFA，advertisingIdentifier 可为nil
    [JPUSHService setupWithOption:launchOptions appKey:@"829a414d80f3a73b73025247"
                          channel:@"Publish channel"
                 apsForProduction:NO
            advertisingIdentifier:advertisingId];
    
    NSNotificationCenter *defaultCenter = [NSNotificationCenter defaultCenter];
    
    [defaultCenter addObserver:self selector:@selector(networkDidReceiveMessage:) name:kJPFNetworkDidReceiveMessageNotification object:nil];
}

#pragma mark 基本设置

/**
 *  @author weishibo, 16-07-08 14:07:19
 *
 *  设置JSPatch
 */
- (void)setJSPatch{
    
    [JSPatch startWithAppKey:kJSPatchAPPKey];
    [JSPatch sync];
}
/**
 *  @author weishibo, 16-07-08 14:07:57
 *
 *  设置腾讯bugly监测
 */
- (void)setBugly{
    [Bugly startWithAppId:kBuglyAppid];
}
/**
 *  @author weishibo, 16-03-19 15:03:58
 *
 *  设置友盟
 */
- (void)setupMob{
    
    //友盟分享
    [UMSocialData setAppKey:UMENG_KEY];
    
    [UMSocialWechatHandler setWXAppId:kWeiXinAppID appSecret:kWeiXinAppSecret url:kRedirectURI];
    [UMSocialQQHandler setQQWithAppId:QQ_APP_ID appKey:QQ_APP_Key url:kRedirectURI];
    [UMSocialSinaSSOHandler openNewSinaSSOWithAppKey:SINA_APP_ID
                                              secret:SINA_APP_Secret
                                         RedirectURL:kRedirectURI];
    
    // 友盟统计
    UMConfigInstance.appKey = UMENG_KEY;
    UMConfigInstance.channelId = @"appstore"; //渠道
    [MobClick startWithConfigure:UMConfigInstance];
    
//    [MobClick setLogEnabled:YES];
    
    //    Class cls = NSClassFromString(@"UMANUtil");
    //    SEL deviceIDSelector = @selector(openUDIDString);
    //    NSString *deviceID = nil;
    //    if(cls && [cls respondsToSelector:deviceIDSelector]){
    //        deviceID = [cls performSelector:deviceIDSelector];
    //    }
    //    NSData* jsonData = [NSJSONSerialization dataWithJSONObject:@{@"oid" : deviceID}
    //                                                       options:NSJSONWritingPrettyPrinted
    //                                                         error:nil];
    //
    //    NSLog(@"%@", [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding]);
}

#pragma mark 登录注册退出
//自动登录
- (void)autoLogin{
    
    [MobClick event:@""];
    NSString *uid = [YRUserInfoManager manager].lastUuid;
    UserModel *user = [UserModel getObjcByid:uid];
    NSString       *userID = [[NSUserDefaults standardUserDefaults] objectForKey:@"logOut"];
    
    if (userID) {
        return;
    }
    
    if (uid && user && user.custId) {
        [[YRUserInfoManager manager] setCurrentUser:user];
        [[SPKitExample sharedInstance] callThisAfterISVAccountLoginSuccessWithYWLoginId:user.custId passWord:user.custId preloginedBlock:^{
            [[SPUtil sharedInstance] setWaitingIndicatorShown:NO withKey:self.description];
        } successBlock:^{
            [[SPUtil sharedInstance] setWaitingIndicatorShown:NO withKey:self.description];
//            [MBProgressHUD showError:@"登录成功"];
        } failedBlock:^(NSError *error) {
            
        }];
        return;
    }
}

/**
 *  注销事件
 */
//- (void)logout
//{
//    //        [self logoutEMAction];
//    [YRUserInfoManager manager].currentUser = nil;
//    YRTabBarController *tabbarVc = [[YRTabBarController alloc] init];
//    tabbarVc.selectedIndex = 4;
//    self.window.rootViewController = tabbarVc;
//}

//横竖屏设置
- (UIInterfaceOrientationMask)application:(UIApplication *)application supportedInterfaceOrientationsForWindow:(UIWindow *)window
{
    if (_allowRotation == 1) {
        return UIInterfaceOrientationMaskAll;//这个可以根据自己的需求设置旋转方向
    }else{
        return (UIInterfaceOrientationMaskPortrait);
    }
}

#pragma mark app                                                                                                                                                                                                                                                                                                                                                                                                                                                                   
- (void)applicationWillResignActive:(UIApplication *)application {
    
    [self setApplicatonBadgeNumber];
}
- (void)applicationDidEnterBackground:(UIApplication *)application {
    
    [self setApplicatonBadgeNumber];
}

- (void)applicationWillEnterForeground:(UIApplication *)application {

    [self setApplicatonBadgeNumber];
}
- (void)applicationDidBecomeActive:(UIApplication *)application {

    [self setApplicatonBadgeNumber];
}
- (void)applicationWillTerminate:(UIApplication *)application {

    [self setApplicatonBadgeNumber];
}

/// iOS8下申请DeviceToken
#if __IPHONE_OS_VERSION_MAX_ALLOWED >= 80000
- (void)application:(UIApplication *)application didRegisterUserNotificationSettings:(UIUserNotificationSettings *)notificationSettings
{
    if ([[UIApplication sharedApplication] respondsToSelector:@selector(registerForRemoteNotifications)]) {
        [[UIApplication sharedApplication] registerForRemoteNotifications];
    }
}

#endif
- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken {
    /// Required - 注册 DeviceToken
    [JPUSHService registerDeviceToken:deviceToken];
}

//自定义消息透传
- (void)networkDidReceiveMessage:(NSNotification *)notification {
    
    NSDictionary * userInfo = [notification userInfo];
    NSString *content = [userInfo valueForKey:@"content"];
//    NSDictionary *extras = [userInfo valueForKey:@"extras"];
//    NSString *customizeField1 = [extras valueForKey:@"customizeField1"]; //服务端传递的Extras附加字段，key是自己定义的
 
//    MsgPlaySound *soundPlay = [[MsgPlaySound alloc] initSystemSoundWithName:@"sms-received1" SoundType:@"caf"];
//    MsgPlaySound *soundPlay = [[MsgPlaySound alloc] initSystemShake];
//    [soundPlay play];

    NSDictionary *msgContent = [content mj_JSONObject];
    
    [self setJPushMsgWithContent:msgContent];
}

- (void)application:(UIApplication *)application didFailToRegisterForRemoteNotificationsWithError:(NSError *)error {
    //Optional
    DLog(@"did Fail To Register For Remote Notifications With Error: %@", error);
}

- (void)application:(UIApplication *)application
didReceiveLocalNotification:(UILocalNotification *)notification {
    
    [JPUSHService showLocalNotificationAtFront:notification identifierKey:nil];
}

- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation
{
    BOOL result = [UMSocialSnsService handleOpenURL:url];
    if (result == FALSE) {
        
    }
    return result;
}

- (void)setNetSate{
    
    // 监测网络情况
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(reachabilityChanged:)
                                                 name: kReachabilityChangedNotification
                                               object: nil];
    Reachability* hostReach = [Reachability reachabilityWithHostName:@"www.baidu.com"];
    [hostReach startNotifier];
    
}

//网络环境改变回调函数
- (void)reachabilityChanged:(NSNotification *)note{
    Reachability* curReach = [note object];
    NSParameterAssert([curReach isKindOfClass: [Reachability class]]);
    NetworkStatus status = [curReach currentReachabilityStatus];
     NSString *frist = [[NSUserDefaults standardUserDefaults] objectForKey:FIRSTENTRY];
    if (frist) {
        switch (status) {
            case NotReachable:
            {
                if (!_netTopLabel) {
                    _netTopLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 64, SCREEN_WIDTH, 26)];
                }
                _netTopLabel.hidden = NO;
                _netTopLabel.backgroundColor = RGB_COLOR(255, 96, 96);
                _netTopLabel.text = @"当前网络不可用，请检查网络设置";
                _netTopLabel.font = [UIFont systemFontOfSize:12];
                _netTopLabel.textColor = [UIColor whiteColor];
                _netTopLabel.textAlignment = NSTextAlignmentCenter;
                
                UIWindow *keyWindow = [[UIApplication sharedApplication].windows lastObject];
//                UIWindow * keyWindow = [[UIApplication sharedApplication] keyWindow];
                [keyWindow addSubview:_netTopLabel];
                self.netState = @"nonet";
            }
                break;
            case ReachableViaWiFi:
                _netTopLabel.hidden = YES;
                self.netState = @"wifi";
                break;
            case ReachableViaWWAN:
                self.netState = @"3G/4G";
                _netTopLabel.hidden = YES;
                break;
            default:
                break;
        }
    }else{
    }
}

- (void)setJPushMsgWithContent:(id)content{
    
    NSDictionary *msgContent = content;
    NSInteger msgType = [msgContent[@"msgType"] integerValue];
    
    if (msgType == kFSendShowType || msgType == kFForwardWorksType || msgType == kFSendWorksOrTextType || msgType == kFSendWorksOrAudioType || msgType == kFSendWorksOrVideoType) {
        
        NSInteger fCount = [YRUserInfoManager manager].currentUser.friendsShowCount;
        fCount = fCount +1;
        [YRUserInfoManager manager].currentUser.friendsShowCount = fCount;
        
        NSMutableArray *msgArr = [NSMutableArray array].mutableCopy;
        
        msgArr = (NSMutableArray *)[[YRYYCache share].yyCache objectForKey:MsgMyFriendsShow_Notification_Key]?(NSMutableArray *)[[YRYYCache share].yyCache objectForKey:MsgMyFriendsShow_Notification_Key]:@[].mutableCopy;
        [msgArr insertObject:msgContent atIndex:0];
        [[YRYYCache share].yyCache setObject:msgArr forKey:MsgMyFriendsShow_Notification_Key];
        [[NSNotificationCenter defaultCenter] postNotificationName:MsgMyShowCount_Notification_Key object:nil];
        
    }else{
        
        if (msgContent[@"msgType"] && msgContent[@"msgType"] != nil) {
            
            NSInteger mineCount = [YRUserInfoManager manager].currentUser.mineShowCount;
            mineCount = mineCount +1;
            [YRUserInfoManager manager].currentUser.mineShowCount = mineCount;
            
            NSMutableArray *msgArr = [NSMutableArray array];
            msgArr = (NSMutableArray *)[[YRYYCache share].yyCache objectForKey:MsgMyShow_Notification_Key]?(NSMutableArray *)[[YRYYCache share].yyCache objectForKey:MsgMyShow_Notification_Key]:@[].mutableCopy;
            [msgArr insertObject:msgContent atIndex:0];
            [[NSNotificationCenter defaultCenter] postNotificationName:MsgMyShowCount_Notification_Key object:nil];
            [[YRYYCache share].yyCache setObject:msgArr forKey:MsgMyShow_Notification_Key];
        }
        
        if ([msgContent[@"msgType"] integerValue] == kBeginCountdownCodeType){
            
//            [YRUserInfoManager manager].currentUser.isOpenLottery = YES;
            [YRUserInfoManager manager].openDic = content;
            if ([[UIViewController getCurrentVC] isKindOfClass:[LuckyDrawController class]]) {
                YRBingLuckController *before = [[YRBingLuckController alloc]init];
                before.dic = content;
                [[UIViewController getCurrentVC].navigationController pushViewController:before animated:YES];
            }
        }
        
        if ([msgContent[@"msgType"] integerValue] == kNewFollowType){
            
            NSMutableArray *msgArr = [NSMutableArray array];
            msgArr = (NSMutableArray *)[[YRYYCache share].yyCache objectForKey:MsgFollow_Notification_Key]?(NSMutableArray *)[[YRYYCache share].yyCache objectForKey:MsgFollow_Notification_Key]:@[].mutableCopy;
            [msgArr insertObject:msgContent atIndex:0];
            
            [[YRYYCache share].yyCache setObject:msgArr forKey:MsgFollow_Notification_Key];
        }
    }
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"sendMsgNotification" object:nil];
}

#ifdef NSFoundationVersionNumber_iOS_9_x_Max
#pragma mark- JPUSHRegisterDelegate

- (void)jpushNotificationCenter:(UNUserNotificationCenter *)center willPresentNotification:(UNNotification *)notification withCompletionHandler:(void (^)(NSInteger))completionHandler {
    NSDictionary * userInfo = notification.request.content.userInfo;
    
    UNNotificationRequest *request = notification.request; // 收到推送的请求
    UNNotificationContent *content = request.content; // 收到推送的消息内容
    
    NSNumber *badge = content.badge;  // 推送消息的角标
    NSString *body = content.body;    // 推送消息体
    UNNotificationSound *sound = content.sound;  // 推送消息的声音
    NSString *subtitle = content.subtitle;  // 推送消息的副标题
    NSString *title = content.title;  // 推送消息的标题
    
    if([notification.request.trigger isKindOfClass:[UNPushNotificationTrigger class]]) {
        [JPUSHService handleRemoteNotification:userInfo];

    }else {
        // 判断为本地通知
        NSLog(@"iOS10 前台收到本地通知:{\nbody:%@，\ntitle:%@,\nsubtitle:%@,\nbadge：%@，\nsound：%@，\nuserInfo：%@\n}",body,title,subtitle,badge,sound,userInfo);
    }
    completionHandler(UNNotificationPresentationOptionBadge|UNNotificationPresentationOptionSound|UNNotificationPresentationOptionAlert); // 需要执行这个方法，选择是否提醒用户，有Badge、Sound、Alert三种类型可以设置
}

- (void)jpushNotificationCenter:(UNUserNotificationCenter *)center didReceiveNotificationResponse:(UNNotificationResponse *)response withCompletionHandler:(void (^)())completionHandler {
    
    NSDictionary * userInfo = response.notification.request.content.userInfo;
    UNNotificationRequest *request = response.notification.request; // 收到推送的请求
    UNNotificationContent *content = request.content; // 收到推送的消息内容
    
    NSNumber *badge = content.badge;  // 推送消息的角标
    NSString *body = content.body;    // 推送消息体
    UNNotificationSound *sound = content.sound;  // 推送消息的声音
    NSString *subtitle = content.subtitle;  // 推送消息的副标题
    NSString *title = content.title;  // 推送消息的标题
    
    if([response.notification.request.trigger isKindOfClass:[UNPushNotificationTrigger class]]) {
        [JPUSHService handleRemoteNotification:userInfo];
       // NSLog(@"iOS10 收到远程通知:%@", [self logDic:userInfo]);
    }else {
        // 判断为本地通知
        NSLog(@"iOS10 收到本地通知:{\nbody:%@，\ntitle:%@,\nsubtitle:%@,\nbadge：%@，\nsound：%@，\nuserInfo：%@\n}",body,title,subtitle,badge,sound,userInfo);
    }
    completionHandler();  // 系统要求执行这个方法
}

#endif
- (void)setApplicatonBadgeNumber{
    
    NSInteger fCount = [YRUserInfoManager manager].currentUser.friendsShowCount;
    NSInteger mineCount = [YRUserInfoManager manager].currentUser.mineShowCount;
    NSInteger msgCount = [YRUserInfoManager manager].currentUser.msgCount;
    NSMutableArray *msgArr = [NSMutableArray array];
    msgArr = (NSMutableArray *)[[YRYYCache share].yyCache objectForKey:MsgFollow_Notification_Key]?(NSMutableArray *)[[YRYYCache share].yyCache objectForKey:MsgFollow_Notification_Key]:@[].mutableCopy;
    
    NSInteger count =  fCount + mineCount + msgCount + msgArr.count;
    [[UIApplication sharedApplication] setApplicationIconBadgeNumber:count];
}


@end
