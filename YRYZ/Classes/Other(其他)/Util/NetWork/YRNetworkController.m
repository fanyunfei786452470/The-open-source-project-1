//
//  YRNetworkController.m
//  Rrz
//
//  Created by weishibo on 16/7/4.
//  Copyright © 2016年 rongzhongwang. All rights reserved.
//

#import "YRNetworkController.h"
#import "AFHTTPSessionManager.h"
#import "AFNetworkActivityIndicatorManager.h"
#import "YRYYCache.h"
#import "AppDelegate.h"

// 请求方式
typedef NS_ENUM(NSInteger, RequestType) {
    RequestTypeGet,
    RequestTypePost,
    RequestTypeUpLoad,
    RequestTypeDownload
};

@implementation YRNetworkController
#pragma mark - 类方法
+(void)getRequestUrlStr:(HttpMethd)httpMethd success:(SuccessBlock)success failure:(FailureBlock)failure
{
    [[self alloc] requestWithHttpMethd:httpMethd withDic:nil requestType:RequestTypeGet isCache:NO cacheKey:nil imageKey:nil withData:nil upLoadProgress:nil success:^(NSDictionary *requestDic) {
        success(requestDic);
    } failure:^(NSString *errorInfo) {
        failure(errorInfo);
    }];
}

+(void)getRequestCacheUrlStr:(HttpMethd)httpMethd success:(SuccessBlock)success failure:(FailureBlock)failuer{
    
    [[self alloc] requestWithHttpMethd:httpMethd withDic:nil requestType:RequestTypeGet isCache:YES cacheKey:Interface[httpMethd] imageKey:nil withData:nil upLoadProgress:nil success:^(NSDictionary *requestDic) {
        success(requestDic);
    } failure:^(NSString *errorInfo) {
        failuer(errorInfo);
    }];
}

+(void)postRequestUrlStr:(HttpMethd)httpMethd withDic:(NSDictionary *)parameters success:(SuccessBlock)success failure:(FailureBlock)failure
{
    [[self alloc] requestWithHttpMethd:httpMethd withDic:parameters requestType:RequestTypePost isCache:NO cacheKey:Interface[httpMethd] imageKey:nil withData:nil upLoadProgress:nil success:^(NSDictionary *requestDic) {
        success(requestDic);
    } failure:^(NSString *errorInfo) {
        failure(errorInfo);
    }];
}

+(void)postRequestWithCacheUrlStr:(HttpMethd)httpMethd  withDic:(NSDictionary *)parameters  cacheKey:(NSString*)cacheKey success:(SuccessBlock)success failure:(FailureBlock)failure
{
    [[self alloc] requestWithHttpMethd:httpMethd withDic:parameters requestType:RequestTypePost isCache:YES cacheKey:cacheKey ? cacheKey:Interface[httpMethd] imageKey:nil withData:nil upLoadProgress:nil success:^(NSDictionary *requestDic) {
        success(requestDic);
    } failure:^(NSString *errorInfo) {
        failure(errorInfo);
    }];
}

+(void)upLoadDataWithHttpMethd:(HttpMethd)httpMethd withDic:(NSDictionary *)parameters imageKey:(NSString *)attach withData:(NSData *)data upLoadProgress:(loadProgress)loadProgress success:(SuccessBlock)success failure:(FailureBlock)failure
{
    [[self alloc] requestWithHttpMethd:httpMethd withDic:parameters requestType:RequestTypeUpLoad isCache:NO cacheKey:Interface[httpMethd] imageKey:attach withData:data upLoadProgress:^(float progress) {
        loadProgress(progress);
    } success:^(NSDictionary *requestDic) {
        success(requestDic);
    } failure:^(NSString *errorInfo) {
        
    }];
}


#pragma mark -- 网络请求统一处理-----------
/**
 *  @author weishibo, 16-07-05 09:07:29
 *
 *  统一网络请求
 *
 *  @param httpMethd    接口
 *  @param parameters   参数
 *  @param requestType  请求类型
 *  @param isCache      是否需要缓存
 *  @param cacheKey     缓存key 使用的是Interface[httpMethd] 为了唯一性加上了baseUrl 后期考虑选择新的方案
 *  @param imageName    图片name
 *  @param data         <#data description#>
 *  @param loadProgress <#loadProgress description#>
 *  @param success      <#success description#>
 *  @param failure      <#failure description#>
 */
-(void)requestWithHttpMethd:(HttpMethd)httpMethd withDic:(NSDictionary *)parameters requestType:(RequestType)requestType  isCache:(BOOL)isCache  cacheKey:(NSString *)cacheKey imageKey:(NSString *)imageName withData:(NSData *)data upLoadProgress:(loadProgress)loadProgress success:(SuccessBlock)success failure:(FailureBlock)failure
{
    
    NSMutableString  *interFace = [[NSMutableString alloc] initWithString:Interface[httpMethd]];
    
    NSString *url = @"";

    
    NSString  *redPacket = @"/app-redpacket";
    NSString  *user = @"/app-user";
    NSString  *circle= @"/app-circle";
    NSString  *shine = @"/app-shine";
    
    if ([interFace hasPrefix:redPacket]) {
        url = [kRedPacketBaseUrl stringByAppendingString:[interFace stringByReplacingOccurrencesOfString:redPacket withString:@""]];
    }else if ([interFace hasPrefix:user]){
        url = [kUserBaseUrl stringByAppendingString:[interFace stringByReplacingOccurrencesOfString:user withString:@""]];
    }else if ([interFace hasPrefix:circle]){
        url = [kCircleBaseUrl stringByAppendingString:[interFace stringByReplacingOccurrencesOfString:circle withString:@""]];
    }else if ([interFace hasPrefix:shine]){
        url = [kShineBaseUrl stringByAppendingString:[interFace stringByReplacingOccurrencesOfString:shine withString:@""]];
    }
    
    
//    url = [kBaseUrl stringByAppendingString:interFace];
    
    NSString * cacheUrl = [self urlDictToStringWithUrlStr:url WithDict:parameters];
    DLog(@"😠😠😠😠请求参数%@\t---------%@\n\n\n------------",parameters,cacheUrl);
    
    id cacheData;
    if (isCache) {
        cacheData = [[YRYYCache share].yyCache objectForKey:cacheKey];
        if (cacheData != 0) {
            //将数据统一处理
            [self returnDataWithRequestData:cacheData Success:^(NSDictionary *requestDic) {
                
                success(requestDic);
            } failure:^(NSString *errorInfo) {
                failure(errorInfo);
            }];
        }
    }
    NSString  *netStr = [((AppDelegate *)[UIApplication sharedApplication].delegate) netState];
    //进行网络检查
    if (![self requestBeforeJudgeConnect]) {
        DLog(@"😠😠😠😠😠没有网络");
        //        [[NSNotificationCenter defaultCenter] postNotificationName:NoNet_Notification_Key object:self];
        
    }else{
        //        [[NSNotificationCenter defaultCenter] postNotificationName:Net_Notification_Key object:self];
    }
    
    //系统直接读取的版本号
    NSString *versionValueStringForSystemNow=[[NSBundle mainBundle].infoDictionary valueForKey:(NSString *)kCFBundleVersionKey];
    
    
    AFHTTPSessionManager *session = [AFHTTPSessionManager manager];
    session.requestSerializer.timeoutInterval =  10;
    session.responseSerializer = [AFHTTPResponseSerializer serializer];
    [session.requestSerializer setValue:@"sign" forHTTPHeaderField:@"sign"];
    [session.requestSerializer setValue:versionValueStringForSystemNow forHTTPHeaderField:@"version"];
    [session.requestSerializer setValue:@"iphone" forHTTPHeaderField:@"devType"];
    [session.requestSerializer setValue:[UIDevice currentDevice].name forHTTPHeaderField:@"devName"];
    [session.requestSerializer setValue:[NSString getUUID] forHTTPHeaderField:@"devId"];
    [session.requestSerializer setValue:[NSString deviceIPAdress] forHTTPHeaderField:@"ip"];
    [session.requestSerializer setValue:netStr forHTTPHeaderField:@"net"];
    [session.requestSerializer setValue:@"token" forHTTPHeaderField:@"token"];
    
    
    
    //get请求
    if (requestType == RequestTypeGet) {
        [session GET:url parameters:nil progress:^(NSProgress * _Nonnull downloadProgress) {
            
        } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            
            [self dealWithResponseObject:responseObject cacheUrl:cacheUrl cacheData:cacheData isCache:isCache  cacheKey:cacheKey success:^(NSDictionary *requestDic) {
                success(requestDic);
            } failure:^(NSString *errorInfo) {
                failure(errorInfo);
                
            }];
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            DLog(@"😠😠😠😠😠😠服务器出错,请联系管理员陈伟%@",error);
            [MBProgressHUD showError:@"😠😠😠😠😠服务器出错,请联系管理员陈伟"];
            dispatch_async(dispatch_get_main_queue(), ^{
                [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
            });
            
            
        }];
        
    }else  if (requestType == RequestTypePost) {
        
        [session POST:url parameters:parameters progress:^(NSProgress * _Nonnull uploadProgress) {
            
        } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            
            [self dealWithResponseObject:responseObject cacheUrl:cacheUrl cacheData:cacheData isCache:isCache  cacheKey:cacheKey success:^(NSDictionary *requestDic) {
                success(requestDic);
            } failure:^(NSString *errorInfo) {
                failure(errorInfo);
            }];
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            
            DLog(@"😠😠😠😠😠服务器出错,请联系管理员陈伟%@",error);
            
            dispatch_async(dispatch_get_main_queue(), ^{
                [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
                
                [MBProgressHUD showError:@"😠😠😠😠😠服务器出错,请联系管理员陈伟"];
            });
            
            
        }];
    }else if (requestType == RequestTypeUpLoad) {
        [session POST:url parameters:parameters constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
            NSTimeInterval timeInterVal = [[NSDate date] timeIntervalSince1970];
            NSString * fileName = [NSString stringWithFormat:@"%@.png",@(timeInterVal)];
            [formData appendPartWithFileData:data name:imageName fileName:fileName mimeType:@"image/png"];
        } progress:^(NSProgress * _Nonnull uploadProgress) {
            loadProgress((float)uploadProgress.completedUnitCount/(float)uploadProgress.totalUnitCount);
        } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            [self dealWithResponseObject:responseObject cacheUrl:cacheUrl cacheData:cacheData isCache:isCache cacheKey:nil success:^(NSDictionary *requestDic) {
                success(requestDic);
            } failure:^(NSString *errorInfo) {
                failure(errorInfo);
            }];
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            DLog(@"😠😠😠😠😠😠服务器出错,请联系管理员陈伟%@",error);
            [MBProgressHUD showError:@"😠😠😠😠😠服务器出错,请联系管理员陈伟"];
            dispatch_async(dispatch_get_main_queue(), ^{
                [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
            });
            
            
        }];
    }
    
}

#pragma mark  统一处理请求到的数据
-(void)dealWithResponseObject:(NSData *)responseData cacheUrl:(NSString *)cacheUrl cacheData:(id)cacheData isCache:(BOOL)isCache cacheKey:(NSString *)cacheKey success:(SuccessBlock)success failure :(FailureBlock)failure
{
    
    dispatch_async(dispatch_get_main_queue(), ^{
        [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
    });
    
    
    NSString * dataString = [[NSString alloc] initWithData:responseData encoding:NSUTF8StringEncoding];
    dataString = [self deleteSpecialCodeWithStr:dataString];
    NSData *requestData = [dataString dataUsingEncoding:NSUTF8StringEncoding];
    if (isCache) {
        [[YRYYCache share].yyCache setObject:requestData forKey:cacheKey];
    }
    //如果不缓存 或者 数据不相同 从网络请求
    if (!isCache || ![cacheData isEqual:requestData]) {
        [self returnDataWithRequestData:requestData Success:^(NSDictionary *requestDic) {
            success(requestDic);
        } failure:^(NSString *errorInfo) {
            failure(errorInfo);
        }];
    }
}

-(id)readCacheForKey:(NSString *)key{
    return [[YRYYCache share].yyCache objectForKey:key];
}

/**
 *  拼接post请求的网址
 *
 *  @param urlStr     基础网址
 *  @param parameters 拼接参数
 *
 *  @return 拼接完成的网址
 */
-(NSString *)urlDictToStringWithUrlStr:(NSString *)urlStr WithDict:(NSDictionary *)parameters
{
    if (!parameters) {
        return urlStr;
    }
    
    NSMutableArray *parts = [NSMutableArray array];
    [parameters enumerateKeysAndObjectsUsingBlock:^(id  _Nonnull key, id  _Nonnull obj, BOOL * _Nonnull stop) {
        NSString *part =[NSString stringWithFormat:@"%@=%@",key,obj];
        [parts addObject:part];
    }];
    
    NSString *queryString = [parts componentsJoinedByString:@"&"];
    NSString *pathStr = [NSString stringWithFormat:@"%@?%@",urlStr,queryString];
    return pathStr;
    
}


#pragma mark --根据返回的数据进行统一的格式处理  ----requestData 网络或者是缓存的数据----
- (void)returnDataWithRequestData:(NSData *)requestData Success:(SuccessBlock)success failure:(FailureBlock)failure{
    id myResult = [NSJSONSerialization JSONObjectWithData:requestData options:NSJSONReadingMutableContainers error:nil];
    
    //判断是否为字典
    if ([myResult isKindOfClass:[NSDictionary  class]]) {
        NSDictionary *  requestDic = (NSDictionary *)myResult;
        
        //根据返回的接口内容来变
        NSInteger ret = [requestDic[@"ret"] integerValue];
        
        NSString *msg = requestDic[@"msg"];
        if (ret == 1  || [msg isEqualToString:@"success"]) {
            success(requestDic[@"data"]);
        }else{
            failure(msg);
        }
    }
}

#pragma mark  网络判断
-(BOOL)requestBeforeJudgeConnect
{
    struct sockaddr zeroAddress;
    bzero(&zeroAddress, sizeof(zeroAddress));
    zeroAddress.sa_len = sizeof(zeroAddress);
    zeroAddress.sa_family = AF_INET;
    SCNetworkReachabilityRef defaultRouteReachability =
    SCNetworkReachabilityCreateWithAddress(NULL, (struct sockaddr *)&zeroAddress);
    SCNetworkReachabilityFlags flags;
    BOOL didRetrieveFlags =
    SCNetworkReachabilityGetFlags(defaultRouteReachability, &flags);
    CFRelease(defaultRouteReachability);
    if (!didRetrieveFlags) {
        printf("Error. Count not recover network reachability flags\n");
        return NO;
    }
    BOOL isReachable = flags & kSCNetworkFlagsReachable;
    BOOL needsConnection = flags & kSCNetworkFlagsConnectionRequired;
    BOOL isNetworkEnable  =(isReachable && !needsConnection) ? YES : NO;
    dispatch_async(dispatch_get_main_queue(), ^{
        [UIApplication sharedApplication].networkActivityIndicatorVisible =isNetworkEnable;/*  网络指示器的状态： 有网络 ： 开  没有网络： 关  */
    });
    return isNetworkEnable;
}

#pragma mark -- 处理json格式的字符串中的换行符、回车符
- (NSString *)deleteSpecialCodeWithStr:(NSString *)str {
    NSString *string = [str stringByReplacingOccurrencesOfString:@"\r" withString:@""];
    string = [string stringByReplacingOccurrencesOfString:@"\n" withString:@""];
    string = [string stringByReplacingOccurrencesOfString:@"\n" withString:@""];
    string = [string stringByReplacingOccurrencesOfString:@"\t" withString:@""];
    string = [string stringByReplacingOccurrencesOfString:@" " withString:@""];
    string = [string stringByReplacingOccurrencesOfString:@"(" withString:@""];
    string = [string stringByReplacingOccurrencesOfString:@")" withString:@""];
    return string;
}

@end







