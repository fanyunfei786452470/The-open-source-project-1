//
//  YRHttpRequest.m
//  YRYZ
//
//  Created by weishibo on 16/7/11.
//  Copyright © 2016年 yryz. All rights reserved.
//

#import "YRHttpRequest.h"
#import "YRNetworkController.h"
#import "AppDelegate.h"
#import "AFHTTPSessionManager.h"
#import "AFNetworkActivityIndicatorManager.h"
#import "YRYYCache.h"
#import <CommonCrypto/CommonCryptor.h>
#import "YRDES.h"
@implementation YRHttpRequest

#pragma mark - 请求接口
+(void)homeBannerListsuccess:(void (^)(id data))success failure:(void (^)(NSString *errorInfo))failure{
    NSDictionary *parameters = @{
                                 @"act":@(9002),
                                 @"type":@"1"
                                 };
    [YRNetworkController postRequestUrlStr:kHomeBannerList withDic:parameters success:^(NSDictionary *requestDic) {
        success(requestDic);
    } failure:^(NSString *errorInfo) {
        failure(errorInfo);
    }];
//    [YRNetworkController postRequestWithCacheUrlStr:kHomeBannerList withDic:parameters cacheKey:nil success:^(NSDictionary *requestDic) {
//        success(requestDic);
//    } failure:^(NSString *errorInfo) {
//        failure(errorInfo);
//    }];
}

#pragma mark - 首页
/**
 *  @author 21.5
 *  圈子公告
 *
 *  @param act <#pageNumber description#>
 *  @param start   <#pageSize description#>
 *  @param limit    <#success description#>
 */
+ (void)getCircleNoticeListstart:(NSInteger)start limit:(NSInteger)limit success:(void (^)(id data))success failure:(void (^)(id data))failure{
    NSDictionary * parameters = @{
                                  @"act":@"9003",
                                  @"start":@(start),
                                  @"limit":@(limit),
                                  };
    [YRNetworkController postRequestUrlStr:KCirclEannouncement withDic:parameters success:^(NSDictionary *requestDic) {
        success(requestDic);
    } failure:^(NSString *errorInfo) {
        failure(errorInfo);
    }];

}
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
+(void)getProductTypeSaveByCustUserId:(NSString *)uid Tags:(NSArray *)tags Title:(NSString *)title InfoIntroduction:(NSString *)infoIntroduction InfoThumbnail:(NSString *)infoThumbnail Content:(NSString *)content Type:(int)type InfoCategor:(NSString *)infoCategor Urls:(NSString *)urls Info_time:(NSString *)info_time success:(void (^)(NSDictionary *data))success failure:(void (^)(NSString *errorInfo))failure{
    
    NSDictionary *parameters = @{
                                 @"act":@"2002",
                                 @"custId":[YRUserInfoManager manager].currentUser.custId ? [YRUserInfoManager manager].currentUser.custId : @"",
                                 @"title":title?title:@"",
                                 @"infoIntroduction" :infoIntroduction?infoIntroduction:@"",
                                 @"infoThumbnail":infoThumbnail?infoThumbnail:@"",
                                 @"content":content?content:@"",
                                 @"type" :@(type),
                                 @"urls" :urls?urls:@"",
                                 @"infoCategory" :infoCategor?infoCategor:@"",
                                 @"infoTime": info_time?info_time:@"",
                                 };
    
    [YRNetworkController postRequestUrlStr:kProductTypeSave withDic:parameters success:^(NSDictionary *requestDic) {
        
        success(requestDic);
    } failure:^(NSString *errorInfo) {
        
        failure(errorInfo);
    }];
    
}
/*!
 *  @author a21.5, 16-09-21 09:09:16
 *
 *  @brief 图文发布
 *
 *  @return <#return value description#>
 *
 *  @since <#version number#>
 */
+(void)getImageTextTypeSaveByCustUserId:(NSString *)uid Tags:(NSArray *)tags Title:(NSString *)title Content:(NSString *)content Type:(int)type  InfoIntroduction:(NSString *)infoIntroduction InfoThumbnail:(NSString *)infoThumbnail InfoCategor:(NSString *)infoCategor Urls:(NSString *)urls success:(void (^)(NSDictionary *data))success failure:(void (^)(NSString *errorInfo))failure{
    
    
    NSDictionary *parameters = @{
                                 @"custId":[YRUserInfoManager manager].currentUser.custId ? [YRUserInfoManager manager].currentUser.custId : @"",
                                 @"tags":tags?[tags mj_JSONString]:@"",
                                 @"title":title?title:@"",
                                 @"infoIntroduction" :infoIntroduction?infoIntroduction:@"",
                                 @"infoThumbnail":infoThumbnail?infoThumbnail:@"",
                                 @"type" :@(type),
                                 @"urls" :urls?urls:@"",
                                 @"infoCategory" :infoCategor?infoCategor:@"",
                                 @"act":@"2002",
                                 @"content":content?content:@""
                                 };
    
    [YRNetworkController postRequestUrlStr:kProductTypeSave withDic:parameters success:^(NSDictionary *requestDic) {
        
        success(requestDic);
    } failure:^(NSString *errorInfo) {
        
        failure(errorInfo);
    }];
    
}
/*!
 *  @author a21.5, 16-09-07 12:09:33
 *
 *  作品标签
 *  @param tpye     文件类型
 *
 */

+ (void)getProductTagsType:(int)type Act:(int)act success:(void (^)(NSDictionary *data))success failure:(void (^)(NSString *errorInfo))failure{

    NSDictionary *parameters = @{
                                 @"type" :@(type),
                                 @"act":act?[NSString stringWithFormat:@"%d",act]:@""
                                 };
    
    [YRNetworkController postRequestUrlStr:KProductTypeTag withDic:parameters success:^(NSDictionary *requestDic) {
        
        success(requestDic);
    } failure:^(NSString *errorInfo) {
        
        failure(errorInfo);
    }];

}

/*!
 *  @author a21.5, 16-09-09 11:09:10
 *
 *  @brief 红包广告列表
 
 *  @param act     接口编号
 *  @param adsType 广告类型 0 ：全部 1 ：最热
 *  @param start   起始位置
 *  @param limit   页面示数
 */

+ (void)getRedPacketAdsListAdsType:(NSInteger)adsType Start:(NSInteger)start Limit:(NSInteger)limit success:(void (^)(NSDictionary *data))success failure:(void (^)(NSString *errorInfo))failure{

    NSDictionary * parameters = @{
                                  @"act":@"6006",
                                  @"start":@(start),
                                  @"limit":@(limit),
                                  @"adsType":@(adsType),
                                @"custId"     : [YRUserInfoManager manager].currentUser.custId ? [YRUserInfoManager manager].currentUser.custId  : @""
                                  };
    [YRNetworkController postRequestUrlStr:kRedPacketAdsList withDic:parameters success:^(NSDictionary *requestDic) {
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
+(void)getPastTheLotteryInformationByStart:(NSInteger )start  limit:(NSInteger)limit  success:(void (^)(NSDictionary *data))success failure:(void (^)(NSString *eCorrorInfo))failure{
    
    NSDictionary *parameters = @{
                                 @"act":@"7002",
                                 @"start":@(start),
                                 @"limit":@(limit),
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
                                 @"custId":[YRUserInfoManager manager].currentUser.custId ? [YRUserInfoManager manager].currentUser.custId : @""
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
                                 @"custId":[YRUserInfoManager manager].currentUser.custId ? [YRUserInfoManager manager].currentUser.custId : @"",
                                 @"content":content?content:@"",
                                 @"pics":pics?[pics mj_JSONString]:@"",
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
                                 @"custId":[YRUserInfoManager manager].currentUser.custId ? [YRUserInfoManager manager].currentUser.custId : @"",
                                 @"fid":uid?uid:@"",
                                 @"limit":@(limit),
                                 @"time":time,
                                 @"act":@"3003"
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
+(void)getFriendsCircleListFeedsByCustLimit:(NSInteger)limit Page:(int)page success:(void (^)(id data))success
                                failure:(void (^)(NSString *errorInfo))failure{
    
    NSDictionary *parameters = @{
                                 @"custId":[YRUserInfoManager manager].currentUser.custId ? [YRUserInfoManager manager].currentUser.custId : @"",
                                 @"limit":@(limit),
                                 @"start":@(page),
                                 @"act":@"3003"
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
                                 @"custId":[YRUserInfoManager manager].currentUser.custId ? [YRUserInfoManager manager].currentUser.custId : @"",
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
                                 @"custId":[YRUserInfoManager manager].currentUser.custId ? [YRUserInfoManager manager].currentUser.custId : @"",
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

                                 @"custId":[YRUserInfoManager manager].currentUser.custId ? [YRUserInfoManager manager].currentUser.custId : @"",
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
                                 @"custId":[YRUserInfoManager manager].currentUser.custId ? [YRUserInfoManager manager].currentUser.custId : @"",
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
                                 @"custId":[YRUserInfoManager manager].currentUser.custId ? [YRUserInfoManager manager].currentUser.custId : @"",
                                 @"sid":@(sid),
                                 @"authorCustId":authorUid?authorUid:@"",
                                 @"content":content?content:@"",
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
                                 @"custId":[YRUserInfoManager manager].currentUser.custId ? [YRUserInfoManager manager].currentUser.custId : @"",
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
                                 @"custId":[YRUserInfoManager manager].currentUser.custId ? [YRUserInfoManager manager].currentUser.custId : @"",
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
                                 @"phone" :accout?accout:@"",
                                 @"password"   :password?password.YCmd5String:@"",
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
                                 @"openId" :openId?openId:@"",
                                 @"accessToken": accessToken?accessToken:@"",
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
                                 @"phone" :custPhone?custPhone:@"",
                                 @"type" :@1,
                                 @"code" :type?@(type):@"",
                                 @"act":@"1001"
                                 };
    [YRNetworkController postRequestUrlStr:kShortMessage withDic:parameters success:^(NSDictionary *requestDic) {
        success(requestDic);
    } failure:^(NSString *errorInfo) {
        failure(errorInfo);
    }];
}
/**
 * @author Sean, 16-09-09 14:09:22
 *
 * 忘记密码
 *
 * @param custPhone <#custPhone description#>
 * @param success   <#success description#>
 * @param failure   <#failure description#>
 */
+(void)whetherToChangeThePassword:(NSString *)custPhone  success:(void (^)(NSDictionary *))success  failure:(void (^)(NSString *))failure{
    NSDictionary *parameters = @{
                                 @"phone" :custPhone?custPhone:@"",
                                 @"type" :@1,
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
                                 @"phone" :phone?phone:@"",
                                 @"password" :password?password.YCmd5String:@"",
                                 @"veriCode" :phoneCode?phoneCode:@"",
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
                                 @"custId":[YRUserInfoManager manager].currentUser.custId ? [YRUserInfoManager manager].currentUser.custId  : @"",
                                 @"password":password?password.YCmd5String:@"",
                                 @"newPassword":newPassword?newPassword.YCmd5String:@"",
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
                                 @"custId":[YRUserInfoManager manager].currentUser.custId ? [YRUserInfoManager manager].currentUser.custId  : @"",
                                 @"payPassword":newPayPassword?newPayPassword.YCmd5String:@"",
                                 @"oldPayPassword":oldPayPassword?oldPayPassword.YCmd5String:@"",
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
                                 @"phone"       : custPhone?custPhone:@"",
                                 @"password"    : password?password.YCmd5String:@"",
                                 @"veriCode"   : phoneCode?phoneCode:@"",
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
                                 @"custId"     : [YRUserInfoManager manager].currentUser.custId ? [YRUserInfoManager manager].currentUser.custId  : @"",
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
                                 @"custId"     : [YRUserInfoManager manager].currentUser.custId ? [YRUserInfoManager manager].currentUser.custId  : @"",
                                 name?name:@""  :value?value:@"",
                                 @"act":@"1011"
                                 };
    
    [YRNetworkController postRequestUrlStr:kChangeInformation withDic:parameters success:^(NSDictionary *requestDic) {
        
        success(requestDic);
        
        
    } failure:^(NSString *errorInfo) {
        
        failure(errorInfo);
    }];
    
}
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
+ (void)setUpFriendsRemarkByFriendID:(NSString *)fid  meomo:(NSString *)meomo  success:(void (^)(NSDictionary *data))success failure:(void (^)(NSString *error))failure{
    
    NSDictionary *parameters = @{
                                 @"custId"     : [YRUserInfoManager manager].currentUser.custId ? [YRUserInfoManager manager].currentUser.custId  : @"",
                                 @"meomo"       :meomo?meomo:@"",
                                 @"act":@"1016",
                                 @"fid":fid?fid:@""
                                 };
    
    [YRNetworkController postRequestUrlStr:kChangeFriendName withDic:parameters success:^(NSDictionary *requestDic) {
        
        success(requestDic);
    } failure:^(NSString *errorInfo) {
        failure(errorInfo);
    }];
}
/**
 * @author Sean, 16-09-13 17:09:19
 *
 * 举报作品和好友
 *
 * @param type     <#type description#>
 * @param sourceId <#sourceId description#>
 * @param content  <#content description#>
 * @param success  <#success description#>
 * @param failure  <#failure description#>
 */
+ (void)reportWorksAndPeopleByType:(NSInteger )type sourceId:(NSString *)sourceId   content:(NSString *)content  success:(void (^)(NSDictionary *data))success failure:(void (^)(NSString *error))failure{
    
    NSDictionary *parameters = @{
                                 @"sourceId"       :sourceId?sourceId:@"",
                                 @"custId"         : [YRUserInfoManager manager].currentUser.custId ? [YRUserInfoManager manager].currentUser.custId  : @"",
                                 @"act"            :@"1012",
                                 @"content"        :content?content:@"",
                                 @"type"           :@(type)
                                 };
    
    [YRNetworkController postRequestUrlStr:kReportWorkAndPeople withDic:parameters success:^(NSDictionary *requestDic) {
        
        success(requestDic);
    } failure:^(NSString *errorInfo) {
        failure(errorInfo);
    }];
}
/**
 * @author Sean, 16-08-30 18:08:34
 *
 * 获取相关信息   圈子  转发  晒一晒 红包广告
 *  个人圈子转发列表   圈子列表
 * @param type    <#type description#>
 * @param start   <#start description#>
 * @param limin   <#limin description#>
 * @param success <#success description#>
 * @param failure <#failure description#>
 */
+ (void)getForMyFnformationByWhatType:(MineInformation)type  start:(NSString *)start limin:(NSString *)limin custId:(NSString *)custId   success:(void (^)(NSDictionary *data))success failure:(void (^)(NSString *error))failure{
    
    
    NSDictionary *parameters = @{
                                 @"act" :@"2106",
                                 @"start"  : start?start:@"",
                                 @"limit"  :limin?limin:@"",
                                 @"custId" : custId?custId:@"",
                                 @"loginUserId" :  [YRUserInfoManager manager].currentUser.custId ? [YRUserInfoManager manager].currentUser.custId  : @""
                                 };
[YRNetworkController postRequestUrlStr:kCircleUserTranList withDic:parameters  success:^(NSDictionary *requestDic) {
         success(requestDic);
    } failure:^(NSString *errorInfo) {
        failure(errorInfo);
    }];
}

/**
 * @author Sean, 16-09-13 18:09:15
 *
 * 获取用户转发统计
 *
 * @param success <#success description#>
 * @param failure <#failure description#>
 */
+ (void)getkUserForwardMoneyCustId:(NSString *)custId success:(void (^)(NSDictionary *data))success failure:(void (^)(NSString *error))failure{
    NSDictionary *parameters = @{
                                 @"act" :@"2117",
                                 @"custId" :custId?custId:@""
                                 };
    [YRNetworkController postRequestUrlStr:kUserForwardMoney withDic:parameters  success:^(NSDictionary *requestDic) {
        success(requestDic);
    } failure:^(NSString *errorInfo) {
        failure(errorInfo);
    }];
}
/**
 *
 * @author 21.5,
 *
 *  圈子收益统计
 *
 *
 **/
+(void)getFriendsCircleEarningStatisticscustId:(NSString *)custId clubId:(NSString *)clubId success:(void (^)(NSDictionary *data))success failure:(void (^)(NSString *eCorrorInfo))failure{
    NSDictionary * parameters = @{
                                  @"act":@"2118",
                                  @"custId":custId?custId:@"",
                                  @"clubId":clubId?clubId:@"",
                                  @"loginUserId":[YRUserInfoManager manager].currentUser.custId?[YRUserInfoManager manager].currentUser.custId:@"",
                                  };
    [YRNetworkController postRequestUrlStr:KCircleEarningStatistics withDic:parameters success:^(NSDictionary *requestDic) {
        success(requestDic);
    } failure:^(NSString *errorInfo) {
        failure(errorInfo);
    }];
}
/**
 * @author Sean, 16-09-06 15:09:47
 *
 * 原创作品列表
 *
 * @param start   <#start description#>
 * @param limit   <#limit description#>
 * @param success <#success description#>
 * @param failure <#failure description#>
 */
+ (void)listOfWorksForStart:(NSString *)start limit:(NSString *)limit  custId:(NSString *)custId success:(void (^)(NSDictionary *data))success failure:(void (^)(NSString *error))failure{
    
    NSDictionary *parameters = @{
                                 @"act" :@"2003",
                                 @"start"  : start?start:@"",
                                 @"limit"  :limit?limit:@"",
                                 @"custId" : custId?custId:@"",
                                 @"loginUserId" : [YRUserInfoManager manager].currentUser.custId?[YRUserInfoManager manager].currentUser.custId:@"",
                                 };
[YRNetworkController postRequestUrlStr:kProductList withDic:parameters success:^(NSDictionary *requestDic) {
        success(requestDic);
    } failure:^(NSString *errorInfo) {
        failure(errorInfo);
    }];
}
/**
 * @author Sean, 16-09-06 15:09:46
 *
 * 晒一晒列表
 *
 * @param start   <#start description#>
 * @param limit   <#limit description#>
 * @param success <#success description#>
 * @param failure <#failure description#>
 */
+ (void)baskInTheSunListForSid:(NSString *)sid limit:(NSString *)limit  custId:(NSString *)custId  success:(void (^)(NSDictionary *data))success failure:(void (^)(NSString *error))failure{
    
    NSDictionary *parameters = @{
                                 @"act" :@"3003",
                                 @"sid"  : sid?sid:@"",
                                 @"fid" : custId?custId:@"",
                                 @"limit"  :limit?limit:@"",
                                 @"custId" : [YRUserInfoManager manager].currentUser.custId?[YRUserInfoManager manager].currentUser.custId:@"",
                                 };
    [YRNetworkController postRequestUrlStr:kFriendsCircleList withDic:parameters success:^(NSDictionary *requestDic) {
        success(requestDic);
    } failure:^(NSString *errorInfo) {
        failure(errorInfo);
    }];
}
/**
 * @author Sean, 16-09-13 10:09:23
 *
 * 我的红包广告列表
 *
 * @param adsType <#adsType description#>
 * @param satrt   <#satrt description#>
 * @param limit   <#limit description#>
 * @param success <#success description#>
 * @param failure <#failure description#>
 */
+ (void)getMineRedPadingListToadsType:(NSString *)adsType start:(NSInteger)satrt limit:(NSInteger)limit  success:(void (^)(NSDictionary *data))success failure:(void (^)(NSString *error))failure{
    NSDictionary *parameters = @{
                                 @"custId"     : [YRUserInfoManager manager].currentUser.custId ? [YRUserInfoManager manager].currentUser.custId  : @"",
                                 @"act"        :  @"6005",
                                 @"adsType"    :  adsType?adsType:@"",
                                 @"start"      :  @(satrt),
                                 @"limit"      :  @(limit)
                                 };
    [YRNetworkController postRequestUrlStr:kMineRedAds withDic:parameters success:^(NSDictionary *requestDic) {
        success(requestDic);
    } failure:^(NSString *errorInfo) {
        failure(errorInfo);
    }];
}
/**
 * @author Sean, 16-09-14 14:09:44
 *
 * 广告申请退款
 *
 * @param AdsId   <#AdsId description#>
 * @param success <#success description#>
 * @param failure <#failure description#>
 */
+ (void)backMoneyForAdsId:(NSString *)AdsId success:(void (^)(NSDictionary *data))success failure:(void (^)(NSString *error))failure{
    
    NSDictionary *parameters = @{
                                 @"act" :@"6004",
                                 @"adsId" :AdsId?AdsId:@"",
                                 @"custId"     : [YRUserInfoManager manager].currentUser.custId ? [YRUserInfoManager manager].currentUser.custId  : @"",
                                 };
    [YRNetworkController postRequestUrlStr:kRedAdsBackMoney withDic:parameters success:^(NSDictionary *requestDic) {
        success(requestDic);
    } failure:^(NSString *errorInfo) {
        failure(errorInfo);
    }];
}
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
{
    NSDictionary *parameters = @{
                                 @"custId"     : [YRUserInfoManager manager].currentUser.custId ? [YRUserInfoManager manager].currentUser.custId  : @"",
                                 @"payDays"       :payDays?payDays:@"",
                                 @"wishUpDate" :@([wishUpDate integerValue]*1000),
                                 @"password" :password?password.YCmd5String:@"",
                                 @"packetType":packetType?packetType:@"",
                                 @"packetAmount":@(packetAmount),
                                 @"packetNum" :@(packetNum),
                                 @"act"   : @"6002",
                                 @"adsId" :adsId?adsId:@""
                                 };
    
    
    [YRNetworkController postRequestUrlStr:kReleaseAgain withDic:parameters success:^(NSDictionary *requestDic) {
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
+ (void)pointsToTheConsumerAccountByChangeTheAmount:(CGFloat)theAmount password:(NSString *)password  success:(void (^)(NSDictionary *data))success failure:(void (^)(NSString *error))failure{
    NSDictionary *parameters = @{
                                 @"custId"     : [YRUserInfoManager manager].currentUser.custId ? [YRUserInfoManager manager].currentUser.custId  : @"",
                                 @"cost"       :@(theAmount),
                                 @"act" :@"1056",
                                 @"password" :password?password.YCmd5String:@""
                                 };
    [YRNetworkController postRequestUrlStr:kToRedeem withDic:parameters success:^(NSDictionary *requestDic) {
        success(requestDic);
    } failure:^(NSString *errorInfo) {
        failure(errorInfo);
    }];
}
/**
 * @author Sean, 16-09-14 14:09:28
 *
 * 小额免密
 *
 * @param isSecret <#isSecret description#>
 * @param success  <#success description#>
 * @param failure  <#failure description#>
 */
+ (void)setSmallFreeByType:(BOOL)isSecret success:(void (^)(NSDictionary *data))success failure:(void (^)(NSString *error))failure{
    NSString *type = isSecret?@"1":@"0";
    NSDictionary *parameters = @{
                                 @"custId"     : [YRUserInfoManager manager].currentUser.custId ? [YRUserInfoManager manager].currentUser.custId  : @"",
                                 @"type"       :type?type:@"",
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
                                 @"custId"     : [YRUserInfoManager manager].currentUser.custId ? [YRUserInfoManager manager].currentUser.custId  : @"",
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
                                 @"custId"     : [YRUserInfoManager manager].currentUser.custId ? [YRUserInfoManager manager].currentUser.custId  : @"",
                                 @"type":name?name:@"",
                                 @"openId":openId?openId:@"",
                                 @"action":action?action:@"",
                                 @"accessToken" :accessToken?accessToken:@"",
                                 @"act":@"1012"
                                 };
    [YRNetworkController postRequestUrlStr:kBindAccount withDic:parameters success:^(NSDictionary *requestDic) {
        success(requestDic);
    } failure:^(NSString *errorInfo) {
        failure(errorInfo);
    }];
}
/**
 * @author Sean, 16-09-09 14:09:18
 *
 * 绑定手机号
 *
 * @param phoneNumber <#phoneNumber description#>
 * @param success     <#success description#>
 * @param failure     <#failure description#>
 */
+ (void)bindOtherAccountByThePhone:(NSString *)phoneNumber veriCode:(NSString *)veriCode password:(NSString *)password success:(void (^)(NSDictionary *))success failure:(void (^)(NSString *))failure{
    
    NSDictionary *parameters = @{
                                 @"custId"     : [YRUserInfoManager manager].currentUser.custId ? [YRUserInfoManager manager].currentUser.custId  : @"",
                                 @"phone"      : phoneNumber?phoneNumber:@"",
                                 @"veriCode"   :veriCode?veriCode:@"",
                                 @"act"        :@"1012",
                                 @"password"   :password?password.YCmd5String:@""
                                 };
    [YRNetworkController postRequestUrlStr:kBingPhone withDic:parameters success:^(NSDictionary *requestDic) {
        success(requestDic);
    } failure:^(NSString *errorInfo) {
        failure(errorInfo);
    }];
    
}

#pragma mark - 通讯录


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
                                 @"custId"     : [YRUserInfoManager manager].currentUser.custId ? [YRUserInfoManager manager].currentUser.custId  : @"",
                                 @"limit"   : limit?limit:@"",
                                 @"start"    :start?start:@"",
                                 @"act"     : @(1015)
                                 };
    [YRNetworkController postRequestUrlStr:kRegardMe withDic:parameters success:^(NSDictionary *requestDic) {
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
                                 @"token"     : [YRUserInfoManager manager].currentUser.token?[YRUserInfoManager manager].currentUser.token:@"",
                                 @"custId"     : [YRUserInfoManager manager].currentUser.custId ? [YRUserInfoManager manager].currentUser.custId  : @"",
                                 };
    
    [YRNetworkController postRequestUrlStr:kMyRegard withDic:parameters   success:^(NSDictionary *requestDic) {
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
                                 @"custId"     : [YRUserInfoManager manager].currentUser.custId ? [YRUserInfoManager manager].currentUser.custId  : @"",
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
                                 @"type"         : type?type:@"",
                                 @"fid"          : fid?fid:@"",
                                 @"action"       : actionType?actionType:@"",
                                 @"custId"       :[YRUserInfoManager manager].currentUser.custId ? [YRUserInfoManager manager].currentUser.custId  : @"",
                                 @"act"          : @"1016"
                                 };
    [YRNetworkController postRequestUrlStr:kFriendsOperation withDic:parameters success:^(NSDictionary *requestDic) {
        success(requestDic);
    } failure:^(NSString *errorInfo) {
        failure(errorInfo);
    }];
}
/**
 * @author Sean, 16-09-07 20:09:42
 *
 * 通过手机号添加好友
 *
 * @param phoneNumber <#phoneNumber description#>
 * @param success     <#success description#>
 * @param failure     <#failure description#>
 */
+ (void)addFriendFromPhoneNumber:(NSString *)phoneNumber success:(void (^)(NSDictionary *data))success failure:(void (^)(NSString *error))failure{
    NSDictionary *parameters = @{
                                 @"phone"        :phoneNumber?phoneNumber:@"",
                                 @"custId"       :[YRUserInfoManager manager].currentUser.custId ? [YRUserInfoManager manager].currentUser.custId  : @"",
                                 @"act"          : @"1016"
                                 };
    [YRNetworkController postRequestUrlStr:kSaveFriendToPhone withDic:parameters success:^(NSDictionary *requestDic) {
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
                                 @"token"     : [YRUserInfoManager manager].currentUser.token?[YRUserInfoManager manager].currentUser.token:@"",
                                 @"custId"       :[YRUserInfoManager manager].currentUser.custId ? [YRUserInfoManager manager].currentUser.custId  : @"",
                                 @"toCustId"       : toCustId?toCustId:@"",
                                 };
    [YRNetworkController postRequestUrlStr:kUserInfo withDic:parameters  success:^(NSDictionary *requestDic) {
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
                                 @"custId"     : [YRUserInfoManager manager].currentUser.custId ? [YRUserInfoManager manager].currentUser.custId  : @"",
                                 @"fid"       : friendsId?friendsId:@"",
                                 @"act" : @"1018"
                                 };
    [YRNetworkController postRequestUrlStr:kFriendsDetail withDic:parameters success:^(NSDictionary *requestDic) {
        success(requestDic);
        
    } failure:^(NSString *errorInfo) {
        failure(errorInfo);
    }];
}
/**
 好友预览图片

 @param friendsId <#friendsId description#>
 @param success   <#success description#>
 @param failure   <#failure description#>
 */
+ (void)getFriendsImagesByFriendId:(NSString *)friendsId success:(void (^)(NSDictionary *data))success failure:(void (^)(NSString *error))failure{
    
    NSNumber *num = SCREEN_WIDTH>=375?@4:@3;
    
    NSDictionary *parameters = @{
                                 @"custId"     :friendsId?friendsId:@"",
                                 @"limit"      :num?num:@"",
                                 @"act"        : @"2302"
                                 };
    [YRNetworkController postRequestUrlStr:kFriendsImages withDic:parameters success:^(NSDictionary *requestDic) {
        success(requestDic);
    } failure:^(NSString *errorInfo) {
        failure(errorInfo);
    }];
}


/**
 * @author Sean, 16-09-06 20:09:22
 *
 * 获取好友的个人信息
 *
 * @param fid     <#fid description#>
 * @param success <#success description#>
 * @param failure <#failure description#>
 */
+ (void)getFriendInformationByFriendID:(NSString *)fid success:(void (^)(NSDictionary *data))success failure:(void (^)(NSString *error))failure{
    NSDictionary *parameters = @{
                                 @"custId"    : [YRUserInfoManager manager].currentUser.custId ? [YRUserInfoManager manager].currentUser.custId  : @"",
                                 @"fid"       : fid?fid:@"",
                                 @"act" : @"1003"
                                 };
    [YRNetworkController postRequestUrlStr:kFriendInformation withDic:parameters success:^(NSDictionary *requestDic) {
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
                                 @"token"     : [YRUserInfoManager manager].currentUser.token?[YRUserInfoManager manager].currentUser.token:@"",
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
                                 @"custId"     : [YRUserInfoManager manager].currentUser.custId ? [YRUserInfoManager manager].currentUser.custId  : @"",
                                 @"data":data?data:@""
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
                                 @"custId"     : [YRUserInfoManager manager].currentUser.custId ? [YRUserInfoManager manager].currentUser.custId  : @"",
                                 @"keyword":keyword?keyword:@"",
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
 关键字搜索好友
 
 @param keyword <#keyword description#>
 @param limit   <#limit description#>
 @param start   <#start description#>
 @param success <#success description#>
 @param failure <#failure description#>
 */
+ (void)searchFriendByString:(NSString *)keyword limit:(NSNumber *)limit start:(NSNumber *)start success:(void (^)(NSDictionary *data))success failure:(void (^)(NSString *error))failure{
    
    NSDictionary *parameters = @{
                                 @"custId"     : [YRUserInfoManager manager].currentUser.custId ? [YRUserInfoManager manager].currentUser.custId  : @"",
                                 @"keyword":keyword?keyword:@"",
                                 @"limit":limit?limit:@"",
                                 @"start":start?start:@"",
                                 @"act":@"1014"
                                 };
    
    [YRNetworkController postRequestUrlStr:kSearchFriend withDic:parameters success:^(NSDictionary *requestDic) {
        success(requestDic);
    } failure:^(NSString *errorInfo) {
        failure(errorInfo);
    }];
    
    
}
/**
 关键字搜索用户  作品
 
 @param keyword <#keyword description#>
 @param limit   <#limit description#>
 @param start   <#start description#>
 @param success <#success description#>
 @param failure <#failure description#>
 */


+ (void)searchPeopleAndWorksByKeyword:(NSString *)keyword limit:(NSNumber *)limit start:(NSNumber *)start success:(void (^)(NSDictionary *data))success failure:(void (^)(NSString *error))failure{
    NSDictionary *parameters = @{
                                 @"loginUserId"  : [YRUserInfoManager manager].currentUser.custId ? [YRUserInfoManager manager].currentUser.custId  : @"",
                                 @"keyword":keyword?keyword:@"",
                                 @"limit":limit?limit:@"",
                                 @"start":start?start:@"",
                                 @"act":@"2101"
                                 };
    [YRNetworkController postRequestUrlStr: kSearchPeopleAndWorks withDic:parameters success:^(NSDictionary *requestDic) {
        success(requestDic);
    } failure:^(NSString *errorInfo) {
        failure(errorInfo);
    }];
}

/**
 关键字搜索作品

 @param keyworrd <#keyworrd description#>
 @param limit    <#limit description#>
 @param start    <#start description#>
 @param success  <#success description#>
 @param failure  <#failure description#>
 */
+ (void)searchWorksByKeyword:(NSString *)keyworrd  limit:(NSNumber *)limit start:(NSNumber *)start type:(NSString *)type success:(void (^)(NSDictionary *data))success failure:(void (^)(NSString *error))failure{
    
    NSDictionary *parameters = @{
                                 @"custId"     : [YRUserInfoManager manager].currentUser.custId ? [YRUserInfoManager manager].currentUser.custId  : @"",
                                 @"keyword":keyworrd?keyworrd:@"",
                                 @"limit":limit?limit:@"",
                                 @"start":start?start:@"",
                                 @"act":@"2016",
                                 @"type":type?type:@""
                                 };
    [YRNetworkController postRequestUrlStr: kSearchWorks withDic:parameters success:^(NSDictionary *requestDic) {
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
                                     @"custId"     : [YRUserInfoManager manager].currentUser.custId ? [YRUserInfoManager manager].currentUser.custId  : @"",
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
+ (void)theUserToCollectByStart:(NSString *)start limit:(NSString *)limit  success:(void (^)(NSDictionary *data))success failure:(void (^)(NSString *error))failure{
    if ([YRUserInfoManager manager].currentUser) {
        
        NSDictionary *parameters = @{
                                     @"custId"     : [YRUserInfoManager manager].currentUser.custId ? [YRUserInfoManager manager].currentUser.custId  : @"",
                                     @"act"        : @"2031",
                                     @"start"      :start?start:@"",
                                     @"limit"      :limit?limit:@"",
                                    @"loginUserId" :[YRUserInfoManager manager].currentUser.custId?[YRUserInfoManager manager].currentUser.custId:@"",
                                     };
        [YRNetworkController postRequestUrlStr:kUserListCollection withDic:parameters success:^(NSDictionary *requestDic) {
            success(requestDic);
        } failure:^(NSString *errorInfo) {
            failure(errorInfo);
        }];
    }else{
        //   DLog(@"没有登录");
    }
    
    
}


#pragma mark - 判空

/**
 * @author Sean, 16-09-05 16:09:37
 *
 * 查询账户余额
 *
 * @param success <#success description#>
 * @param failure <#failure description#>
 */
+ (void)AccountBalanceQuerySuccess:(void (^)(NSDictionary *data))success failure:(void (^)(NSString *error))failure{
        NSDictionary *parameters = @{
                                     @"custId"     : [YRUserInfoManager manager].currentUser.custId ? [YRUserInfoManager manager].currentUser.custId  : @"",
                                     @"act"        : @"1050"
                                     };
        [YRNetworkController postRequestUrlStr:kAccountBalance withDic:parameters success:^(NSDictionary *requestDic) {
            success(requestDic);
        } failure:^(NSString *errorInfo) {
            failure(errorInfo);
        }];
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
+ (void)AccountInformationByBillingDetails:(NSString *)bilingType start:(NSString *)start limit:(NSString *)limit success:(void (^)(NSDictionary *data))success failure:(void (^)(NSString *error))failure{
    
    if ([YRUserInfoManager manager].currentUser) {
        
        NSDictionary *parameters = @{
                                     @"custId"     : [YRUserInfoManager manager].currentUser.custId ? [YRUserInfoManager manager].currentUser.custId  : @"",
                                     @"act"        : @"1049",
                                     @"type"       : bilingType,
                                     @"start"    : start,
                                     @"limit"   : limit,
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
                                 @"custId"     : [YRUserInfoManager manager].currentUser.custId ? [YRUserInfoManager manager].currentUser.custId  : @"",
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
                                 @"custId"  : [YRUserInfoManager manager].currentUser.custId,
                                 @"act":@"1007"
                                 };
    
    [YRNetworkController postRequestUrlStr:kUserLoginOut withDic:parameters success:^(NSDictionary *requestDic) {
        success(requestDic);
    } failure:^(NSString *errorInfo) {
        failure(errorInfo);
    }];
    
}


#pragma mark  充值

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
                                 @"custId"  : [YRUserInfoManager manager].currentUser.custId ? [YRUserInfoManager manager].currentUser.custId : @"",
                                 };

    NSString  *netStr = [((AppDelegate *)[UIApplication sharedApplication].delegate) netState];
    //系统直接读取的版本号
    NSString *versionValueStringForSystemNow=[[NSBundle mainBundle].infoDictionary valueForKey:(NSString *)kCFBundleVersionKey];

    NSMutableString  *interFace = [[NSMutableString alloc] initWithString:@"/app-user/v2/pay/getNewPayFlowId"];

//    NSString  *url = [kBaseUrl stringByAppendingString:interFace];

    NSString  *url = [kUserBaseUrl stringByAppendingString:interFace];

    AFHTTPSessionManager *session = [AFHTTPSessionManager manager];
    //默认60s
    session.requestSerializer.timeoutInterval =  60;
    session.responseSerializer = [AFHTTPResponseSerializer serializer];

    
    NSString *act = @"1052";
    NSString *custId = [YRUserInfoManager manager].currentUser.custId ? [YRUserInfoManager manager].currentUser.custId : @"";
    NSString *token = [YRUserInfoManager manager].currentUser.token;
    
    NSString *persign = [NSString stringWithFormat:@"%@.%@.%@",act,custId,token];
    NSString *persignS = [YRDES base64StringFromText:persign];

    [session.requestSerializer setValue:versionValueStringForSystemNow forHTTPHeaderField:@"version"];
    [session.requestSerializer setValue:@"iphone" forHTTPHeaderField:@"devType"];
    [session.requestSerializer setValue:[UIDevice currentDevice].name forHTTPHeaderField:@"devName"];
    [session.requestSerializer setValue:[NSString getUUID] forHTTPHeaderField:@"devId"];
    [session.requestSerializer setValue:[NSString deviceIPAdress] forHTTPHeaderField:@"ip"];
    [session.requestSerializer setValue:netStr forHTTPHeaderField:@"net"];
    [session.requestSerializer setValue:[YRUserInfoManager manager].currentUser.token forHTTPHeaderField:@"token"];
    [session.requestSerializer setValue:persignS forHTTPHeaderField:@"sign"];
    

    DLog(@"😠😠😠😠请求参数%@\t---------%@\n\n\n------------",parameters,url);
    [session POST:url parameters:parameters progress:^(NSProgress * _Nonnull uploadProgress) {
            
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
//        success(responseObject);
        id myResult = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
        
        //判断是否为字典
        if ([myResult isKindOfClass:[NSDictionary  class]]) {
            NSDictionary *  requestDic = (NSDictionary *)myResult;
            //根据返回的接口内容来变
            NSInteger ret = [requestDic[@"ret"] integerValue];
            
            NSString *msg = requestDic[@"msg"];
            if (ret == 1  || [msg isEqualToString:@"success"]) {
                success(requestDic[@"data"]);
            }else if (ret == 4){
                [YRUserInfoManager manager].currentUser.isbusy = @"4";
            }else{
                failure(msg);
            }
        }
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
          failure(error);
    }];
}

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
+(void)kCheckOrder:(NSString*)orderId orderAmount:(float)orderAmount receipt:(NSString*)receipt success:(void (^)(id data))success failure:(void (^)(id data))failure{
    
    NSDictionary *parameters = @{
                                 @"act":@(1052),
                                 @"orderId":orderId,
                                 @"orderAmount":@(orderAmount * 100),
                                 @"receipt":receipt,
                                 @"custId"  : [YRUserInfoManager manager].currentUser.custId ? [YRUserInfoManager manager].currentUser.custId : @"",
                                 };
    
    [YRNetworkController postRequestUrlStr:kCheckOrder withDic:parameters success:^(NSDictionary *requestDic) {
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
    [YRNetworkController postRequestUrlStr:kProductTypeList withDic:parameters success:^(NSDictionary *requestDic) {
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
 *  @param authorid 发布者id
 *  @param categroy 分类id
 *  @param start    分页
 *  @param limit    记录数
 */
+(void)productList:(InfoProductType)type authorid:(NSString*)authorid categroy:(NSString*)categroy  start:(NSInteger)start limit:(NSUInteger)limit success:(void (^)(id data))success failure:(void (^)(id data))failure{
    NSDictionary *parameters = @{
                                 @"act":@"2003",
                                 @"type":@(type),
//                                 @"custId" : authorid,
                                 @"category" : categroy,
                                 @"start" :@(start),
                                 @"limit" : @(limit),
                                 @"loginUserId" : [YRUserInfoManager manager].currentUser.custId ? [YRUserInfoManager manager].currentUser.custId  : @"",
                                 };

//
    [YRNetworkController postRequestUrlStr:kProductList withDic:parameters success:^(NSDictionary *requestDic) {
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
                                 @"act":@"2005",
                                 @"infoId":pid,
                                 @"loginUserId" : [YRUserInfoManager manager].currentUser.custId ? [YRUserInfoManager manager].currentUser.custId  : @"",
                                 };
    
    [YRNetworkController postRequestUrlStr:kProductdetail withDic:parameters success:^(NSDictionary *requestDic) {
        success(requestDic);
    } failure:^(NSString *errorInfo) {
        failure(errorInfo);
    }];
    
}

/**
 *  @author weishibo, 16-09-08 18:09:11
 *
 *  圈子详情页
 *
 *  @param pid     <#pid description#>
 *  @param success <#success description#>
 *  @param failure <#failure description#>
 */
+(void)circleDetailProductId:(NSString*)clubId  infoId:(NSString*)infoId success:(void (^)(id data))success failure:(void (^)(id data))failure{
    
    NSDictionary *parameters = @{
                                 @"act":@"2019",
                                 @"clubId":clubId,
                                 @"loginUserId" : [YRUserInfoManager manager].currentUser.custId ? [YRUserInfoManager manager].currentUser.custId  : @"",
                                 @"start":@(0),
                                 @"limit":@(0),
                                 @"infoId":infoId
                                 };
    
    [YRNetworkController postRequestUrlStr:kCircleDetail withDic:parameters success:^(NSDictionary *requestDic) {
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
 transferMoney 转发金额
 
 packetType 是否附带红包 0拼手气 1普通
 
 totalCount  红包个数
 
 amount  红包金额
 
 *  @param success <#success description#>
 *  @param failure <#failure description#>
 */
+(void)productTran:(ProductTranType)type pID:(NSString*)pid  transferType:(NSInteger)transferType transferMoney:(NSUInteger)transferMoney authorId:(NSString*)authorId  isSendRedPacket:(NSInteger)isSendRedPacket  packetType:(NSInteger)packetType  totalCount:(NSInteger)totalCount  amount:(float)amount payPassword:(NSString*)payPassword success:(void (^)(id data))success failure:(void (^)(id data))failure{
    NSDictionary *parameters = @{
                                 @"act":@"2017",
                                 @"payType":@(type),
                                 @"custId":[YRUserInfoManager manager].currentUser.custId ? [YRUserInfoManager manager].currentUser.custId :@"",
                                 @"id":pid,
                                 @"type":@(transferType),
                                 @"transferMoney":@(transferMoney),
                                 @"authorId":authorId,
                                 @"isSendRedPacket":@(isSendRedPacket),
                                 @"packetType":@(packetType),
                                 @"totalCount":@(totalCount),
                                 @"amount" :@(amount),
                                 @"payPassword":payPassword.YCmd5String
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
                                 @"custId":[YRUserInfoManager manager].currentUser.custId ? [YRUserInfoManager manager].currentUser.custId :@"",
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
                                 @"act":@(2007),
                                 @"infoId":pid,
                                 @"custId":[YRUserInfoManager manager].currentUser.custId ? [YRUserInfoManager manager].currentUser.custId :@"",
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
                                 @"infoId":pid,
                                 @"custId":[YRUserInfoManager manager].currentUser.custId ? [YRUserInfoManager manager].currentUser.custId :@"",
                                 @"content":content,
                                 @"replyBy":replyBy,
                                 @"replyId":replyId,
                            
                                 };
    
    [YRNetworkController postRequestUrlStr:kPoductCommentReply withDic:parameters success:^(NSDictionary *requestDic) {
        success(requestDic);
    } failure:^(NSString *errorInfo) {
        failure(errorInfo);
    }];
    
}


/**
 *  @author yichao, 16-08-22 13:08:50
 *
 *  作品点赞列表
 *kRedPacketAdsList
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
                                 @"loginUserId":[YRUserInfoManager manager].currentUser.custId ? [YRUserInfoManager manager].currentUser.custId :@"",
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
+(void)productDeleteComment:(NSString*)uid infoId:(NSString*)infoId success:(void (^)(id data))success failure:(void (^)(id data))failure{
    NSDictionary *parameters = @{
                                 @"act":@"2010",
                                 @"custId":[YRUserInfoManager manager].currentUser.custId,
                                 @"id":uid,
                                 @"infoId":infoId
                                 };
    
    [YRNetworkController postRequestUrlStr:kProductDeleteComment withDic:parameters success:^(NSDictionary *requestDic) {
        success(requestDic);
    } failure:^(NSString *errorInfo) {
        failure(errorInfo);
    }];
}


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
+(void)productBankList:(ProuductRankType)rankType  start:(NSInteger)start limit:(NSInteger)limit success:(void (^)(id data))success failure:(void (^)(id data))failure{

    NSDictionary *parameters = @{
                                 @"act":@"2031",
                                 @"start":@(start),
                                 @"limit":@(limit),
                                 @"loginUserId":[YRUserInfoManager manager].currentUser.custId ? [YRUserInfoManager manager].currentUser.custId :@"",
                                 @"rankType":@(rankType)
                                 };
    
    [YRNetworkController postRequestUrlStr:kProductBankList withDic:parameters success:^(NSDictionary *requestDic) {
        success(requestDic);
    } failure:^(NSString *errorInfo) {
        failure(errorInfo);
    }];

}

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
+(void)getTagsInfoByList:(InfoProductType)productType  tag:(NSInteger)tag  start:(NSInteger)start limit:(NSInteger)limit success:(void (^)(id data))success failure:(void (^)(id data))failure{
    
    NSDictionary *parameters = @{
                                 @"act":@"2015",
                                 @"start":@(start),
                                 @"limit":@(limit),
                                 @"loginUserId":[YRUserInfoManager manager].currentUser.custId ? [YRUserInfoManager manager].currentUser.custId :@"",
                                 @"type":@(productType),
                                 @"tag":@(tag)
                                 };
    
    [YRNetworkController postRequestUrlStr:kGetTagsInfoByList withDic:parameters success:^(NSDictionary *requestDic) {
        success(requestDic);
    } failure:^(NSString *errorInfo) {
        failure(errorInfo);
    }];
    
}



/**
 *  @author weishibo, 16-09-18 14:09:32
 *
 *  2001.	作品设置已读标记
 *
 *  @param productType <#productType description#>
 *  @param infoId      <#infoId description#>
 *  @param success     <#success description#>
 *  @param failure     <#failure description#>
 */
+(void)infoReadStatus:(InfoProductType)productType  pid:(NSString*)infoId  success:(void (^)(id data))success failure:(void (^)(id data))failure{
    
    NSDictionary *parameters = @{
                                 @"act":@"2013",
                                 @"infoId":infoId?infoId:@"",
                                 @"custId":[YRUserInfoManager manager].currentUser.custId ? [YRUserInfoManager manager].currentUser.custId :@"",
                                 @"infoType":@(productType),
                                 };
    
    [YRNetworkController postRequestUrlStr:kInfoReadStatus withDic:parameters success:^(NSDictionary *requestDic) {
        success(requestDic);
    } failure:^(NSString *errorInfo) {
        failure(errorInfo);
    }];
    
}

#pragma mark 圈子

/**
 *  @author weishibo, 16-08-23 10:08:31
 *
 *  圈子列表(新数据)
 *
 *  @param type    0全部 1好友 2关注
 *  @param maxId   最新id标记
 *  @param start
 *  @param limit   <#limit description#>
 *  @param success <#success description#>
 *  @param failure <#failure description#>
 */
+(void)circleList:(FriendsType)type  start:(NSInteger)start limit:(NSInteger)limit indexId:(NSInteger)indexId  success:(void (^)(id data))success failure:(void (^)(id data))failure{
    
    NSDictionary *parameters = @{
                                 @"act":@"2102",
                                 @"type":@(type),
                                 @"start":@(start),
                                 @"limit":@(limit),
                                 @"loginUserId":[YRUserInfoManager manager].currentUser.custId ? [YRUserInfoManager manager].currentUser.custId : @"",
                                 @"indexId":@(indexId)
                                 };
    
    [YRNetworkController postRequestUrlStr:kCircleList withDic:parameters success:^(NSDictionary *requestDic) {
        success(requestDic);
    } failure:^(NSString *errorInfo) {
        failure(errorInfo);
    }];
}
/**
 *  @author weishibo, 16-09-08 17:09:41
 *
 *  圈子列表（历史数据）(停用)
 *
 *  @param type    <#type description#>
 *  @param maxId   <#maxId description#>
 *  @param start   <#start description#>
 *  @param limit   <#limit description#>
 *  @param success <#success description#>
 *  @param failure <#failure description#>
 */
+(void)circleUplist:(FriendsType)type   minId:(NSString*)minId  start:(NSInteger)start limit:(NSInteger)limit success:(void (^)(id data))success failure:(void (^)(id data))failure{
    
    NSDictionary *parameters = @{
                                 @"act":@"2018",
                                 @"type":@(type),
                                 @"minId":minId,
                                 @"start":@(start),
                                 @"limit":@(limit),
                                 @"loginUserId":[YRUserInfoManager manager].currentUser.custId ? [YRUserInfoManager manager].currentUser.custId : @"",
                                 };
    
    [YRNetworkController postRequestUrlStr:kCircleUplist withDic:parameters success:^(NSDictionary *requestDic) {
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
                                 @"custId":[YRUserInfoManager manager].currentUser.custId ? [YRUserInfoManager manager].currentUser.custId : @"",
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
                                 @"act":@"2024",
                                 @"id":cid,
                                 @"custId":[YRUserInfoManager manager].currentUser.custId ? [YRUserInfoManager manager].currentUser.custId : @"",
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
+(void)circleTranList:(NSString*)clubId  start:(NSInteger)start limit:(NSInteger)limit success:(void (^)(id data))success failure:(void (^)(id data))failure{
    
    NSDictionary *parameters = @{
                                 @"act":@"2030",
                                 @"clubId": clubId,
                                 @"start":@(start),
                                 @"limit":@(limit),
                                  @"loginUserId":[YRUserInfoManager manager].currentUser.custId ? [YRUserInfoManager manager].currentUser.custId : @"",
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
                                 @"act":@"2024",
                                 @"id":pid,
                                 @"custId":[YRUserInfoManager manager].currentUser.custId,
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
                                 @"act":@"2018",
                                 @"id":pid,
                                 @"custId":[YRUserInfoManager manager].currentUser.custId,
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
 *  @param uid     评论id
 *  @param success <#success description#>
 *  @param failure <#failure description#>
 */
+(void)circleDeleteComment:(NSString*)uid clubId:(NSString*)clubId success:(void (^)(id data))success failure:(void (^)(id data))failure{
    NSDictionary *parameters = @{
                                 @"act":@"2112",
                                 @"id":uid,
                                 @"custId":[YRUserInfoManager manager].currentUser.custId,
                                 @"clubId":clubId
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
                                 @"custId":[YRUserInfoManager manager].currentUser.custId ? [YRUserInfoManager manager].currentUser.custId :@"",
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
                                 @"custId":[YRUserInfoManager manager].currentUser.custId ? [YRUserInfoManager manager].currentUser.custId :@"",
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

/**
 *  @author weishibo, 16-09-13 17:09:21
 *
 *  邀请转发
 *
 *  @param toCustId 被邀请id
 *  @param infoId   作品id
 *  @param success  type 1是作品 2是圈子
 *  @param failure  <#failure description#>
 */
+(void)inviteTransfer:(NSArray*)toCustId infoId:(NSString*)infoId type:(NSInteger)type success:(void (^)(id data))success failure:(void (^)(id data))failure{
    NSDictionary *parameters = @{
                                 @"act":@"2116",
                                 @"infoId":infoId?infoId:@"",
                                 @"formCustId":[YRUserInfoManager manager].currentUser.custId ? [YRUserInfoManager manager].currentUser.custId :@"",
                                 @"toCustId":[toCustId mj_JSONString]?[toCustId mj_JSONString]:@"",
                                 @"type":@(type)
                                 };
    
    [YRNetworkController postRequestUrlStr:kInviteTransfer withDic:parameters success:^(NSDictionary *requestDic) {
        success(requestDic);
    } failure:^(NSString *errorInfo) {
        failure(errorInfo);
    }];

}



///圈子收益与转发数
+(void)circleClubBonud:(NSArray*)clubId success:(void (^)(id data))success failure:(void (^)(id data))failure{
    
    NSDictionary *parameters = @{
                                 @"act":@"2119",
                                 @"clubId":[clubId mj_JSONString],
                                 @"custId":[YRUserInfoManager manager].currentUser.custId ? [YRUserInfoManager manager].currentUser.custId :@"",
                                 };
    
    
    [YRNetworkController postRequestUrlStr:KCircleClubBonud withDic:parameters success:^(NSDictionary *requestDic) {
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
                                 @"custId":[YRUserInfoManager manager].currentUser.custId ? [YRUserInfoManager manager].currentUser.custId :@""
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
                                 @"custId":[YRUserInfoManager manager].currentUser.custId ? [YRUserInfoManager manager].currentUser.custId :@"",
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
 *  @param type     打赏对象打赏类型 打赏对象类型 0转发 1晒一晒 2作品
 *  @param infoId      打赏对象id(作品id或者圈子id)
 
 
pid 当打赏圈子的时候传作品id
 *  @param giftNum  礼物数
 
 打赏作品  类型
 
 打赏 对象标题
 *  @param success  <#success description#>
 *  @param failure  <#failure description#>
 */
+(void)sendReward:(NSString*)giftid touserid:(NSString*)touserid type:(NSInteger)type infoId:(NSString*)infoId giftNum:(NSInteger)giftNum  password:(NSString*)password   infoType:(InfoProductType)infoType  infoTitle:(NSString*)infoTitle pid:(NSString*)pid  success:(void (^)(id data))success failure:(void (^)(id data))failure{
    
    
    if ([password isValid]) {
        password = password.YCmd5String;
    }
    
    if (!infoTitle) {
        infoTitle = @"";
    }
    
    NSDictionary *parameters = @{
                                 @"act":@(4001),
                                 @"giftId":giftid?giftid:@"",
                                 @"custId":[YRUserInfoManager manager].currentUser.custId ? [YRUserInfoManager manager].currentUser.custId:@"",
                                 @"tocustId":touserid?touserid:@"",
                                 @"type":@(type),
                                 @"infoId":infoId?infoId:@"",
                                 @"giftNum":@(giftNum),
                                 @"password":password?password:@"",
                                 @"pId":pid?pid:@"",
                                 @"infoType":@(infoType),
                                 @"infoTitle":infoTitle?infoTitle:@""
                                 };
    [MBProgressHUD showMessage:@""];
    [YRNetworkController postRequestUrlStr:kSendRegardGift withDic:parameters success:^(NSDictionary *requestDic) {
        [MBProgressHUD hideHUD];
        success(requestDic);
    } failure:^(NSString *errorInfo) {
           [MBProgressHUD hideHUD];
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
+(void)sendRedList:(NSInteger)rewardType  start:(NSInteger)start  limit:(NSInteger)limit  success:(void (^)(id data))success failure:(void (^)(id data))failure{
    
    NSDictionary *parameters = @{
                                 @"act":@(5001),
                                 @"custId":[YRUserInfoManager manager].currentUser.custId ? [YRUserInfoManager manager].currentUser.custId :@"",
                                 @"type":@(rewardType),
                                 @"start":@(start),
                                 @"limit":@(limit),
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
 *  @param adsInfoPath  视频广告地址
 *  @param phone        广告联系方式
 *  @param packetType   红包类型  0 拼手气 1普通
 *  @param packetAmount 红包总金额
 *  @param packetNum    红包总个数
 *  @param password     支付密码
 *  @param success      <#success description#>
 *  @param failure      <#failure description#>
 */
+(void)releaseRedAds:(NSString*)adsTitle adsSmallPic:(NSString*)adsSmallPic picCount:(NSInteger)picCount content:(NSString*)content adsType:(InfoProductType)adsType payDays:(NSInteger)payDays wishUpDate:(NSString *)wishUpDate phone:(NSString*)phone packetType:(NSInteger)packetType packetAmount:(CGFloat)packetAmount packetNum:(NSInteger)packetNum password:(NSString*)password  adsInfoPath:(NSString *)adsInfoPath  adsDesc:(NSString *)adsDesc success:(void (^)(id data))success failure:(void (^)(id data))failure{

    NSDictionary *parameters = @{
                                 @"act":@(6001),
                                 @"custId":[YRUserInfoManager manager].currentUser.custId ? [YRUserInfoManager manager].currentUser.custId :@"",
                                 @"adsTitle" : adsTitle,
                                 @"adsSmallPic":adsSmallPic,
                                 @"picCount":@(picCount),
                                 @"content":content,
                                 @"adsType":@(adsType),
                                 @"payDays":@(payDays),
                                 @"wishUpDate":wishUpDate ? wishUpDate : @"",
                                 @"phone":phone,
                                 @"packetType":@(packetType),
                                 @"packetAmount":@(packetAmount),
                                 @"packetNum":@(packetNum),
                                 @"password":password.YCmd5String,
                                 @"adsInfoPath":adsInfoPath,
                                 @"adsDesc":adsDesc
                                 };
    
    [YRNetworkController postRequestUrlStr:kReleaseRedAds withDic:parameters success:^(NSDictionary *requestDic) {
        success(requestDic);
    } failure:^(NSString *errorInfo) {
        failure(errorInfo);
    }];

}

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
+(void)adAddLikeOrUnLike:(NSString*)adsId like:(NSInteger)like success:(void (^)(id data))success failure:(void (^)(id data))failure{
    NSDictionary *parameters = @{
                                 @"act":@"6019",
                                 @"adsId":adsId,
                                 @"custId":[YRUserInfoManager manager].currentUser.custId ? [YRUserInfoManager manager].currentUser.custId  : @"",
                                 @"like" : @(like)
                                 };
    
    [YRNetworkController postRequestUrlStr:kAdAddLikeOrUnLike withDic:parameters success:^(NSDictionary *requestDic) {
        success(requestDic);
    } failure:^(NSString *errorInfo) {
        failure(errorInfo);
    }];
}


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
+(void)adsAddComment:(NSString*)adsId content:(NSString*)content success:(void (^)(id data))success failure:(void (^)(id data))failure{
    NSDictionary *parameters = @{
                                 @"act":@(6020),
                                 @"adsId":adsId,
                                 @"custId":[YRUserInfoManager manager].currentUser.custId ? [YRUserInfoManager manager].currentUser.custId :@"",
                                 @"content":content
                                 };
    
    [YRNetworkController postRequestUrlStr:kAdvertAddCommentlike withDic:parameters success:^(NSDictionary *requestDic) {
        success(requestDic);
    } failure:^(NSString *errorInfo) {
        failure(errorInfo);
    }];
    
}


/**
 *  @author yichao, 16-08-22 14:08:26
 *
 *  广告评论回复
 *
 *  @param pid     作品id
 *  @param content 回复内容
 *  @param replyBy 回复评论人
 *  @param replyId 回复评论对象
 *  @param success <#success description#>
 *  @param failure <#failure description#>
 */
+(void)adsReplyComment:(NSString*)adsId content:(NSString*)content replyBy:(NSString*)replyBy  replyId:(NSString*)replyId  success:(void (^)(id data))success failure:(void (^)(id data))failure{
    NSDictionary *parameters = @{
                                 @"act":@"6021",
                                 @"adsId":adsId,
                                 @"custId":[YRUserInfoManager manager].currentUser.custId ? [YRUserInfoManager manager].currentUser.custId :@"",
                                 @"content":content,
                                 @"replyBy":replyBy,
                                 @"replyId":replyId,
                                 };
    
    [YRNetworkController postRequestUrlStr:kAdsReplyComment withDic:parameters success:^(NSDictionary *requestDic) {
        success(requestDic);
    } failure:^(NSString *errorInfo) {
        failure(errorInfo);
    }];
    
}


/**
 *  @author yichao, 16-08-22 16:08:33
 *
 *  广告评论删除
 *
 *  @param uid     评论id
 *  @param success <#success description#>
 *  @param failure <#failure description#>
 */
+(void)adsDeleteComment:(NSString*)uid  custId:(NSString*)custId success:(void (^)(id data))success failure:(void (^)(id data))failure{
    NSDictionary *parameters = @{
                                 @"act":@"6022",
                                 @"custId":[YRUserInfoManager manager].currentUser.custId,
                                 @"commentId":uid,
                                 };
    
    [YRNetworkController postRequestUrlStr:kAdDeleteComment withDic:parameters success:^(NSDictionary *requestDic) {
        success(requestDic);
    } failure:^(NSString *errorInfo) {
        failure(errorInfo);
    }];
}


/**
 *  @author yichao, 16-08-22 13:08:28
 *
 *  广告评论列表
 *
 *  @param pid     作品id
 *  @param success <#success description#>
 *  @param failure <#failure description#>
 */
+(void)adsCommentList:(NSString*)adsId start:(NSInteger)start limit:(NSInteger)limit success:(void (^)(id data))success failure:(void (^)(id data))failure{
    
    NSDictionary *parameters = @{
                                 @"act":@"6023",
                                 @"adsId":adsId,
                                 @"start":@(start),
                                 @"limit":@(limit),
                                 @"custId":[YRUserInfoManager manager].currentUser.custId ? [YRUserInfoManager manager].currentUser.custId :@"",
                                 };
    
    [YRNetworkController postRequestUrlStr:kAdsCommentsList withDic:parameters success:^(NSDictionary *requestDic) {
        success(requestDic);
    } failure:^(NSString *errorInfo) {
        failure(errorInfo);
    }];
}



/**
 *  @author yichao, 16-08-22 13:08:50
 *
 *  广告点赞列表
 *kRedPacketAdsList
 *  @param pid     <#pid description#>
 *  @param success <#success description#>
 *  @param failure <#failure description#>
 */
+(void)adsLikeList:(NSString*)pid start:(NSInteger)start limit:(NSInteger)limit success:(void (^)(id data))success failure:(void (^)(id data))failure{
    
    NSDictionary *parameters = @{
                                 @"act":@(6025),
                                 @"adsId":pid,
                                 @"custId":[YRUserInfoManager manager].currentUser.custId ? [YRUserInfoManager manager].currentUser.custId :@"",
                                 @"start":@(start),
                                 @"limit":@(limit)
                                 };
    
    [YRNetworkController postRequestUrlStr:kAdsLikeList withDic:parameters success:^(NSDictionary *requestDic) {
        success(requestDic);
    } failure:^(NSString *errorInfo) {
        failure(errorInfo);
    }];
}

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
+(void)adsCommentsNum:(NSString*)pid  success:(void (^)(id data))success failure:(void (^)(id data))failure{
    
    NSDictionary *parameters = @{
                                 @"act":@(6024),
                                 @"adsId":pid,
                                 @"custId":[YRUserInfoManager manager].currentUser.custId ? [YRUserInfoManager manager].currentUser.custId :@"",
                                 };
    
    [YRNetworkController postRequestUrlStr:kAdsCommentsNum withDic:parameters success:^(NSDictionary *requestDic) {
        success(requestDic);
    } failure:^(NSString *errorInfo) {
        failure(errorInfo);
    }];
}


/**
 *  @author weishibo, 16-08-20 16:08:32
 *
 *  广告
 *
 *  @param pid     <#pid description#>
 *  @param success <#success description#>
 *  @param failure <#failure description#>
 */
+(void)adsdetailProductId:(NSString*)pid success:(void (^)(id data))success failure:(void (^)(id data))failure{
    
    NSDictionary *parameters = @{
                                 @"act":@"6007",
                                 @"adsId":pid,
                                 @"custId" : [YRUserInfoManager manager].currentUser.custId ? [YRUserInfoManager manager].currentUser.custId  : @"",
                                 };
    
    [YRNetworkController postRequestUrlStr:kAdDetail withDic:parameters success:^(NSDictionary *requestDic) {
        success(requestDic);
    } failure:^(NSString *errorInfo) {
        failure(errorInfo);
    }];
    
}
///获取广告发布单价
+(void)getAdsPriceDaysuccess:(void (^)(id data))success failure:(void (^)(id data))failure{

    NSDictionary *parameters = @{
                                 @"act":@"6019",
                                 @"custId" : [YRUserInfoManager manager].currentUser.custId ? [YRUserInfoManager manager].currentUser.custId  : @"",
                                 };
    
    [YRNetworkController postRequestUrlStr:kAdsPriceDay withDic:parameters success:^(NSDictionary *requestDic) {
        success(requestDic);
    } failure:^(NSString *errorInfo) {
        failure(errorInfo);
    }];
}

- (NSData *)DESEncrypt:(NSData *)data WithKey:(NSString *)key
{
    char keyPtr[kCCKeySizeAES256+1];
    bzero(keyPtr, sizeof(keyPtr));
    
    [key getCString:keyPtr maxLength:sizeof(keyPtr) encoding:NSUTF8StringEncoding];
    
    NSUInteger dataLength = [data length];
    
    size_t bufferSize = dataLength + kCCBlockSizeAES128;
    void *buffer = malloc(bufferSize);
    
    size_t numBytesEncrypted = 0;
    CCCryptorStatus cryptStatus = CCCrypt(kCCEncrypt, kCCAlgorithmDES,
                                          kCCOptionPKCS7Padding | kCCOptionECBMode,
                                          keyPtr, kCCBlockSizeDES,
                                          NULL,
                                          [data bytes], dataLength,
                                          buffer, bufferSize,
                                          &numBytesEncrypted);
    if (cryptStatus == kCCSuccess) {
        return [NSData dataWithBytesNoCopy:buffer length:numBytesEncrypted];
    }
    
    free(buffer);
    return nil;
}




@end
