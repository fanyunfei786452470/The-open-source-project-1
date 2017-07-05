//
//  YRVideoMainViewController.m
//  YRYZ
//
//  Created by weishibo on 16/8/3.
//  Copyright © 2016年 yryz. All rights reserved.
//

#import "YRVideoMainViewController.h"
#import "BaseNavigationController.h"
#import "YRVideoViewController.h"
#import "YRVideoUploadingViewController.h"
#import "YRReleasedVideoController.h"
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

#import "YRInfoProductTypeModel.h"

@interface YRVideoMainViewController ()<UINavigationControllerDelegate, UIImagePickerControllerDelegate,UIActionSheetDelegate>

@property (nonatomic, assign) BOOL shouldAsync;

@end

@implementation YRVideoMainViewController
- (NSMutableArray*)typeDataSource{
    
    if (!_typeDataSource) {
        _typeDataSource = @[].mutableCopy;
    }
    return _typeDataSource;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"精彩视频";
    if (self.typeDataSource.count == 0 || !self.typeDataSource  ) {
        [self fectProductTypeList:kInfoTypeVideo];
    }
    [self setRightNavButtonWithImage:@"yr_show_edit" title:@"发布"];
    [self setUpChildControllers];
    
}

- (void)fectProductTypeList:(InfoProductType)type{
    
    [YRHttpRequest productTypeListAnd:type cacheKey:nil success:^(NSArray *data) {
        NSArray  *array =  [YRInfoProductTypeModel mj_objectArrayWithKeyValuesArray:data];
        [self.typeDataSource removeAllObjects];
        [self.typeDataSource addObjectsFromArray:array];
        [[YRYYCache share].yyCache removeObjectForKey:@"videodataSource"];
        [[YRYYCache share].yyCache setObject:array forKey:@"videodataSource"];
        
    } failure:^(NSString *data) {
        [MBProgressHUD showError:data];
    }];
    
}

// 添加子控制器
- (void)setUpChildControllers{
    
    @weakify(self);
    [self.typeDataSource    enumerateObjectsUsingBlock:^(YRInfoProductTypeModel *model, NSUInteger idx, BOOL * _Nonnull stop) {
        @strongify(self);
        
        YRVideoViewController *videoController = [[YRVideoViewController alloc]init];
        videoController.title = model.channelName;
        videoController.model = model;
        [self addChildViewController:videoController];
        
    }];
}

/**
 *  @author ZX, 16-08-15 14:08:20
 *
 *  发布视频
 */
- (void)rightNavAction:(UIButton *)button{
    
    if (![YRUserInfoManager manager].currentUser.custId) {
        [self noLoginTip];
        return;
    }
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    
    NSArray *titles = @[@"拍摄视频",@"从相册选取"];
    [self addActionTarget:alert titles:titles];
    [self addCancelActionTarget:alert title:@"取消"];
    
    // 会更改UIAlertController中所有字体的内容（此方法有个缺点，会修改所以字体的样式）
    UILabel *appearanceLabel = [UILabel appearanceWhenContainedIn:UIAlertController.class, nil];
    UIFont *font = [UIFont systemFontOfSize:15];
    appearanceLabel.font = font;
    
    [self presentViewController:alert animated:YES completion:nil];
}

// 添加其他按钮
- (void)addActionTarget:(UIAlertController *)alertController titles:(NSArray *)titles{
    @weakify(self);
    for (NSString *title in titles) {
        
        if ([title isEqualToString:@"拍摄视频"]) {
            UIAlertAction *action = [UIAlertAction actionWithTitle:title style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
                @strongify(self);
                [self movieAction];
                
            }];
            if (SYSTEMVERSION>=8.4) {
                [action setValue:[UIColor themeColor] forKey:@"_titleTextColor"];
            }
            [alertController addAction:action];
        }
        if ([title isEqualToString:@"从相册选取"]) {
            UIAlertAction *action = [UIAlertAction actionWithTitle:title style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
                @strongify(self);
                
                [self getVideoWithsourceType:UIImagePickerControllerSourceTypeSavedPhotosAlbum shouldAsync:NO];
                
            }];
            if (SYSTEMVERSION>=8.4) {
                [action setValue:[UIColor themeColor] forKey:@"_titleTextColor"];
            }
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
    
    [self presentViewController:navigation animated:YES completion:^{
        [self canRecord];
        [self isRearCameraAvailable];
    }];
    
}
// 后面的摄像头是否可用
- (BOOL) isRearCameraAvailable{
    
    __block BOOL bCanRecord = NO;
    
    NSString *mediaType = AVMediaTypeVideo;//读取媒体类型
    AVAuthorizationStatus authStatus = [AVCaptureDevice authorizationStatusForMediaType:mediaType];//读取设备授权状态
    if(authStatus == AVAuthorizationStatusRestricted || authStatus == AVAuthorizationStatusDenied){
        bCanRecord = NO;
        dispatch_async(dispatch_get_main_queue(), ^{
            [[[UIAlertView alloc] initWithTitle:@"无法拍摄"
                                        message:@"悠然一指需要访问您的相机。\n请启用相机-设置/隐私/相机"
                                       delegate:nil
                              cancelButtonTitle:@"关闭"
                              otherButtonTitles:nil] show];
        });
        
    }else{
        bCanRecord = YES;
        
    }
    
    return bCanRecord;
}
-(BOOL)canRecord
{
    __block BOOL bCanRecord = NO;
    AVAudioSession *audioSession = [AVAudioSession sharedInstance];
    if ([audioSession respondsToSelector:@selector(requestRecordPermission:)]) {
        [audioSession performSelector:@selector(requestRecordPermission:) withObject:^(BOOL granted) {
            if (granted) {
                bCanRecord = YES;
            }
            else {
                bCanRecord = NO;
                dispatch_async(dispatch_get_main_queue(), ^{
                    [[[UIAlertView alloc] initWithTitle:@"无法录音"
                                                message:@"悠然一指需要访问您的麦克风。\n请启用麦克风-设置/隐私/麦克风"
                                               delegate:nil
                                      cancelButtonTitle:@"关闭"
                                      otherButtonTitles:nil] show];
                });
            }
        }];
    }
    return bCanRecord;
}

- (void)qupaiSDK:(id<ALBBQuPaiService>)sdk compeleteVideoPath:(NSString *)videoPath thumbnailPath:(NSString *)thumbnailPath
{
    
    [self dismissViewControllerAnimated:YES completion:nil];
    
    if (videoPath) {
        UISaveVideoAtPathToSavedPhotosAlbum(videoPath, nil, nil, nil);
        
        YRReleasedVideoController *releseVideo = [[YRReleasedVideoController alloc]init];
        releseVideo.videoTypeArr = self.typeDataSource;
        NSData *data = [NSData dataWithContentsOfFile:thumbnailPath];
        UIImage *image = [UIImage imageWithData:data];
        releseVideo.videoPath = videoPath;
        releseVideo.thumbnailImg = image;
        
        
        BaseNavigationController *navigation = [[BaseNavigationController alloc] initWithRootViewController:releseVideo];
        [self presentViewController:navigation animated:YES completion:nil];
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
        //        BaseNavigationController *nav = [[BaseNavigationController alloc] initWithRootViewController:picker];
        
        [self presentViewController:picker animated:YES completion:NULL];
        self.shouldAsync = shouldAsync;
    } else {
        [MBProgressHUD showError:@"手机不支持摄像"];
    }
    
}

#pragma mark - UIImagePickerControllerDelegate
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info{
    
    @weakify(self);
    

    
    NSURL *videoURL = [info objectForKey:UIImagePickerControllerMediaURL];
    if (!videoURL) {
        return;
    }
    NSString *strPath = [videoURL absoluteString];
    NSString *path = [strPath substringFromIndex:7];
    
    if ([UIDevice currentDevice].systemVersion.doubleValue < 9.0) {
        ALAssetsLibrary *library = [[ALAssetsLibrary alloc] init];
        dispatch_async(dispatch_get_global_queue(0, 0), ^{
            // 判断相册是否兼容视频，兼容才能保存到相册
            if ([library videoAtPathIsCompatibleWithSavedPhotosAlbum:videoURL]) {
                
                dispatch_async(dispatch_get_main_queue(), ^{
                    @strongify(self);
                    // Begin to compress and export the video to the output path
                    NSString *name = [[NSDate date] description];
                    name = [NSString stringWithFormat:@"%@.mp4", name];
                    
                            DLog(@"视频大小：%f",[self fileSizeAtPath:path]);

                            if ([self fileSizeAtPath:path]<500) {
                            UIImage *image = [self frameImageFromVideoURL:videoURL];
                                
                            YRReleasedVideoController *releseVideo = [[YRReleasedVideoController alloc]init];
                            releseVideo.videoTypeArr = self.typeDataSource;
                            releseVideo.videoPath = path;
                            releseVideo.thumbnailImg = image;
                            
                            BaseNavigationController *navigation = [[BaseNavigationController alloc] initWithRootViewController:releseVideo];
                                
                            [self presentViewController:navigation animated:YES completion:nil];
                                
                            }else{
                                    [MBProgressHUD showError:@"上传视频不能大于500M!"];
                            }
                });
            }
        });
    }else{ // iOS9.0以后
        dispatch_async(dispatch_get_main_queue(), ^{
            @strongify(self);
            
            NSString *name = [[NSDate date] description];
            name = [NSString stringWithFormat:@"%@.mp4", name];
                    DLog(@"视频大小：%f",[self fileSizeAtPath:path]);
                    if ([self fileSizeAtPath:path]<500) {
                        UIImage *image = [self frameImageFromVideoURL:videoURL];
                        
                        YRReleasedVideoController *releseVideo = [[YRReleasedVideoController alloc]init];
                        releseVideo.videoTypeArr = self.typeDataSource;
                        
                        releseVideo.videoPath = path;
                        releseVideo.thumbnailImg = image;
                        
                        BaseNavigationController *navigation = [[BaseNavigationController alloc] initWithRootViewController:releseVideo];
                        [self presentViewController:navigation animated:YES completion:nil];

                    }else{
                        [MBProgressHUD showError:@"上传视频不能大于500M!"];
                    }
            
        });
    }
    
    [picker dismissViewControllerAnimated:YES completion:^{
        @strongify(self);
        
        self.tabBarController.view.frame  = [[UIScreen mainScreen] bounds];
        [self.tabBarController.view layoutIfNeeded];
    }];
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker{
    
    @weakify(self);
    [picker dismissViewControllerAnimated:YES completion:^{
        @strongify(self);
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


- (float) fileSizeAtPath:(NSString*) filePath{
    
    //
    //    NSData* data = [NSData dataWithContentsOfFile:[VoiceRecorderBaseVC getPathByFileName:_convertAmr ofType:@"amr"]];
    //    NSLog(@"amrlength = %d",data.length);
    //    NSString * amr = [NSString stringWithFormat:@"amrlength = %d",data.length];
    
    NSFileManager* manager = [NSFileManager defaultManager];
    
    if ([manager fileExistsAtPath:filePath]){
        
        return [[manager attributesOfItemAtPath:filePath error:nil] fileSize]/(1024.0*1024);
    }
    return 0;
    
}

@end
