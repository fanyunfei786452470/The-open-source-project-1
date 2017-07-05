    //
//  UMShareAndLogin.m
//  Rrz
//
//  Created by Mrs_zhang on 16/6/28.
//  Copyright © 2016年 rongzhongwang. All rights reserved.
//

#import "UMShareAndLogin.h"
#import "UMSocial.h"

@interface UMShareAndLogin()<UMSocialUIDelegate>

@end

@implementation UMShareAndLogin

/**
 *  @author ZX, 16-06-28 11:06:44
 *
 *  QQ分享
 *
 *  @param shareUrl       分享url
 *  @param shareTitle     分享标题
 *  @param image          分享图片
 *  @param successHandler
 */
+ (void)UMShareQQDataSourseWithShareUrl:(NSString *)shareUrl ShareTitle:(NSString *)shareTitle ShareImage:(UIImage *)image SuccessHandler:(SuccessHandler)successHandler{
    
        [UMSocialData defaultData].extConfig.qqData.url =shareUrl;
        [UMSocialData defaultData].extConfig.qqData.title = shareTitle;
    
        [[UMSocialDataService defaultDataService]  postSNSWithTypes:@[UMShareToQQ] content:shareTitle image:image  location:nil urlResource:nil presentedController:nil completion:^(UMSocialResponseEntity *response){
    
            if (response.responseCode == UMSResponseCodeSuccess) {
                DLog(@"分享成功！");
                successHandler(YES,response);
            }
        }];
}
/**
 * @author Sean, 16-08-25 11:08:29
 *
 * QQ空间分享
 *
 * @param shareUrl       <#shareUrl description#>
 * @param shareTitle     <#shareTitle description#>
 * @param image          <#image description#>
 * @param successHandler <#successHandler description#>
 */
+ (void)UMShareQQZoneSourseWithShareUrl:(NSString *)shareUrl ShareTitle:(NSString *)shareTitle ShareImage:(UIImage *)image SuccessHandler:(SuccessHandler)successHandler{
    
    [UMSocialData defaultData].extConfig.qzoneData.url =shareUrl;
    [UMSocialData defaultData].extConfig.qzoneData.title = shareTitle;
    
    [[UMSocialDataService defaultDataService]  postSNSWithTypes:@[UMShareToQzone] content:shareTitle image:image  location:nil urlResource:nil presentedController:nil completion:^(UMSocialResponseEntity *response){
        
        if (response.responseCode == UMSResponseCodeSuccess) {
            DLog(@"分享成功！");
            successHandler(YES,response);
        }
    }];
}

/**
 *  @author ZX, 16-06-28 11:06:32
 *
 *  微信分享
 *
 *  @param shareUrl       分享url
 *  @param shareTitle     分享标题
 *  @param image          分享图片
 *  @param successHandler
 */
+ (void)UMShareWeChatDataSourseWithShareUrl:(NSString *)shareUrl ShareTitle:(NSString *)shareTitle ShareImage:(UIImage *)image SuccessHandler:(SuccessHandler)successHandler{
    
    
//    [UMSocialData defaultData].extConfig.qqData.url =shareUrl;
    [UMSocialData defaultData].extConfig.qqData.title = shareTitle;
    
    [UMSocialData defaultData].extConfig.wechatSessionData.url =shareUrl;
    [UMSocialData defaultData].extConfig.wechatSessionData.title = shareTitle;
    
    [[UMSocialDataService defaultDataService]  postSNSWithTypes:@[UMShareToWechatSession] content:shareTitle image:image  location:nil urlResource:nil presentedController:nil completion:^(UMSocialResponseEntity *response){
        
        if (response.responseCode == UMSResponseCodeSuccess) {
            DLog(@"分享成功！");
            successHandler(YES,response);
        }
    }];
}
/**
 *  @author ZX, 16-06-28 11:06:32
 *
 *  微信朋友圈分享
 *
 *  @param shareUrl       分享url
 *  @param shareTitle     分享标题
 *  @param image          分享图片
 *  @param successHandler
 */
+ (void)UMShareWeChatFriendSourseWithShareUrl:(NSString *)shareUrl ShareTitle:(NSString *)shareTitle ShareImage:(UIImage *)image SuccessHandler:(SuccessHandler)successHandler{
    
    
//    [UMSocialData defaultData].extConfig.qqData.url =shareUrl;
//    [UMSocialData defaultData].extConfig.qqData.title = shareTitle;
//    
    [UMSocialData defaultData].extConfig.wechatTimelineData.url = shareUrl;
     [UMSocialData defaultData].extConfig.wechatTimelineData.title = shareUrl;
    
    [[UMSocialDataService defaultDataService]  postSNSWithTypes:@[UMShareToWechatTimeline] content:shareTitle image:image  location:nil urlResource:nil presentedController:nil completion:^(UMSocialResponseEntity *response){
        
        if (response.responseCode == UMSResponseCodeSuccess) {
            DLog(@"分享成功！");
            successHandler(YES,response);
        }
    }];
}

/**
 *  @author ZX, 16-06-28 11:06:32
 *
 *  微博分享
 *
 *  @param shareUrl       分享url
 *  @param shareTitle     分享标题
 *  @param image          分享图片
 *  @param successHandler
 */
+ (void)UMShareWebDataSourseWithShareUrl:(NSString *)shareUrl ShareTitle:(NSString *)shareTitle ShareImage:(UIImage *)image SuccessHandler:(SuccessHandler)successHandler{
    
    
    [UMSocialData defaultData].extConfig.qqData.url =shareUrl;
    [UMSocialData defaultData].extConfig.qqData.title = shareTitle;
    
    [[UMSocialDataService defaultDataService]  postSNSWithTypes:@[UMShareToSina] content:shareTitle image:image  location:nil urlResource:nil presentedController:nil completion:^(UMSocialResponseEntity *response){
        
        if (response.responseCode == UMSResponseCodeSuccess) {
            DLog(@"分享成功！");
            successHandler(YES,response);
        }
    }];
}


/**
 *  @author ZX, 16-06-28 11:06:32
 *
 *  QQ登录
 */
+ (void)UMLoginWithQQDataSourseWithController:(UIViewController *)controller SuccessHandler:(SuccessHandler)successHandler{

        //友盟QQ登录
        UMSocialSnsPlatform *qqPlatform = [UMSocialSnsPlatformManager getSocialPlatformWithName:UMShareToQQ];
    
        qqPlatform.loginClickHandler(controller,[UMSocialControllerService defaultControllerService],YES,^(UMSocialResponseEntity *response){
            //          获取QQ用户名、uid、token等
    
            if (response.responseCode == UMSResponseCodeSuccess) {
    
                UMSocialAccountEntity *snsAccount = [[UMSocialAccountManager socialAccountDictionary] valueForKey:UMShareToQQ];
                
                DLog(@"%@",snsAccount);
                
    
                DLog(@"username is %@, uid is %@, token is %@ url is %@",snsAccount.userName,snsAccount.usid,snsAccount.accessToken,snsAccount.iconURL);
                successHandler(YES,response);
            }
    });
}


/**
 *  @author ZX, 16-06-28 11:06:32
 *
 *  微信登录
 */
+ (void)UMLoginWithWeChatDataSourseWithController:(UIViewController *)controller SuccessHandler:(SuccessHandler)successHandler{
    
   // 友盟微信登录
        UMSocialSnsPlatform *weChatPlatform = [UMSocialSnsPlatformManager getSocialPlatformWithName:UMShareToWechatSession];
    
    
        weChatPlatform.loginClickHandler(controller,[UMSocialControllerService defaultControllerService],YES,^(UMSocialResponseEntity *response){
    
            if (response.responseCode == UMSResponseCodeSuccess) {
                UMSocialAccountEntity *snsAccount = [[UMSocialAccountManager socialAccountDictionary]valueForKey:UMShareToWechatSession];
                DLog(@"%@",snsAccount);
                DLog(@"username is %@, uid is %@, token is %@ url is %@",snsAccount.userName,snsAccount.usid,snsAccount.accessToken,snsAccount.iconURL);
                successHandler(YES,response);

            }
        });
}

/**
 *  @author ZX, 16-06-28 11:06:32
 *
 *  微博登录
 */
+ (void)UMLoginWithWebDataSourseWithController:(UIViewController *)controller SuccessHandler:(SuccessHandler)successHandler{
    
    //友盟微博登录
    UMSocialSnsPlatform *webPlatform = [UMSocialSnsPlatformManager getSocialPlatformWithName:UMShareToSina];
    
    webPlatform.loginClickHandler(controller,[UMSocialControllerService defaultControllerService],YES,^(UMSocialResponseEntity *response){
        
        //          获取微博用户名、uid、token等
        if (response.responseCode == UMSResponseCodeSuccess) {
            UMSocialAccountEntity *snsAccount = [[UMSocialAccountManager socialAccountDictionary] valueForKey:UMShareToSina];
            DLog(@"username is %@, uid is %@, token is %@ url is %@",snsAccount.userName,snsAccount.usid,snsAccount.accessToken,snsAccount.iconURL);
            
            
            
            successHandler(YES,response);
        }});
}
@end
