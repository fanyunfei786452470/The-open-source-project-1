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
#import "YRReleaseGraphicAdsViewController.h"
#import <AVFoundation/AVFoundation.h>
#import <Photos/Photos.h>
#import <AssetsLibrary/AssetsLibrary.h>
#import "YRMineWebController.h"
#import <AVFoundation/AVAsset.h>
#import <AVFoundation/AVAssetImageGenerator.h>
#import <MobileCoreServices/MobileCoreServices.h>
#import <CoreMedia/CoreMedia.h>

#import <ALBBSDK/ALBBSDK.h>
#import <ALBBQuPai/ALBBQuPaiService.h>
#import <ALBBQuPai/QPEffectMusic.h>

#import "YRAlertView.h"
@interface YRRealseAdsViewController ()<UINavigationControllerDelegate, UIImagePickerControllerDelegate,UIActionSheetDelegate>

@property (nonatomic,strong) UIActionSheet *actionSheet;
@property (nonatomic, assign) BOOL shouldAsync;
@property (nonatomic,strong)UIScrollView * scrollView;
@property (nonatomic,strong)UIButton * imageBtn;
@property (nonatomic,strong)UIButton * videoBtn;
@property (nonatomic,strong)UIButton * ImageVBtn;
@property (nonatomic,strong)UIButton * isYes;
@property (nonatomic,strong)UIView * bgView;

@end

@implementation YRRealseAdsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
//    NSString *text = _isPhone==YES?@"绑定手机号":@"广告发布成功";
    NSString * text = @"红包广告";
    self.title = text;
    [self congUI];
}

//- (void)viewWillAppear:(BOOL)animated{
//    NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
//    NSString *mark = [ user objectForKey:@"mark"];
//    if ([mark isEqualToString:@"1"]) {
//        //_isYes.selected = YES;
//        [_isYes setBackgroundImage:[UIImage imageNamed:@"yr_yesBtn_sel"] forState:UIControlStateNormal];
//        _imageBtn.backgroundColor = RGB_COLOR(204, 204, 204);
//        _videoBtn.backgroundColor = RGB_COLOR(204, 204, 204);
//        _ImageVBtn.backgroundColor = RGB_COLOR(204, 204, 204);
//    }else{
//        //_isYes.selected = NO;
//        [_isYes setBackgroundImage:[UIImage imageNamed:@"yr_yesBtn_nor"] forState:UIControlStateNormal];
//        _imageBtn.backgroundColor = RGB_COLOR(43, 193, 183);
//        _videoBtn.backgroundColor = RGB_COLOR(43, 193, 183);
//        _ImageVBtn.backgroundColor = RGB_COLOR(43, 193, 183);
//    }
//}
- (void)congUI{
    
    _scrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT-64)];
    _scrollView.userInteractionEnabled = YES;
    _scrollView.contentSize = CGSizeMake(SCREEN_WIDTH, 655*SCREEN_H_POINT);
    [self.view addSubview:_scrollView];
    
    _bgView = [[UIView alloc]initWithFrame:CGRectMake(0, 64, SCREEN_WIDTH, 706*SCREEN_H_POINT)];
    //[_scrollView addSubview:_bgView];
    UIImageView *headerImage = [[UIImageView alloc]init];
    //NSString *str = _isPhone==YES?@"yr_phone":@"yr_ads_yes";
     [_scrollView  addSubview:headerImage];
    headerImage.image = [UIImage imageNamed:@"bianji"];
    
    [headerImage mas_makeConstraints:^(MASConstraintMaker *make) {
       
        make.top.equalTo(_scrollView.mas_top).mas_offset(60*SCREEN_H_POINT);
        make.centerX.equalTo(self.view);
        make.size.mas_equalTo(CJSizeMake(150, 150));
    }];
   
//    UILabel *label = [[UILabel alloc]init];
//    label.font = [UIFont systemFontOfSize:16];
//    label.textColor = RGB_COLOR(130, 130, 130);
//    label.textAlignment = NSTextAlignmentCenter;
//    NSString *strT = _isPhone==YES?@"手机号绑定成功":@"广告发布成功,请耐心等待审核";
//    label.text = strT;
//    [self.view addSubview:label];
//    [label mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.top.equalTo(headerImage.mas_bottom).mas_offset(20);
//        make.centerX.equalTo(headerImage);
//        make.size.mas_equalTo(CJSizeMake(SCREEN_WIDTH, 20));
//        
//    }];
    

    UIImageView *bttom = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"yr_release"]];
    [_scrollView addSubview:bttom];
    [bttom mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(headerImage.mas_bottom).mas_offset(40*SCREEN_H_POINT);
        make.centerX.equalTo(headerImage);
        make.size.mas_equalTo(CGSizeMake(300*SCREEN_H_POINT, 180*SCREEN_H_POINT));
    }];
    bttom.userInteractionEnabled = YES;
    _imageBtn = [UIButton buttonWithType:UIButtonTypeSystem];
    _imageBtn.tag= 100;
    [_imageBtn setTitle:@"图文" forState:UIControlStateNormal];
    _imageBtn.backgroundColor = RGB_COLOR(204, 204, 204);
//    imageBtn.backgroundColor = RGB_COLOR(43, 193, 183);
    [_imageBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    
    _videoBtn = [UIButton buttonWithType:UIButtonTypeSystem];
    [_videoBtn setTitle:@"视频拍摄" forState:UIControlStateNormal];
    _videoBtn.tag = 101;
    _videoBtn.backgroundColor = RGB_COLOR(204, 204, 204);
//    videoBtn.backgroundColor = RGB_COLOR(43, 193, 183);
    [_videoBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    
    _ImageVBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    _ImageVBtn.tag = 102;
    [_ImageVBtn setTitle:@"视频从相册获取" forState:UIControlStateNormal];
    _ImageVBtn.backgroundColor = RGB_COLOR(204, 204, 204);
//    ImageVBtn.backgroundColor = RGB_COLOR(43, 193, 183);
    [_ImageVBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [_ImageVBtn.titleLabel setFont:[UIFont systemFontOfSize:15]];
    [bttom addSubview:_imageBtn];
    [bttom addSubview:_videoBtn];
    [bttom addSubview:_ImageVBtn];
    
    _isYes = [UIButton buttonWithType:UIButtonTypeCustom];
    //    isYes.backgroundColor = [UIColor redColor];yr_yesBtn_sel
    [_isYes setBackgroundImage:[UIImage imageNamed:@"yr_yesBtn_sel"] forState:UIControlStateSelected];
    [_isYes setBackgroundImage:[UIImage imageNamed:@"yr_yesBtn_nor"] forState:UIControlStateNormal];
    
    _isYes.tag = 222;
    UILabel *label = [[UILabel alloc]init];
    label.text = @"我已阅读并同意";
    label.font = [UIFont systemFontOfSize:14*SCREEN_H_POINT];
    label.textColor = RGB_COLOR(187, 187, 187);
    UIButton *guize = [UIButton buttonWithType:UIButtonTypeSystem];
    [guize setTitle:@"《红包广告发布及使用规则》" forState:UIControlStateNormal];
    [guize setTitleColor:RGB_COLOR(70, 207, 199) forState:UIControlStateNormal];
    [guize.titleLabel setFont:[UIFont systemFontOfSize:14*SCREEN_H_POINT]];
    guize.tag = 333;
    [_scrollView addSubview:_isYes];
    [_scrollView addSubview:label];
    [_scrollView addSubview:guize];
    
    UIView * ruleView = [[UIView alloc]init];
    ruleView.backgroundColor = RGB_COLOR(240, 240, 240);
    [_scrollView addSubview:ruleView];
    UIImageView * firstImage = [[UIImageView alloc]init];
    [firstImage setImage:[UIImage imageNamed:@"1"]];
    [ruleView addSubview:firstImage];
    UIImageView * secondImage = [[UIImageView alloc]init];
    [secondImage setImage:[UIImage imageNamed:@"2"]];
    [ruleView addSubview:secondImage];
    UILabel * firstRule = [[UILabel alloc]init];
    firstRule.text = @"企业和个人完成了在悠然一指的注册后，均可以按照《红包广告发布及使用规则》的要求，申请在悠然一指“红包广告”栏目发布广告。";
    firstRule.textColor = RGB_COLOR(153, 153, 153);
    firstRule.numberOfLines = 0;
    [firstRule setFont:[UIFont systemFontOfSize:15*SCREEN_H_POINT]];
    [ruleView addSubview:firstRule];
    UILabel * secondRule = [[UILabel alloc]init];
    secondRule.text = @"申请发布广告的用户在提交了拟发布广告内容后的24小时内，须向平台提交必要的资质材料。资质材料发送至ad@yryz.com,发送后等候平台审核。";
    secondRule.numberOfLines = 0;
    [secondRule sizeToFit];
    secondRule.textColor = RGB_COLOR(153, 153, 153);
    [secondRule setFont:[UIFont systemFontOfSize:15*SCREEN_H_POINT]];
    [ruleView addSubview:secondRule];
    
    
    [ruleView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(label.mas_bottom).offset(50*SCREEN_H_POINT);
        make.left.mas_equalTo(_scrollView.mas_left).offset(0);
        make.size.mas_equalTo(CGSizeMake(SCREEN_WIDTH, 150*SCREEN_H_POINT));
    }];
    [firstImage mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.mas_equalTo(15*SCREEN_H_POINT);
        make.top.mas_equalTo(6.5*SCREEN_H_POINT);
        make.size.mas_equalTo(CGSizeMake(18*SCREEN_H_POINT, 18*SCREEN_H_POINT));
    }];
    [firstRule mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(firstImage.mas_right).offset(5*SCREEN_H_POINT);
        make.top.mas_equalTo(firstImage.mas_top);
        make.height.mas_equalTo(54*SCREEN_H_POINT);
        make.width.mas_equalTo((SCREEN_WIDTH - 50*SCREEN_H_POINT));
    }];
    [secondImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(firstImage.mas_left);
        make.top.mas_equalTo(firstRule.mas_bottom).offset(6.5*SCREEN_H_POINT);
        make.size.mas_equalTo(CGSizeMake(18*SCREEN_H_POINT, 18*SCREEN_H_POINT));
    }];
    [secondRule mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(secondImage.mas_right).offset(5*SCREEN_H_POINT);
        make.top.mas_equalTo(firstRule.mas_bottom);
        make.height.mas_equalTo(85*SCREEN_H_POINT);
        make.width.mas_equalTo((SCREEN_WIDTH - 50*SCREEN_H_POINT));
    }];

    
    
    
    [_isYes mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(bttom.mas_bottom).mas_offset(5*SCREEN_H_POINT);
        make.left.equalTo(bttom.mas_left).mas_offset(0);
        make.size.mas_equalTo(CGSizeMake(22*SCREEN_H_POINT, 22*SCREEN_H_POINT));
    }];
    
    [label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(_isYes);
        make.left.equalTo(_isYes.mas_right).mas_offset(5*SCREEN_H_POINT);
        make.size.mas_equalTo(CGSizeMake(105*SCREEN_H_POINT, 20*SCREEN_H_POINT));
    }];
    
    
    [guize mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(_isYes);
        make.left.equalTo(label.mas_right).mas_offset(0);
        make.size.mas_equalTo(CGSizeMake(190*SCREEN_H_POINT, 20*SCREEN_H_POINT));
    }];
    
    [_imageBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(bttom.mas_top).mas_offset(40*SCREEN_H_POINT);
        make.centerX.equalTo(bttom);
        make.size.mas_equalTo(CJSizeMake(170, 30));
    }];
    
    [_videoBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_imageBtn.mas_bottom).mas_offset(20*SCREEN_H_POINT);
        make.centerX.equalTo(bttom);
        make.size.mas_equalTo(CJSizeMake(170, 30));
    }];
    
    [_ImageVBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_videoBtn.mas_bottom).mas_offset(20*SCREEN_H_POINT);
        make.centerX.equalTo(bttom);
        make.size.mas_equalTo(CJSizeMake(170, 30));
    }];
    
    _imageBtn.layer.cornerRadius = 15*SCREEN_H_POINT;
    _videoBtn.layer.cornerRadius = 15*SCREEN_H_POINT;
    _ImageVBtn.layer.cornerRadius = 15*SCREEN_H_POINT;
    _imageBtn.clipsToBounds = YES;
    _videoBtn.clipsToBounds = YES;
    _ImageVBtn.clipsToBounds = YES;
    
    [_imageBtn addTarget:self action:@selector(BtnClick:) forControlEvents:UIControlEventTouchUpInside];
    
    [_videoBtn addTarget:self action:@selector(BtnClick:) forControlEvents:UIControlEventTouchUpInside];
    
    [_ImageVBtn addTarget:self action:@selector(BtnClick:) forControlEvents:UIControlEventTouchUpInside];
    
    [_isYes addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
    [guize addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
}

- (void)btnClick:(UIButton *)sender{
    if (sender.tag==222) {
        if (sender.selected) {
//            NSString * mark = @"1";
//            NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
//            [user setObject:mark forKey:@"mark"];
            [_isYes setBackgroundImage:[UIImage imageNamed:@"yr_yesBtn_sel"] forState:UIControlStateSelected];
            _imageBtn.backgroundColor = RGB_COLOR(204, 204, 204);
            _videoBtn.backgroundColor = RGB_COLOR(204, 204, 204);
            _ImageVBtn.backgroundColor = RGB_COLOR(204, 204, 204);
        }else{
//            NSString * mark = @"0";
//            NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
//            [user setObject:mark forKey:@"mark"];
            [_isYes setBackgroundImage:[UIImage imageNamed:@"yr_yesBtn_nor"] forState:UIControlStateNormal];
            _imageBtn.backgroundColor = RGB_COLOR(43, 193, 183);
            _videoBtn.backgroundColor = RGB_COLOR(43, 193, 183);
            _ImageVBtn.backgroundColor = RGB_COLOR(43, 193, 183);
        }
            sender.selected = !sender.selected;
    }if (sender.tag==333) {
        YRMineWebController * web = [[YRMineWebController alloc]init];
        web.url = REDADSUSERULES;
        web.titletext = @"红包广告发布及使用规则";
        [self.navigationController pushViewController:web animated:YES];
    }
}
- (void)BtnClick:(UIButton *)sender{
    if (_isYes.selected) {
        if (sender.tag==100) {
            YRReleaseGraphicAdsViewController * graphic = [[YRReleaseGraphicAdsViewController alloc]init];
            [self.navigationController pushViewController:graphic animated:YES];
        }if (sender.tag ==101) {
//            if (SYSTEMVERSION>9.0) {
                [self movieAction];
//            }else{
//                [MBProgressHUD showError:@"当前系统版本不支持视频拍摄"];
//            }
        }if (sender.tag == 102) {
            [self getVideoWithsourceType:UIImagePickerControllerSourceTypeSavedPhotosAlbum shouldAsync:NO];
        }
    }else{
        YRAlertView * alertView = [[YRAlertView alloc]initWithTitle:@"  请先阅读并同意\n《红包广告发布及使用规则》" cancelButtonText:@"知道了"];
        alertView.addCancelAction = ^{
            
        };
        [alertView show];
    }
}
- (void)imageBtnClick:(UIButton *)sender{
    
//    YRRedPaperAdPaymemtViewController *ViewController = [[YRRedPaperAdPaymemtViewController alloc]init];
//    [self.navigationController pushViewController:ViewController animated:YES];
    
    YRReleaseGraphicAdsViewController * graphic = [[YRReleaseGraphicAdsViewController alloc]init];
    [self.navigationController pushViewController:graphic animated:YES];
    
}

- (void)videoBtnClick:(UIButton *)sender{
    
//    if([[UIDevice currentDevice].systemVersion doubleValue] >= 8.0)
//    {
//        UIAlertController *alert = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:UIAlertControllerStyleActionSheet];
//        
//        NSArray *titles = @[@"拍摄视频",@"从相册选取"];
//        [self addActionTarget:alert titles:titles];
//        [self addCancelActionTarget:alert title:@"取消"];
//        
//        // 会更改UIAlertController中所有字体的内容（此方法有个缺点，会修改所以字体的样式）
//        UILabel *appearanceLabel = [UILabel appearanceWhenContainedIn:UIAlertController.class, nil];
//        UIFont *font = [UIFont systemFontOfSize:15];
//        appearanceLabel.font = font;
//        
//        [self presentViewController:alert animated:YES completion:nil];
//        
//    }else{
//        [self.actionSheet showInView:self.view];
//    }
    if (SYSTEMVERSION>9.0) {
        [self movieAction];
        
    }else{
        [MBProgressHUD showError:@"当前系统版本不支持视频拍摄"];
    }

}

- (void)ImageVBtnClick:(UIButton *)sender{
        [self getVideoWithsourceType:UIImagePickerControllerSourceTypeSavedPhotosAlbum shouldAsync:NO];
}

//// 添加其他按钮
//- (void)addActionTarget:(UIAlertController *)alertController titles:(NSArray *)titles{
//    for (NSString *title in titles) {
//        
//        if ([title isEqualToString:@"拍摄视频"]) {
//            UIAlertAction *action = [UIAlertAction actionWithTitle:title style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
//                
//                //                [self getVideoWithsourceType:UIImagePickerControllerSourceTypeCamera shouldAsync:YES];
//                if (SYSTEMVERSION>9.0) {
//                    [self movieAction];
//
//                }else{
//                    [MBProgressHUD showError:@"当前系统版本不支持视频拍摄"];
//                }
//            }];
//            [action setValue:[UIColor themeColor] forKey:@"_titleTextColor"];
//            [alertController addAction:action];
//        }
//        if ([title isEqualToString:@"从相册选取"]) {
//            UIAlertAction *action = [UIAlertAction actionWithTitle:title style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
//                [self getVideoWithsourceType:UIImagePickerControllerSourceTypeSavedPhotosAlbum shouldAsync:NO];
//                
//                
//            }];
//            [action setValue:[UIColor themeColor] forKey:@"_titleTextColor"];
//            [alertController addAction:action];
//        }
//        
//        
//    }
//}


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




- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
