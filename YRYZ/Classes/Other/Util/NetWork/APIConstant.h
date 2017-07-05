//
//  APIConstant.h
//  rrz
//
//  Created by weishibo on 16/04/21.
//  Copyright (c) 2016年 weishibo. All rights reserved.

//公司
//#define kBaseUrl                      @"http://192.168.30.15:8090"


#define kUserBaseUrl                      @"https://au.yryz.com"
#define kShineBaseUrl                     @"https://as.yryz.com"
#define kCircleBaseUrl                    @"https://ac.yryz.com"
#define kRedPacketBaseUrl                 @"https://ar.yryz.com"


#define OSS_ACCESSKEYID                    @"LTAIwQU3aCce2JVt"
#define OSS_SECRETACCESSKEY                @"N8qQ8nVlTlUIVmpMH8773VAuHoAkjI"
#define OSS_BUCKETNAME                     @"yryz-circle"

#define kListPageSize                      20

/*   注册途径   */
typedef NS_ENUM(NSUInteger, RegisterType) {
    kRegisterWeb = 1,
    kRegisterApp,
    kRegisterQQ,
    kRegisterWeChat,
    kRegisterSina,
};

/*   HTTP接口对应的标识   */
typedef NS_ENUM(NSUInteger, HttpMethd) {
#pragma mark --- 注册登录
    kHomeBannerList = 0,
    //注册
    kRegisterPage ,
    //登录
    kLoginPage,
    //验证码
    kShortMessage,
    //退出登录
    kUserLoginOut,
    //忘记密码
    kForgotPassword,
    //修改密码
    kChangePassword,
    //修改支付密码
    kChangePayPassword,
    //修改个人信息
    kChangeInformation,
    //修改好友备注
    kChangeFriendName,
    //微信登录
    kWeChatLogin,
    //QQ登录
    kTencentLogin,
    //新浪登录
    kSinaLogin,
    //第三方登录
    kThirdLogin,
    
   //绑定,解绑
    kBindAccount,
    //绑定手机号
    kBingPhone,
    
#pragma mark - 通讯录
    //通讯录首页
    kGoodFriends,
    //关注我的
    kRegardMe,
    //我关注的
    kMyRegard,
    //对好友进行操作,关注、取关/移入、移除黑名单
    kFriendsOperation,
    //好友详情
    kFriendsDetail,
    //用户详情
    kUserInfo,
    //好友个人信息
    kFriendInformation,
    //匹配手机联系人
    kMatchingPhonePeople,
    //搜索好友
    kSearchFriend,
    //获取登录方式
    kLoginMethod,
    //手机号添加好友
    kSaveFriendToPhone,
    //举报接口
    kReportWorkAndPeople,
    //2301.	用户转发作品预览图
    kFriendsImages,
#pragma mark --- 抽奖
    kPastTheLottery,   //往期开奖
    kDrawTheDetails,  //抽奖详情
#pragma mark 账户
//    我的账户
    kGetUserCustAccount,
    //创建订单和支付记录
    kcreateOrderAndPay,
    //验证订单
    kCheckOrder,
    //账户信息
    kAccountInformation,
    //账户统计信息
    kAccountStatistics,
    //账户积分列表
    kAccountListOfIntegral,
    //查询账户余额
    kAccountBalance,
    //账户消费明细
    kAccountStatement,
    //用户收藏列表
    kUserListCollection,
    //我的红包广告列表
    kMineRedAds,
    //兑换积分
    kToRedeem,
    //设置小额免密
    kSetSmallFree,
    //是否有支付密码
    kIsHavePayPassword,
#pragma mark ---我的红包广告
    //广告红包申请退款
    kRedAdsBackMoney,
    //再次发布 续费
    kReleaseAgain,
#pragma mark - 晒一晒
    kFriendsCircleSave,//1.发布晒一晒
    kFriendsCircleList,//3.晒一晒列表
    kFriendsCircleListFeed,//晒一晒Feed列表
    kFriendsCircleDetail,//4.晒一晒详情
    kFriendsCircleDelete,//5.删除晒一晒
    kFriendsCircleComment,//6.晒一晒评论
    kFriendsCircleCommentList,//7.评论列表
    kFriendsCircleCimmentDelete,//8.删除评论
    kFriendsCircleLike,//9.晒一晒点赞
    kFriendsCircleLikeList,//10.点赞列表
    
#pragma mark作品相关
    kProductTypeList, //作品分类类型列表
    kProductTypeSave, //作品发布
    KProductTypeTag,  //作品标签
    kProductList,     //作品列表
    kProductdetail,   //作品详情
    kProductTran,     //作品转发
    kPoductAddComment,   // 作品add评论
    kPoductCommentReply, //作品评论回复
    kPoductCommentList,  //作品评论列表
    kPoductLikeList,//作品点赞列表
    kProductTranList,//作品转发列表
    kProductLikeAndUnLike,//作品点赞取消点赞
    kProudctAddCollect,//作品收藏
    kProductDeleteComment,//作品评论删除
    kProductBankList,//1.	作品榜单（最新，最热，转发最多，收益最多）
    kGetTagsInfoByList,//2015.	作品标签列表
    kInfoReadStatus,//kInfoReadStatus2001.	作品设置已读标记

    //搜索好友和作品
    kSearchPeopleAndWorks,
    //搜索作品
    kSearchWorks,

    
#pragma mark 圈子列表
    
    kCircleList, //圈子列表
    kCircleUplist,
    KCircleCommentList,//圈子评论列表
    KCircleLikeList ,//圈子点赞列表
    kCircleUserTranList , //个人圈子转发列表
    kCircleTranList,// 圈子详情页转发者列表（一级）
    kCircleAddLike,//圈子添加点赞
    kCircleAddCollect, //圈子添加收藏
    kCircleDeleteComment,//圈子评论删除
    kCircleAddComment,//圈子添加评论
    kCircleReplyComment,//圈子回复评论
    kCircleDetail,//圈子详情页
    kUserForwardMoney,//用户转发统计
    kInviteTransfer,//邀请转发
    KCircleClubBonud,//圈子收益与转发数
    KCircleEarningStatistics,//圈子收益统计
    KCirclEannouncement,//圈子公告
    
#pragma mark 红包打赏
    
    kRewardObjList, //打赏对象列表
    KRegardGiftList, //打赏礼物列表
    kSendRegardGift,//发送打赏
    kReceiveRedList,// 收到红包列表
    kSendRedList,//发出红包列表
    kOpenRed,//拆红包
    kGetRedDetail,//领取详情
    kRobRed,//抢红包
    kRedPacketAdsList,//红包广告列表
    kReleaseRedAds,//发布红包广告
    kAdAddLikeOrUnLike,//广告点赞取消点赞
    kAdvertAddCommentlike,//广告添加评论
    kAdsReplyComment, //广告回复评论
    kAdsCommentsNum,//广告详情页点赞评论数
    kAdDetail,//广告详情
    kAdsLikeList,//圈子点赞列表
    kAdsCommentsList,//广告评论列表
    kAdsPriceDay,//广告发布单价
    kAdDeleteComment,
    
};

// 我的界面  原创作品  圈子转发  晒一晒  红包广告
typedef NS_ENUM(NSUInteger,MineInformation) {
    kOriginalWorks = 1,
    kForwardingTheCircle,
    kBaskInTheSun,
    kRedEnvelopeAds
};




// 首页推荐页数据类型  //媒体介质 1-图文 2-视频 3-音频
typedef NS_ENUM(NSUInteger,InfoProductType) {
    kInfoTypePictureWord = 1,
    kInfoTypeVideo,
    kInfoTypeVoice
};

//作品转发类型  0原创 1圈子
typedef NS_ENUM(NSUInteger,ProductTranType) {
    kProductTranOriginal = 0,
    kProductTranCircle,
};

// 用户收藏 转发 阅读作品 1:收藏 2：阅读 3：转发 4发布 5点赞
typedef NS_ENUM(NSUInteger,kUserColltionReadTran) {
    kUserInfoCollection = 1,
    kUserInfoRead,
    kUserInfoTran,
    kUSerInfoPublishe,
    KUserInfoPraise,
};


// 功能码标识
typedef NS_ENUM(NSUInteger,CodeType) {
    // 注册
    kCodeRegister = 1,
    // 忘记密码（找回密码）
    kCodeForgetPassword,
    // 认证
    kCheckingCrad,
    //支付密码
    kPayPassword,
    // 更换手机
    kChangePhone,
};


/**
 *  验证码类型
 */
typedef NS_ENUM(NSUInteger, AuthCodeType){
    /**
     *  注册
     */
    kAuthCodeRegister = 1,
    /**
     *  找回密码
     */
    kAuthCodeChangePassword,
    /**
     *  实名验证
     */
    kAuthAuthentication,
    /**
     *  设置支付密码
     */
    kAuthSetPaypassword,
    /**
     *  更换手机
     */
    kAuthReplacePhone,
    /**
     *  找回支付密码
     */
    kAuthPayBackPassword,
    /**
     *  提现
     */
    kAuthCodeWithdrawMoney,
};

/**
 *  转发平台
 */
typedef NS_ENUM(NSUInteger, TranPlatform){
    /**
     *  系统
     */
    kRrzRegisterSid = 1,
    /**
     *  微信朋友圈
     */
    kWechateTimeline ,
    //微信
    kWXSceneSession,
    /**
     *  微博
     */
    kSinaRegisterSid ,
    /**
     *  QQ
     */
    kTencentQQRegisterSid,
    /**
     *
     *  空间
     */
    kTencentQZoneRegisterSid,
    
    //举报
    kYryzReport
    
    
};

//
typedef NS_ENUM(NSInteger, AddressBookFriendType) {
    //关注
    kFocusOn = 1 ,
    // 粉丝
    kFans = 2,
    // 好友
    kFriends,
    // 黑名单
    kTheBlacklist,
};




typedef NS_ENUM(NSInteger, FriendsType) {
    //全部
    kAllFriends = 0 ,
    // 好友
    kGoodFriend = 1,
    // 关注
    KRegard,
    // 黑名单
    //    kBlacklist,
};


typedef NS_ENUM(NSUInteger, PayType) {
    // 余额
    kBalancePay = 1,
    // 支付宝
    kAlipay,
    //微信
    kWXpay,
    //苹果内购
    kSKPay = 5,
};


typedef NS_ENUM(NSUInteger, OrderSourceType) {
    // 订单来源
    kiOS = 3,
    kWap,
};


// 订单类型
typedef NS_ENUM(NSUInteger, OrderType) {
    //阅读
    kOrderRead = 1,
    //收费转发
    kOrderTran = 2,
//    //普通转发（第二次转发）
//    kOrderCommonTran = 3,
    // 充值
    kOrderTopup = 4,
    //提现
    kOrderWithdrawal = 5,
    //退款
    kOrderArefund = 6,
    //实名认证
    kOrderRealName = 7,
    //再次不收费转发
    kOrderFree = 8,
    
    
    /**
     *  微信朋友圈
     */
    kOrderWechateTimeline ,
    //微信
    kOrderWXSceneSession,
    /**
     *  微博
     */
    kOrderSinaRegister ,
    /**
     *  QQ
     */
    kOrderTencentQQRegister,
    /**
     *
     *  空间
     */
    kOrderTencentQZoneRegister
    
    
    
};


typedef NS_ENUM(NSUInteger, CurrencyType) {
    // 币种
    kRMB = 156,
    kDollar = 840,
    kHongKongdollars = 344,
    kJapanese = 392,
    kEuro = 978,
    kMalaysia = 458,
    kMacau = 032,
    
};



typedef NS_ENUM(NSUInteger, BasicAction) {
//    打赏
    kReward= 1,
//    红包
    kRedBag,
//    转发
    kTran,
//    收藏
    kCollection,
//    点赞
    kPraise,
    // 头像
    kHeadImage,
//    语音播报
    kAudioPlay,
    //邀请转发
    kInvitationForwarding,
    //收益规则
    kEarningsRule,
    //被转发
    kIsforwarded
    
};


//作品榜单类型
typedef NS_ENUM(NSInteger ,ProuductRankType) {

    kProuductRankNew = 1,
    kProuductRankHot,
    kProuductRankTranMax,
    kProuductRankMoneyMax,
};

//红包广告列表

typedef NS_ENUM(NSInteger ,RedPacketAdsType) {
    
   
    KRedPacketAllList = 0,
    KRedPacketHotList,
};

extern  NSString *const Interface[];

extern  NSString *const RRZCustId;
extern  NSString *const RRZPageNowKey;
extern  NSString *const RRZPageSizeKey;



static NSString *ServiceWorkError = @"加载数据失败,请稍后再试";
static NSString *RequestTimedOut = @"加载数据失败,请稍后再试";

@interface APIConstant : NSObject

@end
