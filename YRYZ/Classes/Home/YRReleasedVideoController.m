//
//  YRReleasedVideoController.m
//  YRYZ
//
//  Created by Sean on 16/8/15.
//  Copyright © 2016年 yryz. All rights reserved.
//

#import "YRReleasedVideoController.h"
#import "YRClassIficationController.h"
#import <AliyunOSSiOS/OSSService.h>
#import "YRShowVideoView.h"
#import "YRDataPickerView.h"
#import "YRAdsTipView.h"
@interface YRReleasedVideoController ()<UITableViewDelegate,UITableViewDataSource,UITextViewDelegate,UITextFieldDelegate>
{
    NSTimer *timer;
}
@property(strong,nonatomic) UITableView *uploadTableView;

@property(strong,nonatomic) UILabel *palceholderLabel;

@property (nonatomic,strong) UIProgressView *planLab;

@property (nonatomic,assign) CGFloat progress;

@property (nonatomic,assign) NSInteger isNoWiFiCount;

@property (nonatomic,copy) NSString *seleteTypeName;

@property (nonatomic,copy) NSString *seleteTypeId;

@property (nonatomic,strong) UILabel *typeLab;

@property (nonatomic,strong) UITextView *titleText;

@property (nonatomic,strong) UITextView *contextText;

@property (nonatomic,strong) UILabel *typeNameLab;

@property (nonatomic,strong) UILabel *detailNumLab;

@property (nonatomic,strong) UITextField *titleTextField;

@property (nonatomic,strong) UILabel *titleNumLab;

@property (nonatomic,copy) NSString *UUIDString;

@property (nonatomic,copy) NSString *UUIDImageString;


@property (nonatomic,strong) YRAdsTipView * tipView;//底部时间提示View
@property (nonatomic,strong) UITextField * teleField;//手机输入框
@property (nonatomic,strong) UITextField * timeField;//选择日期

@end
OSSClient * clients;
OSSClient * VideoImgClient;


@implementation YRReleasedVideoController

- (NSMutableArray *)videoTypeArr{
 
    if (!_videoTypeArr) {
        _videoTypeArr = [NSMutableArray array];
    }
    return _videoTypeArr;
}


- (void)viewDidLoad {
    [super viewDidLoad];

    self.title = @"发布视频";
    self.seleteTypeName = @"";
    [self setLeftNavButtonWithTitle:@"取消"];
    
    [self setRightNavButtonWithImage:@"yr_show_edit" title:@"发布"];
    [self setupView];
    
    
    [self updataVideo];
    [self upLoadingImage];
    
//    timer = [NSTimer scheduledTimerWithTimeInterval:0.2 target:self selector:@selector(changeProgress) userInfo:nil repeats:YES];
    
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(textViewEditChanged:) name:@"UITextViewTextDidChangeNotification" object:self.contextText];

}


- (UITextField *)teleField{
    
    if (!_teleField) {
        
        _teleField = [[UITextField alloc]initWithFrame:CGRectMake(SCREEN_WIDTH- 120, 5, 110, 35)];
        _teleField.placeholder = @"请输入手机号";
        _teleField.keyboardType = UIKeyboardTypeNumberPad;
        _teleField.textColor = [UIColor themeColor];
        _teleField.delegate =self;
    }
    return _teleField;
}
- (UITextField *)timeField{
    
    if (!_timeField) {
        _timeField = [[UITextField alloc]initWithFrame:CGRectMake(SCREEN_WIDTH- 120, 5, 110, 35)];
        _timeField.placeholder = @"请选择日期";
        _timeField.textColor = [UIColor themeColor];
        _timeField.delegate =self;
    }
    return _timeField;
}
- (YRAdsTipView *)tipView{
    
    if (!_tipView) {
        _tipView = [[YRAdsTipView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 100)];
        
    }
    return _tipView;
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
    VideoImgClient                        = [[OSSClient alloc] initWithEndpoint:endpoint credentialProvider:credential1 clientConfiguration:conf];
    
    
    CFUUIDRef uuid                        = CFUUIDCreate(NULL);
    CFStringRef uuidstring                = CFUUIDCreateString(NULL, uuid);
    self.UUIDImageString                  = [NSString stringWithFormat:@"%@",uuidstring];
    
    NSData *imageData                     = UIImagePNGRepresentation(self.thumbnailImg);
    OSSPutObjectRequest * put             = [OSSPutObjectRequest new];
    // 必填字段
    put.bucketName                        = OSS_BUCKETNAME;
    put.objectKey                         = [NSString stringWithFormat:@"picture/%@_iOS.jpg",self.UUIDImageString];
    put.uploadingData                     = imageData;
    
    OSSTask * putTask                     = [VideoImgClient putObject:put];
    
    [putTask continueWithBlock:^id(OSSTask *task) {
        
        if (!task.error) {
            
        } else {

        }
        return nil;
    }];
}

- (void)updataVideo{
    
    
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
    conf.timeoutIntervalForRequest = 20;
    conf.timeoutIntervalForResource = 24 * 60 * 60;
    clients = [[OSSClient alloc] initWithEndpoint:endpoint credentialProvider:credential1 clientConfiguration:conf];

    [self resumableUpload];
    
}

// 断点续传
- (void)resumableUpload {
    __block NSString * recordKey;
    @weakify(self);
    CFUUIDRef uuid = CFUUIDCreate(NULL);
    CFStringRef uuidstring = CFUUIDCreateString(NULL, uuid);
    self.UUIDString = [NSString stringWithFormat:@"%@",uuidstring];
    
    NSString * bucketName = OSS_BUCKETNAME;
    
    NSString * objectKey = [NSString stringWithFormat:@"video/%@_iOS.mp4",self.UUIDString];
    
    
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
            return [clients multipartUploadInit:initMultipart];
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
            
            @strongify(self);
            
            CGFloat progress                              = (CGFloat)totalBytesSent/totalBytesExpectedToSend;
            
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.01 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                @strongify(self);
                if (progress == 1.0f) {
                    [self.planLab setProgress:progress animated:YES];
                    self.progress  = progress;
                    [MBProgressHUD showError:@"视频上传成功！"];
                }
                
            });

        };
        
        return [clients resumableUpload:resumableUpload];
    }] continueWithBlock:^id(OSSTask *task) {
        if (task.error) {
            
            self.isNoWiFiCount = 1;
//            [MBProgressHUD showError:@"当前网络不可用，请检查网络设置"];
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

-(void)setupView{
    _uploadTableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT - 64) style:UITableViewStylePlain];
    _uploadTableView.delegate = self;
    _uploadTableView.dataSource = self;
    _uploadTableView.separatorStyle = NO;
//    _uploadTableView.scrollEnabled = NO;
    [self.view addSubview:_uploadTableView];
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    int cellHeight = 0;
    switch (indexPath.section) {
        case 0:
            cellHeight = 44;
            break;
        case 1:
            cellHeight = 44;
            break;
        case 2:
            cellHeight = 110;
            break;
        case 3:
            cellHeight = 100;
            break;
        default:
            break;
    }
    
    
    return cellHeight;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 10;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 4;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    
    return 1;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section==0) {
        
        YRClassIficationController *class = [[YRClassIficationController alloc]init];
        
        class.videoTypeArr = self.videoTypeArr;
        class.typeName     = self.seleteTypeName;

        @weakify(self)
        [class returnSeleteType:^(NSString *typeId, NSString *typeName) {
            @strongify(self)
            self.seleteTypeName = typeName;
            self.seleteTypeId = typeId;
            self.typeNameLab.text = typeName;
            [_uploadTableView reloadData];
            
        }];
        
        [self.navigationController pushViewController:class animated:YES];
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *CellWithIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellWithIdentifier];
    if (!cell) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:CellWithIdentifier];
        cell.accessoryType = UITableViewCellAccessoryNone;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.backgroundColor = [UIColor whiteColor];
        
        switch (indexPath.section) {
            case 0:
            {
                cell.textLabel.text = @"选择分类";
                cell.textLabel.font = [UIFont titleFont17];
                
                self.typeLab = cell.textLabel;
                cell.accessoryView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"yr_msg_access"]];

                UILabel *detailLab      = [[UILabel alloc] initWithFrame:CGRectMake(SCREEN_WIDTH-180, 12, 150, 20)];
                detailLab.text          = self.seleteTypeName;
                detailLab.font          = [UIFont systemFontOfSize:16.f];
                detailLab.textColor     = [UIColor lightGrayColor];
                detailLab.textAlignment = NSTextAlignmentRight;
                [cell.contentView addSubview:detailLab];
                self.typeNameLab = detailLab;
                
            }
                break;
            case 1:
            {
                NSAttributedString *art = [[NSAttributedString alloc]initWithString:@"添加标题" attributes:@{NSFontAttributeName:[UIFont boldSystemFontOfSize:22],NSForegroundColorAttributeName:RGB_COLOR(126, 126, 126)}];
                
                UITextField *addtitleTextField = [[UITextField alloc] initWithFrame:CGRectMake(15, 0, SCREEN_WIDTH-80, 44)];
                addtitleTextField.delegate     = self;
                addtitleTextField.font         = [UIFont boldSystemFontOfSize:20.f];
                addtitleTextField.attributedPlaceholder = art;
                [cell.contentView addSubview:addtitleTextField];
                self.titleTextField = addtitleTextField;
                
                UILabel *textNumber      = [[UILabel alloc] initWithFrame:CGRectMake(SCREEN_WIDTH-63, 12, 25, 20)];
                textNumber.textAlignment = NSTextAlignmentRight;
                textNumber.textColor     = [UIColor themeColor];
                textNumber.font          = [UIFont systemFontOfSize:15.f];
                textNumber.text          = @"0";
                [cell.contentView addSubview:textNumber];
                self.titleNumLab = textNumber;
                
                UILabel *maxNumber      = [[UILabel alloc] initWithFrame:CGRectMake(SCREEN_WIDTH-38, 12, 30, 20)];
                maxNumber.textAlignment = NSTextAlignmentLeft;
                maxNumber.textColor     = [UIColor lightGrayColor];
                maxNumber.font          = [UIFont systemFontOfSize:15.f];
                maxNumber.text          = @"/30";
                [cell.contentView addSubview:maxNumber];
                
                [addtitleTextField addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
            }
                break;
            case 2:
            {
                UITextView *detailTextView        = [[UITextView alloc]init];
                detailTextView.delegate           = self;
                detailTextView.textContainerInset = UIEdgeInsetsMake(10, 10, 10, 10);
                detailTextView.font               = [UIFont systemFontOfSize:16];
                detailTextView.frame              = CGRectMake(0, 0, SCREEN_WIDTH, 80);
                [cell.contentView addSubview:detailTextView];
                
                
                _palceholderLabel           = [[UILabel alloc]init];
                _palceholderLabel.frame     = CGRectMake(15, 12, 100, 15);
                _palceholderLabel.text      = @"添加描述";
                _palceholderLabel.textColor = RGB_COLOR(126, 126, 126);
                _palceholderLabel.font      = [UIFont systemFontOfSize:18];
                [cell.contentView addSubview:_palceholderLabel];
                self.contextText = detailTextView;
                
                UILabel *textNumber      = [[UILabel alloc] initWithFrame:CGRectMake(SCREEN_WIDTH-100, 85, 52, 20)];
                textNumber.textAlignment = NSTextAlignmentRight;
                textNumber.textColor     = [UIColor themeColor];
                textNumber.font          = [UIFont systemFontOfSize:15.f];
                textNumber.text          = @"0";
                [cell.contentView addSubview:textNumber];
                self.detailNumLab = textNumber;
                
                UILabel *maxNumber      = [[UILabel alloc] initWithFrame:CGRectMake(SCREEN_WIDTH-48, 85, 35, 20)];
                maxNumber.textAlignment = NSTextAlignmentRight;
                maxNumber.textColor     = [UIColor lightGrayColor];
                maxNumber.font          = [UIFont systemFontOfSize:14.f];
                maxNumber.text          = @"/200";
                [cell.contentView addSubview:maxNumber];
            }
                break;
            case 3:
            {
                UIImageView *videoImg = [[UIImageView alloc]initWithFrame:CGRectMake(10, 10, 150, 100)];
                videoImg.image = self.thumbnailImg;
                [cell.contentView addSubview:videoImg];
                
                UIButton *playBtn = [UIButton buttonWithType:UIButtonTypeCustom];
                playBtn.frame     = CGRectMake(60, videoImg.mj_y+35, 50, 30);
                [playBtn setImage:[UIImage imageNamed:@"yr_show_video"] forState:UIControlStateNormal];
                [playBtn addTarget:self action:@selector(playVidelAction) forControlEvents:UIControlEventTouchUpInside];
                [cell.contentView addSubview:playBtn];
                
                
                UIProgressView *planLab=[[UIProgressView alloc]initWithProgressViewStyle:UIProgressViewStyleDefault];
                planLab.frame=CGRectMake(10, 110, 150, 2);
                planLab.trackTintColor=[UIColor whiteColor];
                planLab.progress=0.0;
                planLab.progressTintColor=[UIColor themeColor];
                [cell.contentView addSubview:planLab];
                self.planLab = planLab;

            }
                break;
            default:
                break;
        }
    }
    return cell;
}

/**
 *  @author ZX, 16-08-12 16:08:35
 *
 *  播放视频
 */
- (void)playVidelAction{
    [self.view endEditing:YES];

    if (self.progress == 1.0) {

        YRShowVideoView *videoView = [[YRShowVideoView alloc] initWithFrame:self.view.frame IsRequest:NO WithPathOrUrl:self.videoPath];
        [videoView show];
        
    }else{
        
        [MBProgressHUD showError:@"视频上传成功之后才能播放"];
    }
}

-(void)textViewDidChange:(UITextView *)textView{
    
    if (textView.text.length > 0) {
        _palceholderLabel.hidden = YES;
    }else{
        _palceholderLabel.hidden = NO;
    }
}

- (void)leftNavAction:(UIButton *)button{

    [self.view endEditing:YES];
    @weakify(self);
    YRAlertView *alertView = [[YRAlertView alloc] initWithTitle:@"确认退出发布?" cancelButtonText:@"退出" confirmButtonText:@"取消"];
    
    alertView.addCancelAction = ^{
        @strongify(self);
        [self dismissViewControllerAnimated:YES completion:nil];
    };
    alertView.addConfirmAction = ^{
    };
    
    [alertView show];
}

- (void)rightNavAction:(UIButton *)button{
    [self.view endEditing:YES];

        if([self.contextText.text isEqualToString:@""]){
            [MBProgressHUD showError:@"您还没有添加描述"];
        }else if(self.contextText.text.length <5){
            [MBProgressHUD showError:@"描述不能少于5个字"];
        }else if([self.titleTextField.text isEqualToString:@""]){
            [MBProgressHUD showError:@"您还没有添加标题"];
        }else if(self.titleTextField.text.length <1){
            [MBProgressHUD showError:@"标题不能少于一个字"];
        }else if ([self.seleteTypeId isEqualToString:@""] || self.seleteTypeId == nil) {
            [MBProgressHUD showError:@"您还没有添加分类"];
        }else if(self.planLab.progress != 1.0){
            [MBProgressHUD showError:@"视频上传中，请稍后"];
        }else{
            
            @weakify(self);
            NSString *videoUrl = [NSString stringWithFormat:@"http://yryz-circle.oss-cn-hangzhou.aliyuncs.com/video/%@_iOS.mp4",self.UUIDString];
            NSString *imageUrl = [NSString stringWithFormat:@"http://yryz-circle.oss-cn-hangzhou.aliyuncs.com/picture/%@_iOS.jpg",self.UUIDImageString];
            
            YRAlertView *alertView = [[YRAlertView alloc] initWithTitle:@"作品发布成功之后不能修改，也不能删除，确认发布吗?" cancelButtonText:@"取消" confirmButtonText:@"确定"];
            
            alertView.addCancelAction = ^{
                
            };
            alertView.addConfirmAction = ^{

          [MBProgressHUD showMessage:@"" toView:self.view];

           [YRHttpRequest getProductTypeSaveByCustUserId:[YRUserInfoManager manager].currentUser.custId Tags:nil Title:self.titleTextField.text InfoIntroduction:self.contextText.text InfoThumbnail:imageUrl Content:nil Type:2 InfoCategor:self.seleteTypeId Urls:videoUrl Info_time:nil success:^(NSDictionary *data) {
               @strongify(self);
                [self dismissViewControllerAnimated:YES completion:nil];
                [MBProgressHUD showError:@"发布成功，系统审核中，请耐心等待"];
                [MBProgressHUD hideHUDForView:self.view];

           } failure:^(NSString *errorInfo) {
                [MBProgressHUD hideHUDForView:self.view];

           }];
         
         };
            
         [alertView show];
            
        }

}
#pragma mark - 文字改变
//监听描述文字
- (void)textViewEditChanged:(NSNotification *)obj {
    
    self.contextText = (UITextView *)obj.object;
    NSString *toBeString = self.contextText.text;
    NSString *lang = [[UIApplication sharedApplication]textInputMode].primaryLanguage;
    if ([lang isEqualToString:@"zh-Hans"]) {
        UITextRange *selectedRange = [self.contextText markedTextRange];
        UITextPosition *position = [self.contextText positionFromPosition:selectedRange.start offset:0];
        if (!position) {
            if (self.contextText.text.length == 0) {
                self.detailNumLab.text = @"0";
            }else{
                NSInteger  anumber =  [self.contextText.text length];
                if ([self.contextText.text length] > 200) {
                    self.detailNumLab.text = @"200";
                }else {
                    self.detailNumLab.text = [NSString stringWithFormat:@"%ld",(long)anumber];
                }
            }
            if (toBeString.length > 200) {
                self.contextText.text = [toBeString substringToIndex:200];
            }
            if ([self.contextText.text isEqualToString:@"\n"]){
                [self.contextText resignFirstResponder];
            }
        }
    }else {
        if (self.contextText.text.length == 0) {
            self.detailNumLab.text = @"0";
        }else{
            if ([self.contextText.text isEqualToString:@"\n"]){
                [self.contextText resignFirstResponder];
                
            }
            if (toBeString.length > 200) {
                self.contextText.text = [toBeString substringToIndex:200];
            }else {
                NSInteger  anumber =  [self.contextText.text length];
                if ([self.contextText.text length] > 200) {
                    self.detailNumLab.text = @"200";
                }else {
                    self.detailNumLab.text = [NSString stringWithFormat:@"%ld",(long)anumber];
                }
            }
        }
    }
}
//监听标题文字
-(void)textFieldDidChange:(UITextField *)theTextField{
 
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

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView{
    [self.view endEditing:YES];
}

- (void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:animated];
    timer.fireDate = [NSDate distantFuture];
    timer = nil;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
