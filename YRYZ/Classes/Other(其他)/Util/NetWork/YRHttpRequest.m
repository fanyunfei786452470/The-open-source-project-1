//
//  YRHttpRequest.m
//  YRYZ
//
//  Created by weishibo on 16/7/11.
//  Copyright © 2016年 yryz. All rights reserved.
//

#import "YRHttpRequest.h"
#import "YRNetworkController.h"

@implementation YRHttpRequest

#pragma mark - 请求接口


+(void)homeBannerListsuccess:(void (^)(id data))success failure:(void (^)(NSString *errorInfo))failure{
    NSDictionary *parameters = @{
                                 @"act":@(9002),
                                 };
    [YRNetworkController postRequestUrlStr:kHomeBannerList withDic:parameters success:^(NSDictionary *requestDic) {
        success(requestDic);
    } failure:^(NSString *errorInfo) {
        failure(errorInfo);
    }];
}

#pragma mark - 首页

/**
 *  @author ZX, 16-08-20 09:08:29
 *
 *  作品发布
 *
 *  @param uid     用户ID
 *  @param tags    标签
 *  @param title   标题
 *  @param type    文件类型 1.图文 2.视频 3.音频
 *  @param urls    OSS文件地址
 */
+(void)getProductTypeSaveByCustUserId:(NSString *)uid Tags:(NSArray *)tags Title:(NSString *)title Content:(NSString *)content Type:(int)type InfoCategor:(NSString *)infoCategor Urls:(NSString *)urls success:(void (^)(NSDictionary *data))success failure:(void (^)(NSString *errorInfo))failure{
    
    NSDictionary *parameters = @{
                                 @"id":[YRUserInfoManager manager].currentUser.custId?:@"",
                                 @"tags":tags,
                                 @"title":title?title:@"",
                                 @"content" :content?content:@"",
                                 @"type" :@(type),
                                 @"urls" :urls,
                                 @"infoCategory" :infoCategor?infoCategor:@"",
                                 @"act":@"2002"
                                 };
    
    [YRNetworkController postRequestUrlStr:kProductTypeSave withDic:parameters success:^(NSDictionary *requestDic) {
        success(requestDic);
    } failure:^(NSString *errorInfo) {
        failure(errorInfo);
    }];
    
}


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
+(void)getPastTheLotteryInformationBypageNow:(NSString *)pageNow  pageSize:(NSString *)pageSize  success:(void (^)(NSDictionary *data))success failure:(void (^)(NSString *eCorrorInfo))failure{
    
    NSDictionary *parameters = @{
                                 @"act":@"7002",
                                 @"pageNow":pageNow,
                                 @"pageSize":pageSize
                                 };
    
    [YRNetworkController postRequestUrlStr:kPastTheLottery withDic:parameters success:^(NSDictionary *requestDic) {
        success(requestDic);
    } failure:^(NSString *errorInfo) {
        failure(errorInfo);
    }];
}

/**
 * @author Sean, 16-08-27 15:08:47
 *
 * 抽奖详情
 *
 * @param success <#success description#>
 * @param failure <#failure description#>
 */
+ (void)detailsForLuckyDrawsuccess:(void (^)(NSDictionary *data))success failure:(void (^)(NSString *eCorrorInfo))failure{
    NSDictionary *parameters = @{
                                 @"act":@"7001",
                                 @"userid":[YRUserInfoManager manager].currentUser.custId?:@"",
                                 };
    
    [YRNetworkController postRequestUrlStr:kDrawTheDetails withDic:parameters success:^(NSDictionary *requestDic) {
        success(requestDic);
    } failure:^(NSString *errorInfo) {
        failure(errorInfo);
    }];
    
}

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

+(void)sendSunTextByCustContent:(NSString *)content Pics:(NSArray *)pics VideoPic:(NSString *)videoPic VideoUrl:(NSString *)videoUrl success:(void (^)(NSDictionary *data))success failure:(void (^)(NSString *errorInfo))failure{
    
    NSDictionary *parameters = @{

                                 @"custId":[YRUserInfoManager manager].currentUser.custId?:@"",
                                 @"content":content?content:@"",
                                 @"pics":pics?pics:@[],
                                 @"videoPic":videoPic?videoPic:@"",
                                 @"videoUrl":videoUrl?videoUrl:@"",
                                 @"act":@"2002"
                                 };
    [YRNetworkController postRequestUrlStr:kFriendsCircleSave withDic:parameters success:^(NSDictionary *requestDic) {
        success(requestDic);
    } failure:^(NSString *errorInfo) {
        failure(errorInfo);
    }];
}


/**
 *  @author ZX, 16-08-19 11:08:42
 *
 *  晒一晒列表
 *
 *  @param uid     用户Id
 *  @param limit   条数
 *  @param time    时间
 */
+(void)getFriendsCircleListByCustUserId:(NSString *)uid Limit:(NSInteger)limit Time:(NSString *)time success:(void (^)(NSDictionary *data))success
                                failure:(void (^)(NSString *errorInfo))failure{
    
    NSDictionary *parameters = @{
                                 @"custId":[YRUserInfoManager manager].currentUser.custId?:@"",
                                 @"limit":@(limit),
                                 @"time":time,
                                 @"act":@"2002"
                                 };
    [YRNetworkController postRequestUrlStr:kFriendsCircleList withDic:parameters success:^(NSDictionary *requestDic) {
        success(requestDic);
    } failure:^(NSString *errorInfo) {
        failure(errorInfo);
    }];
    
}

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
+(void)getFriendsCircleListFeedsByCustLimit:(NSInteger)limit Page:(int)page success:(void (^)(NSDictionary *data))success
                                failure:(void (^)(NSString *errorInfo))failure{
    
    NSDictionary *parameters = @{
                                 @"custId":[YRUserInfoManager manager].currentUser.custId?:@"",
                                 @"limit":@(limit),
                                 @"page":@(page),
                                 @"act":@"2002"
                                 };
    
    [YRNetworkController postRequestUrlStr:kFriendsCircleListFeed withDic:parameters success:^(NSDictionary *requestDic) {
        success(requestDic);
    } failure:^(NSString *errorInfo) {
        failure(errorInfo);
    }];
    
}

/**
 *  @author ZX, 16-08-25 10:08:36
 *
 *  晒一晒详情
 *
 *  @param sid     晒一晒id
 */
+(void)getFriendsCircleDetailByCustSid:(int)sid success:(void (^)(NSDictionary *data))success
                                    failure:(void (^)(NSString *errorInfo))failure{

    NSDictionary *parameters = @{
                                 @"custId":[YRUserInfoManager manager].currentUser.custId?:@"",
                                 @"sid":@(sid),
                                 @"act":@"2002"
                                 };
    [YRNetworkController postRequestUrlStr:kFriendsCircleDetail withDic:parameters success:^(NSDictionary *requestDic) {
        success(requestDic);
    } failure:^(NSString *errorInfo) {
        failure(errorInfo);
    }];
}

/**
 *  @author ZX, 16-08-25 11:08:03
 *
 *  删除晒一晒
 *
 *  @param sid     晒一晒id
 */
+(void)deleteFriendsCircleDetailByCustSid:(int)sid success:(void (^)(NSDictionary *data))success failure:(void (^)(NSString *errorInfo))failure{
    
    NSDictionary *parameters = @{
                                 @"custId":[YRUserInfoManager manager].currentUser.custId?:@"",
                                 @"sid":@(sid),
                                 @"act":@"2002"
                                 };
    [YRNetworkController postRequestUrlStr:kFriendsCircleDelete withDic:parameters success:^(NSDictionary *requestDic) {
        success(requestDic);
    } failure:^(NSString *errorInfo) {
        failure(errorInfo);
    }];
}
/**
 *  @author ZX, 16-08-25 19:08:05
 *
 *  晒一晒点赞
 *
 *  @param sid     晒一晒id
 *  @param action  操作
 */
+(void)getFriendsCircleLikeByCustSid:(int)sid Action:(int)action success:(void (^)(NSDictionary *data))success failure:(void (^)(NSString *errorInfo))failure{
    
    NSDictionary *parameters = @{

                                 @"custId":[YRUserInfoManager manager].currentUser.custId?:@"",
                                 @"sid":@(sid),
                                 @"action":@(action),
                                 @"act":@"2002"
                                 };
    [YRNetworkController postRequestUrlStr:kFriendsCircleLike withDic:parameters success:^(NSDictionary *requestDic) {
        success(requestDic);
    } failure:^(NSString *errorInfo) {
        failure(errorInfo);
    }];
}

/**
 *  @author ZX, 16-08-26 10:08:08
 *
 *  晒一晒点赞列表
 *
 *  @param sid     晒一晒id
 *  @param lid     赞id
 *  @param limit   每页大小
 */
+(void)getFriendsCircleLikeListByCustSid:(int)sid Lid:(int)lid Limit:(int)limit success:(void (^)(NSDictionary *data))success failure:(void (^)(NSString *errorInfo))failure{
    
    NSDictionary *parameters = @{
                                 @"custId":[YRUserInfoManager manager].currentUser.custId?:@"",
                                 @"sid":@(sid),
                                 @"lid":@(lid),
                                 @"limit":@(limit),
                                 @"act":@"2002"
                                 };
    [YRNetworkController postRequestUrlStr:kFriendsCircleLikeList withDic:parameters success:^(NSDictionary *requestDic) {
        success(requestDic);
    } failure:^(NSString *errorInfo) {
        failure(errorInfo);
    }];
}



/**
 *  @author ZX, 16-08-25 11:08:53
 *
 *  晒一晒评论
 *
 *  @param sid       晒一晒id
 *  @param authorUid 被评论者id
 *  @param content   评论内容
 */
+(void)sendFriendsCircleCommentByCustSid:(int)sid AuthorUid:(NSString *)authorUid Content:(NSString *)content success:(void (^)(NSDictionary *data))success failure:(void (^)(NSString *errorInfo))failure{
    
    NSDictionary *parameters = @{
                                 @"custId":[YRUserInfoManager manager].currentUser.custId?:@"",
                                 @"sid":@(sid),
                                 @"authorUid":authorUid,
                                 @"content":content,
                                 @"act":@"2002"
                                 };
    [YRNetworkController postRequestUrlStr:kFriendsCircleComment withDic:parameters success:^(NSDictionary *requestDic) {
        success(requestDic);
    } failure:^(NSString *errorInfo) {
        failure(errorInfo);
    }];
}
/**
 *  @author ZX, 16-08-25 13:08:05
 *
 *  评论列表
 *
 *  @param sid     晒一晒id
 *  @param limit   每页大小
 *  @param cid     评论id  不传表示从最新开始取列表，cid>0表示接着这条评论往下取
 */
+(void)getFriendsCircleCommentListByCustSid:(int)sid Limit:(int)limit Cid:(int)cid success:(void (^)(NSDictionary *data))success failure:(void (^)(NSString *eCorrorInfo))failure{
    
    NSDictionary *parameters = @{
                                 @"custId":[YRUserInfoManager manager].currentUser.custId?:@"",
                                 @"sid":@(sid),
                                 @"limit":@(limit),
                                 @"cid":@(cid),
                                 @"act":@"2002"
                                 };
    [YRNetworkController postRequestUrlStr:kFriendsCircleCommentList withDic:parameters success:^(NSDictionary *requestDic) {
        success(requestDic);
    } failure:^(NSString *errorInfo) {
        failure(errorInfo);
    }];
}

/**
 *  @author ZX, 16-08-26 10:08:20
 *
 *  删除评论
 *
 *  @param sid     晒一晒id
 *  @param cid     评论id
 */
+(void)deleteFriendsCircleCommentByCustSid:(int)sid Cid:(int)cid success:(void (^)(NSDictionary *data))success failure:(void (^)(NSString *eCorrorInfo))failure{
    
    NSDictionary *parameters = @{
                                 @"custId":[YRUserInfoManager manager].currentUser.custId?:@"",
                                 @"sid":@(sid),
                                 @"cid":@(cid),
                                 @"act":@"2002"
                                 };
    [YRNetworkController postRequestUrlStr:kFriendsCircleCimmentDelete withDic:parameters success:^(NSDictionary *requestDic) {
        success(requestDic);
    } failure:^(NSString *errorInfo) {
        failure(errorInfo);
    }];
}

#pragma mark - 发现


#pragma mark - 我的
+ (void)sendRequestsuccess:(void (^)(id data ,NSString *msg))succ
                   failure:(void (^)(NSString *errorInfo))fail{
}
/**
 *  @author Sean, 16-08-22 13:08:40
 *
 *  登录接口
 *
 *  @param accout   <#accout description#>
 *  @param password <#password description#>
 *  @param succ     <#succ description#>
 *  @param fail     <#fail description#>
 */
+ (void)loginSendRequestByAccout:(NSString*)accout password:(NSString*)password success:(void (^)(NSDictionary *))success failure:(void (^)(NSString *))failure{
    
    NSDictionary *parameters = @{
                                 @"phone" :accout,
                                 @"password"   :password.YCmd5String,
                                 @"act":@"1003"
                                 
                                 //                                 @"deviceType":@"1",//1为手机 2是pc
                                 //                                 @"deviceName":[NSString stringWithFormat:@"%@设备",[UIDevice currentDevice].name],
                                 //                                 @"deviceId":[NSString getUUID],
                                 };
    [YRNetworkController postRequestUrlStr:kLoginPage withDic:parameters success:^(NSDictionary *requestDic) {
        
        success(requestDic);
        
    } failure:^(NSString *errorInfo) {
        
        failure(errorInfo);
        
    }];
    
}
/**
 * @author Sean, 16-08-22 16:08:25
 *
 * 第三方登录
 *
 * @param thirdName WeChat 为微信  QQ为QQ Sina为新浪微博
 1，微信    2，微博   3，qq
 * @param openId    <#openId description#>
 * @param success   <#success description#>
 * @param failure   <#failure description#>
 */
+(void)ThirdPartyLoginByThirdName:(NSString *)thirdName openId:(NSString *)openId  accessToken:(NSString *)accessToken  success:(void (^)(NSDictionary *data))success  failure:(void (^)(NSString *errorInfo))failure{
    NSInteger type;
      if([thirdName isEqualToString:@"WeChat"]){
          type = 1;
        
     }else if ([thirdName isEqualToString:@"QQ"]){
        type = 3;
     
     }else if ([thirdName isEqualToString:@"Sina"]){
        type = 2;
     }
    
    NSDictionary *parameters = @{
                                 @"openId" :openId,
                                 @"accessToken": accessToken,
                                 @"type":@(type),
                                 @"act":@"1004"
                                 };
    
    [YRNetworkController postRequestUrlStr:kThirdLogin withDic:parameters success:^(NSDictionary *requestDic) {
        
        success(requestDic);
        
    } failure:^(NSString *errorInfo) {
        
        failure(errorInfo);
        
    }];
}

/**
 *  @author Sean, 16-08-22 13:08:40
 *
 *  获取验证码
 *
 *  @param custPhone <#custPhone description#>
 *  @param succ      <#succ description#>
 *  @param fail      <#fail description#>
 */
+(void)getRegisterCheckingByCustPhone:(NSString *)custPhone codeType:(AuthCodeType)type success:(void (^)(NSDictionary *))success  failure:(void (^)(NSString *))failure{
    NSDictionary *parameters = @{
                                 @"phone" :custPhone,
                                 @"type" :@1,
                                 @"code" :@(type),
                                 @"act":@"1001"
                                 };
    [YRNetworkController postRequestUrlStr:kShortMessage withDic:parameters success:^(NSDictionary *requestDic) {
        success(requestDic);
    } failure:^(NSString *errorInfo) {
        failure(errorInfo);
    }];
}
/**
 *  @author Sean, 16-08-22 13:08:11
 *  忘记密码
 *  @param phone     <#phone description#>
 *  @param password  <#password description#>
 *  @param phoneCode <#phoneCode description#>
 *  @param success   <#success description#>
 *  @param failure   <#failure description#>
 */
+(void)forgotPasswordRequestByPhoneNumber:(NSString *)phone password:(NSString *)password   phoneCode:(NSString *)phoneCode
                                  success:(void (^)(NSDictionary *data))success
                                  failure:(void (^)(NSString *errorInfo))failure{
    
    NSDictionary *parameters = @{
                                 @"phone" :phone,
                                 @"password" :password.md5String,
                                 @"veriCode" :phoneCode,
                                 @"act":@"1010"
                                 };
    [YRNetworkController postRequestUrlStr:kForgotPassword withDic:parameters success:^(NSDictionary *requestDic) {
        success(requestDic);
    } failure:^(NSString *errorInfo) {
        failure(errorInfo);
    }];
}
/**
 *  @author Sean, 16-08-22 09:08:32
 *
 *  修改密码
 *
 *  @param password    <#password description#>
 *  @param newPassword <#newPassword description#>
 *  @param success     <#success description#>
 *  @param failure     <#failure description#>
 */
+(void)ChangeThePasswordFromOldPassword:(NSString *)password newPassword:(NSString *)newPassword
                                success:(void (^)(NSDictionary *data))success failure:(void (^)(NSString *errorInfo))failure{
    
    NSDictionary *parameters = @{
                                 @"custId":[YRUserInfoManager manager].currentUser.custId,
                                 @"password":password,
                                 @"newPassword":newPassword,
                                 @"act":@"1009"
                                 };
    
    [YRNetworkController postRequestUrlStr:kChangePassword withDic:parameters success:^(NSDictionary *requestDic) {
        success(requestDic);
        
    } failure:^(NSString *errorInfo) {
        DLog(@"%@",errorInfo);
        failure(errorInfo);
        
    }];
}
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
                     success:(void (^)(NSDictionary *data))success failure:(void (^)(NSString *errorInfo))failure{
    
    NSDictionary *parameters = @{
                                 @"custId":[YRUserInfoManager manager].currentUser.custId,
                                 @"payPassword":newPayPassword,
                                 @"oldPayPassword":oldPayPassword,
                                 @"act":@"1048"
                                 };
    [YRNetworkController postRequestUrlStr:kChangePayPassword withDic:parameters success:^(NSDictionary *requestDic) {
        success(requestDic);
        
    } failure:^(NSString *errorInfo) {
        DLog(@"%@",errorInfo);
        failure(errorInfo);
        
    }];
    
}

/**
 *  @author Sean, 16-08-22 13:08:40
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
+(void)registerSendRequestByCustPhone:(NSString *)custPhone password:(NSString *)password phoneCode:(NSString *)phoneCode regType:(CodeType)regType success:(void (^)(NSDictionary *))success failure:(void (^)(NSString *))failure{
    
    NSDictionary *parameters = @{
                                 @"phone"       : custPhone,
                                 @"password"    : password,
                                 @"veriCode"   : phoneCode,
                                 @"custRegType"     : @"iOS",
                                 @"act"        : @"1002",
                                 };
    [YRNetworkController postRequestUrlStr:kRegisterPage withDic:parameters  success:^(NSDictionary *requestDic){
        success(requestDic);
    } failure:^(NSString *errorInfo) {
        failure(errorInfo);
    }];
    
}

/**
 *  @author Sean, 16-08-22 13:08:40
 *  修改个人信息
 *
 *  @param dic     <#dic description#>
 *  @param success <#success description#>
 *  @param failure <#failure description#>
 */
+(void)ModifyPersonalInformationByInformation:(NSDictionary *)dic  success:(void (^)(NSDictionary *data))success failure:(void (^)(NSString *error))failure{
    
    
    NSDictionary *parameters = @{
                                 @"custId"     : [YRUserInfoManager manager].currentUser.custId,
                                 @"nickName":@"",
                                 @"sex":@"",
                                 @"headImg":@"",
                                 @"signature":@"",
                                 @"address":@"",
                                 @"desc":@"",
                                 };
    
    [YRNetworkController postRequestUrlStr:kChangeInformation withDic:parameters success:^(NSDictionary *requestDic) {
        success(requestDic);
    } failure:^(NSString *errorInfo) {
        failure(errorInfo);
    }];
    
}
/**
 * @author Sean, 16-08-22 15:08:59
 *
 * 修改个人信息  单条
 *
 * @param name    <#name description#>
 * @param value   <#value description#>
 * @param success <#success description#>
 * @param failure <#failure description#>
 */
+ (void)ModifyPersonalInformationByChangeName:(NSString *)name value:(NSString *)value success:(void (^)(NSDictionary *data))success failure:(void (^)(NSString *error))failure{
    NSDictionary *parameters = @{
                                 @"custId"     : [YRUserInfoManager manager].currentUser.custId,
                                 name       :value,
                                 @"act":@"1011"
                                 };
    
    [YRNetworkController postRequestUrlStr:kChangeInformation withDic:parameters success:^(NSDictionary *requestDic) {
        
        success(requestDic);
        
        
    } failure:^(NSString *errorInfo) {
        
        failure(errorInfo);
    }];
    
}
/**
 * @author Sean, 16-08-30 18:08:34
 *
 * 获取相关信息   圈子  转发  晒一晒 红包广告
 *
 * @param type    <#type description#>
 * @param start   <#start description#>
 * @param limin   <#limin description#>
 * @param success <#success description#>
 * @param failure <#failure description#>
 */
+ (void)getForMyFnformationByWhatType:(MineInformation)type  start:(NSString *)start limin:(NSString *)limin    success:(void (^)(NSDictionary *data))success failure:(void (^)(NSString *error))failure{
    
    
    NSDictionary *parameters = @{
                                 @"authorid"   : @"68c66679de32497a8ecc21aa29bb3478",
                                 @"act" :@"2025",
                                 @"start"  : start,
                                 @"limit"  :limin
                                 };
    HttpMethd requestUrl;
    switch (type) {
        case 1:     requestUrl = kCircleUserTranList;
            break;
        case 2:     @"";
            break;
        case 3:     @"";
            break;
        case 4:     @"";
            break;
        default:
            break;
    }
    [YRNetworkController postRequestUrlStr:kCircleUserTranList withDic:parameters success:^(NSDictionary *requestDic) {
        success(requestDic);
        
    } failure:^(NSString *errorInfo) {
        
        failure(errorInfo);
    }];
    
}





/**
 * @author Sean, 16-08-24 11:08:41
 *
 * 积分兑换到消费账户
 *
 * @param theAmount <#theAmount description#>
 * @param success   <#success description#>
 * @param failure   <#failure description#>
 */
+ (void)pointsToTheConsumerAccountByChangeTheAmount:(CGFloat)theAmount success:(void (^)(NSDictionary *data))success failure:(void (^)(NSString *error))failure{
    NSDictionary *parameters = @{
                                 @"custId"     : [YRUserInfoManager manager].currentUser.custId,
                                 @"cost"       :@(theAmount),
                                 @"act" :@"1056"
                                 };
    [YRNetworkController postRequestUrlStr:kToRedeem withDic:parameters success:^(NSDictionary *requestDic) {
        success(requestDic);
    } failure:^(NSString *errorInfo) {
        failure(errorInfo);
    }];
}

+ (void)setSmallFreeByType:(BOOL)isSecret success:(void (^)(NSDictionary *data))success failure:(void (^)(NSString *error))failure{
    NSString *type = isSecret?@"1":@"0";
    NSDictionary *parameters = @{
                                 @"custId"     : [YRUserInfoManager manager].currentUser.custId,
                                 @"type"       :type,
                                 @"act" :@"1064"
                                 };
    [YRNetworkController postRequestUrlStr:kSetSmallFree withDic:parameters success:^(NSDictionary *requestDic) {
        success(requestDic);
    } failure:^(NSString *errorInfo) {
        failure(errorInfo);
    }];
    
    
}

/**
 * @author Sean, 16-08-22 17:08:19
 *
 * 获取登录方式
 *
 * @param success <#success description#>
 * @param failure <#failure description#>
 */
+ (void)toObtainTheLoginWaySuccess:(void (^)(NSDictionary *data))success failure:(void (^)(NSString *error))failure{
    
    NSDictionary *parameters = @{
                                 @"custId"     : [YRUserInfoManager manager].currentUser.custId,
                                 @"act":@"1008"
                                 };
    [YRNetworkController postRequestUrlStr:kLoginMethod withDic:parameters success:^(NSDictionary *requestDic) {
        success(requestDic);
        
    } failure:^(NSString *errorInfo) {
        failure(errorInfo);
    }];
    
}
/**
 * @author Sean, 16-08-22 17:08:01
 name    value
 * @param name    1，微信   2，微博   3，qq
    action   0，绑定    1，解绑
 qq      Qq的openId
 wx      微信openId
 wb      微博openId
 * @param success <#success description#>
 * @param failure <#failure description#>
 */
+ (void)bindOtherAccountByTheName:(NSString *)name accessToken:(NSString *)accessToken  openId:(NSString *)openId   action:(NSString *)action success:(void (^)(NSDictionary *data))success failure:(void (^)(NSString *error))failure{
    
    NSDictionary *parameters = @{
                                 @"custId"     : [YRUserInfoManager manager].currentUser.custId,
                                 @"type":name,
                                 @"openId":openId,
                                 @"action":action,
                                 @"accessToken" :accessToken,
                                 @"act":@"1012"
                                 };
    [YRNetworkController postRequestUrlStr:kBindAccount withDic:parameters success:^(NSDictionary *requestDic) {
        success(requestDic);
    } failure:^(NSString *errorInfo) {
        failure(errorInfo);
    }];
}
#pragma mark - 通讯录
/**
 *  @author yichao, 16-08-05 09:08:00
 *
 *  通讯录（好友）
 *
 *  @param success <#success description#>
 *  @param failure <#failure description#>
 */
+(void)getFriendListSuccess:(void (^)(NSDictionary *))success failure:(void (^)(NSString *))failure{
    
    NSDictionary *parameters = @{
                                 @"token"     : [YRUserInfoManager manager].currentUser.token?:@"",
                                 @"fromCustId"     : [YRUserInfoManager manager].currentUser.custId?:@"",
                                 };
    [YRNetworkController postRequestWithCacheUrlStr:kGoodFriends withDic:parameters cacheKey:nil  success:^(NSDictionary *requestDic){
        success(requestDic);
    } failure:^(NSString *errorInfo) {
        failure(errorInfo);
    }];
}

/**
 *  @author Sean, 16-06-28 09:06:19
 *
 *  关注我的
 *
 *  @param succ <#succ description#>
 *  @param fail <#fail description#>
 */
+(void)getRegardMeListWithLimit:(NSNumber *)limit start:(NSNumber *)start   Success:(void (^)(NSDictionary *))success failure:(void (^)(NSString *))failure{
    NSDictionary *parameters = @{
                                 @"custId"     : [YRUserInfoManager manager].currentUser.custId?:@"",
                                 @"limit"   : limit,
                                 @"start"    :start,
                                 @"act"     : @(1015)
                                 };
    
    [YRNetworkController postRequestWithCacheUrlStr:kRegardMe withDic:parameters cacheKey:nil success:^(NSDictionary *requestDic) {
        success(requestDic);
    } failure:^(NSString *errorInfo) {
        failure(errorInfo);
    }];
}

/**
 *  @author yichao, 16-06-28 09:06:19
 *
 *  我关注的
 *
 *  @param succ <#succ description#>
 *  @param fail <#fail description#>
 */
+(void)getMyRegardListSuccess:(void (^)(NSDictionary *))success failure:(void (^)(NSString *))failure{
    NSDictionary *parameters = @{
                                 @"token"     : [YRUserInfoManager manager].currentUser.token?:@"",
                                 @"custId"     : [YRUserInfoManager manager].currentUser.custId?:@"",
                                 };
    
    [YRNetworkController postRequestWithCacheUrlStr:kMyRegard withDic:parameters  cacheKey:nil success:^(NSDictionary *requestDic) {
        success(requestDic);
    } failure:^(NSString *errorInfo) {
        failure(errorInfo);
    }];
}
/**
 * @author Sean, 16-08-24 16:08:08
    我关注的
    1关注 2粉丝 3好友  4黑名单
 *
 * @param type    <#type description#>
 * @param success <#success description#>
 * @param failure <#failure description#>
 */
+(void)getFriendListSuccessWithType:(AddressBookFriendType)type   success:(void (^)(NSDictionary *data))success failure:(void (^)(NSString *error))failure{
    
    NSDictionary *parameters = @{
                                 @"custId"     : [YRUserInfoManager manager].currentUser.custId?:@"",
                                 @"type"       : @(type),
                                 @"act"        :@"1015"
                                 };
    [YRNetworkController postRequestUrlStr:kGoodFriends withDic:parameters success:^(NSDictionary *requestDic) {
        success(requestDic);
    } failure:^(NSString *errorInfo) {
        failure(errorInfo);
    }];
}



/**
 * @author Sean, 16-08-24 16:08:25
 * 添加 取消关注 移入  移除黑名单
 
 * @param type       1- 关注  2- 黑名单
 * @param fid        好友ID
 * @param actionType 操作类型 0 添加  1 删除
 * @param success    <#success description#>
 * @param failure    <#failure description#>
 */
+ (void)AddOrRemoveAttentionToRemoveByType:(NSString *)type friendID:(NSString *)fid actionType:(NSNumber *)actionType  success:(void (^)(NSDictionary *data))success failure:(void (^)(NSString *error))failure{
    
    NSDictionary *parameters = @{
                                 @"type"         : type,
                                 @"fid"          : fid?fid:@"",
                                 @"action"       : actionType,
                                 @"custId"       :[YRUserInfoManager manager].currentUser.custId,
                                 @"act"          : @"1016"
                                 };
    
    [YRNetworkController postRequestUrlStr:kFriendsOperation withDic:parameters success:^(NSDictionary *requestDic) {
        success(requestDic);
    } failure:^(NSString *errorInfo) {
        failure(errorInfo);
    }];
}

/**
 *  @author yichao, 16-08-05 16:08:21
 *
 *  用户详情
 *
 *  @param toCustId <#toCustId description#>
 *  @param success  <#success description#>
 *  @param failure  <#failure description#>
 */
+(void)getUserInfoByToCustId:(NSString *)toCustId success:(void (^)(NSDictionary *))success failure:(void (^)(NSString *))failure{
    NSDictionary *parameters = @{
                                 @"token"     : [YRUserInfoManager manager].currentUser.token?:@"",
                                 @"custId"     : [YRUserInfoManager manager].currentUser.custId?:@"",
                                 @"toCustId"       : toCustId,
                                 };
    [YRNetworkController postRequestWithCacheUrlStr:kUserInfo withDic:parameters  cacheKey:nil success:^(NSDictionary *requestDic) {
        success(requestDic);
    } failure:^(NSString *errorInfo) {
        failure(errorInfo);
    }];
}
/**
 * @author Sean, 16-08-24 18:08:57
 *
 * 好友详情
 *
 * @param friendsId <#friendsId description#>
 * @param success   <#success description#>
 * @param failure   <#failure description#>
 */
+ (void)getFriendsdetailsByFriendId:(NSString *)friendsId success:(void (^)(NSDictionary *data))success failure:(void (^)(NSString *error))failure{
    
    NSDictionary *parameters = @{
                                 @"custId"     : [YRUserInfoManager manager].currentUser.custId?:@"",
                                 @"fid"       : friendsId,
                                 @"act" : @"1018"
                                 };
    [YRNetworkController postRequestUrlStr:kFriendsDetail withDic:parameters success:^(NSDictionary *requestDic) {
        success(requestDic);
    } failure:^(NSString *errorInfo) {
        failure(errorInfo);
    }];
}


/**
 *  @author weishibo, 16-08-09 16:08:39
 *  获取我的账户
 *
 *  @param success <#success description#>
 *  @param failure <#failure description#>
 */

+(void)getUserCustAccountsuccess:(void (^)(NSDictionary *))success failure:(void (^)(NSString *))failure{
    NSDictionary *parameters = @{
                                 @"token"     : [YRUserInfoManager manager].currentUser.token,
                                 };
    [YRNetworkController postRequestUrlStr:kGetUserCustAccount withDic:parameters success:^(NSDictionary *requestDic) {
        success(requestDic);
    } failure:^(NSString *errorInfo) {
        failure(errorInfo);
    }];
}
/**
 * @author Sean, 16-08-22 17:08:53
 * 匹配手机联系人
 *
 * @param data    <#data description#>
 * @param success <#success description#>
 * @param failure <#failure description#>
 */

+ (void)mobilePhoneContactMatchByAddressBook:(NSString *)data success:(void (^)(NSDictionary *data))success failure:(void (^)(NSString *error))failure{
    
    NSDictionary *parameters = @{
                                 @"custId"     : [YRUserInfoManager manager].currentUser.custId,
                                 @"data":data
                                 };
    
    [YRNetworkController postRequestUrlStr:kMatchingPhonePeople withDic:parameters success:^(NSDictionary *requestDic) {
        success(requestDic);
    } failure:^(NSString *errorInfo) {
        failure(errorInfo);
    }];
    
}
/**
 * @author Sean, 16-08-22 17:08:49
 *
 * 好友搜索
 *
 * @param keyword  <#keyword description#>
 * @param page     <#page description#>
 * @param pageSize <#pageSize description#>
 * @param success  <#success description#>
 * @param failure  <#failure description#>
 */

+ (void)searchFriendByKeyWord:(NSString *)keyword page:(int )page pageSize:(int)pageSize  success:(void (^)(NSDictionary *data))success failure:(void (^)(NSString *error))failure{
    
    
    NSDictionary *parameters = @{
                                 @"custId"     : [YRUserInfoManager manager].currentUser.custId,
                                 @"keyword":keyword,
                                 @"start":@(page),
                                 @"limit":@(pageSize),
                                 @"act":@"1014"
                                 };
    
    [YRNetworkController postRequestUrlStr:kSearchFriend withDic:parameters success:^(NSDictionary *requestDic) {
        success(requestDic);
    } failure:^(NSString *errorInfo) {
        failure(errorInfo);
    }];
    
}
/**
 * @author Sean, 16-08-22 18:08:46
 *
 *    获取账户相关信息
 informationName:    kAccountInformation,   //账户信息
 kAccountStatistics,   //账户统计信息
 kAccountListOfIntegral,    //账户积分列表
 kAccountStatement,       //账户消费明细
 kUserListCollection,   //用户收藏列表
 
 */

+ (void)AccountInformationByInformationName:(HttpMethd)informationName  success:(void (^)(NSDictionary *data))success failure:(void (^)(NSString *error))failure{
    
    if ([YRUserInfoManager manager].currentUser) {
 
        NSDictionary *parameters = @{
                                     @"custId"     : [YRUserInfoManager manager].currentUser.custId,
                                     @"act"        : @"1020"
                                     };
        [YRNetworkController postRequestUrlStr:informationName withDic:parameters success:^(NSDictionary *requestDic) {
            success(requestDic);
        } failure:^(NSString *errorInfo) {
            failure(errorInfo);
        }];
    }else{
        //   DLog(@"没有登录");
    }
}

/**
 * @author Sean, 16-09-03 09:09:46
 *
 * 查询账单明细
 *
 * @param bilingType <#bilingType description#>
 * @param pageNow    <#pageNow description#>
 * @param pageSize   <#pageSize description#>
 * @param success    <#success description#>
 * @param failure    <#failure description#>
 */
+ (void)AccountInformationByBillingDetails:(NSString *)bilingType pageNow:(NSString *)pageNow pageSize:(NSString *)pageSize success:(void (^)(NSDictionary *data))success failure:(void (^)(NSString *error))failure{
    
    if ([YRUserInfoManager manager].currentUser) {
        
        NSDictionary *parameters = @{
                                     @"custId"     : [YRUserInfoManager manager].currentUser.custId,
                                     @"act"        : @"1049",
                                     @"type"       : bilingType,
                                     @"pageNow"    : pageNow,
                                     @"pageSize"   : pageSize,
                                     };
        [YRNetworkController postRequestUrlStr:kAccountStatement withDic:parameters success:^(NSDictionary *requestDic) {
            success(requestDic);
        } failure:^(NSString *errorInfo) {
            failure(errorInfo);
        }];
    }else{
        //   DLog(@"没有登录");
    }
}

/**
 * @author Sean, 16-08-25 16:08:39
 *
 * 查询用户是否有支付密码
 *
 * @return <#return value description#>
 */

+ (void)QueryThePaymentPasswordSuccess:(void (^)(NSDictionary *data))success failure:(void (^)(NSString *error))failure{
    
    NSDictionary *parameters = @{
                                 @"custId"     : [YRUserInfoManager manager].currentUser.custId,
                                 @"act":@"1054",
                                 };
    [YRNetworkController postRequestUrlStr:kIsHavePayPassword withDic:parameters success:^(NSDictionary *requestDic) {
        success(requestDic);
    } failure:^(NSString *errorInfo) {
        failure(errorInfo);
    }];
}



/**
 *  @author weishibo, 16-08-09 17:08:06
 *
 *  退出登录
 *
 *  @param succ <#succ description#>
 *  @param fail <#fail description#>
 */
+(void)userLoginOutSuccess:(void (^)(id data))success failure:(void (^)(id data))failure{
    
    NSDictionary *parameters = @{
                                 @"token"  : [YRUserInfoManager manager].currentUser.token,
                                 @"act":@"1007"
                                 };
    
    [YRNetworkController postRequestUrlStr:kUserLoginOut withDic:parameters success:^(NSDictionary *requestDic) {
        success(requestDic);
    } failure:^(NSString *errorInfo) {
        failure(errorInfo);
    }];
    
}


/**
 *  @author weishibo, 16-09-01 17:09:55
 *
 *  1.	创建订单和支付记录
 *
 *  @param payType      支付方式
 *  @param ordersrc     订单来源
 *  @param productId    产品id
 *  @param orderAmount  订单价格
 *  @param currencyType 币种
 *  @param success      <#success description#>
 *  @param failure      <#failure description#>
 */
+(void)createOrderAndPay:(PayType)payType orderSrc:(OrderSourceType)ordersrc infoId:(NSString*)productId
                   orderAmount:(NSString*)orderAmount currency:(CurrencyType)currencyType success:(void (^)(id data))success failure:(void (^)(id data))failure{
    
    NSDictionary *parameters = @{
                                 @"act":@(1052),
                                 @"payWay":@(payType),
                                 @"orderSrc":@(ordersrc),
                                 @"productId":productId,
                                 @"orderAmount":orderAmount,
                                 @"currency":@(currencyType),
                                 @"custId"  : [YRUserInfoManager manager].currentUser.custId?:@"",
                                 };
    
    [YRNetworkController postRequestUrlStr:kcreateOrderAndPay withDic:parameters success:^(NSDictionary *requestDic) {
        success(requestDic);
    } failure:^(NSString *errorInfo) {
        failure(errorInfo);
    }];
}


+(void)kCheckOrder:(NSString*)orderId orderAmount:(NSString*)orderAmount receipt:(NSString*)receipt success:(void (^)(id data))success failure:(void (^)(id data))failure{
    
    NSDictionary *parameters = @{
                                 @"act":@(1052),
                                 @"orderId":orderId,
                                 @"orderAmount":orderAmount,
                                 @"receipt":receipt,
                                 @"custId"  : [YRUserInfoManager manager].currentUser.custId?:@"",
                                 };
    
    [YRNetworkController postRequestUrlStr:kcreateOrderAndPay withDic:parameters success:^(NSDictionary *requestDic) {
        success(requestDic);
    } failure:^(NSString *errorInfo) {
        failure(errorInfo);
    }];

}


+(void)productTypeListAnd:(InfoProductType)type cacheKey:(NSString*)cacheKey  success:(void (^)(id data))success failure:(void (^)(id data))failure{
    
    NSDictionary *parameters = @{
                                 @"act":@"2021",
                                 @"type":@(type)
                                 };
    
    [YRNetworkController postRequestWithCacheUrlStr:kProductTypeList withDic:parameters  cacheKey:cacheKey success:^(NSDictionary *requestDic) {
        success(requestDic);
    } failure:^(NSString *errorInfo) {
        failure(errorInfo);
    }];
}

#pragma mark  作品
/**
 *  @author weishibo, 16-08-20 11:08:19
 *
 *  作品列表
 *
 *  @param type     作品类型
 *  @param authorid 作者id
 *  @param categroy 分类id
 *  @param start    分页
 *  @param limit    记录数
 */
+(void)productList:(InfoProductType)type authorid:(NSString*)authorid categroy:(NSString*)categroy  start:(NSInteger)start limit:(NSUInteger)limit success:(void (^)(id data))success failure:(void (^)(id data))failure{
    NSDictionary *parameters = @{
                                 @"act":@"2004",
                                 @"type":@(type),
                                 @"custId" : authorid,
                                 @"category" : categroy,
                                 @"start" :@(start),
                                 @"limit" : @(limit),
                                 @"loginUserId" : [YRUserInfoManager manager].currentUser.custId ? [YRUserInfoManager manager].currentUser.custId  : @"",
                                 };
    
    [YRNetworkController postRequestWithCacheUrlStr:kProductList withDic:parameters  cacheKey:nil success:^(NSDictionary *requestDic) {
        success(requestDic);
    } failure:^(NSString *errorInfo) {
        failure(errorInfo);
    }];
    
}

/**
 *  @author weishibo, 16-08-20 16:08:32
 *
 *  作品详情
 *
 *  @param pid     <#pid description#>
 *  @param success <#success description#>
 *  @param failure <#failure description#>
 */
+(void)productdetailProductId:(NSString*)pid success:(void (^)(id data))success failure:(void (^)(id data))failure{
    
    NSDictionary *parameters = @{
                                 @"act":@"2006",
                                 @"infoId":pid,
                                 };
    
    [YRNetworkController postRequestUrlStr:kProductdetail withDic:parameters success:^(NSDictionary *requestDic) {
        success(requestDic);
    } failure:^(NSString *errorInfo) {
        failure(errorInfo);
    }];
    
}
/**
 *  @author weishibo, 16-08-20 17:08:01
 *
 *  圈子转发
 *
 *  @param userID  用户id
 *  @param pid     圈子id或作品id
 transferType 0：重复转发  1：付费转发
 type          0原创作品  1圈子转发
 authorId 圈子转发者   作品作者的id
 
 isSendRedPacket 是否附带红包
 
 
 packetType 是否附带红包 0拼手气 1普通
 
 totalCount  红包个数
 
 amount  红包金额
 
 *  @param success <#success description#>
 *  @param failure <#failure description#>
 */
+(void)productTran:(ProductTranType)type pID:(NSString*)pid  transferType:(NSInteger)transferType transferMoney:(NSUInteger)transferMoney authorId:(NSString*)authorId  isSendRedPacket:(NSInteger)isSendRedPacket  packetType:(NSInteger)packetType  totalCount:(NSInteger)totalCount  amount:(NSInteger)amount success:(void (^)(id data))success failure:(void (^)(id data))failure{
    NSDictionary *parameters = @{
                                 @"act":@"2017",
                                 @"payType":@(type),
                                 @"userId":[YRUserInfoManager manager].currentUser.custId ? [YRUserInfoManager manager].currentUser.custId :@"",
                                 @"id":pid,
                                 @"type":@(transferType),
                                 @"transferMoney":@(transferMoney),
                                 @"authorId":authorId,
                                 @"isSendRedPacket":@(isSendRedPacket),
                                 @"packetType":@(packetType),
                                 @"totalCount":@(totalCount),
                                 @"amount" :@(amount),
                                 
                                 };
    
    [YRNetworkController postRequestUrlStr:kProductTran withDic:parameters success:^(NSDictionary *requestDic) {
        success(requestDic);
    } failure:^(NSString *errorInfo) {
        failure(errorInfo);
    }];
}

/**
 *  @author yichao, 16-08-22 13:08:28
 *
 *  作品评论列表
 *
 *  @param pid     作品id
 *  @param success <#success description#>
 *  @param failure <#failure description#>
 */
+(void)productCommentList:(NSString*)pid start:(NSInteger)start limit:(NSInteger)limit success:(void (^)(id data))success failure:(void (^)(id data))failure{
    
    NSDictionary *parameters = @{
                                 @"act":@"2009",
                                 @"infoId":pid,
                                 @"start":@(start),
                                 @"limit":@(limit),
                                 @"authorid":[YRUserInfoManager manager].currentUser.custId ? [YRUserInfoManager manager].currentUser.custId :@"",
                                 };
    
    [YRNetworkController postRequestUrlStr:kPoductCommentList withDic:parameters success:^(NSDictionary *requestDic) {
        success(requestDic);
    } failure:^(NSString *errorInfo) {
        failure(errorInfo);
    }];
}

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
+(void)poductAddComment:(NSString*)pid content:(NSString*)content success:(void (^)(id data))success failure:(void (^)(id data))failure{
    NSDictionary *parameters = @{
                                 @"act":@"2007",
                                 @"id":pid,
                                 @"authorid":[YRUserInfoManager manager].currentUser.custId ? [YRUserInfoManager manager].currentUser.custId :@"",
                                 @"content":content
                                 };
    
    [YRNetworkController postRequestUrlStr:kPoductAddComment withDic:parameters success:^(NSDictionary *requestDic) {
        success(requestDic);
    } failure:^(NSString *errorInfo) {
        failure(errorInfo);
    }];
    
}
/**
 *  @author yichao, 16-08-22 14:08:26
 *
 *  评论回复
 *
 *  @param pid     作品id
 *  @param content 回复内容
 *  @param replyBy 评论信息id
 *  @param replyId 回复人
 *  @param success <#success description#>
 *  @param failure <#failure description#>
 */
+(void)poductCommentReply:(NSString*)pid content:(NSString*)content replyBy:(NSString*)replyBy  replyId:(NSString*)replyId  success:(void (^)(id data))success failure:(void (^)(id data))failure{
    NSDictionary *parameters = @{
                                 @"act":@"2007",
                                 @"id":pid,
                                 @"authorid":[YRUserInfoManager manager].currentUser.custId ? [YRUserInfoManager manager].currentUser.custId :@"",
                                 @"content":content,
                                 @"replyBy":replyBy,
                                 @"replyId":replyId,
                                 };
    
    [YRNetworkController postRequestUrlStr:kPoductAddComment withDic:parameters success:^(NSDictionary *requestDic) {
        success(requestDic);
    } failure:^(NSString *errorInfo) {
        failure(errorInfo);
    }];
    
}


/**
 *  @author yichao, 16-08-22 13:08:50
 *
 *  作品点赞列表
 *
 *  @param pid     <#pid description#>
 *  @param success <#success description#>
 *  @param failure <#failure description#>
 */
+(void)productLikeList:(NSString*)pid start:(NSInteger)start limit:(NSInteger)limit success:(void (^)(id data))success failure:(void (^)(id data))failure{
    
    NSDictionary *parameters = @{
                                 @"act":@(2012),
                                 @"infoId":pid,
                                 @"custId":[YRUserInfoManager manager].currentUser.custId ? [YRUserInfoManager manager].currentUser.custId :@"",
                                 @"start":@(start),
                                 @"limit":@(limit)
                                 };
    
    [YRNetworkController postRequestUrlStr:kPoductLikeList withDic:parameters success:^(NSDictionary *requestDic) {
        success(requestDic);
    } failure:^(NSString *errorInfo) {
        failure(errorInfo);
    }];
}

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
+(void)productTranList:(NSString*)pid start:(NSInteger)start limit:(NSInteger)limit success:(void (^)(id data))success failure:(void (^)(id data))failure{
    NSDictionary *parameters = @{
                                 @"act":@"2028",
                                 @"id":pid,
                                 @"start":@(start),
                                 @"limit":@(limit),
                                 @"authorid":[YRUserInfoManager manager].currentUser.custId ? [YRUserInfoManager manager].currentUser.custId :@"",
                                 };
    
    [YRNetworkController postRequestUrlStr:kProductTranList withDic:parameters success:^(NSDictionary *requestDic) {
        success(requestDic);
    } failure:^(NSString *errorInfo) {
        failure(errorInfo);
    }];
}
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
+(void)productAddLikeAndUnLike:(NSString*)pid like:(NSInteger)like success:(void (^)(id data))success failure:(void (^)(id data))failure{
    NSDictionary *parameters = @{
                                 @"act":@"2011",
                                 @"infoId":pid,
                                 @"custId":[YRUserInfoManager manager].currentUser.custId ? [YRUserInfoManager manager].currentUser.custId  : @"",
                                 @"like" : @(like)
                                 };
    
    [YRNetworkController postRequestUrlStr:kProductLikeAndUnLike withDic:parameters success:^(NSDictionary *requestDic) {
        success(requestDic);
    } failure:^(NSString *errorInfo) {
        failure(errorInfo);
    }];
}

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
+(void)productAddCollect:(NSString*)pid like:(NSInteger)collect success:(void (^)(id data))success failure:(void (^)(id data))failure{
    NSDictionary *parameters = @{
                                 @"act":@"2013",
                                 @"infoId":pid,
                                 @"custId":[YRUserInfoManager manager].currentUser.custId,
                                 @"collect" : @(collect)
                                 };
    
    [YRNetworkController postRequestUrlStr:kProudctAddCollect withDic:parameters success:^(NSDictionary *requestDic) {
        success(requestDic);
    } failure:^(NSString *errorInfo) {
        failure(errorInfo);
    }];
}

/**
 *  @author yichao, 16-08-22 16:08:33
 *
 *  作品评论删除
 *
 *  @param uid     评论id
 *  @param success <#success description#>
 *  @param failure <#failure description#>
 */
+(void)productDeleteComment:(NSString*)uid success:(void (^)(id data))success failure:(void (^)(id data))failure{
    NSDictionary *parameters = @{
                                 @"act":@"2010",
                                 @"authorid":[YRUserInfoManager manager].currentUser.custId,
                                 @"id":uid,
                                 };
    
    [YRNetworkController postRequestUrlStr:kProductDeleteComment withDic:parameters success:^(NSDictionary *requestDic) {
        success(requestDic);
    } failure:^(NSString *errorInfo) {
        failure(errorInfo);
    }];
}


#pragma mark 圈子

/**
 *  @author weishibo, 16-08-23 10:08:31
 *
 *  圈子列表
 *
 *  @param type    0全部 1好友 2关注
 *  @param maxId   最新id标记
 *  @param start
 *  @param limit   <#limit description#>
 *  @param success <#success description#>
 *  @param failure <#failure description#>
 */
+(void)circleList:(FriendsType)type   maxId:(NSString*)maxId  start:(NSInteger)start limit:(NSInteger)limit success:(void (^)(id data))success failure:(void (^)(id data))failure{
    
    NSDictionary *parameters = @{
                                 @"act":@"2014",
                                 @"type":@(type),
                                 @"maxId":maxId,
                                 @"start":@(start),
                                 @"limit":@(limit),
                                 @"userId":[YRUserInfoManager manager].currentUser.custId ? [YRUserInfoManager manager].currentUser.custId : @"",
                                 };
    
    [YRNetworkController postRequestUrlStr:kCircleList withDic:parameters success:^(NSDictionary *requestDic) {
        success(requestDic);
    } failure:^(NSString *errorInfo) {
        failure(errorInfo);
    }];
}


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
+(void)circleCommentList:(NSString*)cid  start:(NSInteger)start limit:(NSInteger)limit success:(void (^)(id data))success failure:(void (^)(id data))failure{
    
    NSDictionary *parameters = @{
                                 @"act":@"2020",
                                 @"id":cid,
                                 @"authorid":[YRUserInfoManager manager].currentUser.custId ? [YRUserInfoManager manager].currentUser.custId : @"",
                                 @"start":@(start),
                                 @"limit":@(limit)
                                 };
    
    [YRNetworkController postRequestUrlStr:KCircleCommentList withDic:parameters success:^(NSDictionary *requestDic) {
        success(requestDic);
    } failure:^(NSString *errorInfo) {
        failure(errorInfo);
    }];
}

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

+(void)circleLikeList:(NSString*)cid  start:(NSInteger)start limit:(NSInteger)limit success:(void (^)(id data))success failure:(void (^)(id data))failure{
    
    NSDictionary *parameters = @{
                                 @"act":@"2026",
                                 @"id":cid,
                                 @"authorid":[YRUserInfoManager manager].currentUser.custId ? [YRUserInfoManager manager].currentUser.custId : @"",
                                 @"start":@(start),
                                 @"limit":@(limit)
                                 };
    
    [YRNetworkController postRequestUrlStr:KCircleLikeList withDic:parameters success:^(NSDictionary *requestDic) {
        success(requestDic);
    } failure:^(NSString *errorInfo) {
        failure(errorInfo);
    }];
}


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
+(void)circleTranList:(NSString*)cid  start:(NSInteger)start limit:(NSInteger)limit success:(void (^)(id data))success failure:(void (^)(id data))failure{
    
    NSDictionary *parameters = @{
                                 @"act":@"2025",
                                 @"id":cid,
                                 @"authorid":[YRUserInfoManager manager].currentUser.custId ? [YRUserInfoManager manager].currentUser.custId : @"",
                                 @"start":@(start),
                                 @"limit":@(limit)
                                 };
    
    [YRNetworkController postRequestUrlStr:kCircleTranList withDic:parameters success:^(NSDictionary *requestDic) {
        success(requestDic);
    } failure:^(NSString *errorInfo) {
        failure(errorInfo);
    }];
}

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

+(void)circleAddLikeAndUnLike:(NSString*)pid like:(NSInteger)like success:(void (^)(id data))success failure:(void (^)(id data))failure{
    NSDictionary *parameters = @{
                                 @"act":@"2029",
                                 @"id":pid,
                                 @"authorid":[YRUserInfoManager manager].currentUser.custId,
                                 @"like" : @(like)
                                 };
    
    [YRNetworkController postRequestUrlStr:kCircleAddLike withDic:parameters success:^(NSDictionary *requestDic) {
        success(requestDic);
    } failure:^(NSString *errorInfo) {
        failure(errorInfo);
    }];
}
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

+(void)circleAddCollect:(NSString*)pid like:(NSInteger)collect success:(void (^)(id data))success failure:(void (^)(id data))failure{
    NSDictionary *parameters = @{
                                 @"act":@"2030",
                                 @"id":pid,
                                 @"authorid":[YRUserInfoManager manager].currentUser.custId,
                                 @"collect" : @(collect)
                                 };
    
    [YRNetworkController postRequestUrlStr:kCircleAddCollect withDic:parameters success:^(NSDictionary *requestDic) {
        success(requestDic);
    } failure:^(NSString *errorInfo) {
        failure(errorInfo);
    }];
}

/**
 *  @author weishibo, 16-08-24 20:08:43
 *
 *  圈子评论删除
 *
 *  @param uid     <#uid description#>
 *  @param success <#success description#>
 *  @param failure <#failure description#>
 */
+(void)circleDeleteComment:(NSString*)uid success:(void (^)(id data))success failure:(void (^)(id data))failure{
    NSDictionary *parameters = @{
                                 @"act":@"2024",
                                 @"id":uid,
                                 @"authorid":[YRUserInfoManager manager].currentUser.custId,
                                 };
    
    [YRNetworkController postRequestUrlStr:kCircleDeleteComment withDic:parameters success:^(NSDictionary *requestDic) {
        success(requestDic);
    } failure:^(NSString *errorInfo) {
        failure(errorInfo);
    }];
}

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
+(void)circleAddComment:(NSString*)pid content:(NSString*)content success:(void (^)(id data))success failure:(void (^)(id data))failure{
    NSDictionary *parameters = @{
                                 @"act":@"2022",
                                 @"id":pid,
                                 @"authorid":[YRUserInfoManager manager].currentUser.custId ? [YRUserInfoManager manager].currentUser.custId :@"",
                                 @"content":content
                                 };
    
    [YRNetworkController postRequestUrlStr:kCircleAddComment withDic:parameters success:^(NSDictionary *requestDic) {
        success(requestDic);
    } failure:^(NSString *errorInfo) {
        failure(errorInfo);
    }];
    
}


+(void)circleCommentReply:(NSString*)pid content:(NSString*)content replyBy:(NSString*)replyBy  replyId:(NSString*)replyId  success:(void (^)(id data))success failure:(void (^)(id data))failure{
    NSDictionary *parameters = @{
                                 @"act":@"2007",
                                 @"id":pid,
                                 @"authorid":[YRUserInfoManager manager].currentUser.custId ? [YRUserInfoManager manager].currentUser.custId :@"",
                                 @"content":content,
                                 @"replyBy":replyBy,
                                 @"replyId":replyId,
                                 };
    
    [YRNetworkController postRequestUrlStr:kCircleReplyComment withDic:parameters success:^(NSDictionary *requestDic) {
        success(requestDic);
    } failure:^(NSString *errorInfo) {
        failure(errorInfo);
    }];
    
}

#pragma mark 红包打赏

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
+(void)rewardObjList:(NSInteger)rewardType pid:(NSString*)pid pageNumber:(NSInteger)pageNumber  pageSize:(NSInteger)pageSize  success:(void (^)(id data))success failure:(void (^)(id data))failure{

    NSDictionary *parameters = @{
                                 @"act":@(4002),
                                 @"infoId":pid,
                                 @"type":@(rewardType),
                                 @"start":@(pageNumber),
                                 @"limit":@(pageSize),
                                 };

    
    
    [YRNetworkController postRequestUrlStr:kRewardObjList withDic:parameters success:^(NSDictionary *requestDic) {
        success(requestDic);
    } failure:^(NSString *errorInfo) {
        failure(errorInfo);
    }];
}


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
+(void)rewardGiftList:(NSInteger)pageNow  pageSize:(NSInteger)pageSize  success:(void (^)(id data))success failure:(void (^)(id data))failure{
    
    NSDictionary *parameters = @{
                                 @"act":@(4003),
                                 @"pageNow":@(pageNow),
                                 @"pageSize":@(pageSize),
                                 };
    
    [YRNetworkController postRequestUrlStr:KRegardGiftList withDic:parameters success:^(NSDictionary *requestDic) {
        success(requestDic);
    } failure:^(NSString *errorInfo) {
        failure(errorInfo);
    }];
}
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
+(void)sendReward:(NSString*)giftid touserid:(NSString*)touserid type:(NSInteger)type pid:(NSString*)pid giftNum:(NSInteger)giftNum success:(void (^)(id data))success failure:(void (^)(id data))failure{
    
    NSDictionary *parameters = @{
                                 @"act":@(4001),
                                 @"giftid":giftid,
                                 @"touserid":touserid,
                                 @"type":@(type),
                                 @"id":pid,
                                 @"giftNum":@(giftNum)
                                 };
    [YRNetworkController postRequestUrlStr:kSendRegardGift withDic:parameters success:^(NSDictionary *requestDic) {
        success(requestDic);
    } failure:^(NSString *errorInfo) {
        failure(errorInfo);
    }];
}
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

+(void)receiveRedList:(NSInteger)rewardType pageNumber:(NSInteger)pageNumber  pageSize:(NSInteger)pageSize  success:(void (^)(id data))success failure:(void (^)(id data))failure{
    
    NSDictionary *parameters = @{
                                 @"act":@(5001),
                                 @"custId":[YRUserInfoManager manager].currentUser.custId ? [YRUserInfoManager manager].currentUser.custId :@"",
                                 @"type":@(rewardType),
                                 @"start":@(pageNumber),
                                 @"limit":@(pageSize),
                                 };
    

    [YRNetworkController postRequestUrlStr:kReceiveRedList withDic:parameters success:^(NSDictionary *requestDic) {
        success(requestDic);
    } failure:^(NSString *errorInfo) {
        failure(errorInfo);
    }];
}

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
+(void)sendRedList:(NSInteger)rewardType  pageNumber:(NSInteger)pageNumber  pageSize:(NSInteger)pageSize  success:(void (^)(id data))success failure:(void (^)(id data))failure{
    
    NSDictionary *parameters = @{
                                 @"act":@(5001),
                                 @"custId":[YRUserInfoManager manager].currentUser.custId ? [YRUserInfoManager manager].currentUser.custId :@"",
                                 @"type":@(rewardType),
                                 @"start":@(pageNumber),
                                 @"limit":@(pageSize),
                                 };
    
    
    [YRNetworkController postRequestUrlStr:kSendRedList withDic:parameters success:^(NSDictionary *requestDic) {
        success(requestDic);
    } failure:^(NSString *errorInfo) {
        failure(errorInfo);
    }];
}
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
+(void)openRed:(NSString*)redID friendStatus:(NSInteger)friendStatus success:(void (^)(id data))success failure:(void (^)(id data))failure{
    NSDictionary *parameters = @{
                                 @"act":@(5003),
                                 @"custId":[YRUserInfoManager manager].currentUser.custId ? [YRUserInfoManager manager].currentUser.custId :@"",
                                 @"redpacketId":redID,
                                 @"friendStatus":@(friendStatus)
                                 };
    
    
    [YRNetworkController postRequestUrlStr:kOpenRed withDic:parameters success:^(NSDictionary *requestDic) {
        success(requestDic);
    } failure:^(NSString *errorInfo) {
        failure(errorInfo);
    }];
}

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
+(void)getRedDetail:(NSString*)redID  pageNumber:(NSInteger)pageNumber  pageSize:(NSInteger)pageSize  success:(void (^)(id data))success failure:(void (^)(id data))failure{
    NSDictionary *parameters = @{
                                 @"act":@(5003),
                                 @"custId":[YRUserInfoManager manager].currentUser.custId ? [YRUserInfoManager manager].currentUser.custId :@"",
                                 @"start":@(pageNumber),
                                 @"limit":@(pageSize),
                                 @"redpacketId" : redID
                                 };
    
    
    [YRNetworkController postRequestUrlStr:kGetRedDetail withDic:parameters success:^(NSDictionary *requestDic) {
        success(requestDic);
    } failure:^(NSString *errorInfo) {
        failure(errorInfo);
    }];
}
/**
 *  @author weishibo, 16-08-26 15:08:36
 *
 *  抢红包
 *
 *  @param redID   <#redID description#>
 *  @param success <#success description#>
 *  @param failure <#failure description#>
 */
+(void)robRed:(NSString*)redID  success:(void (^)(id data))success failure:(void (^)(id data))failure{
    NSDictionary *parameters = @{
                                 @"act":@(5003),
                                 @"custId":[YRUserInfoManager manager].currentUser.custId ? [YRUserInfoManager manager].currentUser.custId :@"",
                                 @"redpacketId" : redID
                                 };
    
    
    [YRNetworkController postRequestUrlStr:kRobRed withDic:parameters success:^(NSDictionary *requestDic) {
        success(requestDic);
    } failure:^(NSString *errorInfo) {
        failure(errorInfo);
    }];
}
@end