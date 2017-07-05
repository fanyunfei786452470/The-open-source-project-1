//
//  YRSoundUploadViewController.m
//  YRYZ
//
//  Created by Rongzhong on 16/8/9.
//  Copyright © 2016年 yryz. All rights reserved.
//

#import "YRSoundUploadViewController.h"
#import "YRClassIficationController.h"
#import <AliyunOSSiOS/OSSService.h>
#import "YRAudioMainViewController.h"
#import "YRAudioPlayView.h"
@interface YRSoundUploadViewController ()<UITableViewDelegate,UITableViewDataSource,UITextViewDelegate>
{
    NSTimer *timer;
}
@property(strong,nonatomic) UITableView     *uploadTableView;

@property(strong,nonatomic) UILabel         *palceholderLabel;

@property (nonatomic,copy) NSString         *audiotTypeId;
@property (nonatomic,copy) NSString         *audiotTypeName;
@property (nonatomic,strong) UITextView     *detailTextView;

@property (nonatomic,strong) UIView         *bkView;

@property (nonatomic,assign) CGFloat        progress;


@end

@implementation YRSoundUploadViewController
OSSClient * audioClient;

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setTitle:@"发布语音"];
    
    self.audiotTypeId = @"";
    self.audiotTypeName = @"";
    
    
    [self setLeftNavButtonWithTitle:@"取消"];
    [self setRightNavButtonWithTitle:@"发布"];

    [self setupView];
    [self updataAudio];
    
    
    timer = [NSTimer scheduledTimerWithTimeInterval:0.2 target:self selector:@selector(changeProgress) userInfo:nil repeats:YES];
    
    
}

- (void)changeProgress{

    if (self.progress == 1.0) {
        [self.bkView removeAllSubviews];
        self.bkView.frame = CGRectZero;
        [MBProgressHUD showError:@"上传成功！"];
        timer.fireDate = [NSDate distantFuture];
        timer = nil;
    }else{
        self.bkView.frame = CGRectMake(10, 20, 190*self.progress, 40);

    }
}


-(void)setupView{
    _uploadTableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT - 64) style:UITableViewStylePlain];
    _uploadTableView.delegate = self;
    _uploadTableView.dataSource = self;
    _uploadTableView.separatorStyle = NO;
    _uploadTableView.scrollEnabled = NO;
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
            cellHeight = 110;
            break;
        case 2:
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
    return 3;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section==0) {
        DLog(@"点击cell");
        YRClassIficationController *vc = [[YRClassIficationController alloc]init];
        vc.videoTypeArr = self.dataSource;
        @weakify(self);
        [vc returnSeleteType:^(NSString *typeId, NSString *typeName) {
            @strongify(self);
            
            self.audiotTypeId = typeId;
            self.audiotTypeName = typeName;
            
        }];
        
        [self.navigationController pushViewController:vc animated:YES];

    }
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
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
                
                cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
            }
                break;
            case 1:
            {
                UITextView *detailTextView = [[UITextView alloc]init];
                detailTextView.delegate = self;
                detailTextView.textContainerInset = UIEdgeInsetsMake(10, 10, 10, 10);
                detailTextView.font = [UIFont systemFontOfSize:15];
                detailTextView.frame = CGRectMake(0, 0, SCREEN_WIDTH, 80);
                [cell.contentView addSubview:detailTextView];
                
                _palceholderLabel = [[UILabel alloc]init];
                _palceholderLabel.frame = CGRectMake(15, 10, 60, 15);
                _palceholderLabel.text = @"添加描述";
                _palceholderLabel.textColor = [UIColor grayColorThree];
                _palceholderLabel.font = [UIFont systemFontOfSize:15];
                [cell.contentView addSubview:_palceholderLabel];
                self.detailTextView = detailTextView;
            }
                break;
            case 2:
            {

                YRAudioPlayView *progressView = [[YRAudioPlayView alloc] initWithFrame:CGRectMake(10, 20, 190, 40) AudioPath:self.audioPath AudioTime:self.audioTime];
                
                [cell.contentView addSubview:progressView];
                
                UIImage *image = [UIImage imageNamed:@"yr_circle_noUpload"];
                CGRect rect = CGRectMake(0, 0, 190, 40);
                
                self.bkView  = [[UIView alloc] initWithFrame:CGRectMake(10, 20, 0, 40)];
                self.bkView.contentMode =  UIViewContentModeLeft;
                self.bkView.clipsToBounds = YES;
                self.bkView.alpha = 0.6;

                [cell.contentView addSubview:self.bkView];
              
                
                UIImageView *bkImage = [[UIImageView alloc] initWithFrame:rect];
                bkImage.contentMode = UIViewContentModeLeft;
                bkImage.clipsToBounds = YES;
                bkImage.image = image;
                [self.bkView addSubview:bkImage];
            }
                break;
            default:
                break;
        }
    }
    return cell;
}

/**
 *  @author ZX, 16-08-22 19:08:07
 *
 *  音频播放
 */
- (void)playAudioAction{
    

}

-(void)textViewDidChange:(UITextView *)textView{
    
    if (textView.text.length > 0) {
        _palceholderLabel.hidden = YES;
    }else{
        _palceholderLabel.hidden = NO;
    }
    //    textview 改变字体的行间距
    //NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    //paragraphStyle.lineSpacing = 5;// 字体的行间距
    //NSDictionary *attributes = @{
    //NSFontAttributeName:[UIFont systemFontOfSize:15],
    //NSParagraphStyleAttributeName:paragraphStyle
    //};
    //textView.attributedText = [[NSAttributedString alloc] initWithString:textView.text attributes:attributes];
}



- (void)leftNavAction:(UIButton *)button{
        YRAlertView *alertView = [[YRAlertView alloc] initWithTitle:@"确定退出编辑?" cancelButtonText:@"确定" confirmButtonText:@"取消"];
        //取消
        alertView.addCancelAction = ^{
                  [self.navigationController popViewControllerAnimated:YES];
        };
        alertView.addConfirmAction = ^{
      
            
        };
        [alertView show];
}

- (void)rightNavAction:(UIButton *)button{
    
    if ([self.audiotTypeId isEqualToString:@""]) {
        [MBProgressHUD showError:@"请选择分类"];
    }else if ([self.detailTextView.text isEqualToString:@""]){
        [MBProgressHUD showError:@"请添加描述"];
    }else{
    
        @weakify(self);
        [YRHttpRequest getProductTypeSaveByCustUserId:[YRUserInfoManager manager].currentUser.custId Tags:@[] Title:nil Content:nil Type:3 InfoCategor:self.audiotTypeId Urls:@"http://yryz.oss-cn-hangzhou.aliyuncs.com/yryz_ios_yinpin.caf"
          success:^(NSDictionary *data) {
             @strongify(self);
            DLog(@"data:%@",data);
              
        YRAudioMainViewController *audioVc = [[YRAudioMainViewController alloc] init];
        [self.navigationController popToViewController:audioVc animated:YES];
                                                  
         } failure:^(NSString *errorInfo) {
                                                  
                                                  
         }];
    }

}


- (void)updataAudio{
    
    
    id<OSSCredentialProvider> credential1 = [[OSSCustomSignerCredentialProvider alloc] initWithImplementedSigner:^NSString *(NSString *contentToSign, NSError *__autoreleasing *error) {
        NSString *signature = [OSSUtil calBase64Sha1WithData:contentToSign withSecret:@"wzZjbJwDpzxN9smCMUZIIHt3HpEeVs"];
        if (signature != nil) {
            //            *error = nil;
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
    conf.timeoutIntervalForRequest = 20;
    conf.timeoutIntervalForResource = 24 * 60 * 60;
    audioClient = [[OSSClient alloc] initWithEndpoint:endpoint credentialProvider:credential1 clientConfiguration:conf];
    
    [self resumableUpload];
    
}

// 断点续传
- (void)resumableUpload {
    __block NSString * recordKey;
    
//    NSDate *currentDate = [NSDate date];//获取当前时间，日期
//    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
//    [dateFormatter setDateFormat:@"YYYY/MM/dd hh:mm:ss SS"];
//    NSString *dateString =  [dateFormatter stringFromDate:currentDate];
    
    NSString * bucketName = @"yryz";
    
    NSString * objectKey = [NSString stringWithFormat:@"yryz_ios_yinpin.mp4"];
    
    
    @weakify(self);
    [[[[[[OSSTask taskWithResult:nil] continueWithBlock:^id(OSSTask *task) {
        // 为该文件构造一个唯一的记录键
        NSURL * fileURL = [NSURL fileURLWithPath:self.audioPath];
        NSDate * lastModified;
        NSError * error;
        [fileURL getResourceValue:&lastModified forKey:NSURLContentModificationDateKey error:&error];
        if (error) {
            return [OSSTask taskWithError:error];
        }
        recordKey = [NSString stringWithFormat:@"%@-%@-%@-%@", bucketName, objectKey, [OSSUtil getRelativePath:self.audioPath], lastModified];
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
            return [audioClient multipartUploadInit:initMultipart];
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
        resumableUpload.uploadingFileURL = [NSURL fileURLWithPath:self.audioPath];
        resumableUpload.uploadProgress = ^(int64_t bytesSent, int64_t totalBytesSent, int64_t totalBytesExpectedToSend) {
            @strongify(self);
            CGFloat progress = (CGFloat)totalBytesSent/totalBytesExpectedToSend;
            
            self.progress = progress;
            
            
            DLog(@"%f",progress);
        };
        
        return [audioClient resumableUpload:resumableUpload];
    }] continueWithBlock:^id(OSSTask *task) {
        if (task.error) {
            
//            self.isNoWiFiCount = 1;
            
            if ([task.error.domain isEqualToString:OSSClientErrorDomain] && task.error.code == OSSClientErrorCodeCannotResumeUpload) {
                // 如果续传失败且无法恢复，需要删除本地记录的UploadId，然后重启任务
                [[NSUserDefaults standardUserDefaults] removeObjectForKey:recordKey];
            }
            
        } else {
            
//            [_uploadTableView reloadData];
//            self.bkView.frame = CGRectZero;
//            self.bkView.alpha = 0.0;
//            [self.bkView removeAllSubviews];
            // 上传成功，删除本地保存的UploadId
            [[NSUserDefaults standardUserDefaults] removeObjectForKey:recordKey];
        }
        return nil;
    }];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
