//
//  APIConstant.h
//  rrz
//
//  Created by weishibo on 14/12/21.
//  Copyright (c) 2014年 weishibo. All rights reserved.
//

NSString * const Interface[] = {
    
#pragma mark 登录注册修改信息
    
    [kHomeBannerList] = @"/app-redpacket/v2/other/getBannerList",           //首页banner
    [kRegisterPage] = @"/app-user/v2/user/register",                        // 注册页面
    [kLoginPage] = @"/app-user/v2/user/login",                              // 登录
    [kWeChatLogin] = @"/app-user/v2/user/wxLogin",                          //微信登录
    [kTencentLogin] = @"/app-user/v2/user/qqLogin",                         //QQ登录
    [kSinaLogin] = @"/app-user/v2/user/wbLogin",                            //新浪登录
    [kThirdLogin] = @"/app-user/v2/user/thirdLogin",                        //第三方登录
    [kShortMessage] = @"/app-user/v2/user/sendVerifyCode",                  // 短信验证
    [kUserLoginOut] = @"/app-user/v2/user/loginOut",                        //退出登录
    [kForgotPassword] = @"/app-user/v2/user/forgotPassword",                //忘记密码
    [kChangePassword] = @"/app-user/v2/user/editPassword",                  //修改密码
    [kChangePayPassword] = @"/app-user/v2/pay/setPayPassword",              //修改支付密码
    [kChangeInformation] = @"/app-user/v2/user/modify",                     //修改个人信息
    [kChangeFriendName] = @"/app-user/v2/relation/modifyfriends",           //修改好友备注
    [kBindAccount] = @"/app-user/v2/user/bindThirdAccount",                 //解绑,绑定
    [kBingPhone] = @"/app-user/v2/user/bindPhoneAccount",                   //绑定手机号
#pragma mark ---我的红包广告
    [kMineRedAds] = @"/app-redpacket/v2/advert/getMyAdverts",               //我的红包广告列表
    [kRedAdsBackMoney] = @"/app-redpacket/v2/advert/returnAds",             //申请退款
    [kReleaseAgain] = @"/app-redpacket/v2/advert/renew",                    //再次发布 续费
    
#pragma mark --- 抽奖和搜索
    [kPastTheLottery] = @"/app-redpacket/v2/lottery/list",          //往期开奖
    [kDrawTheDetails] = @"/app-redpacket/v2/lottery/detail",        //抽奖详情
    [kSearchFriend] = @"/app-user/v2/user/search",                  //搜索好友
    [kSearchPeopleAndWorks] = @"/app-circle/v2/opus/search",        //搜索好友和作品
    [kSearchWorks] = @"/app-circle/v2/opus/searchInfo",             //搜索作品
    
#pragma mark - 通讯录
    [kGoodFriends] = @"/app-user/v2/relation/listAll",                      //好友 关注 黑名单列表
    [kRegardMe] = @"/app-user/v2/relation/listFans",                        //关注我的
    [kMyRegard] = @"/app/relationship/relationshipListAtoB",                //我关注的
    [kFriendsOperation] = @"/app-user/v2/relation/save",                    //对好友进行操作,关注、取关/移入、移除黑名单
    [kUserInfo] = @"/app/relationship/findStatusByCustId",                  //用户详情
    [kFriendsDetail] = @"/app-user/v2/relation/friendsdetail",              // 好友详情
    [kFriendInformation] = @"/app-user/v2/user/find",                       //好友个人信息
    [kMatchingPhonePeople] = @"/app-user/v2/user/uploadContract",           //匹配手机联系人
    [kLoginMethod] = @"/app-user/v2/user/loginMethod",                      //获取登录方式
    [kSaveFriendToPhone] = @"/app-user/v2/relation/saveByPhone",            //手机号添加好友
    [kReportWorkAndPeople] = @"/app-user/v2/reported/save",                 //举报接口
    [kFriendsImages] = @"/app-circle/v2/collection/getCustImg",             //2301.	用户转发作品预览图
    
    
    
#pragma mark 账户相关
    
    [kGetUserCustAccount] = @"/app/custaccount/getCustAccount",         //我的账户
    [kcreateOrderAndPay] = @"/app-user/v2/pay/getNewPayFlowId",         //创建订单和支付记录
    [kCheckOrder] = @"/app-user/v2/pay/checkIOSPay",                    //验证订单
    [kAccountInformation] = @"/app-user/v2/user/counts",                //账户信息
    [kAccountStatistics] = @"/app-user/v2/user/finance",                //账户统计信息
    [kAccountListOfIntegral] = @"/app-user/v2/pay/getOrderList",        //账户积分列表
    [kAccountBalance] = @"/app-user/v2/pay/getUserAccount",             //查询账户余额
    [kAccountStatement] = @"/app-user/v2/pay/getOrderList",             //账户消费明细
    [kUserListCollection] = @"/app-circle/v2/opus/getCollectList",      //用户收藏列表
    [kToRedeem] = @"/app-user/v2/pay/pointsToAccount",                  //兑换积分
    [kSetSmallFree] = @"/app-user/v2/pay/setFreePay",                   //设置小额免密
    [kIsHavePayPassword] = @"/app-user/v2/pay/getUserPhy",              //查询是否有支付密码
    
    
#pragma mark 晒一晒
    [kFriendsCircleSave] = @"/app-shine/v2/friendsCircle/save",
    [kFriendsCircleList] = @"/app-shine/v2/friendsCircle/list",
    [kFriendsCircleListFeed] = @"/app-shine/v2/friendsCircle/listFeed",
    [kFriendsCircleDetail] = @"/app-shine/v2/friendsCircle/detail",
    [kFriendsCircleDelete] = @"/app-shine/v2/friendsCircle/delete",
    [kFriendsCircleComment] = @"/app-shine/v2/friendsCircle/comment",
    [kFriendsCircleCommentList] = @"/app-shine/v2/friendsCircle/commentList",
    [kFriendsCircleCimmentDelete] = @"/app-shine/v2/friendsCircle/commentDelete",
    [kFriendsCircleLike] = @"/app-shine/v2/friendsCircle/like",
    [kFriendsCircleLikeList] = @"/app-shine/v2/friendsCircle/likeList",
    
    
    
#pragma mark 作品相关
    [kProductTypeList] = @"/app-circle/v2/channel/list", // 作品分类列表
    [kProductTypeSave] = @"/app-circle/v2/opus/save", //作品发布
    [KProductTypeTag] = @"/app-circle/v2/opus/getTags", //作品标签
    [kProductList] = @"/app-circle/v2/opus/list", // 作品列表
    [kProductdetail] = @"/app-circle/v2/opus/detail",//作品详情
    [kProductTran] = @"/app-circle/v2/collection/transfer",//作品转发
    [kPoductAddComment] = @"/app-circle/v2/opus/comment",//作品添加评论
    [kPoductCommentReply] = @"/app-circle/v2/opus/reply",//作品评论回复
    [kPoductCommentList] = @"/app-circle/v2/opus/getCommentList",//作品评论列表
    [kPoductLikeList] = @"/app-circle/v2/opus/getLikeList", //作品点赞列表
    [kProductTranList] = @"/app-circle/v2/collection/getClubTransferList",
    [kProductLikeAndUnLike] = @"/app-circle/v2/opus/like",
    [kProudctAddCollect]= @"/app-circle/v2/opus/collect", //作品添加收藏
    [kProductDeleteComment] = @"/app-circle/v2/opus/deleteComment", // 作品评论删除
    [kProductBankList] = @"/app-circle/v2/opus/getInfoRankByList", //1.	作品榜单（最新，最热，转发最多，收益最多）
    [kGetTagsInfoByList] = @"/app-circle/v2/opus/getTagsInfoByList",//2001.	作品标签列表
    [kInfoReadStatus] = @"/app-circle/v2/opus/setInfoReadStatus",//2013.	作品设置已读标记
    
#pragma mark 圈子
    //
    [kCircleList] = @"/app-circle/v2/collection/nextList", //圈子列表(新数据)
    [kCircleUplist] = @"/app-circle/v2/collection/upList",//圈子列表（历史数据）
    [KCircleCommentList] = @"/app-circle/v2/collection/getCommentList", //圈子评论列表,
    [KCircleLikeList] = @"/app-circle/v2/collection/getLikeList", //圈子点赞列表
    [kCircleUserTranList] = @"/app-circle/v2/collection/getTransferList",  //个人圈子转发列表
    [kCircleTranList] = @"/app-circle/v2/collection/getClubLevel1",//一级转发者列表
    [kCircleAddLike] = @"/app-circle/v2/collection/like", //圈子添加点赞
    [kCircleAddCollect] = @"/app-circle/v2/collection/collect", //圈子添加收
    
    [kCircleDeleteComment] = @"/app-circle/v2/collection/deleteComment",
    [kCircleAddComment] = @"/app-circle/v2/collection/comment",//圈子添加评论
    [kCircleReplyComment] = @"/app-circle/v2/collection/reply",//圈子评论回复
    [kCircleDetail] = @"/app-circle/v2/collection/detail",//圈子详情页
    [kUserForwardMoney] = @"/app-circle/v2/collection/getUserStatistics", //用户转发统计
    [kInviteTransfer] = @"/app-circle/v2/collection/inviteTransfer",//邀请转发
    [KCircleClubBonud] = @"/app-circle/v2/collection/getClubBonud",//圈子收益与转发数
    [KCircleEarningStatistics] = @"/app-circle/v2/collection/getClubStatistics",//圈子收益统计
    [KCirclEannouncement] = @"/app-circle/v2/other/getNoticeList",//圈子公告
    
#pragma mark 打赏红包
    
    [kRewardObjList] = @"/app-redpacket/v2/reward/list", // 对象打赏礼物列表
    [KRegardGiftList] = @"/app-redpacket/v2/reward/giftList",
    [kSendRegardGift]= @"/app-redpacket/v2/reward/sendReward",//发送打赏
    [kReceiveRedList] = @"/app-redpacket/v2/redbag/list",
    [kSendRedList] = @"/app-redpacket/v2/redbag/list",
    [kOpenRed] = @"/app-redpacket/v2/redbag/open",
    [kGetRedDetail] = @"/app-redpacket/v2/redbag/receiveList",
    [kRobRed] = @"/app-redpacket/v2/redbag/grab",
    [kRedPacketAdsList]= @"/app-redpacket/v2/advert/getAdverts",//红包广告列表
    [kReleaseRedAds] =  @"/app-redpacket/v2/advert/save",
    [kAdAddLikeOrUnLike] = @"/app-circle/v2/advertcommentlike/like",
    [kAdvertAddCommentlike] = @"/app-circle/v2/advertcommentlike/comment",
    [kAdsReplyComment] = @"/app-circle/v2/advertcommentlike/reply",//广告回复评论
    [kAdsCommentsNum] = @"/app-circle/v2/advertcommentlike/getAdvertCount",
    [kAdDetail] = @"/app-redpacket/v2/advert/getAdvertDetail",
    [kAdsLikeList] = @"/app-circle/v2/advertcommentlike/getLikeList",
    [kAdsCommentsList] = @"/app-circle/v2/advertcommentlike/getCommentList",
    [kAdsPriceDay] = @"/app-redpacket/v2/advert/getAdvertPrice",
    [kAdDeleteComment] = @"/app-circle/v2/advertcommentlike/deleteComment",//广告评论删除
    
};

#pragma

NSString * const RRZCustId = @"custId";
NSString * const RRZPageNowKey = @"pageNow";
NSString * const RRZPageSizeKey = @"pageSize";




