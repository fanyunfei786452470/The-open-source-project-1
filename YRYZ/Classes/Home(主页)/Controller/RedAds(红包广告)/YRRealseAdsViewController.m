//
//  YRRealseAdsViewController.m
//  YRYZ
//
//  Created by Sean on 16/8/11.
//  Copyright © 2016年 yryz. All rights reserved.
//

#import "YRRealseAdsViewController.h"
#import "YRSendVideoPosterViewController.h"
#import "YRRedPaperAdPaymemtViewController.h"

#import <AVFoundation/AVFoundation.h>
#import <Photos/Photos.h>
#import <AssetsLibrary/AssetsLibrary.h>

#import <AVFoundation/AVAsset.h>
#import <AVFoundation/AVAssetImageGenerator.h>
#import <MobileCoreServices/MobileCoreServices.h>
#import <CoreMedia/CoreMedia.h>

#import <ALBBSDK/ALBBSDK.h>
#import <ALBBQuPai/ALBBQuPaiService.h>
#import <ALBBQuPai/QPEffectMusic.h>
@interface YRRealseAdsViewController ()<UINavigationControllerDelegate, UIImagePickerControllerDelegate,UIActionSheetDelegate>

@property (nonatomic,strong) UIActionSheet *actionSheet;
@property (nonatomic, assign) BOOL shouldAsync;

@end

@implementation YRRealseAdsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    NSString *text = _isPhone==YES?@"绑定手机号":@"广告发布成功";
    self.title = text;
    [self congUI];
}

- (void)congUI{
    
    UIImageView *headerImage = [[UIImageView alloc]init];
    NSString *str = _isPhone==YES?@"yr_phone":@"yr_ads_yes";
     [self.view addSubview:headerImage];
    headerImage.image = [UIImage imageNamed:str];
    
    [headerImage mas_makeConstraints:^(MASConstraintMaker *make) {
       
        make.top.equalTo(self.view.mas_top).mas_offset(110);
        make.centerX.equalTo(self.view);
        make.size.mas_equalTo(CJSizeMake(150, 150));
    }];
   
    UILabel *label = [[UILabel alloc]init];
    label.font = [UIFont systemFontOfSize:16];
    label.textColor = RGB_COLOR(130, 130, 130);
    label.textAlignment = NSTextAlignmentCenter;
    NSString *strT = _isPhone==YES?@"手机号绑定成功":@"广告发布成功,请耐心等待审核";
    label.text = strT;
    [self.view addSubview:label];
    [label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(headerImage.mas_bottom).mas_offset(20);
        make.centerX.equalTo(headerImage);
        make.size.mas_equalTo(CJSizeMake(SCREEN_WIDTH, 20));
        
    }];
    

    UIImageView *bttom = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"yr_release"]];
    [self.view addSubview:bttom];
    [bttom mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(label.mas_bottom).mas_offset(30);
        make.centerX.equalTo(label);
        make.size.mas_equalTo(CJSizeMake(285, 171));
    }];
    bttom.userInteractionEnabled = YES;
    UIButton *imageBtn = [UIButton buttonWithType:UIButtonTypeSystem];
    [imageBtn setTitle:@"发布图文广告" forState:UIControlStateNormal];
    imageBtn.backgroundColor = RGB_COLOR(43, 193, 183);
    [imageBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    
    UIButton *videoBtn = [UIButton buttonWithType:UIButtonTypeSystem];
    [videoBtn setTitle:@"发布视频广告" forState:UIControlStateNormal];
    videoBtn.backgroundColor = RGB_COLOR(43, 193, 183);
    [videoBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    
    [bttom addSubview:imageBtn];
    [bttom addSubview:videoBtn];
    
    [imageBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(bttom.mas_top).mas_offset(50);
        make.centerX.equalTo(bttom);
        make.size.mas_equalTo(CJSizeMake(170, 40));
    }];
    
    [videoBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(imageBtn.mas_bottom).mas_offset(20);
        make.centerX.equalTo(bttom);
        make.size.mas_equalTo(CJSizeMake(170, 40));
    }];
    imageBtn.layer.cornerRadius = 20;
    videoBtn.layer.cornerRadius = 20;
    imageBtn.clipsToBounds = YES;
    videoBtn.clipsToBounds = YES;
    [imageBtn addTarget:self action:@selector(imageBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    
    [videoBtn addTarget:self action:@selector(videoBtnClick:) forControlEvents:UIControlEventTouchUpInside];
}

- (void)imageBtnClick:(UIButton *)sender{
    
    YRRedPaperAdPaymemtViewController *ViewController = [[YRRedPaperAdPaymemtViewController alloc]init];
    [self.navigationController pushViewController:ViewController animated:YES];
    
}

- (void)videoBtnClick:(UIButton *)sender{
    
    if([[UIDevice currentDevice].systemVersion doubleValue] >= 8.0)
    {
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:UIAlertControllerStyleActionSheet];
        
        NSArray *titles = @[@"拍摄视频",@"从相册选取"];
        [self addActionTarget:alert titles:titles];
        [self addCancelActionTarget:alert title:@"取消"];
        
        // 会更改UIAlertController中所有字体的内容（此方法有个缺点，会修改所以字体的样式）
        UILabel *appearanceLabel = [UILabel appearanceWhenContainedIn:UIAlertController.class, nil];
        UIFont *font = [UIFont systemFontOfSize:15];
        appearanceLabel.font = font;
        
        [self presentViewController:alert animated:YES completion:nil];
        
    }else{
        [self.actionSheet showInView:self.view];
    }

}


// 添加其他按钮
- (void)addActionTarget:(UIAlertController *)alertController titles:(NSArray *)titles{
    for (NSString *title in titles) {
        
        if ([title isEqualToString:@"拍摄视频"]) {
            UIAlertAction *action = [UIAlertAction actionWithTitle:title style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
                
                //                [self getVideoWithsourceType:UIImagePickerControllerSourceTypeCamera shouldAsync:YES];
                if (SYSTEMVERSION>9.0) {
                    [self movieAction];

                }else{
                    [MBProgressHUD showError:@"当前系统版本不支持视频拍摄"];
                }
            }];
            [action setValue:[UIColor themeColor] forKey:@"_titleTextColor"];
            [alertController addAction:action];
        }
        if ([title isEqualToString:@"从相册选取"]) {
            UIAlertAction *action = [UIAlertAction actionWithTitle:title style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
                [self getVideoWithsourceType:UIImagePickerControllerSourceTypeSavedPhotosAlbum shouldAsync:NO];
                
                
            }];
            [action setValue:[UIColor themeColor] forKey:@"_titleTextColor"];
            [alertController addAction:action];
        }
        
        
    }
}


- (void)movieAction{
    
    id<ALBBQuPaiService> sdk = [[ALBBSDK sharedInstance] getService:@protocol(ALBBQuPaiService)];
    [sdk setDelegte:(id<QupaiSDKDelegate>)self];
    
    /* 可选设置 */
    [sdk setEnableImport:NO]; //开启导入
    [sdk setEnableMoreMusic:NO]; //更多音乐
    [sdk setEnableBeauty:NO]; // 美颜开关
    [sdk setEnableVideoEffect:NO]; //视频编辑
    [sdk setEnableWatermark:NO]; //开启水印
    [sdk setTintColor:[UIColor themeColor]]; //RGB颜色
    [sdk setThumbnailCompressionQuality:0.3]; //首贞图片质量
    [sdk setWatermarkImage:YES ? [UIImage imageNamed:@"watermask"] : nil ]; //开启水印
    [sdk setWatermarkPosition:QupaiSDKWatermarkPositionTopRight];
    [sdk setCameraPosition:QupaiSDKCameraPositionBack]; //前置摄像头
    
    /**
     *  @author ZX, 16-07-09 17:07:31
     *
     *  MinDuration 最小时长
     *  maxDuration 最大时长
     *  bitRate     码率
     */
    
    UIViewController *recordController = [sdk createRecordViewControllerWithMinDuration:5
                                                                            maxDuration:60
                                                                                bitRate:500000];
    UINavigationController *navigation = [[UINavigationController alloc] initWithRootViewController:recordController];
    navigation.navigationBarHidden = YES;
    [self presentViewController:navigation animated:YES completion:nil];
    
}
- (void)qupaiSDK:(id<ALBBQuPaiService>)sdk compeleteVideoPath:(NSString *)videoPath thumbnailPath:(NSString *)thumbnailPath
{
    
    //    NSData *data = [NSData dataWithContentsOfFile:thumbnailPath];
    //    NSAssert(data.length != 0, @"failed");‘
    
    [self dismissViewControllerAnimated:YES completion:nil];
    
    if (videoPath) {
        UISaveVideoAtPathToSavedPhotosAlbum(videoPath, nil, nil, nil);
        
        YRSendVideoPosterViewController *releseVideo = [[YRSendVideoPosterViewController alloc]init];
        NSData *data = [NSData dataWithContentsOfFile:thumbnailPath];
        UIImage *image = [UIImage imageWithData:data];
        releseVideo.videoPath = videoPath;
        releseVideo.thumbnailImg = image;
        [self.navigationController pushViewController:releseVideo animated:YES];
    }
    if (thumbnailPath) {
        UIImageWriteToSavedPhotosAlbum([UIImage imageWithContentsOfFile:thumbnailPath], nil, nil, nil);
    }
}

// 取消按钮
- (void)addCancelActionTarget:(UIAlertController *)alertController title:(NSString *)title{
    
    UIAlertAction *action = [UIAlertAction actionWithTitle:title style:UIAlertActionStyleCancel handler:^(UIAlertAction *action) {
        
        
    }];
    
    [action setValue:[UIColor wordColor] forKey:@"_titleTextColor"];
    [alertController addAction:action];
}
// iOS8.0之前可用
- (void)willPresentActionSheet:(UIActionSheet *)actionSheet{
    for (UIView *view in actionSheet.subviews) {
        UIButton *btn = (UIButton *)view;
        btn.titleLabel.font = [UIFont systemFontOfSize:15];
        if([[btn titleForState:UIControlStateNormal] isEqualToString:@"取消"]){
            [btn setTitleColor:[UIColor wordColor] forState:UIControlStateNormal];
        }else{
            [btn setTitleColor:RGB_COLOR(0, 121, 255) forState:UIControlStateNormal];
        }
    }
}


- (void)getVideoWithsourceType:(UIImagePickerControllerSourceType)type shouldAsync:(BOOL)shouldAsync{
    // 取得授权状态
    AVAuthorizationStatus authStatus = [AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeVideo];
    // 判断当前状态
    if (authStatus == AVAuthorizationStatusRestricted
        || authStatus == AVAuthorizationStatusDenied) {
        // 拒绝当前App访问【Photo】运用
        [MBProgressHUD showError:@"请打开访问开关"];
        return;
    }
    
    if ([UIImagePickerController isSourceTypeAvailable:type]) {
        UIImagePickerController *picker = [[UIImagePickerController alloc] init];
        picker.delegate = self;
        picker.allowsEditing = YES;
        picker.sourceType = type;
        picker.mediaTypes = @[(NSString *)kUTTypeMovie];
        [self presentViewController:picker animated:YES completion:NULL];
        self.shouldAsync = shouldAsync;
    } else {
        [MBProgressHUD showError:@"手机不支持摄像"];
    }
    
}

#pragma mark - UIImagePickerControllerDelegate
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info{
    
    NSURL *videoURL = [info objectForKey:UIImagePickerControllerMediaURL];
    
    if ([UIDevice currentDevice].systemVersion.doubleValue < 9.0) {
        ALAssetsLibrary *library = [[ALAssetsLibrary alloc] init];
        dispatch_async(dispatch_get_global_queue(0, 0), ^{
            // 判断相册是否兼容视频，兼容才能保存到相册
            if ([library videoAtPathIsCompatibleWithSavedPhotosAlbum:videoURL]) {
                //                [library writeVideoAtPathToSavedPhotosAlbum:videoURL completionBlock:^(NSURL *assetURL, NSError *error) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    
                    
                    // Begin to compress and export the video to the output path
                    NSString *name = [[NSDate date] description];
                    name = [NSString stringWithFormat:@"%@.mp4", name];
                    
                    [self compressVideoWithVideoURL:videoURL savedName:name completion:^(NSString *savedPath) {
                        
                        if (savedPath) {
                            UIImage *image = [self frameImageFromVideoURL:videoURL];
                            YRSendVideoPosterViewController *releseVideo = [[YRSendVideoPosterViewController alloc]init];
                            releseVideo.videoPath = savedPath;
                            releseVideo.thumbnailImg = image;

                            [self.navigationController pushViewController:releseVideo animated:YES];
                            
                        } else {
                            
                            
                        }
                    }];
                    
                });
                //                }];
            }
        });
    }else{ // iOS9.0以后
        dispatch_async(dispatch_get_main_queue(), ^{
            

            
            NSString *name = [[NSDate date] description];
            name = [NSString stringWithFormat:@"%@.mp4", name];
            [self compressVideoWithVideoURL:videoURL savedName:name completion:^(NSString *savedPath) {
                
                if (savedPath) {
                    UIImage *image = [self frameImageFromVideoURL:videoURL];
                    
                    YRSendVideoPosterViewController *releseVideo = [[YRSendVideoPosterViewController alloc]init];
                    releseVideo.videoPath = savedPath;
                    releseVideo.thumbnailImg = image;
                    
                    [self.navigationController pushViewController:releseVideo animated:YES];
                }
            }];
            
        });
    }
    
    [picker dismissViewControllerAnimated:YES completion:^{
        self.tabBarController.view.frame  = [[UIScreen mainScreen] bounds];
        [self.tabBarController.view layoutIfNeeded];
    }];
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker{
    [picker dismissViewControllerAnimated:YES completion:^{
        self.tabBarController.view.frame  = [[UIScreen mainScreen]bounds];
        [self.tabBarController.view layoutIfNeeded];
    }];
}

// Get the video's center frame as video poster image
- (UIImage *)frameImageFromVideoURL:(NSURL *)videoURL {
    
    UIImage *image = nil;
    AVAsset *asset = [AVAsset assetWithURL:videoURL];
    AVAssetImageGenerator *imageGenerator = [[AVAssetImageGenerator alloc] initWithAsset:asset];
    imageGenerator.appliesPreferredTrackTransform = YES;
    
    Float64 duration = CMTimeGetSeconds([asset duration]);
    
    CMTime midpoint = CMTimeMakeWithSeconds(duration / 2.0, 600);
    NSError *error = nil;
    CMTime actualTime;
    CGImageRef centerFrameImage = [imageGenerator copyCGImageAtTime:midpoint
                                                         actualTime:&actualTime
                                                              error:&error];
    
    if (centerFrameImage != NULL) {
        image = [[UIImage alloc] initWithCGImage:centerFrameImage];
        CGImageRelease(centerFrameImage);
    }
    
    return image;
}

// 异步获取帧图片，可以一次获取多帧图片
- (void)centerFrameImageWithVideoURL:(NSURL *)videoURL completion:(void (^)(UIImage *image))completion {
    
    AVAsset *asset = [AVAsset assetWithURL:videoURL];
    AVAssetImageGenerator *imageGenerator = [[AVAssetImageGenerator alloc] initWithAsset:asset];
    imageGenerator.appliesPreferredTrackTransform = YES;
    
    Float64 duration = CMTimeGetSeconds([asset duration]);
    
    CMTime midpoint = CMTimeMakeWithSeconds(duration / 2.0, 600);
    
    // 异步获取多帧图片
    NSValue *midTime = [NSValue valueWithCMTime:midpoint];
    [imageGenerator generateCGImagesAsynchronouslyForTimes:@[midTime] completionHandler:^(CMTime requestedTime, CGImageRef  _Nullable image, CMTime actualTime, AVAssetImageGeneratorResult result, NSError * _Nullable error) {
        if (result == AVAssetImageGeneratorSucceeded && image != NULL) {
            UIImage *centerFrameImage = [[UIImage alloc] initWithCGImage:image];
            dispatch_async(dispatch_get_main_queue(), ^{
                if (completion) {
                    completion(centerFrameImage);
                }
            });
        } else {
            dispatch_async(dispatch_get_main_queue(), ^{
                if (completion) {
                    completion(nil);
                }
            });
        }
    }];
}

/// 压缩并导出视频
- (void)compressVideoWithVideoURL:(NSURL *)videoURL
                        savedName:(NSString *)savedName
                       completion:(void (^)(NSString *savedPath))completion {
    AVURLAsset *videoAsset = [[AVURLAsset alloc] initWithURL:videoURL options:nil];
    
    NSArray *presets = [AVAssetExportSession exportPresetsCompatibleWithAsset:videoAsset];
    if ([presets containsObject:AVAssetExportPreset960x540]) {
        AVAssetExportSession *session = [[AVAssetExportSession alloc] initWithAsset:videoAsset  presetName:AVAssetExportPreset960x540];
        
        NSString *doc = [NSHomeDirectory() stringByAppendingPathComponent:@"Documents"];
        NSString *folder = [doc stringByAppendingPathComponent:@"MGVideos"];
        BOOL isDir = NO;
        BOOL isExist = [[NSFileManager defaultManager] fileExistsAtPath:folder isDirectory:&isDir];
        if (!isExist || (isExist && !isDir)) {
            NSError *error = nil;
            [[NSFileManager defaultManager] createDirectoryAtPath:folder
                                      withIntermediateDirectories:YES
                                                       attributes:nil
                                                            error:&error];
            if (error == nil) {
                [MBProgressHUD showError:@"目录创建成功"];
            } else {
                [MBProgressHUD showError:@"目录创建失败"];
            }
        }
        
        NSString *outPutPath = [folder stringByAppendingPathComponent:savedName];
        session.outputURL = [NSURL fileURLWithPath:outPutPath];
        
        // Optimize for network use.
        session.shouldOptimizeForNetworkUse = true;
        
        NSArray *supportedTypeArray = session.supportedFileTypes;
        if ([supportedTypeArray containsObject:AVFileTypeMPEG4]) {
            session.outputFileType = AVFileTypeMPEG4;
        } else if (supportedTypeArray.count == 0) {
            [MBProgressHUD showError:@"No supported file types"];
            return;
        } else {
            session.outputFileType = [supportedTypeArray objectAtIndex:0];
        }
        
        // Begin to export video to the output path asynchronously.
        [session exportAsynchronouslyWithCompletionHandler:^{
            if ([session status] == AVAssetExportSessionStatusCompleted) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    if (completion) {
                        completion([session.outputURL path]);
                    }
                });
            } else {
                dispatch_async(dispatch_get_main_queue(), ^{
                    if (completion) {
                        completion(nil);
                    }
                });
            }
        }];
    }
}





- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
