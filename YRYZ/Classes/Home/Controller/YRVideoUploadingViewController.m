//
//  YRVideoUploadingViewController.m
//  YRYZ
//
//  Created by Mrs_zhang on 16/8/15.
//  Copyright © 2016年 yryz. All rights reserved.
//

#import "YRVideoUploadingViewController.h"

@interface YRVideoUploadingViewController ()

@end

@implementation YRVideoUploadingViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.title = @"视频上传";
    
    
//    NSString *endpoint = @"http://oss-cn-hangzhou.aliyuncs.com";
//    
//    // 明文设置secret的方式建议只在测试时使用，更多鉴权模式请参考后面的`访问控制`章节
//    id<OSSCredentialProvider> credential = [[OSSPlainTextAKSKPairCredentialProvider alloc] initWithPlainTextAccessKey:@"<your accessKeyId>"
//                                                                                                            secretKey:@"<your accessKeySecret>"];
//    
//    client = [[OSSClient alloc] initWithEndpoint:endpoint credentialProvider:credential];
//
//    
//    OSSPutObjectRequest * put = [OSSPutObjectRequest new];
//    
//    put.bucketName = @"<bucketName>";
//    put.objectKey = @"<objectKey>";
//    
//    
////    put.uploadingData = <NSData *>; // 直接上传NSData
//    
//    put.uploadProgress = ^(int64_t bytesSent, int64_t totalByteSent, int64_t totalBytesExpectedToSend) {
//        NSLog(@"%lld, %lld, %lld", bytesSent, totalByteSent, totalBytesExpectedToSend);
//    };
//    
//    OSSTask * putTask = [client putObject:put];
//    
//    [putTask continueWithBlock:^id(OSSTask *task) {
//        if (!task.error) {
//            NSLog(@"upload object success!");
//        } else {
//            NSLog(@"upload object failed, error: %@" , task.error);
//        }
//        return nil;
//    }];
//

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
