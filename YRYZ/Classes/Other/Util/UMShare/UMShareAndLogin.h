//
//  UMShareAndLogin.h
//  Rrz
//
//  Created by Mrs_zhang on 16/6/28.
//  Copyright © 2016年 rongzhongwang. All rights reserved.
//

#import <Foundation/Foundation.h>
typedef void (^ SuccessHandler) (BOOL isSuccess, id result);
typedef void (^ FailureHandler) (NSError *error);


@interface UMShareAndLogin : NSObject

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
+ (void)UMShareQQDataSourseWithShareUrl:(NSString *)shareUrl title:(NSString *)title ShareTitle:(NSString *)shareTitle ShareImage:(UIImage *)image SuccessHandler:(SuccessHandler)successHandler;
/**
 * @author Sean, 16-08-25 10:08:49
 *
 *  QQ空间分享
 *
 *  @param shareUrl       分享url
 *  @param shareTitle     分享标题
 *  @param image          分享图片
 *  @param successHandler
 */
+ (void)UMShareQQZoneSourseWithShareUrl:(NSString *)shareUrl title:(NSString *)title ShareTitle:(NSString *)shareTitle ShareImage:(UIImage *)image SuccessHandler:(SuccessHandler)successHandler;


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
+ (void)UMShareWeChatDataSourseWithShareUrl:(NSString *)shareUrl title:(NSString *)title ShareTitle:(NSString *)shareTitle ShareImage:(UIImage *)image SuccessHandler:(SuccessHandler)successHandler;
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
+ (void)UMShareWeChatFriendSourseWithShareUrl:(NSString *)shareUrl title:(NSString *)title  ShareTitle:(NSString *)shareTitle ShareImage:(UIImage *)image SuccessHandler:(SuccessHandler)successHandler;

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
+ (void)UMShareWebDataSourseWithShareUrl:(NSString *)shareUrl title:(NSString *)title ShareTitle:(NSString *)shareTitle ShareImage:(UIImage *)image SuccessHandler:(SuccessHandler)successHandler;


/**
 *  @author ZX, 16-06-28 11:06:32
 *
 *  QQ登录
 */
+ (void)UMLoginWithQQDataSourseWithController:(UIViewController *)controller SuccessHandler:(SuccessHandler)successHandler;

/**
 *  @author ZX, 16-06-28 11:06:32
 *
 *  微信登录
 */
+ (void)UMLoginWithWeChatDataSourseWithController:(UIViewController *)controller SuccessHandler:(SuccessHandler)successHandler;

/**
 *  @author ZX, 16-06-28 11:06:32
 *
 *  新浪微博登录
 */
+ (void)UMLoginWithWebDataSourseWithController:(UIViewController *)controller SuccessHandler:(SuccessHandler)successHandler;
@end
