//
//  SPKitExample.m
//  WXOpenIMSampleDev
//
//  Created by huanglei on 15/4/11.
//  Copyright (c) 2015年 taobao. All rights reserved.
//

#import "SPKitExample.h"

#import "YRMessageViewController.h"
#import "UIBarButtonItem+BlockSupport.h"
#import "YRMsgDetailViewController.h"
#import "YRGroupMsgDetailViewController.h"
#import "YRMsgDetailViewController.h"

#import <AVFoundation/AVFoundation.h>

#import <WXOpenIMSDKFMWK/YWFMWK.h>
#import <WXOUIModule/YWUIFMWK.h>

#import "SPUtil.h"

#import "SPBaseBubbleChatViewCustomize.h"
#import "SPBubbleViewModelCustomize.h"

#import "SPInputViewPluginGreeting.h"
#import "SPInputViewPluginCallingCard.h"
#import "SPInputViewPluginTransparent.h"

#import <WXOUIModule/YWIndicator.h>
#import <objc/runtime.h>
#import <WXOpenIMSDKFMWK/YWTribeSystemConversation.h>

#import "YRAdListUserInfoController.h"
#import "YRTabBarController.h"

#if __has_include("YWFeedbackServiceFMWK/YWFeedbackServiceFMWK.h")
#import <YWFeedbackServiceFMWK/YWFeedbackServiceFMWK.h>
#define HAS_FEEDBACK 1
#endif

#if __has_include("SPContactProfileController.h")
#import "SPContactProfileController.h"
#define HAS_CONTACTPROFILE 1
#endif

#if __has_include("SPTribeConversationViewController.h")
/// Demo中使用了继承方式，实现群聊聊天页面。
#import "SPTribeConversationViewController.h"
#define HAS_TRIBECONVERSATION 1
#endif

#if __has_include("SPMessageInputView.h")
#import "SPMessageInputView.h"
#define HAS_CUSTOMINPUT 1
#endif

#if __has_include("SPInputViewPluginPrivateImage.h")
#import "SPInputViewPluginPrivateImage.h"
#import "SPLogicBizPrivateImage.h"
#define HAS_PRIVATEIMAGE 1
#endif
/// 如果需要客服跟踪用户操作轨迹的功能，你可以取消以下行的注释，引入YWExtensionForCustomerServiceFMWK.framework
//#import <YWExtensionForCustomerServiceFMWK/YWExtensionForCustomerServiceFMWK.h>


#import "SPCallingCardBubbleViewModel.h"
#import "SPCallingCardBubbleChatView.h"

#import "SPGreetingBubbleViewModel.h"
#import "SPGreetingBubbleChatView.h"
#import "YRLoginController.h"

#if __has_include(<YWExtensionForShortVideoFMWK/IYWExtensionForShortVideoService.h>)
#import <YWExtensionForShortVideoFMWK/IYWExtensionForShortVideoService.h>

#define SPExtensionServiceFromProtocol(service) \
(id<service>)[[[YWAPI sharedInstance] getGlobalExtensionService] getExtensionByServiceName:NSStringFromProtocol(@protocol(service))]
#endif

NSString *const kSPCustomConversationIdForPortal = @"ywcustom007";
NSString *const kSPCustomConversationIdForFAQ = @"ywcustom008";

//#import "SPLoginController.h"

@interface SPKitExample ()
<YWMessageLifeDelegate,
UIAlertViewDelegate>

#define kSPAlertViewTagPhoneCall 2046

/**
 *  是否已经预登录进入
 */
- (BOOL)exampleIsPreLogined;

// 用于监听群系统消息变更
@property (nonatomic, strong) YWTribeSystemConversation *tribeSystemConversation;

@end

@implementation SPKitExample

#pragma mark - life

- (id)init
{
    self = [super init];
    
    if (self) {
        /// 初始化
        [self setLastConnectionStatus:YWIMConnectionStatusDisconnected];
    }
    return self;
}

#pragma mark - properties

- (id<UIApplicationDelegate>)appDelegate
{
    return [UIApplication sharedApplication].delegate;
}

- (UIWindow *)rootWindow
{
    UIWindow *result = nil;
    
    do {
        if ([self.appDelegate respondsToSelector:@selector(window)]) {
            result = [self.appDelegate window];
        }
        
        if (result) {
            break;
        }
    } while (NO);
    
    
    NSAssert(result, @"如果在您的App中出现这个断言失败，您需要检查- [SPKitExample rootWindow]中的实现，是否符合您的App结构");
    
    return result;
    
}

- (UINavigationController *)conversationNavigationController {
    UITabBarController *tabBarController = (UITabBarController *)self.rootWindow.rootViewController;
    if (![tabBarController isKindOfClass:[UITabBarController class]]) {
        return nil;
    }

    UINavigationController *navigationController = tabBarController.viewControllers.firstObject;
    if (![navigationController isKindOfClass:[UINavigationController class]]) {
        navigationController = nil;
        NSAssert(navigationController, @"如果在您的 App 中出现这个断言失败，您需要检查 View Controller 结构是否符合您的 App");
    }

    return navigationController;
}


#pragma mark - private methods


#pragma mark - public methods

+ (instancetype)sharedInstance
{
    static SPKitExample *sExample = nil;
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sExample = [[SPKitExample alloc] init];
    });
    
    return sExample;
}

#pragma mark - SDK Life Control
/**
 *  程序完成启动，在appdelegate中的 application:didFinishLaunchingWithOptions:一开始的地方调用
 */
- (void)callThisInDidFinishLaunching
{
    [self exampleSetCertName];
    
    if ([self exampleInit]) {
        // 在IMSDK截获到Push通知并需要您处理Push时，IMSDK会自动调用此回调
        [self exampleHandleAPNSPush];
        
        // 在IMSDK收到反馈消息通知时，IMSDK会自动调用此回调
        [self exampleListenFeedbackNewMessage];
        
        // 自定义全局导航栏
        [self exampleCustomGlobleNavigationBar];

        // 自定义头像样式
        [self exampleSetAvatarStyle];

        /// 监听消息生命周期回调
        [self exampleListenMyMessageLife];
        
    } else {
//        if ([UIDevice currentDevice].systemVersion.floatValue >= 8.0) {
//            UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"错误" message:@"SDK初始化失败, 请检查网络后重试" preferredStyle:UIAlertControllerStyleAlert];
//            
//            UIAlertAction *alertAction = [UIAlertAction actionWithTitle:@"重试" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
//                
//            }];
//            
//            [alertController addAction:alertAction];
//            
//            [[self conversationNavigationController] presentViewController:alertController animated:YES completion:nil];
//        } else {
//            /// 初始化失败，需要提示用户
//            UIAlertView *av = [[UIAlertView alloc] initWithTitle:@"错误" message:@"SDK初始化失败, 请检查网络后重试"
//                                                        delegate:self cancelButtonTitle:@"重试" otherButtonTitles:nil];
//            [av show];
//        }
    }
}

/**
 *  用户在应用的服务器登录成功之后，向云旺服务器登录之前调用
 *  @param ywLoginId, 用来登录云旺IMSDK的id
 *  @param password, 用来登录云旺IMSDK的密码
 *  @param aSuccessBlock, 登陆成功的回调
 *  @param aFailedBlock, 登录失败的回调
 */
- (void)callThisAfterISVAccountLoginSuccessWithYWLoginId:(NSString *)ywLoginId passWord:(NSString *)passWord preloginedBlock:(void(^)())aPreloginedBlock successBlock:(void(^)())aSuccessBlock failedBlock:(void (^)(NSError *))aFailedBlock
{
    /// 监听连接状态
    [self exampleListenConnectionStatus];
    
    /// 设置声音播放模式
    [self exampleSetAudioCategory];
    
    /// 设置头像和昵称
    [self exampleSetProfile];
    
//    /// 设置最大气泡宽度
//    [self exampleSetMaxBubbleWidth];
    
    /// 监听新消息
    [self exampleListenNewMessage];
    
    // 设置提示
    [self exampleSetNotificationBlock];

    /// 监听头像点击事件
    [self exampleListenOnClickAvatar];
    
    /// 监听链接点击事件
    [self exampleListenOnClickUrl];
    
    /// 监听预览大图事件
    [self exampleListenOnPreviewImage];
    
//    /// 自定义皮肤
    [self exampleCustomUISkin];
    
    /// 开启群@消息功能
//    [self exampleEnableTribeAtMessage];
    
    /// 开启单聊已读未读状态显示
//    [self exampleEnableReadFlag];
    
    if ([ywLoginId length] > 0 && [passWord length] > 0) {
        /// 预登陆
        [self examplePreLoginWithLoginId:ywLoginId successBlock:aPreloginedBlock];
        
        /// 真正登录
        [self exampleLoginWithUserID:ywLoginId password:passWord successBlock:aSuccessBlock failedBlock:aFailedBlock];
    } else {
        if (aFailedBlock) {
            aFailedBlock([NSError errorWithDomain:YWLoginServiceDomain code:YWLoginErrorCodePasswordError userInfo:nil]);
        }
    }
}

/**
 *  用户即将退出登录时调用
 */
- (void)callThisBeforeISVAccountLogout
{
    [self exampleLogout];
}

#pragma mark - basic

- (NSNumber *)lastEnvironment
{
    NSNumber *environment = [[NSUserDefaults standardUserDefaults] objectForKey:@"lastEnvironment"];
    if (environment == nil) {
        return @(YWEnvironmentRelease);
    }
    return environment;
}

/**
 *  设置证书名的示例代码
 */
- (void)exampleSetCertName
{
    /// 你可以根据当前的bundleId，设置不同的证书，避免修改代码
    
    /// 这些证书是我们在百川后台添加的。
    if ([[NSBundle mainBundle].bundleIdentifier isEqualToString:@"com.rzw.yrzy"]) {
        [[[YWAPI sharedInstance] getGlobalPushService] setXPushCertName:@"formal"];
    } else {
        /// 默认的情况下，我们都设置为生产证书
        [[[YWAPI sharedInstance] getGlobalPushService] setXPushCertName:@"formal"];
    }
}
/**
 *  初始化示例代码
 */
- (BOOL)exampleInit;
{
    /// 开启日志
    [[YWAPI sharedInstance] setLogEnabled:NO];
    
    NSError *error = nil;
    
    /// 异步初始化IM SDK
    // 设置环境，开发者可以不设置。默认是 线上环境 YWEnvironmentRelease
    [[YWAPI sharedInstance] setEnvironment:[self lastEnvironment].intValue];
//    [[YWAPI sharedInstance] setEnvironment:YWEnvironmentRelease];
    
    if ([self lastEnvironment].intValue == YWEnvironmentRelease || [self lastEnvironment].intValue == YWEnvironmentPreRelease) {
//#warning TODO: CHANGE TO YOUR AppKey
        /// 线上环境，更换成你自己的AppKey
//        [[YWAPI sharedInstance] syncInitWithOwnAppKey:@"23015524" getError:&error];
        [[YWAPI sharedInstance] syncInitWithOwnAppKey:@"23389732" getError:&error];

    } else {
        // OpenIM内网环境，暂时不向开发者开放，需要测试环境的，自行申请另一个Appkey作为测试环境
        [[YWAPI sharedInstance] syncInitWithOwnAppKey:@"23389732" getError:&error];
//        [[YWAPI sharedInstance] syncInitWithOwnAppKey:@"60028148" getError:&error];
    }

    if (error.code != 0 && error.code != YWSdkInitErrorCodeAlreadyInited) {
        /// 初始化失败
        return NO;
    } else {
        if (error.code == 0) {
            /// 首次初始化成功
            /// 获取一个IMKit并持有
            self.ywIMKit = [[YWAPI sharedInstance] fetchIMKitForOpenIM];
            [[self.ywIMKit.IMCore getContactService] setEnableContactOnlineStatus:NO];
        } else {
            /// 已经初始化
        }
        return YES;
    }
}

/**
 *  登录的示例代码
 */
- (void)exampleLoginWithUserID:(NSString *)aUserID password:(NSString *)aPassword successBlock:(void(^)())aSuccessBlock failedBlock:(void (^)(NSError *))aFailedBlock
{
    __weak typeof(self) weakSelf = self;
    aSuccessBlock = [aSuccessBlock copy];
    aFailedBlock = [aFailedBlock copy];
    
    /// 登录之前，先告诉IM如何获取登录信息。
    /// 当IM向服务器发起登录请求之前，会调用这个block，来获取用户名和密码信息。
    [[self.ywIMKit.IMCore getLoginService] setFetchLoginInfoBlock:^(YWFetchLoginInfoCompletionBlock aCompletionBlock) {
        aCompletionBlock(YES, aUserID, aPassword, nil, nil);
    }];
    /// 发起登录
    [[self.ywIMKit.IMCore getLoginService] asyncLoginWithCompletionBlock:^(NSError *aError, NSDictionary *aResult) {
        if (aError.code == 0 || [[self.ywIMKit.IMCore getLoginService] isCurrentLogined]) {
            /// 登录成功
//#ifdef DEBUG
//            [[SPUtil sharedInstance] showNotificationInViewController:self.rootWindow.rootViewController title:nil subtitle:nil type:SPMessageNotificationTypeSuccess];
//            [YWIndicator showTopToastTitle:nil content:nil userInfo:nil withTimeToDisplay:1.f andClickBlock:NULL];

//#endif
            
            /// 添加长期置顶的自定义会话
            [weakSelf exampleAddHighPriorityCustomConversation];
            
            if (aSuccessBlock) {
                aSuccessBlock();
            }
        } else {
//            [YWIndicator showTopToastTitle:@"登录失败" content:aError.description userInfo:nil withTimeToDisplay:1.f andClickBlock:NULL];

            /// 登录失败
//            [[SPUtil sharedInstance] showNotificationInViewController:self.rootWindow.rootViewController title:@"登录失败" subtitle:aError.description type:SPMessageNotificationTypeError];
//            [MBProgressHUD showError:@"IM登录失败"];
            if (aFailedBlock) {
                aFailedBlock(aError);
            }
        }
    }];
}

/**
 *  预登陆
 */
- (void)examplePreLoginWithLoginId:(NSString *)loginId successBlock:(void(^)())aPreloginedBlock
{
    /// 预登录
    if ([[self.ywIMKit.IMCore getLoginService] preLoginWithPerson:[[YWPerson alloc] initWithPersonId:loginId]]) {
        /// 预登录成功，直接进入页面,这里可以打开界面
        if (aPreloginedBlock) {
            aPreloginedBlock();
        }
    }
}

/**
 *  是否已经预登录进入
 */
- (BOOL)exampleIsPreLogined
{
    /// 这个是Demo中判断是否已经进入IM主页面的方法，你需要修改成你自己的方法
    return [self.rootWindow.rootViewController isKindOfClass:[YRTabBarController class]];
}

/**
 *  监听连接状态
 */
- (void)exampleListenConnectionStatus
{
    __weak typeof(self) weakSelf = self;
    [[self.ywIMKit.IMCore getLoginService] addConnectionStatusChangedBlock:^(YWIMConnectionStatus aStatus, NSError *aError) {
        
        [weakSelf setLastConnectionStatus:aStatus];

        if (aStatus == YWIMConnectionStatusForceLogout || aStatus == YWIMConnectionStatusMannualLogout || aStatus == YWIMConnectionStatusAutoConnectFailed) {
            /// 手动登出、被踢、自动连接失败，都退出到登录页面
            if (aStatus != YWIMConnectionStatusMannualLogout) {
                DLog(@"%ldYW状态------------",aStatus);
            }
   
        }else if (aStatus == YWIMConnectionStatusConnected) {
            /// 监听群系统消息
//            [self exampleListenTribeSystemMessagesUpdate];
        }
    } forKey:[self description] ofPriority:YWBlockPriorityDeveloper];
}


/**
 *  注销的示例代码
 */
- (void)exampleLogout
{
    [[self.ywIMKit.IMCore getLoginService] asyncLogoutWithCompletionBlock:^(NSError *aError, NSDictionary *aResult) {
        
        DLog(@"注销：%@",aResult);
    }];
}

#pragma mark - abilities


/**
 *  设置声音播放模式
 */
- (void)exampleSetAudioCategory
{
    /// 设置为扬声器模式，这样可以支持靠近耳朵时自动切换到听筒
    [self.ywIMKit setAudioSessionCategory:AVAudioSessionCategoryPlayback];
}

- (void)exampleSetAvatarStyle
{
    [self.ywIMKit setAvatarImageViewCornerRadius:6];
//    [self.ywIMKit setAvatarImageViewCornerRadius:UIViewContentModeScaleAspectFill];
}

- (void)exampleSetProfile
{
    /// 如果你已经将所有的用户Profile都导入到了IM服务器，则可以直接注释掉下面setFetchProfileBlockV2:函数。
    /// 如果你使用了客服功能，或者你还没有将用户Profile导入到IM服务器，则需要参考下面setFetchProfileBlockV2:中的实现，并修改成你自己获取用户Profile的方式
    [self.ywIMKit setFetchProfileBlockV2:^(YWPerson *aPerson, YWFetchProfileProgressBlock aProgressBlock, YWFetchProfileCompletionBlock aCompletionBlock) {
        if (!aPerson.personId) {
            return;
        }
        
        /// Demo中模拟了异步获取Profile的过程，你需要根据实际情况，从你的服务器获取用户profile
        [[SPUtil sharedInstance] asyncGetProfileWithPerson:aPerson progress:aProgressBlock completion:aCompletionBlock];
    }];
    /// IM会在需要显示群聊profile时，调用这个block，来获取群聊的头像和昵称
    [self.ywIMKit setFetchProfileForTribeBlock:^(YWTribe *aTribe, YWProfileProgressBlock aProgressBlock, YWProfileCompletionBlock aCompletionBlock) {
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.01f * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
             /// 用2秒钟的网络延迟，模拟从网络获取群头像
            YWProfileItem *item = [[YWProfileItem alloc] init];
            item.tribe = aTribe;
            item.displayName = aTribe.tribeName;
            item.avatar = [[SPUtil sharedInstance] avatarForTribe:aTribe];
            aCompletionBlock(YES, item);
        });
    }];
    
    /// IM会在显示自定义会话时，调用此block
//    [self.ywIMKit setFetchCustomProfileBlock:^(YWConversation *conversation, YWFetchCustomProfileCompletionBlock aCompletionBlock) {
//        if (aCompletionBlock) {
//            if ([conversation.conversationId isEqualToString:SPTribeSystemConversationID]) {
//                aCompletionBlock(YES, conversation, @"群系统信息", [UIImage imageNamed:@"demo_group_120"]);
//            } else if ([conversation.conversationId isEqualToString:kSPCustomConversationIdForPortal]) {
//                aCompletionBlock(YES, conversation, @"自定义会话和置顶功能！", [UIImage imageNamed:@"input_plug_ico_hi_nor"]);
//            } else if ([conversation.conversationId isEqualToString:kSPCustomConversationIdForFAQ]) {
//                aCompletionBlock(YES, conversation, @"云旺iOS精华问题大汇总！", [UIImage imageNamed:@"input_plug_ico_card_nor"]);
//            }
//        }
//    }];
}

#pragma mark - ui pages

/**
 *  创建会话列表页面
 */
- (YWConversationListViewController *)exampleMakeConversationListControllerWithSelectItemBlock:(YWConversationsListDidSelectItemBlock)aSelectItemBlock
{
    YWConversationListViewController *result = [self.ywIMKit makeConversationListViewController];
    
    [result setDidSelectItemBlock:aSelectItemBlock];
    
    /// 自定义会话Cell
    [self exampleCustomizeConversationCellWithConversationListController:result];
    
    return result;
}

/**
 *  打开某个会话
 */
- (void)exampleOpenConversationViewControllerWithConversation:(YWConversation *)aConversation fromNavigationController:(UINavigationController *)aNavigationController
{

    self.conversation = aConversation;
    BaseNavigationController *conversationNavigationController = nil;
//    if (aNavigationController) {
        conversationNavigationController = (BaseNavigationController *)aNavigationController;
//    }
//    else {
//        conversationNavigationController = [self conversationNavigationController];
//    }

    __block YWConversationViewController *conversationViewController = nil;
    [aNavigationController.viewControllers enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        if ([obj isKindOfClass:[YWConversationViewController class]]) {
            YWConversationViewController *c = obj;
            if (aConversation.conversationId && [c.conversation.conversationId isEqualToString:aConversation.conversationId]) {
                conversationViewController = c;
                *stop = YES;
            }
        }
    }];

    if (!conversationViewController) {
        conversationViewController = [self exampleMakeConversationViewControllerWithConversation:aConversation];
    }

    NSArray *viewControllers = nil;
    if (conversationNavigationController.viewControllers.firstObject == conversationViewController) {
        viewControllers = @[conversationNavigationController.viewControllers.firstObject];
    }else {

        viewControllers = @[conversationNavigationController.viewControllers.firstObject, conversationViewController];
    }
    NSLog(@"%@,%@",self.ywIMKit,aConversation);
    
    if ([aConversation isKindOfClass:[YWP2PConversation class]]) {
        YWP2PConversation *chatConversation = (YWP2PConversation*)aConversation;
        self.aPerson = chatConversation.person;
        self.isGroupChat = 1;

    }else if([aConversation isKindOfClass:[YWTribeConversation class]]){
        self.isGroupChat = 2;
        YWTribeConversation *groupConversation = (YWTribeConversation *)aConversation;
        self.aTribe = groupConversation.tribe;
    }
    

    [conversationNavigationController setViewControllers:viewControllers animated:YES];
}

/**
 *  打开单聊页面
 */
- (void)exampleOpenConversationViewControllerWithPerson:(YWPerson *)aPerson fromNavigationController:(UINavigationController *)aNavigationController
{
    YWConversation *conversation = [YWP2PConversation fetchConversationByPerson:aPerson creatIfNotExist:YES baseContext:self.ywIMKit.IMCore];
//    YWFeedbackConversation *feedbackConversation = (YWFeedbackConversation *)conversation;
//    YWConversationViewController *conversationController = nil;
//    
//    conversationController = [self.ywIMKit makeFeedbackViewControllerWithConversation:feedbackConversation];
 
    
    self.isGroupChat = 1;
    self.aPerson = aPerson;
    [self exampleOpenConversationViewControllerWithConversation:conversation fromNavigationController:aNavigationController];
}

/**
 *  打开群聊页面
 */
- (void)exampleOpenConversationViewControllerWithTribe:(YWTribe *)aTribe fromNavigationController:(UINavigationController *)aNavigationController
{
    YWConversation *conversation = [YWTribeConversation fetchConversationByTribe:aTribe createIfNotExist:YES baseContext:self.ywIMKit.IMCore];
    
    
    self.aTribe = aTribe;
    self.isGroupChat = 2;
    
    [self exampleOpenConversationViewControllerWithConversation:conversation fromNavigationController:aNavigationController];
    
}

- (void)exampleOpenEServiceConversationWithPersonId:(NSString *)aPersonId fromNavigationController:(UINavigationController *)aNavigationController
{
    YWPerson *person = [[SPKitExample sharedInstance] exampleFetchEServicePersonWithPersonId:aPersonId groupId:nil];
    [[SPKitExample sharedInstance] exampleOpenConversationViewControllerWithPerson:person fromNavigationController:aNavigationController];
    

}

/**
 *  创建某个会话Controller，在这个Demo中仅用于iPad SplitController中显示会话
 */
- (YWConversationViewController *)exampleMakeConversationViewControllerWithConversation:(YWConversation *)conversation {
    
    
    YWConversationViewController *conversationController = nil;
#if HAS_TRIBECONVERSATION
    /// Demo中使用了继承方式，实现群聊聊天页面。
    if ([conversation isKindOfClass:[YWTribeConversation class]]) {
        conversationController = [SPTribeConversationViewController makeControllerWithIMKit:self.ywIMKit
                                                                               conversation:conversation];
        
        [self.ywIMKit addDefaultInputViewPluginsToMessagesListController:conversationController];
        
    }else
#endif
#if HAS_FEEDBACK
        if ([conversation isKindOfClass:[YWFeedbackConversation class]]) {
            YWFeedbackConversation *feedbackConversation = (YWFeedbackConversation *)conversation;
            conversationController = [self.ywIMKit makeFeedbackViewControllerWithConversation:feedbackConversation];
            
            // 如果不需要显示顶部联系方式输入可以打开下面注释
            //[conversationController setHidesBottomBarWhenPushed:YES];

            conversationController.hidesBottomBarWhenPushed = YES;
            return conversationController;
        }
        else
#endif
    {
        conversationController = [YWConversationViewController makeControllerWithIMKit:self.ywIMKit conversation:conversation];
        [self.ywIMKit addDefaultInputViewPluginsToMessagesListController:conversationController];
    }
    //导航栏左、右侧按钮
    {
       
        
        
        __weak YWConversationViewController *weakController = conversationController;
        __weak typeof(self) weakS = self;
        conversationController.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"yr_mine"] style:UIBarButtonItemStylePlain andBlock:^{
            
            if (weakS.isGroupChat == 1) {
                YRMsgDetailViewController *msgDetailVc = [[YRMsgDetailViewController alloc] init];
                msgDetailVc.imKit = self.ywIMKit;
                msgDetailVc.person = self.aPerson;
                [weakController.navigationController pushViewController:msgDetailVc animated:YES];
            }else if (weakS.isGroupChat == 2){
                __weak typeof(self) weakSelf = self;
                
                [self.ywTribeService requestTribeMembersFromServer:weakSelf.aTribe.tribeId completion:^(NSArray *members, NSString *tribeId, NSError *error) {
                    if( error == nil ) {
                        
                        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1f * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                            
                            YRGroupMsgDetailViewController *msgDetailVc = [[YRGroupMsgDetailViewController alloc] init];
                            
                            msgDetailVc.imKit = weakSelf.ywIMKit;
                            msgDetailVc.tribe = weakSelf.aTribe;
                            msgDetailVc.dataArr = members;
                            [weakController.navigationController pushViewController:msgDetailVc animated:YES];
                            
//                            weakSelf.userArray = [members mutableCopy];
//                            
//                            NSInteger count = weakSelf.userArray.count >2?2:1;
//                            YRGroupDetailHeaderView *headersView = [[YRGroupDetailHeaderView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH,(itemHeight+20)*count+100)];
//                            headersView.delegate = self;
//                            weakSelf.tb_View.tableHeaderView = headersView;
//                            headersView.dataSource = weakSelf.userArray;
//                            [self.headerView removeAllSubviews];
//                            [weakSelf.tb_View reloadData];
                            
                        });
                    }
                }];
            }
        }];
        
        conversationController.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"yr_return"] style:UIBarButtonItemStylePlain andBlock:^{
            
            
            [weakController.navigationController popViewControllerAnimated:YES];
        }];
        
        
        
        [self.ywIMKit setOpenProfileBlock:^(YWPerson *aPerson, UIViewController *aParentController) {
#pragma mark 头像点击
            //            YWConversation *conversation = [YWP2PConversation fetchConversationByPerson:aPerson creatIfNotExist:YES baseContext:self.ywIMKit.IMCore];
            //            YWConversationViewController *weakController = [YWConversationViewController makeControllerWithIMKit:self.ywIMKit conversation:conversation];
            //            [self.ywIMKit addDefaultInputViewPluginsToMessagesListController:weakController];
            
            YRAdListUserInfoController *userInfoVc = [[YRAdListUserInfoController alloc] init];
            userInfoVc.custId = aPerson.personId?aPerson.personId:@"";
            userInfoVc.isFriend = YES;
            
            [weakController.navigationController pushViewController:userInfoVc animated:YES];
            
            
            
        }];

    }
    /// 添加自定义插件
//    [self exampleAddInputViewPluginToConversationController:conversationController];

    /// 添加自定义表情
    [self exampleShowCustomEmotionWithConversationController:conversationController];

    /// 设置显示自定义消息
    [self exampleShowCustomMessageWithConversationController:conversationController];

    /// 设置消息长按菜单didSelectItemBlock
    [self exampleSetMessageMenuToConversationController:conversationController];


    conversationController.hidesBottomBarWhenPushed = YES;

    return conversationController;
}


#pragma mark - Customize

/**
 *  自定义全局导航栏
 */
- (void)exampleCustomGlobleNavigationBar
{
    [[UINavigationBar appearance] setBarTintColor:[UIColor whiteColor]];
}

/**
 *  自定义皮肤
 */
- (void)exampleCustomUISkin
{
    // 使用自定义UI资源和配置
    YWIMKit *imkit = self.ywIMKit;
    
    NSString *bundleName = @"CustomizedUIResources.bundle";
    NSString *bundlePath = [[NSBundle mainBundle].resourcePath stringByAppendingPathComponent:bundleName];
    NSBundle *customizedUIResourcesBundle = [NSBundle bundleWithPath:bundlePath];
    [imkit setCustomizedUIResources:customizedUIResourcesBundle];
}

- (void)exampleEnableTribeAtMessage
{
    [self.ywIMKit.IMCore getSettingService].disableAtFeatures = NO;
}

- (void)exampleEnableReadFlag
{
    // 开启单聊已读未读显示开关，如果应用场景不需要，可以关闭
    [[self.ywIMKit.IMCore getConversationService] setEnableMessageReadFlag:YES];
}

#pragma mark - 聊天页面自定义

/**
 *  添加输入面板插件
 */
- (void)exampleAddInputViewPluginToConversationController:(YWConversationViewController *)aConversationController
{    /// 添加插件
    if ([aConversationController.messageInputView isKindOfClass:[YWMessageInputView class]]) {
        YWMessageInputView *messageInputView = (YWMessageInputView *)aConversationController.messageInputView;

        /// 创建自定义插件
        SPInputViewPluginGreeting *plugin = [[SPInputViewPluginGreeting alloc] init];
        [messageInputView addPlugin:plugin];

        SPInputViewPluginCallingCard *pluginCallingCard = [[SPInputViewPluginCallingCard alloc] init];
        [messageInputView addPlugin:pluginCallingCard];
        
        if ([aConversationController.conversation isKindOfClass:[YWP2PConversation class]]) {
            /// 透传消息目前仅支持单聊会话
            /// 此功能仅作为示例代码
            /**
            SPInputViewPluginTransparent *pluginTransparent = [[SPInputViewPluginTransparent alloc] init];
            [messageInputView addPlugin:pluginTransparent];
             */
        }
        
#if HAS_PRIVATEIMAGE
        if ([aConversationController.conversation isKindOfClass:[YWP2PConversation class]]) {
            /// 透传消息目前仅支持单聊会话
            SPInputViewPluginPrivateImage *plugin = [[SPInputViewPluginPrivateImage alloc] init];
            [messageInputView addPlugin:plugin];
        }
#endif
    }
}

/**
 *  设置如何显示自定义消息
 */
- (void)exampleShowCustomMessageWithConversationController:(YWConversationViewController *)aConversationController
{
    /// 设置用于显示自定义消息的ViewModel
    /// ViewModel，顾名思义，一般用于解析和存储结构化数据
    
    __weak __typeof(self) weakSelf = self;
    __weak __typeof(aConversationController) weakController = aConversationController;
    [aConversationController setHook4BubbleViewModel:^YWBaseBubbleViewModel *(id<IYWMessage> message) {
        if ([[message messageBody] isKindOfClass:[YWMessageBodyCustomize class]]) {
            
#if HAS_PRIVATEIMAGE
            {
                YWBaseBubbleViewModel *vm = [[SPLogicBizPrivateImage sharedInstance] handleShowMessage:message];
                if (vm) {
                    return vm;
                }
            }
#endif

            
            YWMessageBodyCustomize *customizeMessageBody = (YWMessageBodyCustomize *)[message messageBody];
            
            NSData *contentData = [customizeMessageBody.content dataUsingEncoding:NSUTF8StringEncoding];
            NSDictionary *contentDictionary = [NSJSONSerialization JSONObjectWithData:contentData
                                                                              options:0
                                                                                error:NULL];
            
            NSString *messageType = contentDictionary[kSPCustomizeMessageType];
            if ([messageType isEqualToString:@"CallingCard"]) {
                SPCallingCardBubbleViewModel *viewModel = [[SPCallingCardBubbleViewModel alloc] initWithMessage:message];
                return viewModel;
            }
            else if ([messageType isEqualToString:@"Greeting"]) {
                SPGreetingBubbleViewModel *viewModel = [[SPGreetingBubbleViewModel alloc] initWithMessage:message];
                return viewModel;
                
            }
            else {
                SPBubbleViewModelCustomize *viewModel = [[SPBubbleViewModelCustomize alloc] initWithMessage:message];
                return viewModel;
            }
        }
        
        return nil;
    }];
    
    /// 设置用于显示自定义消息的ChatView
    /// ChatView一般从ViewModel中获取已经解析的数据，用于显示
    [aConversationController setHook4BubbleView:^YWBaseBubbleChatView *(YWBaseBubbleViewModel *viewModel) {
#if HAS_PRIVATEIMAGE
        {
            YWBaseBubbleChatView *cv = [[SPLogicBizPrivateImage sharedInstance] handleShowModel:viewModel];
            if (cv) {
                return cv;
            }
        }
#endif
        if ([viewModel isKindOfClass:[SPCallingCardBubbleViewModel class]]) {
            SPCallingCardBubbleChatView *chatView = [[SPCallingCardBubbleChatView alloc] init];
            return chatView;
        }
        else if ([viewModel isKindOfClass:[SPGreetingBubbleViewModel class]]) {
            SPGreetingBubbleChatView *chatView = [[SPGreetingBubbleChatView alloc] init];
            return chatView;
        }
        else if ([viewModel isKindOfClass:[SPBubbleViewModelCustomize class]]) {
            SPBaseBubbleChatViewCustomize *chatView = [[SPBaseBubbleChatViewCustomize alloc] init];
            return chatView;
        }
        return nil;
    }];
    
    /// SDk会对上面Hoo Block中返回的BubbleView做Cache，当BubbleView被首次使用或者复用时会触发Block以便刷新数据。
    [aConversationController setHook4BubbleViewPrepare4Use:^(YWBaseBubbleChatView *bubbleView) {
#if HAS_PRIVATEIMAGE
        {
            BOOL handled = [[SPLogicBizPrivateImage sharedInstance] handlePrepare4UseBubbleView:bubbleView inConversationController:weakController];
            if (handled) {
                return;
            }
        }
#endif
    }];
    
    /// SDk会对上面Hoo Block中返回的BubbleViewModel做Cache，当BubbleViewModel被首次使用或者复用时会触发Block以便刷新数据。
    [aConversationController setHook4BubbleViewModelPrepare4Use:^(YWBaseBubbleViewModel *viewModel) {
        
        if ([viewModel isKindOfClass:[SPCallingCardBubbleViewModel class]]) {
            
            __weak SPCallingCardBubbleViewModel * weakModel = (SPCallingCardBubbleViewModel *)viewModel;
            ((SPCallingCardBubbleViewModel *)viewModel).ask4showBlock = ^(void) {
                BOOL isMe = [weakModel.person.personId isEqualToString:[[weakController.kitRef.IMCore getLoginService] currentLoginedUserId]];
                
                if ( isMe == NO ) {
                    [weakSelf exampleOpenConversationViewControllerWithPerson:weakModel.person fromNavigationController:weakController.navigationController];
                }
                else if (weakController.kitRef.openProfileBlock) {
                    weakController.kitRef.openProfileBlock(weakModel.person, weakController);
                }
            };
            
        }
        
    }];
}

/**
 *  添加或者更新自定义会话
 */
- (void)exampleAddOrUpdateCustomConversation
{
    NSInteger random = arc4random()%100;
    static NSArray *contentArray = nil;
    if (contentArray == nil) {
        contentArray = @[@"欢迎使用OpenIM", @"新的开始", @"完美的APP", @"请点击我"];
    }
    YWCustomConversation *conversation = [YWCustomConversation fetchConversationByConversationId:kSPCustomConversationIdForPortal creatIfNotExist:YES baseContext:[SPKitExample sharedInstance].ywIMKit.IMCore];
    /// 每一次点击都随机的展示未读数和最后消息
    [conversation modifyUnreadCount:@(random) latestContent:contentArray[random%4] latestTime:[NSDate date]];
    
    /// 将这个会话置顶
    [self exampleMarkConversationOnTop:conversation onTop:YES];
}

/**
 *  将会话置顶
 */
- (void)exampleMarkConversationOnTop:(YWConversation *)aConversation onTop:(BOOL)aOnTop
{
    NSError *error = nil;
    [aConversation markConversationOnTop:aOnTop getError:&error];
    if (error) {
//        [[SPUtil sharedInstance] showNotificationInViewController:nil title:@"自定义消息置顶失败" subtitle:nil type:SPMessageNotificationTypeError];
        [MBProgressHUD showError:@"自定义消息置顶失败"];

    }
}

/**
 *  自定义优先级的置顶会话（可保持长期置顶）
 */
- (void)exampleAddHighPriorityCustomConversation
{
    /// 获取该自定义会话
    YWCustomConversation *conversation = [YWCustomConversation fetchConversationByConversationId:kSPCustomConversationIdForFAQ creatIfNotExist:NO baseContext:[SPKitExample sharedInstance].ywIMKit.IMCore];
    
    if (conversation == nil) {
        /// 还没有则创建
        conversation = [YWCustomConversation fetchConversationByConversationId:kSPCustomConversationIdForFAQ creatIfNotExist:YES baseContext:[SPKitExample sharedInstance].ywIMKit.IMCore];
        
        /// 将这个会话置顶，时间为10年后（除非10年后你置顶了其他会话，否则这个优先级最高。:-)  ）
        [conversation markConversationOnTop:YES time:[[NSDate date] timeIntervalSince1970]+3600*24*365*10 getError:NULL];
    }
}


/**
 *  自定义会话Cell
 */

const CGFloat kSPCustomConversationCellHeight = 30;
const CGFloat kSPCustomConversationCellContentMargin =10;
- (void)exampleCustomizeConversationCellWithConversationListController:(YWConversationListViewController *)aConversationListController
{
    /// 自定义Cell高度
    [aConversationListController setHeightForRowBlock:^CGFloat(UITableView *aTableView, NSIndexPath *aIndexPath, YWConversation *aConversation) {
        if ([aConversation.conversationId isEqualToString:kSPCustomConversationIdForFAQ]) {
            /// TODO: 如果希望自定义Cell高度，在此返回你希望的高度
            return 0;
        } else {
            return YWConversationListCellDefaultHeight;
        }
    }];
    
    /// 自定义Cell
    [aConversationListController setCellForRowBlock:^UITableViewCell *(UITableView *aTableView, NSIndexPath *aIndexPath, YWConversation *aConversation) {
        if ([aConversation.conversationId isEqualToString:kSPCustomConversationIdForFAQ]) {
            /// TODO: 如果希望自定义Cell，在此返回非空的cell
            UITableViewCell *faqCell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"FAQCell"];
            
            UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(kSPCustomConversationCellContentMargin, 0, faqCell.contentView.frame.size.width - kSPCustomConversationCellContentMargin*2, faqCell.contentView.frame.size.height)];
            [label setAutoresizingMask:UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight];
            [faqCell.contentView addSubview:label];
            
//            [label setText:@"点击查看云旺iOS精华问题"];
            [faqCell setBackgroundColor:[UIColor colorWithRed:201.f/255.f green:201.f/255.f blue:206.f/255.f alpha:1.f]];
            [label setTextColor:[UIColor whiteColor]];
            [label setTextAlignment:NSTextAlignmentCenter];
            [label setFont:[UIFont systemFontOfSize:12.f]];
            return faqCell;
        } else {
            return nil;
        }
    }];
    
    /// 自定义Cell调整
    [aConversationListController setConfigureCellBlock:^(UITableViewCell *aCell, UITableView *aTableView, NSIndexPath *aIndexPath, YWConversation *aConversation) {
        if ([aConversation.conversationId isEqualToString:kSPCustomConversationIdForFAQ]) {
            return;
        } else {
            return;
        }
    }];
    
    /// 自定义Cell菜单
    [aConversationListController setConversationEditActionBlock:^NSArray *(YWConversation *aConversation, NSArray *editActions) {
        if ([aConversation.conversationId isEqualToString:kSPCustomConversationIdForFAQ]) {
            /// 这个会话不能取消置顶和删除
            return @[];
        } else {
            /// TODO: 如果需要自定义其他会话的菜单，在此编辑
            return editActions;
        }
    }];
}

/**
 *  发送透传指令
 *  并且展示了如何在客户端控制对方iOS设备收到的Push文案
 *  不显示在会话列表和聊天页面，开发者可以监听到该消息，做特定的逻辑处理
 */
- (void)exampleSendTransparentCommand:(NSString *)aCommand inConversation:(YWConversation *)aConversation completion:(YWMessageSendingCompletionBlock)aCompletion
{
    YWMessageBodyCustomize *body = [[YWMessageBodyCustomize alloc] initWithMessageCustomizeContent:aCommand summary:@"阅后即焚" isTransparent:YES];
    /// 控制对方收到的Push文案，你还可以控制推送声音，是否需要push等，详见：YWConversationServiceDef.h
    NSDictionary *controlParameters = @{kYWMsgCtrlKeyPush:@{kYWMsgCtrlKeyPushKeyHowToPush:@{kYWMsgCtrlKeyPushKeyHowToPushKeyTitle:@"请务必阅后即焚"}}};
    [aConversation asyncSendMessageBody:body controlParameters:controlParameters progress:NULL completion:aCompletion];
}

/**
 *  插入本地消息
 *  消息不会被发送到对方，仅本地展示
 */
- (void)exampleInsertLocalMessageBody:(YWMessageBody *)aBody inConversation:(YWConversation *)aConversation
{
    NSDictionary *controlParameters = @{kYWMsgCtrlKeyClientLocal:@{kYWMsgCtrlKeyClientLocalKeyOnlySave:@(YES)}}; /// 控制字段
    [aConversation asyncSendMessageBody:aBody controlParameters:controlParameters progress:NULL completion:NULL];
}


/**
 *  设置如何显示自定义表情
 */
- (void)exampleShowCustomEmotionWithConversationController:(YWConversationViewController *)aConversationController
{
    if ([aConversationController.messageInputView isKindOfClass:[YWMessageInputView class]]) {
        YWMessageInputView *messageInputView = (YWMessageInputView *)aConversationController.messageInputView;
        for ( id item in messageInputView.allPluginList )
        {
            if ( ![item isKindOfClass:[YWInputViewPluginEmoticonPicker class]] ) continue;

            YWInputViewPluginEmoticonPicker *emotionPicker = (YWInputViewPluginEmoticonPicker *)item;

            NSString *filePath = [[NSBundle mainBundle] pathForResource:@"YW_TGZ_Emoitons" ofType:@"emo"];
            NSArray *groups = [YWEmoticonGroupLoader emoticonGroupsWithEMOFilePath:filePath];

            for (YWEmoticonGroup *group in groups)
            {
                [emotionPicker addEmoticonGroup:group];
            }
        }

    }
}

/**
 *  设置气泡最大宽度
 */
- (void)exampleSetMaxBubbleWidth
{
    [YWBaseBubbleChatView setMaxWidthUsedForLayout:280.f];
}

- (void)image:(UIImage *)image didFinishSavingWithError:(NSError *)error contextInfo:(void *)contextInfo
{
    NSString* strError = @"保存成功，照片已经保存至相册。";
    if( error != nil )
    {
        strError = error.localizedDescription;
    }
    
//    [[SPUtil sharedInstance] showNotificationInViewController:nil title:@"图片保存结果" subtitle:strError type:SPMessageNotificationTypeMessage];
    [MBProgressHUD showSuccess:strError];
}


/**
 *  设置消息的长按菜单
 *  这个方法展示如何设置图片消息的长按菜单
 */
- (void)exampleSetMessageMenuToConversationController:(YWConversationViewController *)aConversationController
{
    __weak typeof(self) weakSelf = self;
    [aConversationController setMessageCustomMenuItemsBlock:^NSArray *(id<IYWMessage> aMessage) {
        if ([[aMessage messageBody] isKindOfClass:[YWMessageBodyImage class]]) {
            YWMessageBodyImage *bodyImage = (YWMessageBodyImage *)[aMessage messageBody];
            if (bodyImage.originalImageType == YWMessageBodyImageTypeNormal) {
                /// 对于普通图片，我们增加一个保存按钮
                return @[[[YWMoreActionItem alloc] initWithActionName:@"保存" actionBlock:^(NSDictionary *aUserInfo) {
                    NSString *messageId = aUserInfo[YWConversationMessageCustomMenuItemUserInfoKeyMessageId]; /// 获取长按的MessageId
                    YWConversationViewController *conversationController = aUserInfo[YWConversationMessageCustomMenuItemUserInfoKeyController]; /// 获取会话Controller
                    id<IYWMessage> message = [conversationController.conversation fetchMessageWithMessageId:messageId];
                    message = [message conformsToProtocol:@protocol(IYWMessage)] ? message : nil;
                    if ([[message messageBody] isKindOfClass:[YWMessageBodyImage class]]) {
                        YWMessageBodyImage *bodyImage = (YWMessageBodyImage *)[message messageBody];
                        NSArray *forRetain = @[bodyImage];
                        [bodyImage asyncGetOriginalImageWithProgress:^(CGFloat progress) {
                            ;
                        } completion:^(NSData *imageData, NSError *aError) {
                            /// 下载成功后保存
                            UIImage *img = [UIImage imageWithData:imageData];
                            if (img) {
                                UIImageWriteToSavedPhotosAlbum(img, weakSelf, @selector(image:didFinishSavingWithError:contextInfo:), NULL);
                            }
                            [forRetain count]; /// 用于防止bodyImage被释放
                        }];
                    }
                }]];
            }
        }
        return nil;
    }];
}

#pragma mark - events

/**
 *  监听新消息
 */
- (void)exampleListenNewMessage
{
    [[self.ywIMKit.IMCore getConversationService] addOnNewMessageBlockV2:^(NSArray *aMessages, BOOL aIsOffline) {
        
        /// 你可以在此处根据需要播放提示音
        
        /// 展示透传消息
        [aMessages enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
            id<IYWMessage> msg = obj;
            YWMessageBodyCustomize *body = nil;
            if ([msg respondsToSelector:@selector(messageBody)]) {
                body = [[msg messageBody] isKindOfClass:[YWMessageBodyCustomize class]] ? (YWMessageBodyCustomize *)[msg messageBody] : nil;
            }
            if (body) {
                /// 先询问其他相关逻辑是否会处理
#if HAS_PRIVATEIMAGE
                if ([[SPLogicBizPrivateImage sharedInstance] handleListenNewCustomMessage:msg]) {
                    return;
                }
#endif
                
                
                NSData *contentData = [body.content dataUsingEncoding:NSUTF8StringEncoding];
                NSDictionary *contentDictionary = [NSJSONSerialization JSONObjectWithData:contentData
                                                                                  options:0
                                                                                    error:NULL];

                NSString *messageType = contentDictionary[kSPCustomizeMessageType];
                if ([messageType isEqualToString:@"yuehoujifen"] && body.isTransparent) {
                    NSString *text = contentDictionary[@"text"];
                    if (text.length > 0) {
                        dispatch_async(dispatch_get_main_queue(), ^{
                            UIAlertView *av = [[UIAlertView alloc] initWithTitle:@"阅后即焚" message:text delegate:nil cancelButtonTitle:@"朕知道了" otherButtonTitles:nil];
                            [av show];
                        });
                    }
                }
            }
        }];
    } forKey:self.description ofPriority:YWBlockPriorityDeveloper];
}

/**
 *  监听自己发送的消息的生命周期
 */
- (void)exampleListenMyMessageLife
{
    [[self.ywIMKit.IMCore getConversationService] addMessageLifeDelegate:self forPriority:YWBlockPriorityDeveloper];
}

/// 当你监听了消息生命周期，IMSDK会回调以下两个函数
- (YWMessageLifeContext *)messageLifeWillSend:(YWMessageLifeContext *)aContext
{
    /// 你可以通过返回context，来实现改变消息的能力
    if ([aContext.messageBody isKindOfClass:[YWMessageBodyText class]]) {
        NSString *text = [(YWMessageBodyText *)aContext.messageBody messageText];
        if ([text rangeOfString:@"法轮功事件"].location != NSNotFound) {
            YWMessageBodySystemNotify *bodyNotify = [[YWMessageBodySystemNotify alloc] initWithContent:@"消息包含违禁词语"];
            [aContext setMessageBody:bodyNotify];
            
            NSDictionary *params = @{kYWMsgCtrlKeyClientLocal:@{kYWMsgCtrlKeyClientLocalKeyOnlySave:@(YES)}};
            [aContext setControlParameters:params];
            
            return aContext;
        }
    }
    return nil;
}

- (void)messageLifeDidSend:(NSString *)aMessageId conversationId:(NSString *)aConversationId result:(NSError *)aResult
{
    /// 你可以在消息发送完成后，做一些事情，例如播放一个提示音等等
}

- (void)exampleSetNotificationBlock
{
    // 当IMSDK需要弹出提示时，会调用此回调，你需要修改成你App中显示提示的样式
    [self.ywIMKit setShowNotificationBlock:^(UIViewController *aViewController, NSString *aTitle, NSString *aSubtitle, YWMessageNotificationType aType) {
//        [[SPUtil sharedInstance] showNotificationInViewController:aViewController title:aTitle subtitle:aSubtitle type:(SPMessageNotificationType)aType];
        
        [MBProgressHUD showError:aTitle];
//        [YWIndicator showTopToastTitle:aTitle content:aSubtitle userInfo:nil withTimeToDisplay:1.f andClickBlock:NULL];

    }];
}
/**
 *  监听群系统消息更新
 */
- (void)exampleListenTribeSystemMessagesUpdate {

    if (self.tribeSystemConversation) {
        [self.tribeSystemConversation clearContentChangeBlocks];
    }

    YWTribeSystemConversation *tribeSystemConversation = [[self.ywIMKit.IMCore getTribeService] fetchTribeSystemConversation];
    self.tribeSystemConversation = tribeSystemConversation;

    __weak __typeof(self) weakSelf = self;
    __weak __typeof(tribeSystemConversation) weakConversation = tribeSystemConversation;
    void(^tribeSystemConversationUpdateBlock)(void) = ^(void) {

        NSUInteger count = weakConversation.fetchedObjects.count;
        if (count) {
            NSNumber *unreadCount = weakConversation.conversationUnreadMessagesCount;
            NSDate *time = weakConversation.conversationLatestMessageTime;
            NSString *content = weakConversation.conversationLatestMessageContent;

            YWCustomConversation *tribeInvitationCustomConversation = [YWCustomConversation fetchConversationByConversationId:SPTribeSystemConversationID creatIfNotExist:YES baseContext:weakSelf.ywIMKit.IMCore];

            [tribeInvitationCustomConversation modifyUnreadCount:unreadCount
                                                   latestContent:content
                                                      latestTime:time];
        }
        else {
            [[weakSelf.ywIMKit.IMCore getConversationService] removeConversationByConversationId:SPTribeSystemConversationID error:NULL];
        }
    };
    [tribeSystemConversation setDidResetContentBlock:tribeSystemConversationUpdateBlock];
    [tribeSystemConversation setDidChangeContentBlock:tribeSystemConversationUpdateBlock];
    [tribeSystemConversation loadMoreMessages:10 completion:nil];
}

/**
 * 头像点击事件
 */
- (void)exampleListenOnClickAvatar{
    
  
    

}


/**
 *  链接点击事件
 */
- (void)exampleListenOnClickUrl
{
    __weak __typeof(self) weakSelf = self;
    [self.ywIMKit setOpenURLBlock:^(NSString *aURLString, UIViewController *aParentController) {
        /// 您可以使用您的容器打开该URL

        if ([aURLString hasPrefix:@"tel:"]) {
            if ([[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:aURLString]]) {
                NSString *phoneNumber = [aURLString stringByReplacingOccurrencesOfString:@"tel:" withString:@""];
                UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"拨打电话"
                                                                    message:phoneNumber
                                                                   delegate:weakSelf
                                                          cancelButtonTitle:@"取消"
                                                          otherButtonTitles:@"呼叫", nil];
                alertView.tag = kSPAlertViewTagPhoneCall;
                [alertView show];
            }
        }
        else {
//            NSRegularExpression *regularExpression = [NSRegularExpression regularExpressionWithPattern:@"^\\w+:" options:kNilOptions error:NULL];
//            if ([regularExpression numberOfMatchesInString:aURLString options:NSMatchingReportCompletion range:NSMakeRange(0, aURLString.length - 1)] == 0) {
//                aURLString = [NSString stringWithFormat:@"http://%@", aURLString];
//            }
//            YWWebViewController *controller = [YWWebViewController makeControllerWithUrlString:aURLString andImkit:[SPKitExample sharedInstance].ywIMKit];
//            [aParentController.navigationController pushViewController:controller animated:YES];
        }
    }];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (alertView.tag == kSPAlertViewTagPhoneCall) {
        if (buttonIndex != alertView.cancelButtonIndex) {
            NSString *phoneNumber = alertView.message;
            NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"tel:%@", phoneNumber]];
            [[UIApplication sharedApplication] openURL:url];
        }
    }
}

/**
 *  预览大图事件
 */
- (void)exampleListenOnPreviewImage
{
    __weak typeof(self) weakSelf = self;
    
    [self.ywIMKit setPreviewImageMessageBlockV3:^(id<IYWMessage> aMessage, YWConversation *aOfConversation, NSDictionary *aFromUserInfo) {
        /// 增加更多按钮，例如转发
//        YWMoreActionItem *transferItem = [[YWMoreActionItem alloc] initWithActionName:@"转发" actionBlock:^(NSDictionary *aUserInfo) {
//            /// 获取会话及消息相关信息
//            NSString *convId = aUserInfo[YWImageBrowserHelperActionKeyConversationId];
//            NSString *msgId = aUserInfo[YWImageBrowserHelperActionKeyMessageId];
//            
//            YWConversation *conv = [[weakSelf.ywIMKit.IMCore getConversationService] fetchConversationByConversationId:convId];
//            if (conv) {
//                id<IYWMessage> msg = [conv fetchMessageWithMessageId:msgId];
//                if (msg) {
//                    YWPerson *person = [[YWPerson alloc] initWithPersonId:@"jiakuipro003"];
//                    YWP2PConversation *targetConv = [YWP2PConversation fetchConversationByPerson:person creatIfNotExist:YES baseContext:weakSelf.ywIMKit.IMCore];
//                    [targetConv asyncForwardMessage:msg progress:NULL completion:^(NSError *error, NSString *messageID) {
//                        NSLog(@"转发结果：%@", error.code == 0 ? @"成功" : @"失败");
//                        [[SPUtil sharedInstance] asyncGetProfileWithPerson:person progress:nil completion:^(BOOL aIsSuccess, YWPerson *aPerson, NSString *aDisplayName, UIImage *aAvatarImage) {
////                            [[SPUtil sharedInstance] showNotificationInViewController:nil title:[NSString stringWithFormat:@"已经成功转发给:%@", aDisplayName] subtitle:nil type:SPMessageNotificationTypeMessage];
//                            
//                            [MBProgressHUD showSuccess:[NSString stringWithFormat:@"已经成功转发给:%@", aDisplayName]];
//                        }];
//                    }];
//                }
//            }
//        }];
        
        /// 打开IMSDK提供的预览大图界面
        [YWImageBrowserHelper previewImageMessage:aMessage conversation:aOfConversation inNavigationController:[aFromUserInfo[YWUIPreviewImageMessageUserInfoKeyFromController] navigationController] fromView:aFromUserInfo[YWUIPreviewImageMessageUserInfoKeyFromView] additionalActions:@[] withIMKit:weakSelf.ywIMKit];
    }];
}

#pragma mark - apns
/**
 *  您需要在-[AppDelegate application:didFinishLaunchingWithOptions:]中第一时间设置此回调
 *  在IMSDK截获到Push通知并需要您处理Push时，IMSDK会自动调用此回调
 */
- (void)exampleHandleAPNSPush
{
    __weak typeof(self) weakSelf = self;
    
    [[[YWAPI sharedInstance] getGlobalPushService] addHandlePushBlockV4:^(NSDictionary *aResult, BOOL *aShouldStop) {
        BOOL isLaunching = [aResult[YWPushHandleResultKeyIsLaunching] boolValue];
        UIApplicationState state = [aResult[YWPushHandleResultKeyApplicationState] integerValue];
        NSString *conversationId = aResult[YWPushHandleResultKeyConversationId];
        Class conversationClass = aResult[YWPushHandleResultKeyConversationClass];
        
        
        if (conversationId.length <= 0) {
            return;
        }
        
        if (conversationClass == NULL) {
            return;
        }
        
        if (isLaunching) {
            /// 用户划开Push导致app启动
            
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.3f * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                if ([self exampleIsPreLogined]) {
                    /// 说明已经预登录成功
                    YWConversation *conversation = nil;
                    if (conversationClass == [YWP2PConversation class]) {
                        conversation = [YWP2PConversation fetchConversationByConversationId:conversationId creatIfNotExist:YES baseContext:weakSelf.ywIMKit.IMCore];
                    } else if (conversationClass == [YWTribeConversation class]) {
                        conversation = [YWTribeConversation fetchConversationByConversationId:conversationId creatIfNotExist:YES baseContext:weakSelf.ywIMKit.IMCore];
                    }
                    if (conversation) {
                        [weakSelf exampleOpenConversationViewControllerWithConversation:conversation fromNavigationController:[weakSelf conversationNavigationController]];
                    }
                }
            });
            
        } else {
            /// app已经启动时处理Push
            
            if (state != UIApplicationStateActive) {
                if ([self exampleIsPreLogined]) {
                    /// 说明已经预登录成功
                    YWConversation *conversation = nil;
                    if (conversationClass == [YWP2PConversation class]) {
                        conversation = [YWP2PConversation fetchConversationByConversationId:conversationId creatIfNotExist:YES baseContext:weakSelf.ywIMKit.IMCore];
                    } else if (conversationClass == [YWTribeConversation class]) {
                        conversation = [YWTribeConversation fetchConversationByConversationId:conversationId creatIfNotExist:YES baseContext:weakSelf.ywIMKit.IMCore];
                    }
                    if (conversation) {
                        [weakSelf exampleOpenConversationViewControllerWithConversation:conversation fromNavigationController:[weakSelf conversationNavigationController]];
                    }
                }
            } else {
                /// 应用处于前台
                /// 建议不做处理，等待IM连接建立后，收取离线消息。
            }
        }
    } forKey:self.description ofPriority:YWBlockPriorityDeveloper];
}

#pragma mark - EService

/**
 *  获取EService对象
 */
- (YWPerson *)exampleFetchEServicePersonWithPersonId:(NSString *)aPersonId groupId:(NSString *)aGroupId
{
    YWPerson *person = [[YWPerson alloc] initWithPersonId:aPersonId EServiceGroupId:aGroupId baseContext:self.ywIMKit.IMCore];
    /// 下面这一行用于控制锁定某个子账号，不分流。
//    [person setLockShunt:YES];
    return person;
}

#pragma mrk - Feedback
- (void)exampleListenFeedbackNewMessage
{
    __weak typeof(self) weakSelf = self;
    
    /// 这里演示的是匿名账号消息监听，云旺账号参考exampleListenNewMessage
    [YWAnonFeedbackService setOnNewMessageBlock:^(BOOL aIsLaunching, UIApplicationState aState) {
        if ( aIsLaunching || aState != UIApplicationStateActive ) {
            [YWAnonFeedbackService makeFeedbackConversationWithCompletionBlock:^(YWFeedbackConversation *conversation, NSError *error) {
                [weakSelf exampleOpenFeedbackViewController:YES fromViewController:[weakSelf conversationNavigationController]];
            }];
        } else {
            /// 播放声音或者跳转打开反馈页面等方式提醒用户有新的反馈消息
        }
    }];
}

- (void)exampleGetFeedbackUnreadCount:(BOOL)isAnonLogin inViewController:(UIViewController *)viewController;
{
    /// 使用云旺(OpenIM)账号，登陆后需要主动调用获取未读数。
    
    id<IYWFeedbackService> service = nil;
    
    if ( isAnonLogin ) {
        service = YWAnonFeedbackService;
    } else {
        service = YWFeedbackServiceForIMCore(self.ywIMKit.IMCore);
    }
    
    [service getUnreadCountWithCompletionBlock:^(NSNumber *unreadCount, NSError *error) {
        if ( [unreadCount intValue] > 0 ) {
//            [[SPUtil sharedInstance] showNotificationInViewController:viewController title:@"未读反馈消息"
//                                                             subtitle:[NSString stringWithFormat:@"未读数：%@", unreadCount]
//                                                                 type:SPMessageNotificationTypeSuccess];
            [MBProgressHUD showError:[NSString stringWithFormat:@"您有%@条未读消息",unreadCount]];
        }
    }];
}

- (void)exampleOpenFeedbackViewController:(BOOL)isAnonLogin
                       fromViewController:(UIViewController *)aViewController
{
    UINavigationController *rootNavigation = [self conversationNavigationController];
    UIViewController *topVC = [[rootNavigation childViewControllers] lastObject];
    if ( [topVC isKindOfClass:[YWFeedbackViewController class]] ) return;
    
    __weak typeof(self) weakSelf = self;
    id<IYWFeedbackService> service = nil;
    
    if ( isAnonLogin ) {
        service = YWAnonFeedbackService;
    } else {
        service = YWFeedbackServiceForIMCore(self.ywIMKit.IMCore);
    }
    
    // 设置App自定义扩展反馈数据
    [service setExtInfo:@{@"loginTime":[[NSDate date] description],
                          @"visitPath":@"登陆->关于->反馈",
                          @"应用自定义扩展信息":@"开发者可以根据需要设置不同的自定义信息，方便在反馈系统中查看"}];
    
    [service makeFeedbackConversationWithCompletionBlock:^(YWFeedbackConversation *conversation, NSError *error) {
        if ( conversation != nil ) {
            YWFeedbackViewController *feedback = [weakSelf.ywIMKit makeFeedbackViewControllerWithConversation:conversation];

            if ( [aViewController isKindOfClass:[UINavigationController class]] ) {
                UINavigationController *nav = (UINavigationController *)aViewController;
                [nav setNavigationBarHidden:NO animated:YES];
                [nav pushViewController:feedback animated:YES];
            } else {
                if ( aViewController.navigationController ) {
                    [aViewController.navigationController setNavigationBarHidden:NO animated:NO];
                    [aViewController.navigationController pushViewController:feedback animated:YES];
                } else {
//                    UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:feedback];
//                    
//                    UIBarButtonItem *rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"关闭" style:UIBarButtonItemStylePlain andBlock:^{
//                        [aViewController dismissViewControllerAnimated:YES completion:nil];
//                    }];
//                    
//                    feedback.navigationItem.rightBarButtonItem = rightBarButtonItem;
//                    
//                    [aViewController presentViewController:navigationController animated:YES completion:nil];
                }
            }
        } else {
//            [[SPUtil sharedInstance] showNotificationInViewController:nil title:@"反馈页面打开出错"
//                                                             subtitle:[NSString stringWithFormat:@"%@", error]
//                                                                 type:SPMessageNotificationTypeError];
            [MBProgressHUD showError:@"反馈页面打开出错"];
        }
    }];
}

- (YWIMCore *)ywIMCore {
    return [SPKitExample sharedInstance].ywIMKit.IMCore;
}
- (id<IYWTribeService>)ywTribeService {
    return [[self ywIMCore] getTribeService];
}
#pragma mark - 可删代码，这里用来演示一些非主流程的功能，您可以删除
#if HAS_CONTACTPROFILE
- (void)opeConversationVC:(YWConversationViewController *)ConversationViewController withConversation:(YWConversation *)conversation
{
    if ([conversation isKindOfClass:[YWP2PConversation class]]) {
        SPContactProfileController *contactprofileController = [[SPContactProfileController alloc] initWithContact:((YWP2PConversation *)conversation).person IMKit:self.ywIMKit];
        
    }
}
#endif

@end
