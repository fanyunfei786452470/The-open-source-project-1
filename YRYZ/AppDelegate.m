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
#import <IQKeyboardManager.h>


@interface AppDelegate ()
@property (nonatomic,strong)YRTabBarController          *tabbar;

@end

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
    self.allowRotation = 0;
    
    self.window = [[UIWindow alloc]initWithFrame:[UIScreen mainScreen].bounds];
    self.window.backgroundColor = [UIColor whiteColor];
    self.tabbar = [[YRTabBarController alloc]init];
    self.window.rootViewController = self.tabbar;
    [self.window makeKeyAndVisible];
    
    
    // 注册友盟
    [self setupMob];
    [YRYZUIAppearance customNavigationbarAppearance];
    [self setJSPatch];
    [self setBugly];
    [self setupIQKeyboardManager];
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
    
    //趣拍
    [[SPKitExample sharedInstance] callThisInDidFinishLaunching];
    [[ALBBSDK sharedInstance] asyncInit:^{
    } failure:^(NSError *error) {
    }];
    
#pragma mark - 极光推送
    [self setJpushSDK:launchOptions];

    
    return YES;
}
-(void)setJpushSDK:(NSDictionary *)launchOptions{
    // Override point for customization after application launch.
    
    if ([[UIDevice currentDevice].systemVersion floatValue] >= 8.0) {
        //可以添加自定义categories
        [JPUSHService registerForRemoteNotificationTypes:(UIUserNotificationTypeBadge |
                                                          UIUserNotificationTypeSound |
                                                          UIUserNotificationTypeAlert)
                                              categories:nil];
    } else {
        //categories 必须为nil
        [JPUSHService registerForRemoteNotificationTypes:UIUserNotificationTypeNone categories:nil];
        //        [JPUSHService registerForRemoteNotificationTypes:(UIRemoteNotificationTypeBadge |
        //                                                          UIRemoteNotificationTypeSound |
        //                                                          UIRemoteNotificationTypeAlert)
        //                                              categories:nil];
    }
    
    //如不需要使用IDFA，advertisingIdentifier 可为nil
    [JPUSHService setupWithOption:launchOptions appKey:@"829a414d80f3a73b73025247"
                          channel:nil
                 apsForProduction:NO
            advertisingIdentifier:nil];
    
}



#pragma mark 基本设置
/**
 *  键盘设置
 */
- (void)setupIQKeyboardManager {
    
    [IQKeyboardManager sharedManager].shouldResignOnTouchOutside = YES;
    [IQKeyboardManager sharedManager].enable = YES;
    [IQKeyboardManager sharedManager].enableAutoToolbar = NO;
}
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
    
    [MobClick setLogEnabled:YES];
    
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
    DLog(@"%@----------",uid);
    if (uid && user && user.custId) {
        [[YRUserInfoManager manager] setCurrentUser:user];
        
        [[SPKitExample sharedInstance] callThisAfterISVAccountLoginSuccessWithYWLoginId:@"visitor89"
             passWord:@"taobao1234"
             preloginedBlock:^{
                                                                            
        } successBlock:^{
                                                                            
        } failedBlock:^(NSError *aError) {
        if (aError.code == YWLoginErrorCodePasswordError || aError.code == YWLoginErrorCodePasswordInvalid || aError.code == YWLoginErrorCodeUserNotExsit) {
                                                                                
         }
        }];
        return;
    }
}

/**
 *  注销事件
 */
- (void)logout
{
    //        [self logoutEMAction];
    [YRUserInfoManager manager].currentUser = nil;
    YRTabBarController *tabbarVc = [[YRTabBarController alloc] init];
    tabbarVc.selectedIndex = 4;
    self.window.rootViewController = tabbarVc;
}

//横竖屏设置
- (UIInterfaceOrientationMask)application:(UIApplication *)application supportedInterfaceOrientationsForWindow:(UIWindow *)window
{
    if (_allowRotation == 1) {
        return UIInterfaceOrientationMaskAll;//这个可以根据自己的需求设置旋转方向
    }
    else
    {
        return (UIInterfaceOrientationMaskPortrait);
    }
}

#pragma mark app
- (void)applicationWillResignActive:(UIApplication *)application {
    
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    
}

- (void)applicationWillTerminate:(UIApplication *)application {
    
}
- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken {
    NSLog(@"%@", [NSString stringWithFormat:@"Device Token: %@", deviceToken]);
    /// Required - 注册 DeviceToken
    [JPUSHService registerDeviceToken:deviceToken];
}
//消息推送通知
- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo {
    
    [JPUSHService handleRemoteNotification:userInfo];
    
    NSLog(@"收到通知1:%@", [self logDic:userInfo]);
    
    [JPUSHService handleRemoteNotification:userInfo];
}

//广告推送通知
- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo fetchCompletionHandler:(void (^)(UIBackgroundFetchResult))completionHandler {
    [JPUSHService handleRemoteNotification:userInfo];
    NSLog(@"收到通知2:%@", [self logDic:userInfo]);
    NSString *title = userInfo[@"aps"][@"alert"];
    UIAlertView *elar = [[UIAlertView alloc]initWithTitle:@"推送" message:title delegate:nil cancelButtonTitle:@"取消" otherButtonTitles:nil, nil];
    [elar show];

    completionHandler(UIBackgroundFetchResultNewData);
}

- (void)application:(UIApplication *)application didFailToRegisterForRemoteNotificationsWithError:(NSError *)error {
    //Optional
    NSLog(@"did Fail To Register For Remote Notifications With Error: %@", error);
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
    
    NetworkStatus status = [[Reachability reachabilityForInternetConnection] currentReachabilityStatus];
    
    switch (status) {
        case NotReachable:
        {
            UIView  *netTopView = [[UIView alloc] initWithFrame:CGRectMake(0, 64, SCREEN_WIDTH, 26)];
            netTopView .backgroundColor = RGBA_COLOR(255, 96, 96,0.8);
          
            
            UILabel  *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 26)];
            label.text = @"网络有点问题";
            label.font = [UIFont systemFontOfSize:12];
            label.textColor = [UIColor whiteColor];
            label.textAlignment = NSTextAlignmentCenter;
            [netTopView  addSubview:label];
            
            UIWindow * keyWindow = [[UIApplication sharedApplication] keyWindow];
            [keyWindow addSubview:netTopView ];
            
            self.netState = @"no net";
        }
            break;
        case ReachableViaWiFi:
            self.netState = @"wifi";
            break;
        case ReachableViaWWAN:
            self.netState = @"3G/4G";
            break;
        default:
            break;
    }
}

// 是否wifi
- (BOOL) isEnableWIFI
{
    return ([[Reachability reachabilityForLocalWiFi] currentReachabilityStatus] != NotReachable);
}

// 是否3G
- (BOOL) isEnable3G
{
    return ([[Reachability reachabilityForInternetConnection] currentReachabilityStatus] != NotReachable);
}
// log NSSet with UTF8
// if not ,log will be \Uxxx

- (NSString *)logDic:(NSDictionary *)dic {
    if (![dic count]) {
        return nil;
    }
    NSString *tempStr1 =
    [[dic description] stringByReplacingOccurrencesOfString:@"\\u"
                                                 withString:@"\\U"];
    NSString *tempStr2 =
    [tempStr1 stringByReplacingOccurrencesOfString:@"\"" withString:@"\\\""];
    NSString *tempStr3 =
    [[@"\"" stringByAppendingString:tempStr2] stringByAppendingString:@"\""];
    NSData *tempData = [tempStr3 dataUsingEncoding:NSUTF8StringEncoding];
    NSString *str =
    [NSPropertyListSerialization propertyListFromData:tempData
                                     mutabilityOption:NSPropertyListImmutable
                                               format:NULL
                                     errorDescription:NULL];
    return str;
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

@end
