//
//  YRAudioUrlPlayView.m
//  YRYZ
//
//  Created by Mrs_zhang on 16/8/23.
//  Copyright © 2016年 yryz. All rights reserved.
//

#import "YRAudioUrlPlayView.h"


@interface YRAudioUrlPlayView()<AVAudioPlayerDelegate>

@property (nonatomic,weak) UIImageView          *playAnimationV;
@property (nonatomic,weak) UIButton             *playAudioBtn;
@property (nonatomic ,strong) NSMutableArray    *animatList;
@property (nonatomic,copy) NSString             *playImageStr;
@end

@implementation YRAudioUrlPlayView

- (instancetype)initWithFrame:(CGRect)frame AudioUrl:(NSString *)audioUrl AudioTime:(NSString *)time productListModel:(YRProductListModel *)productListModel{
    
    self = [super initWithFrame:frame];
    
    if (self) {

        NSString  *imageStr = @"";
        NSString  *playImageStr = @"";
        self.animatList = @[].mutableCopy;
        
        UIColor  *coror = [UIColor whiteColor];
        if (productListModel.readStatus) {
            imageStr = @"yr_button_playaudionBg";
            playImageStr = @"yr_circle_audioRePlay_3";
            for (int i=1; i<=3; i++) {
                [self.animatList addObject:[UIImage imageNamed:[NSString stringWithFormat:@"yr_circle_audioRePlay_%d",i]]];
            }
            coror = [UIColor themeColor];
            self.playImageStr = playImageStr;
        }else{
            
            imageStr = @"yr_button_audionBg";
            playImageStr = @"yr_circle_audioplay_3";
            for (int i=1; i<=3; i++) {
                [self.animatList addObject:[UIImage imageNamed:[NSString stringWithFormat:@"yr_circle_audioplay_%d",i]]];
            }
            coror = [UIColor whiteColor];
            self.playImageStr = playImageStr;

        }

    
        UIImageView *bkImgView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, frame.size.width, frame.size.height)];
        bkImgView.image        = [UIImage imageNamed:imageStr];
        [self addSubview:bkImgView];
        
        UIImageView *playAnimationV = [[UIImageView alloc] initWithFrame:CGRectMake(20, 10, 15, 20)];
        playAnimationV.image        = [UIImage imageNamed:playImageStr];
        self.playAnimationV         = playAnimationV;
        [self addSubview:playAnimationV];
        
        UIButton *playBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        playBtn.frame     = CGRectMake(CGRectGetMaxX(playAnimationV.frame)+10, 0, 80, 40) ;
        [playBtn setTitle:@"点击播放" forState:UIControlStateNormal];
        [playBtn setTitleColor:coror forState:UIControlStateNormal];
        [playBtn addTarget:self action:@selector(playAction:) forControlEvents:UIControlEventTouchUpInside];
        self.playAudioBtn = playBtn;
        [self addSubview:playBtn];
        
        NSURL *url = [NSURL URLWithString:audioUrl];
        self.songItem = [[AVPlayerItem alloc]initWithURL:url];
        self.player = [[AVPlayer alloc] initWithPlayerItem:self.songItem];
        
        UILabel *timeLab  = [[UILabel alloc] initWithFrame:CGRectMake(frame.size.width-60, 10, 50, 20)];
        timeLab.textAlignment = NSTextAlignmentCenter;
        timeLab.textColor = coror;
        timeLab.text  = time;
        
        [self addSubview:timeLab];
        
        [self.songItem addObserver:self forKeyPath:@"status" options:NSKeyValueObservingOptionNew context:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(playbackFinished:) name:AVPlayerItemDidPlayToEndTimeNotification object:self.songItem];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(deleteNotifier:) name:@"deleteAudioNotifier" object:nil];
    }
    return self;
}


- (instancetype)initWithFrame:(CGRect)frame AudioUrl:(NSString *)audioUrl AudioTime:(NSInteger )time productDetail:(YRProductDetail*)productDetail{
    
    self = [super initWithFrame:frame];
    
    if (self) {
        
        self.productDetail  = productDetail;
        NSString  *imageStr = @"";
        NSString  *playImageStr = @"";
        self.animatList = @[].mutableCopy;
        
        UIColor  *coror = [UIColor whiteColor];
        if (productDetail.readStatus) {
            imageStr = @"yr_button_playaudionBg";
            playImageStr = @"yr_circle_audioRePlay_3";
            for (int i=1; i<=3; i++) {
                [self.animatList addObject:[UIImage imageNamed:[NSString stringWithFormat:@"yr_circle_audioRePlay_%d",i]]];
            }
            coror = [UIColor themeColor];
            self.playImageStr = playImageStr;
        }else{
            
            imageStr = @"yr_button_audionBg";
            playImageStr = @"yr_circle_audioplay_3";
            for (int i=1; i<=3; i++) {
                [self.animatList addObject:[UIImage imageNamed:[NSString stringWithFormat:@"yr_circle_audioplay_%d",i]]];
            }
            coror = [UIColor whiteColor];
            self.playImageStr = playImageStr;
            
        }
        
        
        UIImageView *bkImgView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, frame.size.width, frame.size.height)];
        bkImgView.image        = [UIImage imageNamed:imageStr];
        [self addSubview:bkImgView];
        
        UIImageView *playAnimationV = [[UIImageView alloc] initWithFrame:CGRectMake(20, 10, 15, 20)];
        playAnimationV.image        = [UIImage imageNamed:playImageStr];
        self.playAnimationV         = playAnimationV;
        [self addSubview:playAnimationV];
        
        UIButton *playBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        playBtn.frame     = CGRectMake(CGRectGetMaxX(playAnimationV.frame)+10, 0, 80, 40) ;
        [playBtn setTitle:@"点击播放" forState:UIControlStateNormal];
        [playBtn setTitleColor:coror forState:UIControlStateNormal];
        [playBtn addTarget:self action:@selector(playAction:) forControlEvents:UIControlEventTouchUpInside];
        self.playAudioBtn = playBtn;
        [self addSubview:playBtn];
        
        NSURL *url = [NSURL URLWithString:audioUrl];
        NSLog(@"%@",audioUrl);
        self.songItem = [[AVPlayerItem alloc]initWithURL:url];
        self.player = [[AVPlayer alloc] initWithPlayerItem:self.songItem];
        
        UILabel *timeLab  = [[UILabel alloc] initWithFrame:CGRectMake(frame.size.width-60, 10, 50, 20)];
        timeLab.textAlignment = NSTextAlignmentCenter;
        timeLab.textColor = coror;
        timeLab.text  = [NSString stringWithFormat:@"%ld\"",time];
        [self addSubview:timeLab];
        
        [self.songItem addObserver:self forKeyPath:@"status" options:NSKeyValueObservingOptionNew context:nil];
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(playbackFinished:) name:AVPlayerItemDidPlayToEndTimeNotification object:self.songItem];
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(deleteNotifier:) name:@"deleteAudioNotifier" object:nil];
    }
    return self;
}


- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSString *,id> *)change context:(void *)context {
    
    if ([keyPath isEqualToString:@"status"]) {
        switch (self.player.status) {
            case AVPlayerStatusUnknown:
                DLog(@"KVO：未知状态，此时不能播放");
                break;
            case AVPlayerStatusReadyToPlay:
                self.isPlay = YES;
                DLog(@"KVO：准备完毕，可以播放");
                break;
            case AVPlayerStatusFailed:
                DLog(@"KVO：加载失败，网络或者服务器出现问题");
                break;
            default:
                break;
        }
    }
}

- (void)playbackFinished:(NSNotification *)notice {
    
    [self.player replaceCurrentItemWithPlayerItem:self.songItem];
    
    self.playAnimationV.image  = [UIImage imageNamed:self.playImageStr];
    
    self.playAudioBtn.selected = NO;
    [self.playAudioBtn setTitle:@"点击播放" forState:UIControlStateNormal];
    [self.playAnimationV stopAnimating];
    
}

/**
 *  @author ZX, 16-08-23 10:08:38
 *
 *  点击播放
 *
 */
- (void)playAction:(UIButton *)sender{
    //playState 0没有登录 1没有转发 2播放
    if (_forward) {
        if (![YRUserInfoManager manager].currentUser.custId) {
            _forward(0);
            return;
        }else{
            
            
            if (self.type != 2) {
                if (self.productListModel || self.productDetail){
                    //               作品 //没有转发
                    if (!self.productDetail) {
                        if(self.productListModel.forwardStatus == 0  && self.productListModel.recommand == 0 && self.productListModel.infoForwardStatus == 0 ){
                            _forward(1);
                            return;
                        }
                        
                    }else{
                        if(self.productDetail.forwardStatus == 0  && self.productDetail.recommand == 0  && self.productDetail.infoForwardStatus == 0){
                            _forward(1);
                            return;
                        }
                    }
                }
            }
            //圈子
            if (self.type == 2) {
                    if(self.productDetail.forwardStatus == 0 && self.productDetail.infoForwardStatus == 0 && self.productDetail.recommand == 0){
                    _forward(1);
                    return;
                }
            }
            
        }
    }
    if (sender.selected) {
        
        self.playAnimationV.image = [UIImage imageNamed:@"yr_circle_audioplay_3"];
        [sender setTitle:@"点击播放" forState:UIControlStateNormal];
        [self.playAnimationV stopAnimating];
        [self.player pause];
        sender.selected = NO;
        
    }else{
        
        if (self.isPlay) {
            
            if (_forward) {
                _forward(2);
            }
            
            [sender setTitle:@"停止播放" forState:UIControlStateNormal];
            
            self.playAnimationV.hidden = NO;

            //设置动画数组
            [self.playAnimationV setAnimationImages:self.animatList];
            //设置动画播放次数
            [self.playAnimationV setAnimationRepeatCount:0];
            //设置动画播放时间
            [self.playAnimationV setAnimationDuration:3*0.4];
            //开始动画
            [self.playAnimationV startAnimating];
            
            [self.songItem seekToTime:kCMTimeZero];
            
            [self.player play];
            sender.selected = YES;
        }
    }
    
}
- (void)deleteNotifier:(NSNotification *)notification{
    [self.player pause];
    [self.songItem removeObserver:self forKeyPath:@"status"];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

@end
