//
//  YRSendVideoPosterViewController.m
//  YRYZ
//
//  Created by Mrs_zhang on 16/8/19.
//  Copyright © 2016年 yryz. All rights reserved.
//

#import "YRSendVideoPosterViewController.h"
#import "YRRedPaperAdPaymemtViewController.h"
#import "YRReportTextView.h"
#import "YRShowVideoView.h"
#import "YRAudioTipView.h"
#import "YRDataPickerView.h"
#import <AliyunOSSiOS/OSSService.h>
#import "YRRedAdsPaymentModel.h"
//#import "IQKeyboardManager.h"
@interface YRSendVideoPosterViewController ()<UITextFieldDelegate>
{
    NSTimer *timer;
}
@property (nonatomic,copy) NSString *UUIDString;
@property (nonatomic,strong)YRReportTextView *textView;
@property (nonatomic,strong) UILabel *numberLab;
@property (nonatomic,strong) UIProgressView *planProgress;
@property (nonatomic,assign) CGFloat progress;
@property (nonatomic,assign) NSInteger isNoWiFiCount;
@property (nonatomic,strong) UIView * bottomView;//底部View
@property (nonatomic,strong) UITextField * teleField;//手机输入框
@property (nonatomic,strong) UILabel * timeField;//选择日期
@property (nonatomic,strong) YRAudioTipView * tipView;//最底部提示View
@property (nonatomic,strong) UITextField * titleTextField;//标题
@property (nonatomic,strong) UILabel * titleNumLab;//统计标题文字
@property (nonatomic,strong) NSString * timetemp;//时间戳
@property (nonatomic,assign) NSInteger locateTime;//获取当前时间
@property (nonatomic,assign) NSInteger chooseTime;//获取选择时间
@property (nonatomic,strong) YRRedAdsPaymentModel * model;
@property (nonatomic,strong) UIScrollView *scrollView;
@property (nonatomic,copy) NSString   *UUIDImageString;

@end
OSSClient * videoClient;
OSSClient * sendImageClient;
static dispatch_queue_t queue4demo;
@implementation YRSendVideoPosterViewController

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
//    [IQKeyboardManager sharedManager].enable = NO;
}
- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
//    [IQKeyboardManager sharedManager].enable = YES;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"发布视频广告";
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"yr_return"] style:UIBarButtonItemStylePlain target:self action:@selector(backAction)];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"下一步" style:UIBarButtonItemStylePlain target:self action:@selector(publishAction)];
    
    _scrollView   = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT-64)];
    _scrollView.backgroundColor = [UIColor whiteColor];
    _scrollView.contentSize     = CGSizeMake(SCREEN_WIDTH, SCREEN_HEIGHT+110);
    _scrollView.scrollEnabled   = YES;
    _scrollView.keyboardDismissMode = UIScrollViewKeyboardDismissModeOnDrag;
    [self.view addSubview:_scrollView];
    
    CALayer *layerOne        = [CALayer layer];
    layerOne.frame           = CGRectMake(0, 0, SCREEN_WIDTH, 10);
    layerOne.backgroundColor = RGB_COLOR(245, 245, 245).CGColor;
    [_scrollView.layer addSublayer:layerOne];
    
    UIView * titleView = [[UIView alloc]initWithFrame:CGRectMake(0, 10, SCREEN_WIDTH, 44)];
    [_scrollView addSubview:titleView];
    
    CALayer *layertitle        = [CALayer layer];
    layertitle.frame           = CGRectMake(0, CGRectGetMaxY(titleView.frame), SCREEN_WIDTH, 10);
    layertitle.backgroundColor = RGB_COLOR(245, 245, 245).CGColor;
    [_scrollView.layer addSublayer:layertitle];
    
    //添加标题
    
    NSMutableAttributedString *art = [[NSMutableAttributedString alloc]initWithString:@"添加广告标题(30个字以内)" attributes:@{NSFontAttributeName:[UIFont boldSystemFontOfSize:20],NSForegroundColorAttributeName:RGB_COLOR(126, 126, 126)}];
    
    [art addAttribute:NSFontAttributeName
     
                          value:[UIFont systemFontOfSize:16.0]
     
                          range:NSMakeRange(6, 8)];
    
    [art addAttribute:NSForegroundColorAttributeName
     
                          value:RGB_COLOR(153, 153, 153)
     
                          range:NSMakeRange(6, 8)];
    UITextField *addtitleTextField = [[UITextField alloc] initWithFrame:CGRectMake(15, 0, SCREEN_WIDTH-80, 44)];
    addtitleTextField.delegate     = self;
    addtitleTextField.font         = [UIFont boldSystemFontOfSize:20.f];
    addtitleTextField.attributedPlaceholder = art;
    [titleView addSubview:addtitleTextField];
    self.titleTextField = addtitleTextField;
    
    UILabel *titleMin      = [[UILabel alloc] initWithFrame:CGRectMake(SCREEN_WIDTH-63, 12, 25, 20)];
    titleMin.textAlignment = NSTextAlignmentRight;
    titleMin.textColor     = [UIColor themeColor];
    titleMin.font          = [UIFont systemFontOfSize:15.f];
    titleMin.text          = @"0";
    [titleView addSubview:titleMin];
    self.titleNumLab = titleMin;
    
    UILabel *titleMax      = [[UILabel alloc] initWithFrame:CGRectMake(SCREEN_WIDTH-38, 12, 30, 20)];
    titleMax.textAlignment = NSTextAlignmentLeft;
    titleMax.textColor     = [UIColor lightGrayColor];
    titleMax.font          = [UIFont systemFontOfSize:15.f];
    titleMax.text          = @"/30";
    [titleView addSubview:titleMax];
    
    [addtitleTextField addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
    
    _textView = [[YRReportTextView alloc] init];
    _textView.mj_x              = 10.f;
    _textView.mj_y              = 64.f;
    _textView.mj_w              = SCREEN_WIDTH - 20;
    _textView.mj_h              = 200.f;
    _textView.font              = [UIFont systemFontOfSize:17.f];
    _textView.placeholder       = @"好的广告内容可以吸引更多人哦";
    _textView.clipsToBounds     = YES;
    [_scrollView addSubview:_textView];
    
    UILabel *textNumber      = [[UILabel alloc] initWithFrame:CGRectMake(SCREEN_WIDTH-130, CGRectGetMaxY(_textView.frame)+12, 60, 18)];
    textNumber.textAlignment = NSTextAlignmentRight;
    textNumber.textColor     = [UIColor themeColor];
    textNumber.font          = [UIFont systemFontOfSize:15.f];
    textNumber.text          = @"0";
    [_scrollView addSubview:textNumber];
    self.numberLab = textNumber;
    
    UILabel *maxNumber      = [[UILabel alloc] initWithFrame:CGRectMake(SCREEN_WIDTH-70, CGRectGetMaxY(_textView.frame)+12, 60, 18)];
    maxNumber.textAlignment = NSTextAlignmentLeft;
    maxNumber.textColor     = [UIColor lightGrayColor];
    maxNumber.font          = [UIFont systemFontOfSize:15.f];
    maxNumber.text          = @"/1000";
    [_scrollView addSubview:maxNumber];
    
    CALayer *layer        = [CALayer layer];
    layer.frame           = CGRectMake(0, CGRectGetMaxY(textNumber.frame)+10, SCREEN_WIDTH, 10);
    layer.backgroundColor = RGB_COLOR(245, 245, 245).CGColor;
    [_scrollView.layer addSublayer:layer];
    
    UIImageView *videoImg = [[UIImageView alloc] initWithFrame:CGRectMake(10, CGRectGetMaxY(textNumber.frame)+40 , 150,100)];
    videoImg.image        = self.thumbnailImg;
    [_scrollView addSubview:videoImg];
    
    UIButton *playBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    playBtn.frame     = CGRectMake(60, videoImg.mj_y+35, 50, 30);
    [playBtn setImage:[UIImage imageNamed:@"yr_show_video"] forState:UIControlStateNormal];
    [playBtn addTarget:self action:@selector(playVidelAction) forControlEvents:UIControlEventTouchUpInside];
    [_scrollView addSubview:playBtn];
    
    UIProgressView *planLab   = [[UIProgressView alloc]initWithProgressViewStyle:UIProgressViewStyleDefault];
    planLab.frame             = CGRectMake(10, CGRectGetMaxY(videoImg.frame), 150, 2);
    planLab.trackTintColor    = [UIColor whiteColor];
    planLab.progressTintColor = [UIColor themeColor];
    planLab.progress          = 0.0;
    [_scrollView addSubview:planLab];
    self.planProgress = planLab;
    
    CALayer *layerBottom        = [CALayer layer];
    layerBottom.frame           = CGRectMake(0, SCREEN_HEIGHT-50-64 , SCREEN_WIDTH, 500);
    layerBottom.backgroundColor = RGB_COLOR(245, 245, 245).CGColor;
    [_scrollView.layer addSublayer:layerBottom];
    
    _bottomView = [[UIView alloc]initWithFrame:CGRectMake(0, SCREEN_HEIGHT-40-64, SCREEN_WIDTH, 180)];
    [_scrollView addSubview:_bottomView];
    
    UIView * teleView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 50)];
    teleView.backgroundColor = [UIColor whiteColor];
    [_bottomView addSubview:teleView];
    
    UILabel*  teleLabel = [[UILabel alloc]initWithFrame:CGRectMake(10, 5, 120, 40)];
    teleLabel.text = @"请输入手机号:";
    teleLabel.textColor = [UIColor blackColor];
    [teleView addSubview:teleLabel];
    
    _teleField = [[UITextField alloc]initWithFrame:CGRectMake(SCREEN_WIDTH- 125, 5, 115, 40)];
    _teleField.placeholder = @"请输入手机号";
    _teleField.keyboardType = UIKeyboardTypeNumberPad;
    _teleField.textColor = [UIColor themeColor];
    _teleField.delegate =self;
    [teleView addSubview:_teleField];
    
    UIView * timeView = [[UIView alloc]initWithFrame:CGRectMake(0, 50, SCREEN_WIDTH, 50)];
    timeView.backgroundColor = [UIColor whiteColor];
    [_bottomView addSubview:timeView];
    
    UILabel*  timeLabel = [[UILabel alloc]initWithFrame:CGRectMake(10, 5, 120, 40)];
    timeLabel.text = @"期望发布时间:";
    timeLabel.textColor = [UIColor blackColor];
    [timeView addSubview:timeLabel];
    
    _timeField = [[UILabel alloc]initWithFrame:CGRectMake(SCREEN_WIDTH- 125, 5, 115, 35)];
    _timeField.text = @"请选择日期";
    _timeField.textColor = RGB_COLOR(200, 200, 200);
    _timeField.userInteractionEnabled = YES;
    UITapGestureRecognizer * timetap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(timeLable:)];
    [_timeField addGestureRecognizer:timetap];
    [timeView addSubview:_timeField];
    
    _tipView = [[YRAudioTipView alloc]initWithFrame:CGRectMake(0, 100, SCREEN_WIDTH, 130)];
    _tipView.firstText = @"广告期望发布时间:当前日期后2天至60天内;";
    _tipView.secondText= @"如果用户不选发布时间,审核通过后立即发布。";
    _tipView.thirdText = @"视频时长不超过60s,如果需要上传大的视频,请进入:http://www.yryz.com 进行发布";
    [_bottomView addSubview:_tipView];
    [self upLoadingImage];
    [self updataVideo];
    
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(textViewEditChanged:) name:@"UITextViewTextDidChangeNotification"object:_textView];
    timer = [NSTimer scheduledTimerWithTimeInterval:0.2 target:self selector:@selector(changeProgress) userInfo:nil repeats:YES];
    NSNotificationCenter * nc = [NSNotificationCenter defaultCenter];
    UITapGestureRecognizer * tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(KeyBroad:)];
    NSOperationQueue * main = [NSOperationQueue mainQueue];
    [nc addObserverForName:UIKeyboardWillShowNotification object:nil queue:main usingBlock:^(NSNotification * _Nonnull note) {
        [self.view addGestureRecognizer:tap];
    }];
    [nc addObserverForName:UIKeyboardWillHideNotification object:nil queue:main usingBlock:^(NSNotification * _Nonnull note) {
        [self.view removeGestureRecognizer:tap];
    }];
    // 键盘将要出来
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    //2.监听键盘退出，放回原位
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
}
#pragma mark 键盘出现
-(void)keyboardWillShow:(NSNotification *)note
{
    CGRect keyBoardRect=[note.userInfo[UIKeyboardFrameEndUserInfoKey] CGRectValue];
    self.scrollView.contentInset = UIEdgeInsetsMake(0, 0, keyBoardRect.size.height, 0);
}
#pragma mark 键盘消失
-(void)keyboardWillHide:(NSNotification *)note
{
    self.scrollView.contentInset = UIEdgeInsetsZero;
}
- (void)KeyBroad:(UITapGestureRecognizer *)sender{
    
    [self.view endEditing:YES];
}
#pragma 时间选择
-(void)timeLable:(UITapGestureRecognizer *)sender{
    
    [self.view endEditing:YES];
    YRDataPickerView *datePickerView = [[YRDataPickerView alloc] initWithFrame:CGRectMake(0, SCREEN_HEIGHT -344*SCREEN_POINT, SCREEN_WIDTH, 344*SCREEN_POINT)];
    [self.view addSubview:datePickerView];
    [datePickerView getDateWithBlock:^(NSDate *date) {
        NSTimeZone *zone = [NSTimeZone systemTimeZone];
        NSInteger interval = [zone secondsFromGMTForDate: date];
        NSDate *localeDate = [date  dateByAddingTimeInterval: interval];
        
        _locateTime = [[self getCurrentTimestamp]integerValue]/86400;
        _chooseTime = [[self timesTampWithTime:[self dateToDateString:date]] integerValue]/86400;
        _timetemp = [self timesTampWithTime:[self dateToDateString:date]] ;
        if ((_chooseTime - _locateTime)>59) {
            
            [MBProgressHUD showError:@"不能超过60天"];
        }else if((_chooseTime -_locateTime)<1){
            
            [MBProgressHUD showError:@"日期选择不正确"];
        }else{
            _timeField.textColor = [UIColor themeColor];
            self.timeField.text = [self dateToDateString:localeDate];
        }
    }];
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
    [self.view endEditing:YES];
    if([self.textView.text isEqualToString:@""]){
        [MBProgressHUD showError:@"您还没有添加描述"];
    }else if(self.textView.text.length >1000){
        [MBProgressHUD showError:@"描述不能超过1000个字"];
    }else if([self.titleTextField.text isEqualToString:@""]){
        [MBProgressHUD showError:@"请添加标题"];
    }else if(self.teleField.text.length == 0){
        [MBProgressHUD showError:@"请输入手机号"];
    }else if(self.timeField.text.length == 0){
        [MBProgressHUD showError:@"请选择发布时间"];
    }else if(self.progress != 1.0){
        [MBProgressHUD showError:@"视频上传中，请稍后"];
    }else{
        NSString *videoUrl = [NSString stringWithFormat:@"http://yryz-circle.oss-cn-hangzhou.aliyuncs.com/video/%@_iOS.mp4",self.UUIDString];
        NSString *imageUrl = [NSString stringWithFormat:@"http://yryz-circle.oss-cn-hangzhou.aliyuncs.com/picture/%@_iOS.jpg",self.UUIDImageString];
        
//        YRAlertView *alertView = [[YRAlertView alloc] initWithTitle:@"作品发布成功之后不能修改，也不能删除，确认发布吗?" cancelButtonText:@"确定" confirmButtonText:@"取消"];
//        alertView.addCancelAction = ^{
        
            YRRedAdsPaymentModel * model = [[YRRedAdsPaymentModel alloc]init];
            model.adsTitle = self.titleTextField.text;
            model.adsSmallPic = imageUrl;
            model.picCount = 0;
            model.content= @"";
            model.adsType = 1;
            model.payDays = _chooseTime - _locateTime;
            model.wishUpData= [NSString stringWithFormat:@"%ld",[_timetemp integerValue]*1000];
            model.phone = self.teleField.text;
            model.adsInfoPath = videoUrl;
            model.adsDesc = self.textView.text;
            dispatch_async(dispatch_get_main_queue(), ^{
                [MBProgressHUD hideHUD];
                YRRedPaperAdPaymemtViewController * payment= [[YRRedPaperAdPaymemtViewController alloc]init];
                payment.model = model;
                [self.navigationController pushViewController:payment animated:YES];
            });
//        };
//        alertView.addConfirmAction = ^{
//    };
//        [alertView show];
    }
  }
/**
 *  @author ZX, 16-08-13 13:08:11
 *
 *  返回
 */
- (void)backAction{
    [self.view endEditing:YES];
    YRAlertView *alertView = [[YRAlertView alloc] initWithTitle:@"确认退出发布吗?" cancelButtonText:@"退出" confirmButtonText:@"取消"];
    alertView.addCancelAction = ^{
        [self.navigationController popViewControllerAnimated:YES];
    };
    alertView.addConfirmAction = ^{
    
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
        [self.view endEditing:YES];
        YRShowVideoView *videoView = [[YRShowVideoView alloc] initWithFrame:self.view.frame IsRequest:NO WithPathOrUrl:self.videoPath];
        [videoView show];
     }else{
         [MBProgressHUD showError:@"视频上传成功之后才能播放"];
     }
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
    sendImageClient                             = [[OSSClient alloc] initWithEndpoint:endpoint credentialProvider:credential1 clientConfiguration:conf];
    
    CFUUIDRef uuid                        = CFUUIDCreate(NULL);
    CFStringRef uuidstring                = CFUUIDCreateString(NULL, uuid);
    self.UUIDImageString                  = [NSString stringWithFormat:@"%@",uuidstring];
    
    OSSPutObjectRequest * put             = [OSSPutObjectRequest new];
    // 必填字段
    put.bucketName                        = OSS_BUCKETNAME;
    put.objectKey                         = [NSString stringWithFormat:@"picture/%@_iOS.jpg",self.UUIDImageString];
    put.uploadingData                  = UIImageJPEGRepresentation(self.thumbnailImg, 0.5);;
    
    OSSTask * putTask                     = [sendImageClient putObject:put];
    
    [putTask continueWithBlock:^id(OSSTask *task) {
        
        if (!task.error) {
            
        } else {
            
            NSLog(@"upload object failed, error: %@" , task.error);
        }
        return nil;
    }];
}

- (void)updataVideo{
    //自实现签名，可以用本地签名也可以远程加签
    id<OSSCredentialProvider> credential1 = [[OSSCustomSignerCredentialProvider alloc] initWithImplementedSigner:^NSString *(NSString *contentToSign, NSError *__autoreleasing *error) {
        NSString *signature = [OSSUtil calBase64Sha1WithData:contentToSign withSecret:OSS_SECRETACCESSKEY];
        if (signature != nil) {
        } else {
            return nil;
        }
        return [NSString stringWithFormat:@"OSS %@:%@",OSS_ACCESSKEYID, signature];
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
    CFUUIDRef uuid = CFUUIDCreate(NULL);
    CFStringRef uuidstring = CFUUIDCreateString(NULL, uuid);
    self.UUIDString = [NSString stringWithFormat:@"%@",uuidstring];
    NSString * bucketName = OSS_BUCKETNAME;
    NSString * objectKey = [NSString stringWithFormat:@"video/%@_iOS.mp4",uuidstring];
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
            // 上传成功，删除本地保存的UploadId
            [[NSUserDefaults standardUserDefaults] removeObjectForKey:recordKey];
        }
        return nil;
    }];
}
#pragma mark - 文字改变
- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text{
    if (range.length == 1 && text.length == 0) {
        return YES;
    }else if (self.textView.text.length<1000) {
        return YES;
    }else{
        [MBProgressHUD showError:@"不能超过1000"];
        return NO;
    }
}
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
//监听标题文字
-(void)textFieldDidChange:(UITextField *)theTextField{
    if (theTextField.text.length>30) {
        [MBProgressHUD showError:@"只能输入30字以内"];
    }
    NSString *toBeString = self.titleTextField.text;
    NSString *lang = [[UIApplication sharedApplication]textInputMode].primaryLanguage;
    if ([lang isEqualToString:@"zh-Hans"]) {
        UITextRange *selectedRange = [self.titleTextField markedTextRange];
        UITextPosition *position = [self.titleTextField positionFromPosition:selectedRange.start offset:0];
        if (!position) {
            if (self.titleTextField.text.length == 0) {
                self.titleNumLab.text = @"0";
            }else{
                NSInteger  anumber =  [self.titleTextField.text length];
                if ([self.titleTextField.text length] > 30) {
                    self.titleNumLab.text = @"30";
                }else {
                    self.titleNumLab.text = [NSString stringWithFormat:@"%ld",(long)anumber];
                }
            }
            if (toBeString.length > 30) {
                self.titleTextField.text = [toBeString substringToIndex:30];
            }
            if ([self.titleTextField.text isEqualToString:@"\n"]){
                [self.titleTextField resignFirstResponder];
            }
        }
    }else{
        if (self.titleTextField.text.length == 0) {
            self.titleNumLab.text = @"0";
        }else{
            if ([self.titleTextField.text isEqualToString:@"\n"]){
                [self.titleTextField resignFirstResponder];
            }
            if (toBeString.length > 30) {
                self.titleTextField.text = [toBeString substringToIndex:30];
            }else {
                NSInteger  anumber =  [self.titleTextField.text length];
                if ([self.titleTextField.text length] > 30) {
                    self.titleNumLab.text = @"30";
                }else {
                    self.titleNumLab.text = [NSString stringWithFormat:@"%ld",(long)anumber];
                }
            }
        }
    }
}
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    if (range.length == 1 && string.length == 0) {
        return YES;
    }
    if ([textField isEqual:_teleField]) {
        if (textField.text.length>10) {
            [MBProgressHUD showError:@"只能输入11位"];
            return NO;
        }
    }
    return YES;
}
#pragma mark - 获取当前时间戳
-(NSString*)getCurrentTimestamp{
    NSDate* dat = [NSDate dateWithTimeIntervalSinceNow:0];
    NSTimeInterval a=[dat timeIntervalSince1970];
    NSString*timeString = [NSString stringWithFormat:@"%0.f", a];//转为字符型
    return timeString;
}
#pragma mark - 将时间转化为时间戳
- (NSString *)timesTampWithTime:(NSString *)time{
    NSDateFormatter* collectFormatter = [[NSDateFormatter alloc]init];
    [collectFormatter setDateFormat:@"yyyy-MM-dd"];
    NSDate *collecDate = [collectFormatter dateFromString:time];
    NSString *timeSp = [NSString stringWithFormat:@"%ld", (long)[collecDate timeIntervalSince1970]];
    return timeSp;
}
#pragma mark - 日期转化为字符串
-(NSString *)dateToDateString:(NSDate *)date{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd"];
    NSTimeZone *timezone = [[NSTimeZone alloc] initWithName:@"GMT"];
    [dateFormatter setTimeZone:timezone];
    NSString *dateString = [dateFormatter stringFromDate:date];
    return dateString;
}
- (void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end
