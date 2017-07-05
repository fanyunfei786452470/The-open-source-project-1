//
//  YRNetworkController.h
//  Rrz
//
//  Created by weishibo on 16/7/4.
//  Copyright © 2016年 rongzhongwang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "APIConstant.h"

typedef void (^SuccessBlock)(NSDictionary *requestDic);
typedef void (^FailureBlock)(NSString     *errorInfo);
typedef void (^loadProgress)(float progress);

@interface YRNetworkController : NSObject

/**
 *  Post请求
 *
 *  @param urlStr     url
 *  @param parameters post参数
 *  @param success    成功的回调
 *  @param failure    失败的回调
 */
+(void)postRequestUrlStr:(HttpMethd)httpMethd withDic:(NSDictionary *)parameters success:(SuccessBlock )success failure:(FailureBlock)failure;

/**
 *  上传单个文件
 *
 *  @param urlStr       服务器地址
 *  @param parameters   参数
 *  @param attach       上传的key
 *  @param data         上传的问价
 *  @param loadProgress 上传的进度
 *  @param success      成功的回调
 *  @param failure      失败的回调
 */
+(void)upLoadDataWithHttpMethd:(HttpMethd)httpMethd withDic:(NSDictionary *)parameters imageKey:(NSString *)attach withData:(NSData *)data upLoadProgress:(loadProgress)loadProgress success:(SuccessBlock)success failure:(FailureBlock)failure;

+(void)postRequestWithCacheUrlStr:(HttpMethd)httpMethd  withDic:(NSDictionary *)parameters  cacheKey:(NSString*)cacheKey success:(SuccessBlock)success failure:(FailureBlock)failure;

@end
