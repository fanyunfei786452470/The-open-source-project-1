//
//  YRHttpRequest.h
//  YRYZ
//
//  Created by weishibo on 16/7/11.
//  Copyright © 2016年 yryz. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "APIConstant.h"

@interface YRHttpRequest : NSObject


#pragma mark - 请求接口
#pragma mark - 首页

+(void)homeBannerListsuccess:(void (^)(id data))success failure:(void (^)(NSString *errorInfo))failure;
/**
 *  @author ZX, 16-08-20 09:08:29
 *
 *  作品发布
 *
 *  @param uid     用户ID
 *  @param tags    标签
 *  @param title   标题
 *  @param infoIntroduction   简介
 *  @param infoThumbnail   缩略图
 *  @param content   正文
 *  @param type    文件类型 1.图文 2.视频 3.音频
 *  @param urls    OSS文件地址
 *  @param infoCategory   文件所属分类
 *  @param info_time   作品时长
 */
+(void)getProductTypeSaveByCustUserId:(NSString *)uid Tags:(NSArray *)tags Title:(NSString *)title InfoIntroduction:(NSString *)infoIntroduction InfoThumbnail:(NSString *)infoThumbnail Content:(NSString *)content Type:(int)type InfoCategor:(NSString *)infoCategor Urls:(NSString *)urls Info_time:(NSString *)info_time success:(void (^)(NSDictionary *data))success failure:(void (^)(NSString *errorInfo))failure;
/*!
 *  @author a21.5, 16-09-21 09:09:58
 *
 *  @brief 图文发布
 *
 *  @return <#return value description#>
 *
 *  @since <#version number#>
 */
+(void)getImageTextTypeSaveByCustUserId:(NSString *)uid Tags:(NSArray *)tags Title:(NSString *)title Content:(NSString *)content Type:(int)type  InfoIntroduction:(NSString *)infoIntroduction InfoThumbnail:(NSString *)infoThumbnail InfoCategor:(NSString *)infoCategor Urls:(NSString *)urls success:(void (^)(NSDictionary *data))success failure:(void (^)(NSString *errorInfo))failure;
/*!
 *  @author a21.5, 16-09-07 12:09:33
 *
 *  作品标签
 *  @param tpye     文件类型
 *
 */

+ (void)getProductTagsType:(int)type Act:(int)act success:(void (^)(NSDictionary *data))success failure:(void (^)(NSString *errorInfo))failure;

/*!
 *  @author a21.5, 16-09-09 11:09:10
 *
 *  @brief 红包广告列表
 
 *  @param act     接口编号
 *  @param adsType 广告类型 0 ：全部 1 ：最热
 *  @param start   起始位置
 *  @param limit   页面示数
 */

+ (void)getRedPacketAdsListAdsType:(NSInteger)adsType Start:(NSInteger)start Limit:(NSInteger)limit success:(void (^)(NSDictionary *data))success failure:(void (^)(NSString *errorInfo))failure;

#pragma mark - 消息


#pragma mark - 晒
/**
 *  @author ZX, 16-08-24 17:08:50
 *
 *  发布晒一晒
 *
 *  @param uid      用户id
 *  @param content  文字内容
 *  @param pics     图片列表
 *  @param videoPic 视频缩略图
 *  @param videoUrl 视频地址
 */

+(void)sendSunTextByCustContent:(NSString *)content Pics:(NSArray *)pics VideoPic:(NSString *)videoPic VideoUrl:(NSString *)videoUrl success:(void (^)(NSDictionary *data))success failure:(void (^)(NSString *errorInfo))failure;
/**
 *  @author ZX, 16-08-19 11:08:42
 *
 *  晒一晒列表
 *
 *  @param uid     用户Id
 *  @param limit   条数
 *  @param time    时间
 */
+(void)getFriendsCircleListByCustUserId:(NSString *)uid Limit:(NSInteger)limit Time:(NSString *)time success:(void (^)(NSDictionary *data))success failure:(void (^)(NSString *errorInfo))failure;

/**
 *  @author ZX, 16-08-25 10:08:34
 *
 *  晒一晒Feeds列表
 *
 *  @param uid     <#uid description#>
 *  @param limit   <#limit description#>
 *  @param page    <#page description#>
 *  @param success <#success description#>
 *  @param failure <#failure description#>
 */
+(void)getFriendsCircleListFeedsByCustLimit:(NSInteger)limit Page:(int)page success:(void (^)(id data))success failure:(void (^)(NSString *errorInfo))failure;
/**
 *  @author ZX, 16-08-25 10:08:36
 *
 *  晒一晒详情
 *
 *  @param sid     晒一晒id
 */
+(void)getFriendsCircleDetailByCustSid:(int)sid success:(void (^)(NSDictionary *data))success failure:(void (^)(NSString *errorInfo))failure;

/**
 *  @author ZX, 16-08-25 11:08:03
 *
 *  删除晒一晒
 *
 *  @param sid     晒一晒id
 */
+(void)deleteFriendsCircleDetailByCustSid:(int)sid success:(void (^)(NSDictionary *data))success failure:(void (^)(NSString *errorInfo))failure;

/**
 *  @author ZX, 16-08-25 11:08:53
 *
 *  晒一晒评论
 *
 *  @param sid       晒一晒id
 *  @param authorUid 被评论者id
 *  @param content   评论内容
 */
+(void)sendFriendsCircleCommentByCustSid:(int)sid AuthorUid:(NSString *)authorUid Content:(NSString *)content success:(void (^)(NSDictionary *data))success failure:(void (^)(NSString *errorInfo))failure;

/**
 *  @author ZX, 16-08-26 10:08:08
 *
 *  晒一晒点赞列表
 *
 *  @param sid     晒一晒id
 *  @param lid     赞id
 *  @param limit   每页大小
 */
+(void)getFriendsCircleLikeListByCustSid:(int)sid Lid:(int)lid Limit:(int)limit success:(void (^)(NSDictionary *data))success failure:(void (^)(NSString *errorInfo))failure;

/**
 *  @author ZX, 16-08-25 19:08:05
 *
 *  晒一晒点赞
 *
 *  @param sid     晒一晒id
 *  @param action  操作
 */

+(void)getFriendsCircleLikeByCustSid:(int)sid Action:(int)action success:(void (^)(NSDictionary *data))success failure:(void (^)(NSString *errorInfo))failure;
/**
 *  @author ZX, 16-08-25 13:08:05
 *
 *  评论列表
 *
 *  @param sid     晒一晒id
 *  @param limit   每页大小
 *  @param cid     评论id  不传表示从最新开始取列表，cid>0表示接着这条评论往下取
 */
+(void)getFriendsCircleCommentListByCustSid:(int)sid Limit:(int)limit Cid:(int)cid success:(void (^)(NSDictionary *data))success failure:(void (^)(NSString *eCorrorInfo))failure;
/**
 *
 * @author 21.5,
 *
 *  圈子收益统计
 *
 *
 **/
+(void)getFriendsCircleEarningStatisticscustId:(NSString *)custId clubId:(NSString *)clubId success:(void (^)(NSDictionary *data))success failure:(void (^)(NSString *eCorrorInfo))failure;
/**
 *  @author ZX, 16-08-26 10:08:20
 *
 *  删除评论
 *
 *  @param sid     晒一晒id
 *  @param cid     评论id
 */
+(void)deleteFriendsCircleCommentByCustSid:(int)sid Cid:(int)cid success:(void (^)(NSDictionary *data))success failure:(void (^)(NSString *eCorrorInfo))failure;

#pragma mark --- 抽奖
/**
 * @author Sean, 16-08-26 17:08:24
 *
 * 往期开奖
 *
 * @param pageNow  <#pageNow description#>
 * @param pageSize <#pageSize description#>
 * @param success  <#success description#>
 * @param failure  <#failure description#>
 */
+(void)getPastTheLotteryInformationByStart:(NSInteger )start  limit:(NSInteger)limit  success:(void (^)(NSDictionary *data))success failure:(void (^)(NSString *eCorrorInfo))failure;

/**
 * @author Sean, 16-08-27 15:08:47
 *
 * 抽奖详情
 *
 * @param success <#success description#>
 * @param failure <#failure description#>
 */
+ (void)detailsForLuckyDrawsuccess:(void (^)(NSDictionary *data))success failure:(void (^)(NSString *eCorrorInfo))failure;

#pragma mark - 发现


#pragma mark - 我的
/**
 *  @author yichao, 16-07-13 14:07:34
 *
 *  登录接口
 *
 *  @param accout   <#accout description#>
 *  @param password <#password description#>
 *  @param succ     <#succ description#>
 *  @param fail     <#fail description#>
 */
+(void)loginSendRequestByAccout:(NSString*)accout password:(NSString*)password success:(void (^)(NSDictionary *data))success
                   failure:(void (^)(NSString *errorInfo))failure;

/**
 * @author Sean, 16-08-22 16:08:35
 *
 * 第三方登录
 *
 * @return <#return value description#>
 */
+(void)ThirdPartyLoginByThirdName:(NSString *)thirdName openId:(NSString *)openId  accessToken:(NSString *)accessToken  success:(void (^)(NSDictionary *data))success
                          failure:(void (^)(NSString *errorInfo))failure;


/**
 *  @author yichao, 16-07-13 17:07:26
 *
 *  获取验证码
 *
 *  @param custPhone <#custPhone description#>
 *  @param succ      <#succ description#>
 *  @param fail      <#fail description#>
 */
+(void)getRegisterCheckingByCustPhone:(NSString *)custPhone   codeType:(AuthCodeType)type success:(void (^)(NSDictionary *data))success 
                              failure:(void (^)(NSString *errorInfo))failure;



/**
 *  @author yichao, 16-07-13 17:07:23
 *
 *  注册
 *
 *  @param custPhone <#custPhone description#>
 *  @param password  <#password description#>
 *  @param phoneCode <#phoneCode description#>
 *  @param regType   <#regType description#>
 *  @param succ      <#succ description#>
 *  @param fail      <#fail description#>
 */
+(void)registerSendRequestByCustPhone:(NSString *)custPhone password:(NSString *)password phoneCode:(NSString *)phoneCode regType:(CodeType)regType success:(void (^)(NSDictionary *data))success
                              failure:(void (^)(NSString *errorInfo))failure;
/**
 * @author Sean, 16-09-06 11:09:14
 *
 * 验证是找回密码还是注册
 *
 * @param custPhone <#custPhone description#>
 * @param success   <#success description#>
 * @param failure   <#failure description#>
 */
+(void)whetherToChangeThePassword:(NSString *)custPhone  success:(void (^)(NSDictionary *))success  failure:(void (^)(NSString *))failure;
/**
 *  @author Sean, 16-08-20 14:08:52
 *
 *  找回密码
 *
 *  @param phone     <#phone description#>
 *  @param phoneCode <#phoneCode description#>
 *  @param success   <#success description#>
 *  @param failure   <#failure description#>
 */
+(void)forgotPasswordRequestByPhoneNumber:(NSString *)phone password:(NSString *)password phoneCode:(NSString *)phoneCode
                                  success:(void (^)(NSDictionary *data))success
                                  failure:(void (^)(NSString *errorInfo))failure;
/**
 *  @author Sean, 16-08-22 09:08:19
 *
 *  修改密码
 *
 *  @param password    <#password description#>
 *  @param newPassword <#newPassword description#>
 *  @param success     <#success description#>
 *  @param failure     <#failure description#>
 */
+(void)ChangeThePasswordFromOldPassword:(NSString *)password newPassword:(NSString *)newPassword
                                success:(void (^)(NSDictionary *data))success failure:(void (^)(NSString *errorInfo))failure;
/**
 * @author Sean, 16-08-24 10:08:34
 *
 * 修改支付密码
 *
 * @param oldPayPassword <#oldPayPassword description#>
 * @param newPayPassword <#newPayPassword description#>
 * @param success        <#success description#>
 * @param failure        <#failure description#>
 */
+ (void)changeThePayPassword:(NSString *)oldPayPassword newPayPassword:(NSString *)newPayPassword
                     success:(void (^)(NSDictionary *data))success failure:(void (^)(NSString *errorInfo))failure;


/**
 *  @author Sean, 16-08-22 13:08:35
 *
 *  修改个人信息
 *
 *  @param dic     <#dic description#>
 *  @param success <#success description#>
 *  @param failure <#failure description#>
 */
+(void)ModifyPersonalInformationByInformation:(NSDictionary *)dic  success:(void (^)(NSDictionary *data))success failure:(void (^)(NSString *error))failure;
/**
 * @author Sean, 16-08-22 15:08:34
 *
 * 修改个人信息 单条
 *
 * @param name    <#name description#>
 * @param value   <#value description#>
 * @param success <#success description#>
 * @param failure <#failure description#>
 */
+ (void)ModifyPersonalInformationByChangeName:(NSString *)name value:(NSString *)value success:(void (^)(NSDictionary *data))success failure:(void (^)(NSString *error))failure;
/**
 * @author Sean, 16-08-24 11:08:56
 *
 * 积分兑换到消费账户
 *
 * @param theAmount <#theAmount description#>
 * @param success   <#success description#>
 * @param failure   <#failure description#>
 */
+ (void)pointsToTheConsumerAccountByChangeTheAmount:(CGFloat)theAmount password:(NSString *)password  success:(void (^)(NSDictionary *data))success failure:(void (^)(NSString *error))failure;

/**
 * @author Sean, 16-08-24 13:08:23
 *
 * 设置小额免密
 *
 * @return <#return value description#>
 */
+ (void)setSmallFreeByType:(BOOL)isSecret success:(void (^)(NSDictionary *data))success failure:(void (^)(NSString *error))failure;



/**
 * @author Sean, 16-08-22 17:08:29
 *
 * 获取登录方式
 *
 * @param success <#success description#>
 * @param failure <#failure description#>
 */
+ (void)toObtainTheLoginWaySuccess:(void (^)(NSDictionary *data))success failure:(void (^)(NSString *error))failure;


/**
 * @author Sean, 16-08-22 17:08:01
    解绑,绑定
 * @param name    1，微信   2，微博   3，qq
    action   0，绑定    1，解绑
 * @param success <#success description#>
 * @param failure <#failure description#>
 */
+ (void)bindOtherAccountByTheName:(NSString *)name  accessToken:(NSString *)accessToken openId:(NSString *)openId   action:(NSString *)action success:(void (^)(NSDictionary *data))success failure:(void (^)(NSString *error))failure;
/**
 * @author Sean, 16-09-09 14:09:15
 *
 * 绑定手机号
 *
 * @param phoneNumber <#phoneNumber description#>
 * @param veriCode    <#veriCode description#>
 * @param success     <#success description#>
 * @param failure     <#failure description#>
 */
+ (void)bindOtherAccountByThePhone:(NSString *)phoneNumber veriCode:(NSString *)veriCode  password:(NSString *)password  success:(void (^)(NSDictionary *))success failure:(void (^)(NSString *))failure;


/**
 *  @author yichao, 16-06-28 09:06:19
 *
 *  关注我的
 *
 *  @param succ <#succ description#>
 *  @param fail <#fail description#>
 */
+(void)getRegardMeListWithLimit:(NSNumber *)limit start:(NSNumber *)start   Success:(void (^)(NSDictionary *))success failure:(void (^)(NSString *))failure;

/**
 *  @author yichao, 16-06-28 09:06:19
 *
 *  我关注的
 *
 *  @param succ <#succ description#>
 *  @param fail <#fail description#>
 */
+(void)getMyRegardListSuccess:(void (^)(NSDictionary *))success failure:(void (^)(NSString *))failure;


/**
 * @author Sean, 16-08-24 16:08:25
 * 添加 取消关注 移入  移除黑名单
 
 * @param type       1- 关注  2- 黑名单
 * @param fid        好友ID
 * @param actionType 操作类型 0 添加  1 删除
 * @param success    <#success description#>
 * @param failure    <#failure description#>
 */
+ (void)AddOrRemoveAttentionToRemoveByType:(NSString *)type friendID:(NSString *)fid actionType:(NSNumber *)actionType  success:(void (^)(NSDictionary *data))success failure:(void (^)(NSString *error))failure;
/**
 * @author Sean, 16-09-07 20:09:28
 *
 * 通过手机号添加好友
 *
 * @param phoneNumber <#phoneNumber description#>
 * @param success     <#success description#>
 * @param failure     <#failure description#>
 */
+ (void)addFriendFromPhoneNumber:(NSString *)phoneNumber success:(void (^)(NSDictionary *data))success failure:(void (^)(NSString *error))failure;

/**
 关键字搜索好友

 @param keyword <#keyword description#>
 @param limit   <#limit description#>
 @param start   <#start description#>
 @param success <#success description#>
 @param failure <#failure description#>
 */
+ (void)searchFriendByString:(NSString *)keyword limit:(NSNumber *)limit start:(NSNumber *)start success:(void (^)(NSDictionary *data))success failure:(void (^)(NSString *error))failure;
/**
 关键字搜索用户  作品
 
 @param keyword <#keyword description#>
 @param limit   <#limit description#>
 @param start   <#start description#>
 @param success <#success description#>
 @param failure <#failure description#>
 */


+ (void)searchPeopleAndWorksByKeyword:(NSString *)keyword limit:(NSNumber *)limit start:(NSNumber *)start success:(void (^)(NSDictionary *data))success failure:(void (^)(NSString *error))failure;
/**
 关键字搜索作品
 
 @param keyworrd <#keyworrd description#>
 @param limit    <#limit description#>
 @param start    <#start description#>
 @param success  <#success description#>
 @param failure  <#failure description#>
 */
+ (void)searchWorksByKeyword:(NSString *)keyworrd  limit:(NSNumber *)limit start:(NSNumber *)start type:(NSString *)type success:(void (^)(NSDictionary *data))success failure:(void (^)(NSString *error))failure;
/**
 * @author Sean, 16-08-24 16:08:21
 *
 *
     kFocusOn = 1 ,  //关注
     kFans = 2,   // 粉丝
     kFriends,   // 好友
     kTheBlacklist,   // 黑名单
 *
 * @param type    <#type description#>
 * @param success <#success description#>
 * @param failure <#failure description#>
 */
+(void)getFriendListSuccessWithType:(AddressBookFriendType)type   success:(void (^)(NSDictionary *data))success failure:(void (^)(NSString *error))failure;

/**
 *  @author yichao, 16-08-05 16:08:21
 *
 *  用户详情
 *
 *  @param toCustId <#toCustId description#>
 *  @param success  <#success description#>
 *  @param failure  <#failure description#>
 */
+(void)getUserInfoByToCustId:(NSString *)toCustId success:(void (^)(NSDictionary *))success failure:(void (^)(NSString *))failure;

/**
 * @author Sean, 16-08-24 18:08:47
 *
 * 好友详情
 *
 * @param friendsId <#friendsId description#>
 * @param success   <#success description#>
 * @param failure   <#failure description#>
 */
+ (void)getFriendsdetailsByFriendId:(NSString *)friendsId success:(void (^)(NSDictionary *data))success failure:(void (^)(NSString *error))failure;
/**
 好友预览图片
 
 @param friendsId <#friendsId description#>
 @param success   <#success description#>
 @param failure   <#failure description#>
 */
+ (void)getFriendsImagesByFriendId:(NSString *)friendsId success:(void (^)(NSDictionary *data))success failure:(void (^)(NSString *error))failure;
/**
 * @author Sean, 16-09-06 20:09:15
 *
 * 获取好友的个人信息
 *
 * @param fid     <#fid description#>
 * @param success <#success description#>
 * @param failure <#failure description#>
 */
+ (void)getFriendInformationByFriendID:(NSString *)fid success:(void (^)(NSDictionary *data))success failure:(void (^)(NSString *error))failure;

/**
 * @author Sean, 16-09-07 10:09:53
 *
 * 设置好友备注名
 *
 * @param fid     <#fid description#>
 * @param meomo   <#meomo description#>
 * @param success <#success description#>
 * @param failure <#failure description#>
 */
+ (void)setUpFriendsRemarkByFriendID:(NSString *)fid  meomo:(NSString *)meomo  success:(void (^)(NSDictionary *data))success failure:(void (^)(NSString *error))failure;
/**
 * @author Sean, 16-09-13 17:09:58
 *
 * 举报 作品好友
 *
 * @param type     <#type description#>
 * @param sourceId <#sourceId description#>
 * @param content  <#content description#>
 * @param success  <#success description#>
 * @param failure  <#failure description#>
 */
+ (void)reportWorksAndPeopleByType:(NSInteger )type sourceId:(NSString *)sourceId   content:(NSString *)content  success:(void (^)(NSDictionary *data))success failure:(void (^)(NSString *error))failure;
/**
 *  @author weishibo, 16-08-09 16:08:39
 *
 *  获取我的账户
 *
 *  @param success <#success description#>
 *  @param failure <#failure description#>
 */
+(void)getUserCustAccountsuccess:(void (^)(NSDictionary *))success failure:(void (^)(NSString *))failure;

/**
 * @author Sean, 16-08-26 15:08:29
 * 圈子转发列表
    kOriginalWorks = 1,     原创作品
    kForwardingTheCircle,   圈子转发
    kBaskInTheSun,          晒一晒
    kRedEnvelopeAds         红包广告
 * @param start   <#start description#>
 * @param limin   <#limin description#>
 * @param success <#success description#>
 * @param failure <#failure description#>
 */
+ (void)getForMyFnformationByWhatType:(MineInformation)type  start:(NSString *)start limin:(NSString *)limin custId:(NSString *)custId   success:(void (^)(NSDictionary *data))success failure:(void (^)(NSString *error))failure;
/**
 * @author Sean, 16-09-13 18:09:55
 *
 * 获取用户转发统计
 *
 * @param success <#success description#>
 * @param failure <#failure description#>
 */
+ (void)getkUserForwardMoneyCustId:(NSString *)custId success:(void (^)(NSDictionary *data))success failure:(void (^)(NSString *error))failure;
/**
 * @author Sean, 16-09-13 10:09:04
 *
 * 获取我的红包广告列表
 *
 * @param adsType <#adsType description#>
 * @param satrt   <#satrt description#>
 * @param limit   <#limit description#>
 * @param success <#success description#>
 * @param failure <#failure description#>
 */
+ (void)getMineRedPadingListToadsType:(NSString *)adsType start:(NSInteger)satrt limit:(NSInteger)limit  success:(void (^)(NSDictionary *data))success failure:(void (^)(NSString *error))failure;
/**
 * @author Sean, 16-09-14 13:09:46
 *
 * 广告申请退款
 *
 * @param AdsId   <#AdsId description#>
 * @param success <#success description#>
 * @param failure <#failure description#>
 */
+ (void)backMoneyForAdsId:(NSString *)AdsId success:(void (^)(NSDictionary *data))success failure:(void (^)(NSString *error))failure;
/**
 * @author Sean, 16-09-14 16:09:09
 *
 * 广告续费和再次发布
 *
 * @param adsId        <#adsId description#>
 * @param payDays      <#payDays description#>
 * @param wishUpDate   <#wishUpDate description#>
 * @param packetType   <#packetType description#>
 * @param packetAmount <#packetAmount description#>
 * @param packetNum    <#packetNum description#>
 * @param password     <#password description#>
 */
+ (void)giveMoneyToAdsNumber:(NSString *)adsId payDays:(NSString *)payDays wishUpDate:(NSString *)wishUpDate packetType:(NSString *)packetType packetAmount:(NSInteger)packetAmount packetNum:(NSInteger )packetNum password:(NSString*)password success:(void (^)(NSDictionary *data))success failure:(void (^)(NSString *error))failure;


/**
 * @author Sean, 16-09-06 15:09:07
 *
 * 作品列表
 *
 * @param start   <#start description#>
 * @param limit   <#limit description#>
 * @param success <#success description#>
 * @param failure <#failure description#>
 */
+ (void)listOfWorksForStart:(NSString *)start limit:(NSString *)limit custId:(NSString *)custId success:(void (^)(NSDictionary *data))success failure:(void (^)(NSString *error))failure;
/**
 * @author Sean, 16-08-22 17:08:10
 *
 * 手机联系人匹配
 *
 * @param data    <#data description#>
 * @param success <#success description#>
 * @param failure <#failure description#>
 */

+ (void)mobilePhoneContactMatchByAddressBook:(NSString *)data success:(void (^)(NSDictionary *data))success failure:(void (^)(NSString *error))failure;

/**
 * @author Sean, 16-08-22 17:08:58
 *
 * 好友搜索
 *
 * @param keyword  <#keyword description#>
 * @param page     <#page description#>
 * @param pageSize <#pageSize description#>
 * @param success  <#success description#>
 * @param failure  <#failure description#>
 */
+ (void)searchFriendByKeyWord:(NSString *)keyword page:(int )page pageSize:(int)pageSize  success:(void (^)(NSDictionary *data))success failure:(void (^)(NSString *error))failure;


#pragma mark ---账号相关
/**
 * @author Sean, 16-08-22 18:08:46
 *
 *    获取账户相关信息
    informationName:     kAccountInformation,   //账户信息
                         kAccountStatistics,   //账户统计信息
                         kAccountListOfIntegral,    //账户积分列表
                         kAccountStatement,       //账户消费明细
                         kUserListCollection,   //用户收藏列表
                         kLoginMethod          //获取登录方式
 * @param informationName <#informationName description#>
 * @param success         <#success description#>
 * @param failure         <#failure description#>
 */
+ (void)AccountInformationByInformationName:(HttpMethd)informationName  success:(void (^)(NSDictionary *data))success failure:(void (^)(NSString *error))failure;

/**
 * @author Sean, 16-09-05 17:09:28
 *
 * 收藏列表
 *
 * @param start   <#start description#>
 * @param limit   <#limit description#>
 * @param success <#success description#>
 * @param failure <#failure description#>
 */
+ (void)theUserToCollectByStart:(NSString *)start limit:(NSString *)limit  success:(void (^)(NSDictionary *data))success failure:(void (^)(NSString *error))failure;
/**
 * @author Sean, 16-09-06 15:09:59
 *
 * 晒一晒列表
 *
 * @param sid     <#sid description#>
 * @param limit   <#limit description#>
 * @param success <#success description#>
 * @param failure <#failure description#>
 */
+ (void)baskInTheSunListForSid:(NSString *)sid limit:(NSString *)limit custId:(NSString *)custId  success:(void (^)(NSDictionary *data))success failure:(void (^)(NSString *error))failure;

/**
 * @author Sean, 16-09-03 09:09:52
 *
 * 查询账单明细
 *
 * @param bilingType 1，消费流水；2，积分流水
 * @param pageNow    默认0
 * @param pageSize   默认20
 * @param success    <#success description#>
 * @param failure    <#failure description#>
 */
+ (void)AccountInformationByBillingDetails:(NSString *)bilingType start:(NSString *)start limit:(NSString *)limit success:(void (^)(NSDictionary *data))success failure:(void (^)(NSString *error))failure;
/**
 * @author Sean, 16-09-05 16:09:37
 *
 * 查询账户余额
 *
 * @param success <#success description#>
 * @param failure <#failure description#>
 */
+ (void)AccountBalanceQuerySuccess:(void (^)(NSDictionary *data))success failure:(void (^)(NSString *error))failure;
/**
 * @author Sean, 16-08-25 16:08:39
 *
 * 查询用户是否有支付密码
 *
 * @return <#return value description#>
 */

+ (void)QueryThePaymentPasswordSuccess:(void (^)(NSDictionary *data))success failure:(void (^)(NSString *error))failure;


/**
 *  @author weishibo, 16-08-09 17:08:24
 *
 *  退出登录
 *
 *  @param success <#success description#>
 *  @param failure <#failure description#>
 */
+(void)userLoginOutSuccess:(void (^)(id data))success failure:(void (^)(id data))failure;



/**
 *  @author weishibo, 16-09-01 17:09:55
 *
 *  1.	创建订单和支付记录
 *
 *  @param payType      支付方式
 *  @param orderType    订单类型
 *  @param ordersrc     订单来源
 *  @param productId    产品id
 *  @param orderAmount  订单价格
 *  @param currencyType 币种
 *  @param success      <#success description#>
 *  @param failure      <#failure description#>
 */
+(void)createOrderAndPay:(PayType)payType  orderSrc:(OrderSourceType)ordersrc infoId:(NSString*)productId
             orderAmount:(NSString*)orderAmount currency:(CurrencyType)currencyType success:(void (^)(id data))success failure:(void (^)(id data))failure;


#pragma mark 作品
/**
 *  @author weishibo, 16-08-19 17:08:25
 *
 *
 *
 *  @param type    产品类型
 *  @param success <#success description#>
 *  @param failure <#failure description#>
 */
+(void)productTypeListAnd:(InfoProductType)type cacheKey:(NSString*)cacheKey  success:(void (^)(id data))success failure:(void (^)(id data))failure;



+(void)productList:(InfoProductType)type authorid:(NSString*)authorid categroy:(NSString*)categroy  start:(NSInteger)start limit:(NSUInteger)limit success:(void (^)(id data))success failure:(void (^)(id data))failure;
/**
 *  @author weishibo, 16-08-20 16:08:32
 *
 *  作品详情
 *
 *  @param pid     <#pid description#>
 *  @param success <#success description#>
 *  @param failure <#failure description#>
 */
+(void)productdetailProductId:(NSString*)pid success:(void (^)(id data))success failure:(void (^)(id data))failure;

/**
 *  @author weishibo, 16-09-08 18:09:11
 *
 *  圈子详情页
 *
 *  @param pid     <#pid description#>
 *  @param success <#success description#>
 *  @param failure <#failure description#>
 */
+(void)circleDetailProductId:(NSString*)clubId  infoId:(NSString*)infoId success:(void (^)(id data))success failure:(void (^)(id data))failure;
/**
 *  @author weishibo, 16-08-20 17:08:01
 *
 *  圈子转发
 *
 *  @param userID  用户id
 *  @param pid     圈子id或作品id
     transferMoney 钱分为单位
 *  @param success <#success description#>
 *  @param failure <#failure description#>
 */

+(void)productTran:(ProductTranType)type pID:(NSString*)pid  transferType:(NSInteger)transferType transferMoney:(NSUInteger)transferMoney authorId:(NSString*)authorId  isSendRedPacket:(NSInteger)isSendRedPacket  packetType:(NSInteger)packetType  totalCount:(NSInteger)totalCount  amount:(float)amount payPassword:(NSString*)payPassword success:(void (^)(id data))success failure:(void (^)(id data))failure;

/**
 *  @author yichao, 16-08-22 13:08:28
 *
 *  作品评论列表
 *
 *  @param pid     作品id
 *  @param success <#success description#>
 *  @param failure <#failure description#>
 */
+(void)productCommentList:(NSString*)pid start:(NSInteger)start limit:(NSInteger)limit  success:(void (^)(id data))success failure:(void (^)(id data))failure;

/**
 *  @author yichao, 16-08-22 14:08:42
 *
 *  作品添加评论
 *
 *  @param pid      作品id
 *  @param authorid 评论人id
 *  @param content  评论内容
 *  @param success  <#success description#>
 *  @param failure  <#failure description#>
 */
+(void)poductAddComment:(NSString*)pid  content:(NSString*)content success:(void (^)(id data))success failure:(void (^)(id data))failure;
/**
 *  @author yichao, 16-08-22 14:08:26
 *
 *  评论回复
 *
 *  @param pid     作品id
 *  @param content 回复内容
 *  @param replyBy 回复对象
 *  @param replyId 回复人
 *  @param success <#success description#>
 *  @param failure <#failure description#>
 */
+(void)poductCommentReply:(NSString*)pid content:(NSString*)content replyBy:(NSString*)replyBy  replyId:(NSString*)replyId  success:(void (^)(id data))success failure:(void (^)(id data))failure;

/**
 *  @author yichao, 16-08-22 13:08:50
 *
 *  作品点赞列表
 *
 *  @param pid     <#pid description#>
 *  @param success <#success description#>
 *  @param failure <#failure description#>
 */
+(void)productLikeList:(NSString*)pid  start:(NSInteger)start limit:(NSInteger)limit success:(void (^)(id data))success failure:(void (^)(id data))failure;

/**
 *  @author yichao, 16-08-22 15:08:51
 *
 *  作品转发列表
 *
 *  @param pid     作品、圈子id
 *  @param start   起始页
 *  @param limit   每次个数
 *  @param success <#success description#>
 *  @param failure <#failure description#>
 */
+(void)productTranList:(NSString*)pid start:(NSInteger)start limit:(NSInteger)limit success:(void (^)(id data))success failure:(void (^)(id data))failure;


/**
 *  @author yichao, 16-08-22 16:08:22
 *
 *  作品点赞
 *
 *  @param pid     作品id
 *  @param like    0取消点赞 、 1点赞
 *  @param success <#success description#>
 *  @param failure <#failure description#>
 */
+(void)productAddLikeAndUnLike:(NSString*)pid like:(NSInteger)like success:(void (^)(id data))success failure:(void (^)(id data))failure;



/**
 *  @author yichao, 16-08-22 16:08:26
 *
 *  作品收藏取消收藏
 *
 *  @param pid     用品id
 *  @param collect 0取消 1收藏
 *  @param success <#success description#>
 *  @param failure <#failure description#>
 */
+(void)productAddCollect:(NSString*)pid like:(NSInteger)collect success:(void (^)(id data))success failure:(void (^)(id data))failure;

/**
 *  @author yichao, 16-08-22 16:08:33
 *
 *  作品评论删除
 *
 *  @param uid     <#uid description#>
 *  @param success <#success description#>
 *  @param failure <#failure description#>
 */
+(void)productDeleteComment:(NSString*)uid infoId:(NSString*)infoId success:(void (^)(id data))success failure:(void (^)(id data))failure;



/**
 *  @author weishibo, 16-09-02 11:09:04
 *
 *  作品榜单
 *
 *  @param rankType 1最新 2最热 3转发最多 4收益最
 *  @param start    <#start description#>
 *  @param limit    <#limit description#>
 *  @param success  <#success description#>
 *  @param failure  <#failure description#>
 */
+(void)productBankList:(ProuductRankType)rankType  start:(NSInteger)start limit:(NSInteger)limit success:(void (^)(id data))success failure:(void (^)(id data))failure;

/**
 *  @author weishibo, 16-09-03 11:09:34
 *
 *  作品标签列表
 *
 *  @param productType 文件类型
 *  @param tag         <#tag description#>
 *  @param start       <#start description#>
 *  @param limit       <#limit description#>
 *  @param success     <#success description#>
 *  @param failure     <#failure description#>
 */
+(void)getTagsInfoByList:(InfoProductType)productType  tag:(NSInteger)tag  start:(NSInteger)start limit:(NSInteger)limit success:(void (^)(id data))success failure:(void (^)(id data))failure;

+(void)infoReadStatus:(InfoProductType)productType  pid:(NSString*)infoId  success:(void (^)(id data))success failure:(void (^)(id data))failure;
#pragma mark 圈子

/**
 *  @author weishibo, 16-08-23 10:08:31
 *
 *  圈子列表（新数据）
 *
 *  @param type    0全部 1好友 2关注
 *  @param maxId   最新id标记
 *  @param start
 *  @param limit   <#limit description#>
 *  @param success <#success description#>
 *  @param failure <#failure description#>
 */
+(void)circleList:(FriendsType)type  start:(NSInteger)start limit:(NSInteger)limit indexId:(NSInteger)indexId  success:(void (^)(id data))success failure:(void (^)(id data))failure;

/**
 *  @author weishibo, 16-09-08 17:09:41
 *
 *  圈子列表（历史数据）
 *
 *  @param type    <#type description#>
 *  @param maxId   <#maxId description#>
 *  @param start   <#start description#>
 *  @param limit   <#limit description#>
 *  @param success <#success description#>
 *  @param failure <#failure description#>
 */
+(void)circleUplist:(FriendsType)type   minId:(NSString*)minId  start:(NSInteger)start limit:(NSInteger)limit success:(void (^)(id data))success failure:(void (^)(id data))failure;
/**
 *  @author weishibo, 16-08-24 19:08:16
 *
 *  圈子评论列表
 *
 *  @param type    <#type description#>
 *  @param cid     <#cid description#>
 *  @param start   <#start description#>
 *  @param limit   <#limit description#>
 *  @param success <#success description#>
 *  @param failure <#failure description#>
 */
+(void)circleCommentList:(NSString*)cid  start:(NSInteger)start limit:(NSInteger)limit success:(void (^)(id data))success failure:(void (^)(id data))failure;

/**
 *  @author weishibo, 16-08-24 19:08:29
 *
 *  圈子点赞列表
 *
 *  @param cid     <#cid description#>
 *  @param start   <#start description#>
 *  @param limit   <#limit description#>
 *  @param success <#success description#>
 *  @param failure <#failure description#>
 */

+(void)circleLikeList:(NSString*)cid  start:(NSInteger)start limit:(NSInteger)limit success:(void (^)(id data))success failure:(void (^)(id data))failure;


/**
 *  @author weishibo, 16-08-24 20:08:02
 *
 *  圈子转发列表
 *
 *  @param cid     <#cid description#>
 *  @param start   <#start description#>
 *  @param limit   <#limit description#>
 *  @param success <#success description#>
 *  @param failure <#failure description#>
 */
+(void)circleTranList:(NSString*)cid  start:(NSInteger)start limit:(NSInteger)limit success:(void (^)(id data))success failure:(void (^)(id data))failure;

/**
 *  @author weishibo, 16-08-24 20:08:28
 *
 *  圈子添加点赞
 *
 *  @param pid     <#pid description#>
 *  @param like    <#like description#>
 *  @param success <#success description#>
 *  @param failure <#failure description#>
 */

+(void)circleAddLikeAndUnLike:(NSString*)pid like:(NSInteger)like success:(void (^)(id data))success failure:(void (^)(id data))failure;

/**
 *  @author weishibo, 16-08-24 20:08:52
 *
 *  圈子添加收藏
 *
 *  @param pid     <#pid description#>
 *  @param collect <#collect description#>
 *  @param success <#success description#>
 *  @param failure <#failure description#>
 */

+(void)circleAddCollect:(NSString*)pid like:(NSInteger)collect success:(void (^)(id data))success failure:(void (^)(id data))failure;

/**
 *  @author weishibo, 16-08-24 20:08:43
 *
 *  圈子评论删除
 *
 *  @param uid     <#uid description#>
 *  @param success <#success description#>
 *  @param failure <#failure description#>
 */
+(void)circleDeleteComment:(NSString*)uid clubId:(NSString*)clubId success:(void (^)(id data))success failure:(void (^)(id data))failure;

/**
 *  @author weishibo, 16-08-24 20:08:28
 *
 *  圈子添加评论
 *
 *  @param pid     <#pid description#>
 *  @param content <#content description#>
 *  @param success <#success description#>
 *  @param failure <#failure description#>
 */
+(void)circleAddComment:(NSString*)pid content:(NSString*)content success:(void (^)(id data))success failure:(void (^)(id data))failure;
/**
 *  @author weishibo, 16-08-24 20:08:57
 *
 *  圈子评论回复
 *
 *  @param pid     <#pid description#>
 *  @param content <#content description#>
 *  @param replyBy <#replyBy description#>
 *  @param replyId <#replyId description#>
 *  @param success <#success description#>
 *  @param failure <#failure description#>
 */
+(void)circleCommentReply:(NSString*)pid content:(NSString*)content replyBy:(NSString*)replyBy  replyId:(NSString*)replyId  success:(void (^)(id data))success failure:(void (^)(id data))failure;
/**
 *  @author weishibo, 16-09-13 17:09:21
 *
 *  邀请转发
 *
 *  @param toCustId 被邀请id
 *  @param infoId   作品id
 *  @param success  <#success description#>
 *  @param failure  <#failure description#>
 */
+(void)inviteTransfer:(NSArray*)toCustId infoId:(NSString*)infoId type:(NSInteger)type success:(void (^)(id data))success failure:(void (^)(id data))failure;

//圈子收益与转发数
+(void)circleClubBonud:(NSArray*)clubId success:(void (^)(id data))success failure:(void (^)(id data))failure;

/**
 *  @author 21.5
 *  圈子公告
 *
 *  @param act <#pageNumber description#>
 *  @param start   <#pageSize description#>
 *  @param limit    <#success description#>
 */
+ (void)getCircleNoticeListstart:(NSInteger)start limit:(NSInteger)limit success:(void (^)(id data))success failure:(void (^)(id data))failure;
#pragma mark 红包打赏

/**
 *  @author weishibo, 16-08-26 11:08:44
 *
 *  红包打赏礼物列表
 *
 *  @param rewardType 打赏类型 打赏对象类型0转发1晒一晒 2作品
 *  @param pageNumber <#pageNumber description#>
 *  @param pageSize   <#pageSize description#>
 *  @param success    <#success description#>
 *  @param failure    <#failure description#>
 */

/**
 *  @author weishibo, 16-08-26 11:08:44
 *
 *  打赏列表(作品圈子晒一晒)
 *
 *  @param rewardType 打赏类型 打赏对象类型0转发1晒一晒 2作品
 *  @param pageNumber <#pageNumber description#>
 *  @param pageSize   pid 对象id
 *  @param success    <#success description#>
 *  @param failure    <#failure description#>
 */
+(void)rewardObjList:(NSInteger)rewardType pid:(NSString*)pid pageNumber:(NSInteger)pageNumber  pageSize:(NSInteger)pageSize  success:(void (^)(id data))success failure:(void (^)(id data))failure;



/**
 *  @author weishibo, 16-08-26 11:08:09
 *
 *  打赏礼物列表
 *
 *  @param pageNumber <#pageNumber description#>
 *  @param pageSize   <#pageSize description#>
 *  @param success    <#success description#>
 *  @param failure    <#failure description#>
 */
+(void)rewardGiftList:(NSInteger)pageNow  pageSize:(NSInteger)pageSize  success:(void (^)(id data))success failure:(void (^)(id data))failure;


/**
 *  @author weishibo, 16-08-26 14:08:23
 *
 *  发送打赏
 *
 *  @param giftid   礼物id
 *  @param userid   打赏人
 *  @param touserid 被打赏人
 *  @param type     打赏对象打赏类型 打赏对象类型0转发1晒一晒 2作品
 *  @param pid      打赏对象id
 *  @param giftNum  礼物数
 *  @param success  <#success description#>
 *  @param failure  <#failure description#>
 */
+(void)sendReward:(NSString*)giftid touserid:(NSString*)touserid type:(NSInteger)type infoId:(NSString*)infoId giftNum:(NSInteger)giftNum  password:(NSString*)password   infoType:(InfoProductType)infoType  infoTitle:(NSString*)infoTitle pid:(NSString*)pid success:(void (^)(id data))success failure:(void (^)(id data))failure;


/**
 *  @author weishibo, 16-08-26 15:08:19
 *
 *  收到红包列表
 *
 *  @param rewardType 0查询已发1查询已领取
 *  @param pageNumber <#pageNumber description#>
 *  @param pageSize   <#pageSize description#>
 *  @param success    <#success description#>
 *  @param failure    <#failure description#>
 */

+(void)receiveRedList:(NSInteger)rewardType pageNumber:(NSInteger)pageNumber  pageSize:(NSInteger)pageSize  success:(void (^)(id data))success failure:(void (^)(id data))failure;
/**
 *  @author weishibo, 16-08-26 15:08:29
 *
 *  发出红包列表
 *
 *  @param rewardType  0查询已发1查询已领取
 *  @param pageNumber <#pageNumber description#>
 *  @param pageSize   <#pageSize description#>
 *  @param success    <#success description#>
 *  @param failure    <#failure description#>
 */
+(void)sendRedList:(NSInteger)rewardType  start:(NSInteger)start  limit:(NSInteger)limit   success:(void (^)(id data))success failure:(void (^)(id data))failure;

/**
 *  @author weishibo, 16-08-26 15:08:20
 *
 *  拆红包
 *
 *  @param redID         红包id
 *  @param friendStatusn 关注状态0关注1不关注
 *  @param success       <#success description#>
 *  @param failure       <#failure description#>
 */
+(void)openRed:(NSString*)redID friendStatus:(NSInteger)friendStatus success:(void (^)(id data))success failure:(void (^)(id data))failure;
/**
 *  @author weishibo, 16-08-26 15:08:36
 *
 *  抢红包
 *
 *  @param redID   <#redID description#>
 *  @param success <#success description#>
 *  @param failure <#failure description#>
 */
+(void)robRed:(NSString*)redID  success:(void (^)(id data))success failure:(void (^)(id data))failure;



/**
 *  @author weishibo, 16-08-26 15:08:10
 *
 *  查看红包领取详情
 *
 *  @param redID      <#redID description#>
 *  @param pageNumber <#pageNumber description#>
 *  @param pageSize   <#pageSize description#>
 *  @param success    <#success description#>
 *  @param failure    <#failure description#>
 */
+(void)getRedDetail:(NSString*)redID  pageNumber:(NSInteger)pageNumber  pageSize:(NSInteger)pageSize  success:(void (^)(id data))success failure:(void (^)(id data))failure;


/**
 *  @author weishibo, 16-09-06 13:09:42
 *
 *  验证支付是否成功
 *
 *  @param orderId     <#orderId description#>
 *  @param orderAmount <#orderAmount description#>
 *  @param receipt     <#receipt description#>
 *  @param success     <#success description#>
 *  @param failure     <#failure description#>
 */
+(void)kCheckOrder:(NSString*)orderId orderAmount:(float)orderAmount receipt:(NSString*)receipt success:(void (^)(id data))success failure:(void (^)(id data))failure;



/**
 *  @author weishibo, 16-09-13 09:09:46
 *
 *  发布红包广告
 *
 *  @param adsTitle     广告标题
 *  @param adsSmallPic  列表小图地址
 *  @param picCount     图片数量
 *  @param content      广告主体内容
 *  @param adsType      广告类型 0图文 1视频
 *  @param payDays      购买天数
 *  @param wishUpDate   期望上架时间
 *  @param phone        广告联系方式
 *  @param packetType   红包类型  0 拼手气 1普通
 *  @param packetAmount 红包总金额
 *  @param packetNum    红包总个数
 *  @param password     支付密码
 *  @param success      <#success description#>
 *  @param failure      <#failure description#>
 */
+(void)releaseRedAds:(NSString*)adsTitle adsSmallPic:(NSString*)adsSmallPic picCount:(NSInteger)picCount content:(NSString*)content adsType:(InfoProductType)adsType payDays:(NSInteger)payDays wishUpDate:(NSString *)wishUpDate phone:(NSString*)phone packetType:(NSInteger)packetType packetAmount:(CGFloat)packetAmount packetNum:(NSInteger)packetNum password:(NSString*)password  adsInfoPath:(NSString *)adsInfoPath adsDesc:(NSString *)adsDesc success:(void (^)(id data))success failure:(void (^)(id data))failure;

/**
 *  @author weishibo, 16-09-13 19:09:33
 *
 *  广告点赞取消点赞
 *
 *  @param adsId   <#adsId description#>
 *  @param like    <#like description#>
 *  @param success <#success description#>
 *  @param failure <#failure description#>
 */
+(void)adAddLikeOrUnLike:(NSString*)adsId like:(NSInteger)like success:(void (^)(id data))success failure:(void (^)(id data))failure;

/**
 *  @author yichao, 16-08-22 14:08:42
 *
 *  广告添加评论
 *
 *  @param pid      作品id
 *  @param authorid 评论人id
 *  @param content  评论内容
 *  @param success  <#success description#>
 *  @param failure  <#failure description#>
 */
+(void)adsAddComment:(NSString*)adsId content:(NSString*)content success:(void (^)(id data))success failure:(void (^)(id data))failure;

/**
 *  @author yichao, 16-08-22 14:08:26
 *
 *  广告评论回复
 *
 *  @param pid     作品id
 *  @param content 回复内容
 *  @param replyBy 评论信息id
 *  @param replyId 回复人
 *  @param success <#success description#>
 *  @param failure <#failure description#>
 */
+(void)adsReplyComment:(NSString*)adsId content:(NSString*)content replyBy:(NSString*)replyBy  replyId:(NSString*)replyId  success:(void (^)(id data))success failure:(void (^)(id data))failure;


/**
 *  @author yichao, 16-08-22 16:08:33
 *
 *  广告评论删除
 *
 *  @param uid     评论id
 *  @param success <#success description#>
 *  @param failure <#failure description#>
 */
+(void)adsDeleteComment:(NSString*)uid  custId:(NSString*)custId success:(void (^)(id data))success failure:(void (^)(id data))failure;

/**
 *  @author yichao, 16-08-22 13:08:28
 *
 *  广告评论列表
 *
 *  @param pid     作品id
 *  @param success <#success description#>
 *  @param failure <#failure description#>
 */
+(void)adsCommentList:(NSString*)adsId start:(NSInteger)start limit:(NSInteger)limit success:(void (^)(id data))success failure:(void (^)(id data))failure;

/**
 *  @author yichao, 16-08-22 13:08:50
 *
 *  广告点赞列表
 *kRedPacketAdsList
 *  @param pid     <#pid description#>
 *  @param success <#success description#>
 *  @param failure <#failure description#>
 */
+(void)adsLikeList:(NSString*)pid start:(NSInteger)start limit:(NSInteger)limit success:(void (^)(id data))success failure:(void (^)(id data))failure;


/**
 *  @author weishibo, 16-09-13 19:09:21
 *
 *  广告点赞 评论数
 *
 *  @param pid     <#pid description#>
 *  @param start   <#start description#>
 *  @param limit   <#limit description#>
 *  @param success <#success description#>
 *  @param failure <#failure description#>
 */
+(void)adsCommentsNum:(NSString*)pid  success:(void (^)(id data))success failure:(void (^)(id data))failure;


/**
 *  @author weishibo, 16-08-20 16:08:32
 *
 *  广告
 *
 *  @param pid     <#pid description#>
 *  @param success <#success description#>
 *  @param failure <#failure description#>
 */
+(void)adsdetailProductId:(NSString*)pid success:(void (^)(id data))success failure:(void (^)(id data))failure;


///获取广告发布单价
+(void)getAdsPriceDaysuccess:(void (^)(id data))success failure:(void (^)(id data))failure;

@end






















