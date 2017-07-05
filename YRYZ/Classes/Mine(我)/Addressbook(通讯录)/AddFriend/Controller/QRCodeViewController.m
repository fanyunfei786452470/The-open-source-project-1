//
//  QRCodeViewController.m
//  ShouKeBao
//
//  Created by 吴铭 on 15/4/3.
//  Copyright (c) 2015年 shouKeBao. All rights reserved.
//

#import "QRCodeViewController.h"
#import <AVFoundation/AVFoundation.h>
#import "ScanBGView.h"
//
#import "YRAdListUserInfoController.h"
@interface QRCodeViewController ()<AVCaptureMetadataOutputObjectsDelegate>
@property (weak, nonatomic) IBOutlet UIView *viewPreview;
@property (weak, nonatomic) IBOutlet UILabel *lblStatus;
@property (strong, nonatomic) UILabel *tipLabel;

/** <#注释#>*/
@property (strong, nonatomic) ScanBGView *myScanBGView;
@property (strong, nonatomic) UIImageView *scanRectView, *lineView;

@property (strong, nonatomic) UIView *boxView;
@property (nonatomic) BOOL isReading;
@property (strong, nonatomic) UIView *scanLayer;
//@property (strong,nonatomic) NSTimer *timer;
-(BOOL)startReading;
-(void)stopReading;

//捕捉会话
@property (nonatomic, strong) AVCaptureSession *captureSession;
//展示layer
@property (nonatomic, strong) AVCaptureVideoPreviewLayer *videoPreviewLayer;
@property (nonatomic, strong) AVCaptureConnection * connection;
@end

@implementation QRCodeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"二维码扫描";
    _captureSession = nil;
    _isReading = NO;
//    CGFloat viewW = [[UIScreen mainScreen] bounds].size.width;
//    
//    CGFloat screenH = [[UIScreen mainScreen] bounds].size.height;
//    CGFloat viewH = screenH - 157;
    //CGFloat viewH = screenH ;
//    self.viewPreview.frame = CGRectMake(0, 0, viewW, viewH);
    
    [self startReading];

    [self openUrl];
    
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    [btn setImage:[UIImage imageNamed:@"backIndicatorImage"] forState:UIControlStateNormal];
    btn.frame = CGRectMake(20, 20, 40, 40);
    [self.view addSubview:btn];
    [btn addTarget:self action:@selector(backBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    
}
- (void)backBtnClick:(UIButton *)sender{
    [self dismissViewControllerAnimated:YES completion:nil];
}
#pragma mark 设置焦距
- (void)setFocalLength:(CGFloat)lengthScale
{
    [UIView animateWithDuration:0.5 animations:^{
        [_videoPreviewLayer setAffineTransform:CGAffineTransformMakeScale(lengthScale, lengthScale)];
        _connection.videoScaleAndCropFactor = lengthScale;
    }];
}



-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [self.captureSession startRunning];//当QR被父vc remove时候关闭识别，当被添加的时候打开识别
    
    //------------当唤出证件神器 以下代码放viewdidload上
    
}


-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    [self.captureSession stopRunning];
}


-(void)viewDidLayoutSubviews{
    [super viewDidLayoutSubviews];
    self.viewPreview.frame = self.view.bounds;
    [_videoPreviewLayer setFrame:_viewPreview.layer.bounds];
}


//实现startReading方法（这可就是重点咯）
- (BOOL)startReading {
    NSError *error;
    //1.初始化捕捉设备（AVCaptureDevice），类型为AVMediaTypeVideo
    AVCaptureDevice *captureDevice = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
    //2.用captureDevice创建输入流
    AVCaptureDeviceInput *input = [AVCaptureDeviceInput deviceInputWithDevice:captureDevice error:&error];
    if (!input) {
        NSLog(@"%@", [error localizedDescription]);
        return NO;
    }

    //3.创建媒体数据输出流
    AVCaptureMetadataOutput *captureMetadataOutput = [[AVCaptureMetadataOutput alloc] init];
    //4.实例化捕捉会话
    _captureSession = [[AVCaptureSession alloc] init];
    //4.1.将输入流添加到会话
    [_captureSession addInput:input];
    //4.2.将媒体输出流添加到会话中
    [_captureSession addOutput:captureMetadataOutput];
    //5.创建串行队列，并加媒体输出流添加到队列当中
    dispatch_queue_t dispatchQueue;
    dispatchQueue = dispatch_queue_create("myQueue", NULL);
    //5.1.设置代理
    [captureMetadataOutput setMetadataObjectsDelegate:self queue:dispatchQueue];
    //5.2.设置输出媒体数据类型为QRCode
    [captureMetadataOutput setMetadataObjectTypes:[NSArray arrayWithObject:AVMetadataObjectTypeQRCode]];
    //6.实例化预览图层
    _videoPreviewLayer = [[AVCaptureVideoPreviewLayer alloc] initWithSession:_captureSession];
    //7.设置预览图层填充方式
    [_videoPreviewLayer setVideoGravity:AVLayerVideoGravityResizeAspectFill];
    //8.设置图层的frame
    [_videoPreviewLayer setFrame:_viewPreview.layer.bounds];
    //[_videoPreviewLayer setFrame:self.view.frame];
    //9.将图层添加到预览view的图层上
    [_viewPreview.layer addSublayer:_videoPreviewLayer];
    //10.设置扫描范围
    captureMetadataOutput.rectOfInterest = CGRectMake(0.2f, 0.2f, 0.8f, 0.8f);
    _connection = [captureMetadataOutput connectionWithMediaType:AVMediaTypeVideo];
    [self setFocalLength:2.0];//1倍正常，2x，3x，4x依次放大
    //10.1.扫描框
//    CGFloat boxX = _viewPreview.bounds.size.width * 0.1f;
//    CGFloat wid = _viewPreview.bounds.size.width*0.8f;
//    _boxView = [[UIView alloc] initWithFrame:CGRectMake(boxX, _viewPreview.bounds.size.height/2 - wid/2, wid, wid)];
//    _boxView.layer.borderColor = [UIColor whiteColor].CGColor;
//    _boxView.layer.borderWidth = 1.0f;
//    [_viewPreview addSubview:_boxView];
    
    CGFloat width = SCREEN_WIDTH *2/3;
    CGFloat padding = (SCREEN_WIDTH - width)/2;
    CGFloat y = (SCREEN_HEIGHT - width) / 2;
    CGRect scanRect = CGRectMake(padding, y, width, width);
    
    if (!_myScanBGView) {
        _myScanBGView = [[ScanBGView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
        _myScanBGView.backgroundColor = [UIColor colorWithWhite:0 alpha:0.5];
        _myScanBGView.scanRect = scanRect;
    }
    
    if (!_scanRectView) {
        _scanRectView = [[UIImageView alloc] initWithFrame:scanRect];
        _scanRectView.image = [[UIImage imageNamed:@"scan_bg"] resizableImageWithCapInsets:UIEdgeInsetsMake(25, 25, 25, 25)];
        _scanRectView.clipsToBounds = YES;
    }
    if (!_tipLabel) {
        _tipLabel = [UILabel new];
        _tipLabel.textAlignment = NSTextAlignmentCenter;
        _tipLabel.font = [UIFont boldSystemFontOfSize:16];
        _tipLabel.textColor = [[UIColor whiteColor] colorWithAlphaComponent:0.4];
        _tipLabel.text = @"将二维码放入框内，即可自动扫描";
    }
    if (!_lineView) {
        UIImage *lineImage = [UIImage imageNamed:@"scan_line"];
        CGFloat lineHeight = 2;
        CGFloat lineWidth = CGRectGetWidth(_scanRectView.frame);
        _lineView = [[UIImageView alloc] initWithFrame:CGRectMake(0, -lineHeight, lineWidth, lineHeight)];
        _lineView.contentMode = UIViewContentModeScaleToFill;
        _lineView.image = lineImage;
    }
    
    [self.view.layer addSublayer:_videoPreviewLayer];
    [self.view addSubview:_myScanBGView];
    [self.view addSubview:_scanRectView];
    [self.view addSubview:_tipLabel];
    [_tipLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.view);
        make.top.equalTo(_scanRectView.mas_bottom).offset(20);
        make.height.mas_equalTo(30);
    }];
    [_scanRectView addSubview:_lineView];    //提示label
//    UILabel *lab = [[UILabel alloc]initWithFrame:CGRectMake(boxX, CGRectGetMaxY(_boxView.frame), wid, 30)];
//    lab.text = @"请将二维码放入框内，可自动进行扫描";
//    lab.textAlignment = NSTextAlignmentCenter;
//    lab.font = [UIFont systemFontOfSize:11];
//    lab.textColor = [UIColor whiteColor];
//    [_viewPreview addSubview:lab];
    //10.2.扫描线
    _scanLayer = [[UIView alloc] init];
    _scanLayer.frame = CGRectMake(0, 0, _scanRectView.bounds.size.width, 2);
//    _scanLayer.contents = (id)[UIImage imageNamed:@"widLine"].CGImage;
     _scanLayer.backgroundColor = [UIColor themeColor];
    
    [self scanLineStartAction];
    
    [_scanRectView addSubview:_scanLayer];
    NSTimer *timer = [NSTimer scheduledTimerWithTimeInterval:0.05f target:self selector:@selector(moveScanLayer:) userInfo:nil repeats:YES];
    [timer fire];
    
    //10.开始扫描
    [_captureSession startRunning];
    return YES;
}

- (void)scanLineStartAction{
    [self scanLineStopAction];
    
    CABasicAnimation *scanAnimation = [CABasicAnimation animationWithKeyPath:@"position.y"];
    scanAnimation.fromValue = @(-CGRectGetHeight(_lineView.frame));
    scanAnimation.toValue = @(CGRectGetHeight(_lineView.frame) + CGRectGetHeight(_scanRectView.frame));
    
    scanAnimation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    scanAnimation.repeatCount = CGFLOAT_MAX;
    scanAnimation.duration = 2.0;
    [self.lineView.layer addAnimation:scanAnimation forKey:@"basic"];
}

- (void)scanLineStopAction{
    [self.lineView.layer removeAllAnimations];
}

//实现AVCaptureMetadataOutputObjectsDelegate协议方法
#pragma mark - AVCaptureMetadataOutputObjectsDelegate
- (void)captureOutput:(AVCaptureOutput *)captureOutput didOutputMetadataObjects:(NSArray *)metadataObjects fromConnection:(AVCaptureConnection *)connection
{
    //判断是否有数据
    if (metadataObjects != nil && [metadataObjects count] > 0) {
        AVMetadataMachineReadableCodeObject *metadataObj = [metadataObjects objectAtIndex:0];
        //判断回传的数据类型
        if ([[metadataObj type] isEqualToString:AVMetadataObjectTypeQRCode]) {
            [_lblStatus performSelectorOnMainThread:@selector(setText:) withObject:[metadataObj stringValue] waitUntilDone:NO];
            
            
            [self performSelectorOnMainThread:@selector(stopReading) withObject:nil waitUntilDone:NO];
            
            _isReading = NO;
        }
    }
    // NSLog(@" 外 url is %@",_lblStatus.text);
    
}
//实现计时器方法moveScanLayer:(NSTimer *)timer
- (void)moveScanLayer:(NSTimer *)timer
{
    CGRect frame = _scanLayer.frame;
    if (_scanRectView.frame.size.height < _scanLayer.frame.origin.y) {
        frame.origin.y = 0;
        _scanLayer.frame = frame;
    }else{
        
        frame.origin.y += 5;
        
        [UIView animateWithDuration:0.1 animations:^{
            _scanLayer.frame = frame;
        }];
    }
    
    
}
////实现开始和停止方法
//- (void)startStopReading{
//    if (!_isReading) {
//        if ([self startReading]) {
//            [_startBtn setTitle:@"停止扫描" forState:UIControlStateNormal];
//            // [_lblStatus setText:@"Scanning for QR Code"];
//        }
//    }
//    else{
//        [self stopReading];
//        [_startBtn setTitle:@"开始扫描!" forState:UIControlStateNormal];
//    }
//    _isReading = !_isReading;
//}

- (void)openUrl {
    
    
    NSLog(@"---------得到网址:%@-------",self.lblStatus.text);
    NSString *resultAsString = self.lblStatus.text;
    if (resultAsString.length > 0) {
        //震动反馈
        AudioServicesPlaySystemSound(kSystemSoundID_Vibrate);
        
//        NSString *parametersType = [self jiexi:@"type" webaddress:resultAsString];
        
        NSData *jsonData = [resultAsString dataUsingEncoding:NSUTF8StringEncoding];
        NSError *err;
        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:jsonData
                             
                                                            options:NSJSONReadingMutableContainers
                             
                                                              error:&err];
        NSString *uid = [dic objectForKey:@"uid"];
        if (uid) {
            NSString *TEACHERLower      = [uid lowercaseString];    //小写
            YRAdListUserInfoController *userInfo = [[YRAdListUserInfoController alloc]init];
            userInfo.custId = TEACHERLower;
            [self.delegate.navigationController pushViewController:userInfo animated:YES];
            [self dismissViewControllerAnimated:YES completion:nil];
            
        }else{
            NSURL *url = [NSURL URLWithString:self.lblStatus.text];
            if ([[UIApplication sharedApplication]canOpenURL:url]) {
                [[UIApplication sharedApplication]openURL:url];
            }else{
                [MBProgressHUD showError:@"无法识别该二维码" toView:self.view];
            }
            [self dismissViewControllerAnimated:YES completion:nil];
        }
    }
    
        
//        NSString *parametersId = [self jiexi:@"id" webaddress:resultAsString];
//        if ([parametersType isEqualToString:@"yryzcust"]) {
//            RRZFriendInfoController *friendInfoController = [[RRZFriendInfoController alloc]init];
//            friendInfoController.superiorType = 10;
//            friendInfoController.custId = parametersId;
//            [self.navigationController pushViewController:friendInfoController animated:YES];
//        }else if([parametersType isEqualToString:@"yryzinfo"]){
//            RRZInfoDetailPageController *detailPageController = [[RRZInfoDetailPageController alloc]init];
//            detailPageController.superiorType = 10;
//            detailPageController.infoID = parametersId;
//            [self.navigationController pushViewController:detailPageController animated:YES];
//        }else{
//            NSURL *url = [NSURL URLWithString:self.lblStatus.text];
//            if ([[UIApplication sharedApplication]canOpenURL:url]) {
//                [[UIApplication sharedApplication]openURL:url];
//            }else{
//                [MBProgressHUD showError:@"无法识别该二维码" toView:self.view];
//            }
//            
//            [self.navigationController popViewControllerAnimated:YES];
//            [self dismissViewControllerAnimated:YES completion:^{
//            }];
//        }
//    }
}


-(void)stopReading{
    [_captureSession stopRunning];
    _captureSession = nil;
    [_scanLayer removeFromSuperview];
    [_videoPreviewLayer removeFromSuperlayer];
    [self openUrl];
}


    
#pragma mark - NSString
    
/**
 *  @author yichao, 16-04-21 11:04:39
 *
 *  从URL中获取参数
 *
 *  @param CS         参数名称
 *  @param webaddress URL
 *
 *  @return 参数
 */
-(NSString *) jiexi:(NSString *)CS webaddress:(NSString *)webaddress
{
    NSError *error;
    NSString *regTags=[[NSString alloc] initWithFormat:@"(^|&|\\?)+%@=+([^&]*)(&|$)",CS];
    NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:regTags
                                                                           options:NSRegularExpressionCaseInsensitive
                                                                             error:&error];
    
    // 执行匹配的过程
    // NSString *webaddress=@"http://www.baidu.com/dd/adb.htm?adc=e12&xx=lkw&dalsjd=12";
    NSArray *matches = [regex matchesInString:webaddress
                                      options:0
                                        range:NSMakeRange(0, [webaddress length])];
    for (NSTextCheckingResult *match in matches) {
        //NSRange matchRange = [match range];
        //NSString *tagString = [webaddress substringWithRange:matchRange];  // 整个匹配串
        //        NSRange r1 = [match rangeAtIndex:1];
        //        if (!NSEqualRanges(r1, NSMakeRange(NSNotFound, 0))) {    // 由时分组1可能没有找到相应的匹配，用这种办法来判断
        //            //NSString *tagName = [webaddress substringWithRange:r1];  // 分组1所对应的串
        //            return @"";
        //        }
        
        NSString *tagValue = [webaddress substringWithRange:[match rangeAtIndex:2]];  // 分组2所对应的串
        //    NSLog(@"分组2所对应的串:%@\n",tagValue);
        return tagValue;
    }
    return @"";
}

@end
