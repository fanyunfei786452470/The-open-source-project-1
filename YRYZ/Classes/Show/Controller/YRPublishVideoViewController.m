//
//  YRPublishVideoViewController.m
//  YRYZ
//
//  Created by Mrs_zhang on 16/8/12.
//  Copyright © 2016年 yryz. All rights reserved.
//

#import "YRPublishVideoViewController.h"
#import "YRReportTextView.h"
#import "YRShowVideoView.h"
#import <AliyunOSSiOS/OSSService.h>

@interface YRPublishVideoViewController ()<UIScrollViewDelegate>

@property (nonatomic,strong)YRReportTextView *textView;

@property (nonatomic,strong) UILabel *numberLab;

@property (nonatomic,strong) UIProgressView *progress;

@property (nonatomic,copy) NSString *UUIDVideoString;

@property (nonatomic,copy) NSString *UUIDImageString;

@end

OSSClient * Videoclient;
OSSClient * Imgclient;


@implementation YRPublishVideoViewController
- (void)viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:animated];
    }
- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"随手晒";
    
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"取消" style:UIBarButtonItemStylePlain target:self action:@selector(backAction)];
    
    UIButton *rightBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 60, 30)];
    [rightBtn setImage:[UIImage imageNamed:@"yr_show_edit"] forState:UIControlStateNormal];
    [rightBtn setTitle:@" 发布" forState:UIControlStateNormal];
    rightBtn.titleLabel.font = [UIFont systemFontOfSize:17.f];
    rightBtn.titleLabel.textColor = [UIColor whiteColor];
    [rightBtn addTarget:self action:@selector(publishAction) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem     *rightBarBtn = [[UIBarButtonItem alloc] initWithCustomView:rightBtn];
    self.navigationItem.rightBarButtonItem = rightBarBtn;

    
    UIScrollView *scrollView   = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT-64)];
    scrollView.backgroundColor = [UIColor whiteColor];
    scrollView.contentSize     = CGSizeMake(SCREEN_WIDTH, SCREEN_HEIGHT);
    scrollView.contentInset    = UIEdgeInsetsMake(0, 0, 10, 0);
    scrollView.delegate        = self;
    [self.view addSubview:scrollView];

    YRReportTextView *textView = [[YRReportTextView alloc] init];
    textView.mj_x              = 10.f;
    textView.mj_y              = 10.f;
    textView.mj_w              = SCREEN_WIDTH - 20;
    textView.mj_h              = 150.f;
    textView.font              = [UIFont systemFontOfSize:17.f];
    textView.placeholder       = @"写点什么来随手晒吧...";
    textView.clipsToBounds     = YES;
    self.textView              = textView;
    [scrollView addSubview:textView];

    CALayer *layer             = [CALayer layer];
    layer.frame                = CGRectMake(10, CGRectGetMaxY(textView.frame)+10, SCREEN_WIDTH-20, 1);
    layer.backgroundColor      = RGB_COLOR(245, 245, 245).CGColor;
    [scrollView.layer addSublayer:layer];

    UILabel *textNumber        = [[UILabel alloc] initWithFrame:CGRectMake(SCREEN_WIDTH-100, CGRectGetMaxY(textView.frame)+12, 52, 18)];
    textNumber.textAlignment   = NSTextAlignmentRight;
    textNumber.textColor       = [UIColor themeColor];
    textNumber.font            = [UIFont systemFontOfSize:15.f];
    textNumber.text            = @"0";
    self.numberLab             = textNumber;
    [scrollView addSubview:textNumber];

    UILabel *maxNumber         = [[UILabel alloc] initWithFrame:CGRectMake(SCREEN_WIDTH-48, CGRectGetMaxY(textView.frame)+12, 38, 18)];
    maxNumber.textAlignment    = NSTextAlignmentRight;
    maxNumber.textColor        = [UIColor lightGrayColor];
    maxNumber.font             = [UIFont systemFontOfSize:15.f];
    maxNumber.text             = @"/300";
    [scrollView addSubview:maxNumber];

    NSData *data               = [NSData dataWithContentsOfFile:self.thumbnailPath];
    UIImage *image             = [UIImage imageWithData:data];
    UIImageView *videoImg      = [[UIImageView alloc] initWithFrame:CGRectMake(10, CGRectGetMaxY(textView.frame)+40 , 150,100)];
    videoImg.image             = image;
    [scrollView addSubview:videoImg];

    UIProgressView *progress   = [[UIProgressView alloc]initWithProgressViewStyle:UIProgressViewStyleDefault];
    progress.frame             = CGRectMake(10, CGRectGetMaxY(videoImg.frame), 150, 2);
    progress.trackTintColor    = [UIColor whiteColor];
    progress.progress          = 0.0;
    progress.progressTintColor = [UIColor themeColor];
    self.progress              = progress;
    [scrollView addSubview:progress];

    UIButton *playBtn          = [UIButton buttonWithType:UIButtonTypeCustom];
    playBtn.frame              = CGRectMake(60, videoImg.mj_y+35, 50, 30);
    [playBtn setImage:[UIImage imageNamed:@"yr_show_video"] forState:UIControlStateNormal];
    [playBtn addTarget:self action:@selector(playVidelAction) forControlEvents:UIControlEventTouchUpInside];
    [scrollView addSubview:playBtn];

    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(textViewEditChanged:) name:@"UITextViewTextDidChangeNotification"object:textView];

    [self upLoading];
}

/**
 *  @author ZX, 16-07-28 16:07:35
 *
 *  发布
 */
- (void)publishAction{
    
    [self.view endEditing:YES];
    
    @weakify(self);
    if (self.progress.progress == 1.0f) {
        NSString *videoUrl = [NSString stringWithFormat:@"http://yryz-circle.oss-cn-hangzhou.aliyuncs.com/video/%@_iOS.mp4",self.UUIDVideoString];
        
        NSString *imageUrl = [NSString stringWithFormat:@"http://yryz-circle.oss-cn-hangzhou.aliyuncs.com/picture/%@_iOS.jpg",self.UUIDImageString];
        
        
        YRAlertView *alertView = [[YRAlertView alloc] initWithTitle:@"作品发布成功之后不能修改，也不能删除，确认发布?" cancelButtonText:@"取消" confirmButtonText:@"确定"];
        
        alertView.addCancelAction = ^{
            
        };
        alertView.addConfirmAction = ^{
            
            [MBProgressHUD showMessage:@""];

            [YRHttpRequest sendSunTextByCustContent:self.textView.text Pics:@[] VideoPic:imageUrl VideoUrl:videoUrl success:^(NSDictionary *data) {
                NSDate *senddate = [NSDate date];
                NSString *date2 = [NSString stringWithFormat:@"%ld", (long)[senddate timeIntervalSince1970]];
                NSDictionary *dic = @{@"comments":@[],
                                      @"content":self.textView.text?self.textView.text:@"",
                                      @"custId":[YRUserInfoManager manager].currentUser.custId?[YRUserInfoManager manager].currentUser.custId:@"",
                                      @"custImg":[YRUserInfoManager manager].currentUser.custImg?[YRUserInfoManager manager].currentUser.custImg:@"",
                                      @"custNname":[YRUserInfoManager manager].currentUser.custNname?[YRUserInfoManager manager].currentUser.custNname:@"",
                                      @"isLike":@(0),
                                      @"likes":@[],
                        
                                      @"pics":@[],
                                      @"sendTime":@"",
                                      @"sid":data[@"sid"]?data[@"sid"]:@"",
                                      @"timeStamp":date2,
                                      @"videoPic":imageUrl,
                                      @"videoUrl":videoUrl,
                                      };
                @strongify(self);
                [self dismissViewControllerAnimated:YES completion:^{
                    
                    if ([self.delegate respondsToSelector:@selector(getPublishVideoShowSunTextWithDic:)]) {
                        [self.delegate getPublishVideoShowSunTextWithDic:dic];
                    }
 
                }];
                [MBProgressHUD hideHUDForView:nil];
                [MBProgressHUD showError:@"发布成功"];
                
            } failure:^(NSString *errorInfo) {
                [MBProgressHUD hideHUDForView:nil];

                DLog(@"error:%@",errorInfo);
            }];
        };
        
        [alertView show];
        
    }else{
        [MBProgressHUD showError:@"视频上传中，请稍后"];
    }
}

/**
 *  @author ZX, 16-08-13 13:08:11
 *
 *  返回
 */
- (void)backAction{
    
    [self.view endEditing:YES];

    
    YRAlertView *alertView = [[YRAlertView alloc] initWithTitle:@"确认退出发布?" cancelButtonText:@"取消" confirmButtonText:@"确定"];
    
    alertView.addCancelAction = ^{
        
    };
    alertView.addConfirmAction = ^{
        
        [self dismissViewControllerAnimated:YES completion:nil];
    };
    [alertView show];
}

/**
 *  @author ZX, 16-08-12 16:08:35
 *
 *  播放视频
 */
- (void)playVidelAction{
    
    if (self.progress.progress == 1.0) {
        [self.view endEditing:YES];
        
        YRShowVideoView *videoView = [[YRShowVideoView alloc] initWithFrame:self.view.frame IsRequest:NO WithPathOrUrl:self.videoPath];
        [videoView show];
    }else{
        [MBProgressHUD showError:@"视频上传成功之后才能播放"];
    }

}

/**上传视频*/
- (void)upLoading{
    
    [self resumableUpload];
    [self upLoadingImage];
}

/**上传图片*/
- (void)upLoadingImage{
    //自实现签名，可以用本地签名也可以远程加签
    id<OSSCredentialProvider> credential1 = [[OSSCustomSignerCredentialProvider alloc] initWithImplementedSigner:^NSString *(NSString *contentToSign, NSError *__autoreleasing *error) {
    NSString *signature                   = [OSSUtil calBase64Sha1WithData:contentToSign withSecret:OSS_SECRETACCESSKEY];
        return [NSString stringWithFormat:@"OSS %@:%@", OSS_ACCESSKEYID, signature];
    }];
    NSString *endpoint                    = @"http://oss-cn-hangzhou.aliyuncs.com";
    OSSClientConfiguration * conf         = [OSSClientConfiguration new];
    conf.maxRetryCount                    = 2;
    conf.timeoutIntervalForRequest        = 30;
    conf.timeoutIntervalForResource       = 24 * 60 * 60;
    Imgclient                             = [[OSSClient alloc] initWithEndpoint:endpoint credentialProvider:credential1 clientConfiguration:conf];


    CFUUIDRef uuid                        = CFUUIDCreate(NULL);
    CFStringRef uuidstring                = CFUUIDCreateString(NULL, uuid);
    self.UUIDImageString                  = [NSString stringWithFormat:@"%@",uuidstring];

    OSSPutObjectRequest * put             = [OSSPutObjectRequest new];
    // 必填字段
    put.bucketName                        = OSS_BUCKETNAME;
    put.objectKey                         = [NSString stringWithFormat:@"picture/%@_iOS.jpg",self.UUIDImageString];
    put.uploadingFileURL                  = [NSURL fileURLWithPath:self.thumbnailPath];

    OSSTask * putTask                     = [Imgclient putObject:put];

    [putTask continueWithBlock:^id(OSSTask *task) {
        
        if (!task.error) {
            
        } else {
            
            NSLog(@"upload object failed, error: %@" , task.error);
        }
        return nil;
    }];
}

/**上传视频*/
- (void)resumableUpload {
    
    //自实现签名，可以用本地签名也可以远程加签
    id<OSSCredentialProvider> credential1 = [[OSSCustomSignerCredentialProvider alloc] initWithImplementedSigner:^NSString *(NSString *contentToSign, NSError *__autoreleasing *error) {
        NSString *signature = [OSSUtil calBase64Sha1WithData:contentToSign withSecret:OSS_SECRETACCESSKEY];
        return [NSString stringWithFormat:@"OSS %@:%@", OSS_ACCESSKEYID, signature];
    }];
    NSString *endpoint                            = @"http://oss-cn-hangzhou.aliyuncs.com";
    OSSClientConfiguration * conf                 = [OSSClientConfiguration new];
    conf.maxRetryCount                            = 2;
    conf.timeoutIntervalForRequest                = 30;
    conf.timeoutIntervalForResource               = 24 * 60 * 60;
    Videoclient                                   = [[OSSClient alloc] initWithEndpoint:endpoint credentialProvider:credential1 clientConfiguration:conf];
    __block NSString * recordKey;

    CFUUIDRef uuid                                = CFUUIDCreate(NULL);
    CFStringRef uuidstring                        = CFUUIDCreateString(NULL, uuid);
    self.UUIDVideoString                          = [NSString stringWithFormat:@"%@",uuidstring];

    NSString * bucketName                         = OSS_BUCKETNAME;

    NSString * objectKey                          = [NSString stringWithFormat:@"video/%@_iOS.mp4",self.UUIDVideoString];

    @weakify(self);
    [[[[[[OSSTask taskWithResult:nil] continueWithBlock:^id(OSSTask *task) {
        // 为该文件构造一个唯一的记录键
    NSURL * fileURL                               = [NSURL fileURLWithPath:self.videoPath];
        NSDate * lastModified;
        NSError * error;
        [fileURL getResourceValue:&lastModified forKey:NSURLContentModificationDateKey error:&error];
        if (error) {
            return [OSSTask taskWithError:error];
        }
    recordKey                                     = [NSString stringWithFormat:@"%@-%@-%@-%@", bucketName, objectKey, [OSSUtil getRelativePath:self.videoPath], lastModified];
        // 通过记录键查看本地是否保存有未完成的UploadId
    NSUserDefaults * userDefault                  = [NSUserDefaults standardUserDefaults];
        return [OSSTask taskWithResult:[userDefault objectForKey:recordKey]];
    }] continueWithSuccessBlock:^id(OSSTask *task) {
        if (!task.result) {
            // 如果本地尚无记录，调用初始化UploadId接口获取
    OSSInitMultipartUploadRequest * initMultipart = [OSSInitMultipartUploadRequest new];
    initMultipart.bucketName                      = bucketName;
    initMultipart.objectKey                       = objectKey;
    initMultipart.contentType                     = @"application/octet-stream";
            return [Videoclient multipartUploadInit:initMultipart];
        }
        OSSLogVerbose(@"An resumable task for uploadid: %@", task.result);
        return task;
    }] continueWithSuccessBlock:^id(OSSTask *task) {
    NSString * uploadId                           = nil;

        if (task.error) {
            return task;
        }

        if ([task.result isKindOfClass:[OSSInitMultipartUploadResult class]]) {
    uploadId                                      = ((OSSInitMultipartUploadResult *)task.result).uploadId;
        } else {
    uploadId                                      = task.result;
        }

        if (!uploadId) {
            return [OSSTask taskWithError:[NSError errorWithDomain:OSSClientErrorDomain
                                                              code:OSSClientErrorCodeNilUploadid
                                                          userInfo:@{OSSErrorMessageTOKEN: @"Can't get an upload id"}]];
        }
        // 将“记录键：UploadId”持久化到本地存储
    NSUserDefaults * userDefault                  = [NSUserDefaults standardUserDefaults];
        [userDefault setObject:uploadId forKey:recordKey];
        [userDefault synchronize];
        return [OSSTask taskWithResult:uploadId];
    }] continueWithSuccessBlock:^id(OSSTask *task) {
        // 持有UploadId上传文件
    OSSResumableUploadRequest * resumableUpload   = [OSSResumableUploadRequest new];
    resumableUpload.bucketName                    = bucketName;
    resumableUpload.objectKey                     = objectKey;
    resumableUpload.uploadId                      = task.result;
    resumableUpload.uploadingFileURL              = [NSURL fileURLWithPath:self.videoPath];
    resumableUpload.uploadProgress                = ^(int64_t bytesSent, int64_t totalBytesSent, int64_t totalBytesExpectedToSend) {
            @strongify(self);

    CGFloat progress                              = (CGFloat)totalBytesSent/totalBytesExpectedToSend;

            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.01 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                @strongify(self);
                if (progress == 1.0f) {
                    [self.progress setProgress:progress animated:YES];
                    [MBProgressHUD showError:@"视频上传成功！"];
                }
            });

        };
        return [Videoclient resumableUpload:resumableUpload];
    }] continueWithBlock:^id(OSSTask *task) {
        if (task.error) {


            if ([task.error.domain isEqualToString:OSSClientErrorDomain] && task.error.code == OSSClientErrorCodeCannotResumeUpload) {
                // 如果续传失败且无法恢复，需要删除本地记录的UploadId，然后重启任务
                [[NSUserDefaults standardUserDefaults] removeObjectForKey:recordKey];
            }
        } else {
            NSLog(@"upload completed!");
            // 上传成功，删除本地保存的UploadId
            [[NSUserDefaults standardUserDefaults] removeObjectForKey:recordKey];
        }
        return nil;
    }];
}

#pragma mark - ScrollViewDelegate

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView{

    [self.view endEditing:YES];
}

#pragma mark - 文字改变
- (void)textViewEditChanged:(NSNotification *)obj {
    
    self.textView = (YRReportTextView *)obj.object;
    NSString *toBeString = self.textView.text;
    NSString *lang = [[UIApplication sharedApplication]textInputMode].primaryLanguage;
    if ([lang isEqualToString:@"zh-Hans"]) {
        UITextRange *selectedRange = [self.textView markedTextRange];
        UITextPosition *position = [self.textView positionFromPosition:selectedRange.start offset:0];
        if (!position) {
            if (self.textView.text.length == 0) {
                self.textView.placeholder = @"晒一晒...";
                self.numberLab.text = @"0";
            }else{
                self.textView.placeholder = @"";
                NSInteger  anumber =  [self.textView.text length];
                if ([self.textView.text length] > 300) {
                    self.numberLab.text = @"300";
                }else {
                    self.numberLab.text = [NSString stringWithFormat:@"%ld",(long)anumber];
                }
            }
            if (toBeString.length > 300) {
                self.textView.text = [toBeString substringToIndex:300];
            }
            if ([self.textView.text isEqualToString:@"\n"]){
                [self.textView resignFirstResponder];
            }
        }else {
            
        }
    }else {
        if (self.textView.text.length == 0) {
            self.textView.placeholder = @"晒一晒...";
            self.numberLab.text = @"0";
        }else{
            if ([self.textView.text isEqualToString:@"\n"]){
                [self.textView resignFirstResponder];
                
            }
            if (toBeString.length > 300) {
                self.textView.text = [toBeString substringToIndex:300];
            }else {
                self.textView.placeholder = @"";
                NSInteger  anumber =  [self.textView.text length];
                if ([self.textView.text length] > 300) {
                    self.numberLab.text = @"300";
                }else {
                    self.numberLab.text = [NSString stringWithFormat:@"%ld",(long)anumber];
                }
            }
        }
    }
}
- (void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
