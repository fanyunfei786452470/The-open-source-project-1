//
//  APIConstant.h
//  rrz
//
//  Created by weishibo on 14/12/21.
//  Copyright (c) 2014年 weishibo. All rights reserved.
//

NSString * const Interface[] = {
    
    [kHomeBannerList] = @"/app-redpacket/v2/other/getBannerList",
    // 注册页面
    [kRegisterPage] = @"/app-user/v2/user/register",
    // 登录
    [kLoginPage] = @"/app-user/v2/user/login",
    //微信登录
    [kWeChatLogin] = @"/app-user/v2/user/wxLogin",
    //QQ登录
    [kTencentLogin] = @"/app-user/v2/user/qqLogin",
    //新浪登录
    [kSinaLogin] = @"/app-user/v2/user/wbLogin",
    //第三方登录
    [kThirdLogin] = @"/app-user/v2/user/thirdLogin",
    // 短信验证
    [kShortMessage] = @"/app-user/v2/user/sendVerifyCode",
    //退出登录
    [kUserLoginOut] = @"/app-user/v2/user/loginOut",
      //忘记密码
    [kForgotPassword] = @"/app-user/v2/user/forgotPassword",
    //修改密码
    [kChangePassword] = @"/app-user/v2/user/editPassword",
    //修改支付密码
    [kChangePayPassword] = @"/app-user/v2/pay/setPayPassword",
    //修改个人信息
    [kChangeInformation] = @"/app-user/v2/user/modify",
   
    //解绑,绑定
    [kBindAccount] = @"/app-user/v2/user/bindThirdAccount",
#pragma mark --- 抽奖
    [kPastTheLottery] = @"/app-redpacket/v2/lottery/list",  //往期开奖
    
    [kDrawTheDetails] = @"/app-redpacket/v2/lottery/detail",
#pragma mark - 通讯录
    //好友 关注 黑名单列表
    [kGoodFriends] = @"/app-user/v2/relation/listAll",
    //关注我的
    [kRegardMe] = @"/app-user/v2/relation/listFans",
    //我关注的
    [kMyRegard] = @"/app/relationship/relationshipListAtoB",
    
    //对好友进行操作,关注、取关/移入、移除黑名单
    [kFriendsOperation] = @"/app-user/v2/relation/save",
    //用户详情
    [kUserInfo] = @"/app/relationship/findStatusByCustId",
//    好友详情
    [kFriendsDetail] = @"/app-user/v2/relation/friendsdetail",
    //匹配手机联系人
    [kMatchingPhonePeople] = @"/app-user/v2/user/uploadContract",
    //搜索好友
    [kSearchFriend] = @"/app-user/v2/user/search",
    //获取登录方式
    [kLoginMethod] = @"/app-user/v2/user/loginMethod",
    
#pragma mark 账户相关
    //我的账户
    [kGetUserCustAccount] = @"/app/custaccount/getCustAccount",
    //创建订单和支付记录
    [kcreateOrderAndPay] = @"/app-user/pay/getNewPayFlowId",
    //验证订单
    [kCheckOrder] = @"/app-user/v2/pay/checkIOSPay",
    
//    //账户信息
    [kAccountInformation] = @"/app-user/v2/user/counts",
    //账户统计信息
    [kAccountStatistics] = @"/app-user/v2/user/finance",
    //账户积分列表
    [kAccountListOfIntegral] = @"/app-user/v2/pay/getOrderList",
    //账户消费明细
    [kAccountStatement] = @"/app-user/v2/pay/getOrderList",
    //用户收藏列表
    [kUserListCollection] = @"/app-user/v2/user/collectList",
    //兑换积分
    [kToRedeem] = @"/app-user/v2/pay/pointstoaccount",
    //设置小额免密
    [kSetSmallFree] = @"/app-user/v2/pay/setFreePay",
    //查询是否有支付密码
    [kIsHavePayPassword] = @"/app-user/v2/pay/getUserPhy",
    

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
    [kProductTypeSave] = @"/app-circle/v2/opus/save",
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
    
    
#pragma mark 圈子
    
    [kCircleList] = @"/app-circle/v2/collection/nextList", //圈子列表
    [KCircleCommentList] = @"/app-circle/v2/collection/getCommentList", //圈子评论列表,
    [KCircleLikeList] = @"/app-circle/v2/collection/getLikeList", //圈子点赞列表
    [kCircleUserTranList] = @"/app-circle/v2/collection/getTransferList",  //圈子转发列表
    [kCircleTranList] = @"/app-circle/v2/collection/getClubTransferList",
    [kCircleAddLike] = @"/app-circle/v2/collection/like", //圈子添加点赞
    [kCircleAddCollect] = @"/app-circle/v2/collection/collect", //圈子添加收藏
    [kCircleDeleteComment] = @"/app-circle/v2/collection/deleteComment",
    [kCircleAddComment] = @"/app-circle/v2/collection/comment",//圈子添加评论
    [kCircleReplyComment] = @"/app-circle/v2/collection/reply",//圈子评论回复
    
    
#pragma mark 打赏红包
    
    [kRewardObjList] = @"/app-redpacket/v2/reward/list", // 对象打赏礼物列表
    [KRegardGiftList] = @"/app-redpacket/v2/reward/giftList",
    [kSendRegardGift]= @"/app-redpacket/v2/reward/sendReward",//发送打赏
    [kReceiveRedList] = @"/app-redpacket/v2/redbag/list",
    [kSendRedList] = @"/app-redpacket/v2/redbag/list",
    [kOpenRed] = @"/app-redpacket/v2/redbag/open",
    [kGetRedDetail] = @"/app-redpacket/v2/redbag/receiveList",
    [kRobRed] = @"/app-redpacket/v2/redbag/grab",

 };


NSString * const RRZCustId = @"custId";
NSString * const RRZPageNowKey = @"pageNow";
NSString * const RRZPageSizeKey = @"pageSize";




