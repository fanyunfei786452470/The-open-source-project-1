//
//  YRSendVideoPosterViewController.m
//  YRYZ
//
//  Created by Mrs_zhang on 16/8/19.
//  Copyright © 2016年 yryz. All rights reserved.
//

#import "YRSendVideoPosterViewController.h"
#import "YRReportTextView.h"
#import "YRShowVideoView.h"
#import <AliyunOSSiOS/OSSService.h>
@interface YRSendVideoPosterViewController ()
{
    NSTimer *timer;
}
@property (nonatomic,strong)YRReportTextView *textView;

@property (nonatomic,strong) UILabel *numberLab;

@property (nonatomic,strong) UIProgressView *planProgress;

@property (nonatomic,assign) CGFloat progress;

@property (nonatomic,assign) NSInteger isNoWiFiCount;
@end
OSSClient * videoClient;

static dispatch_queue_t queue4demo;
@implementation YRSendVideoPosterViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"发布视频广告";
    
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"yr_return"] style:UIBarButtonItemStylePlain target:self action:@selector(backAction)];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"下一步" style:UIBarButtonItemStylePlain target:self action:@selector(publishAction)];
    
    UIScrollView *scrollView   = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT-64)];
    scrollView.backgroundColor = [UIColor whiteColor];
    scrollView.contentSize     = CGSizeMake(SCREEN_WIDTH, SCREEN_HEIGHT);
    scrollView.scrollEnabled   = NO;
    [self.view addSubview:scrollView];
    
    CALayer *layerOne        = [CALayer layer];
    layerOne.frame           = CGRectMake(0, 0, SCREEN_WIDTH, 10);
    layerOne.backgroundColor = RGB_COLOR(245, 245, 245).CGColor;
    [scrollView.layer addSublayer:layerOne];
    
    YRReportTextView *textView = [[YRReportTextView alloc] init];
    textView.mj_x              = 10.f;
    textView.mj_y              = 20.f;
    textView.mj_w              = SCREEN_WIDTH - 20;
    textView.mj_h              = 200.f;
    textView.font              = [UIFont systemFontOfSize:17.f];
    textView.placeholder       = @"好的广告内容可以吸引更多人哦";
    textView.clipsToBounds     = YES;
    self.textView              = textView;
    [scrollView addSubview:textView];
    
    UILabel *textNumber      = [[UILabel alloc] initWithFrame:CGRectMake(SCREEN_WIDTH-110, CGRectGetMaxY(textView.frame)+12, 52, 18)];
    textNumber.textAlignment = NSTextAlignmentRight;
    textNumber.textColor     = [UIColor themeColor];
    textNumber.font          = [UIFont systemFontOfSize:15.f];
    textNumber.text          = @"0";
    [scrollView addSubview:textNumber];
    self.numberLab = textNumber;
    
    UILabel *maxNumber      = [[UILabel alloc] initWithFrame:CGRectMake(SCREEN_WIDTH-58, CGRectGetMaxY(textView.frame)+12, 48, 18)];
    maxNumber.textAlignment = NSTextAlignmentRight;
    maxNumber.textColor     = [UIColor lightGrayColor];
    maxNumber.font          = [UIFont systemFontOfSize:15.f];
    maxNumber.text          = @"/1000";
    [scrollView addSubview:maxNumber];
    
    CALayer *layer        = [CALayer layer];
    layer.frame           = CGRectMake(0, CGRectGetMaxY(textNumber.frame)+10, SCREEN_WIDTH, 10);
    layer.backgroundColor = RGB_COLOR(245, 245, 245).CGColor;
    [scrollView.layer addSublayer:layer];
    
    UIImageView *videoImg = [[UIImageView alloc] initWithFrame:CGRectMake(10, CGRectGetMaxY(textNumber.frame)+40 , 150,100)];
    videoImg.image        = self.thumbnailImg;
    [scrollView addSubview:videoImg];
    
    UIButton *playBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    playBtn.frame     = CGRectMake(60, videoImg.mj_y+35, 50, 30);
    [playBtn setImage:[UIImage imageNamed:@"yr_show_video"] forState:UIControlStateNormal];
    [playBtn addTarget:self action:@selector(playVidelAction) forControlEvents:UIControlEventTouchUpInside];
    [scrollView addSubview:playBtn];
    
    UIProgressView *planLab   = [[UIProgressView alloc]initWithProgressViewStyle:UIProgressViewStyleDefault];
    planLab.frame             = CGRectMake(10, CGRectGetMaxY(videoImg.frame), 150, 2);
    planLab.trackTintColor    = [UIColor whiteColor];
    planLab.progressTintColor = [UIColor themeColor];
    planLab.progress          = 0.0;
    [scrollView addSubview:planLab];
    self.planProgress = planLab;
    
    CALayer *layerBottom        = [CALayer layer];
    layerBottom.frame           = CGRectMake(0, SCREEN_HEIGHT-50-64 , SCREEN_WIDTH, 500);
    layerBottom.backgroundColor = RGB_COLOR(245, 245, 245).CGColor;
    [scrollView.layer addSublayer:layerBottom];
    
    UILabel *waringLab      = [[UILabel alloc] initWithFrame:CGRectMake(20, SCREEN_HEIGHT-45-64, SCREEN_WIDTH-40, 40)];
    waringLab.text          = @"视频时长不超过60s,如果需要上传大的视频请进入:http://www.yryz.com进行发布";
    waringLab.numberOfLines = 3;
    waringLab.font          = [UIFont systemFontOfSize:13.f];
    waringLab.textAlignment = NSTextAlignmentCenter;
    waringLab.textColor     = [UIColor lightGrayColor];
    [scrollView addSubview:waringLab];
    
    
    [self updataVideo];
    
    
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(textViewEditChanged:) name:@"UITextViewTextDidChangeNotification"object:textView];


    
    timer = [NSTimer scheduledTimerWithTimeInterval:0.2 target:self selector:@selector(changeProgress) userInfo:nil repeats:YES];
}

- (void)changeProgress{
    if (self.progress == 1.0) {
        [timer invalidate];
        [MBProgressHUD showError:@"视频上传成功！"];
        timer.fireDate = [NSDate distantFuture];
        
    }
    
    if (self.isNoWiFiCount == 1) {
        
        YRAlertView *alertView = [[YRAlertView alloc] initWithTitle:@"网络出现故障，请检查网络并重新上传" cancelButtonText:@"取消" confirmButtonText:@"确定"];
        
        alertView.addCancelAction = ^{
            
        };
        alertView.addConfirmAction = ^{
            
            [self.navigationController popViewControllerAnimated:YES];
            
        };
        [alertView show];
        
        self.isNoWiFiCount = 2;
        
    }
    
    [self.planProgress setProgress:self.progress animated:YES];
}


/**
 *  @author ZX, 16-07-28 16:07:35
 *
 *  发布
 */
- (void)publishAction{
    
    [MBProgressHUD showError:@"下一步"];

}
/**
 *  @author ZX, 16-08-13 13:08:11
 *
 *  返回
 */
- (void)backAction{
    
    YRAlertView *alertView = [[YRAlertView alloc] initWithTitle:@"确定退出编辑?" cancelButtonText:@"取消" confirmButtonText:@"确定"];
    
    alertView.addCancelAction = ^{
        
    };
    alertView.addConfirmAction = ^{
    
    [self.navigationController popViewControllerAnimated:YES];
        
    };
    [alertView show];
    
}
/**
 *  @author ZX, 16-08-12 16:08:35
 *
 *  播放视频
 */
- (void)playVidelAction{
    
     if (self.progress == 1.0) {
        YRShowVideoView *videoView = [[YRShowVideoView alloc] initWithFrame:self.view.frame IsRequest:NO WithPathOrUrl:self.videoPath];
        [videoView show];
     }else{
     
         [MBProgressHUD showError:@"视频上传成功之后才能播放"];
     }
  
}
- (void)updataVideo{
    //自实现签名，可以用本地签名也可以远程加签
    id<OSSCredentialProvider> credential1 = [[OSSCustomSignerCredentialProvider alloc] initWithImplementedSigner:^NSString *(NSString *contentToSign, NSError *__autoreleasing *error) {
        NSString *signature = [OSSUtil calBase64Sha1WithData:contentToSign withSecret:@"wzZjbJwDpzxN9smCMUZIIHt3HpEeVs"];
        if (signature != nil) {
            //                *error = nil;
        } else {
            // construct error object
            //            *error = [NSError errorWithDomain:@"<your error domain>" code:OSSClientErrorCodeSignFailed userInfo:nil];
            return nil;
        }
        return [NSString stringWithFormat:@"OSS %@:%@", @"Oul8T3WUa6qjuLLm", signature];
    }];
    
    NSString *endpoint = @"http://oss-cn-hangzhou.aliyuncs.com";
    OSSClientConfiguration * conf = [OSSClientConfiguration new];
    conf.maxRetryCount = 2;
    conf.timeoutIntervalForRequest = 30;
    conf.timeoutIntervalForResource = 24 * 60 * 60;
    videoClient = [[OSSClient alloc] initWithEndpoint:endpoint credentialProvider:credential1 clientConfiguration:conf];
    
    [self resumableUpload];
}


// 断点续传
- (void)resumableUpload {
    __block NSString * recordKey;
    
    NSDate *currentDate = [NSDate date];//获取当前时间，日期
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"YYYY/MM/dd hh:mm:ss SS"];
    NSString *dateString = [dateFormatter stringFromDate:currentDate];
    
    NSString * bucketName = @"yryz";
    
    NSString * objectKey = [NSString stringWithFormat:@"yryz_ios_%@.mp4",dateString];
    
    
    [[[[[[OSSTask taskWithResult:nil] continueWithBlock:^id(OSSTask *task) {
        // 为该文件构造一个唯一的记录键
        NSURL * fileURL = [NSURL fileURLWithPath:self.videoPath];
        NSDate * lastModified;
        NSError * error;
        [fileURL getResourceValue:&lastModified forKey:NSURLContentModificationDateKey error:&error];
        if (error) {
            return [OSSTask taskWithError:error];
        }
        recordKey = [NSString stringWithFormat:@"%@-%@-%@-%@", bucketName, objectKey, [OSSUtil getRelativePath:self.videoPath], lastModified];
        // 通过记录键查看本地是否保存有未完成的UploadId
        NSUserDefaults * userDefault = [NSUserDefaults standardUserDefaults];
        return [OSSTask taskWithResult:[userDefault objectForKey:recordKey]];
    }] continueWithSuccessBlock:^id(OSSTask *task) {
        if (!task.result) {
            // 如果本地尚无记录，调用初始化UploadId接口获取
            OSSInitMultipartUploadRequest * initMultipart = [OSSInitMultipartUploadRequest new];
            initMultipart.bucketName = bucketName;
            initMultipart.objectKey = objectKey;
            initMultipart.contentType = @"application/octet-stream";
            return [videoClient multipartUploadInit:initMultipart];
        }
        OSSLogVerbose(@"An resumable task for uploadid: %@", task.result);
        return task;
    }] continueWithSuccessBlock:^id(OSSTask *task) {
        NSString * uploadId = nil;
        
        if (task.error) {
            return task;
        }
        
        if ([task.result isKindOfClass:[OSSInitMultipartUploadResult class]]) {
            uploadId = ((OSSInitMultipartUploadResult *)task.result).uploadId;
        } else {
            uploadId = task.result;
        }
        
        if (!uploadId) {
            return [OSSTask taskWithError:[NSError errorWithDomain:OSSClientErrorDomain
                                                              code:OSSClientErrorCodeNilUploadid
                                                          userInfo:@{OSSErrorMessageTOKEN: @"Can't get an upload id"}]];
        }
        // 将“记录键：UploadId”持久化到本地存储
        NSUserDefaults * userDefault = [NSUserDefaults standardUserDefaults];
        [userDefault setObject:uploadId forKey:recordKey];
        [userDefault synchronize];
        return [OSSTask taskWithResult:uploadId];
    }] continueWithSuccessBlock:^id(OSSTask *task) {
        // 持有UploadId上传文件
        OSSResumableUploadRequest * resumableUpload = [OSSResumableUploadRequest new];
        resumableUpload.bucketName = bucketName;
        resumableUpload.objectKey = objectKey;
        resumableUpload.uploadId = task.result;
        resumableUpload.uploadingFileURL = [NSURL fileURLWithPath:self.videoPath];
        resumableUpload.uploadProgress = ^(int64_t bytesSent, int64_t totalBytesSent, int64_t totalBytesExpectedToSend) {
            CGFloat progress = (CGFloat)totalBytesSent/totalBytesExpectedToSend;
            self.progress = progress;
        };
        return [videoClient resumableUpload:resumableUpload];
    }] continueWithBlock:^id(OSSTask *task) {
        if (task.error) {
            self.isNoWiFiCount = 1;

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
                self.textView.placeholder = @"好的广告内容可以吸引更多人哦";
                self.numberLab.text = @"0";
            }else{
                self.textView.placeholder = @"";
                NSInteger  anumber =  [self.textView.text length];
                if ([self.textView.text length] > 1000) {
                    self.numberLab.text = @"1000";
                }else {
                    self.numberLab.text = [NSString stringWithFormat:@"%ld",(long)anumber];
                }
            }
            if (toBeString.length > 1000) {

                self.textView.text = [toBeString substringToIndex:1000];
            }
            if ([self.textView.text isEqualToString:@"\n"]){
                [self.textView resignFirstResponder];
            }
        }else {
            
        }
    }else {
        if (self.textView.text.length == 0) {
            self.textView.placeholder = @"好的广告内容可以吸引更多人哦";
            self.numberLab.text = @"0";
        }else{
            if ([self.textView.text isEqualToString:@"\n"]){
                [self.textView resignFirstResponder];
                
            }
            if (toBeString.length > 1000) {

                self.textView.text = [toBeString substringToIndex:1000];
            }else {
                self.textView.placeholder = @"";
                NSInteger  anumber =  [self.textView.text length];
                if ([self.textView.text length] > 1000) {
                    self.numberLab.text = @"1000";
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
