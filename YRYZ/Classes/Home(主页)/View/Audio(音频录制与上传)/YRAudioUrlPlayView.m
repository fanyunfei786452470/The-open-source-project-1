//
//  YRAudioUrlPlayView.m
//  YRYZ
//
//  Created by Mrs_zhang on 16/8/23.
//  Copyright © 2016年 yryz. All rights reserved.
//

#import "YRAudioUrlPlayView.h"


@interface YRAudioUrlPlayView()<AVAudioPlayerDelegate>

@property (nonatomic,strong) UIImageView *playAnimationV;
@property (nonatomic,strong) UIButton *playAudioBtn;

@end


@implementation YRAudioUrlPlayView

- (instancetype)initWithFrame:(CGRect)frame AudioUrl:(NSString *)audioUrl AudioTime:(NSString *)time{

    self = [super initWithFrame:frame];
    
    if (self) {
        UIImageView *bkImgView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, frame.size.width, frame.size.height)];
        bkImgView.image        = [UIImage imageNamed:@"yr_button_audionBg"];
        [self addSubview:bkImgView];
        
        UIImageView *playAnimationV = [[UIImageView alloc] initWithFrame:CGRectMake(20, 10, 15, 20)];
        playAnimationV.image        = [UIImage imageNamed:@"yr_circle_audioplay_3"];
        self.playAnimationV         = playAnimationV;
        [self addSubview:playAnimationV];
        
        UIButton *playBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        playBtn.frame     = CGRectMake(CGRectGetMaxX(playAnimationV.frame)+10, 0, 80, 40) ;
        [playBtn setTitle:@"点击播放" forState:UIControlStateNormal];
        [playBtn addTarget:self action:@selector(playAction:) forControlEvents:UIControlEventTouchUpInside];
        self.playAudioBtn = playBtn;
        [self addSubview:playBtn];
        
        NSURL *url = [NSURL URLWithString:audioUrl];
        self.songItem = [[AVPlayerItem alloc]initWithURL:url];
        self.player = [[AVPlayer alloc] initWithPlayerItem:self.songItem];
        
        UILabel *timeLab  = [[UILabel alloc] initWithFrame:CGRectMake(frame.size.width-60, 10, 50, 20)];
        timeLab.textAlignment = NSTextAlignmentCenter;
        timeLab.textColor = [UIColor whiteColor];
        timeLab.text  = time;

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
    DLog(@"播放完成");
    [self.songItem seekToTime:kCMTimeZero];

    [self.player replaceCurrentItemWithPlayerItem:self.songItem];
    self.playAnimationV.image  = [UIImage imageNamed:@"yr_circle_audioplay_3"];
    self.playAudioBtn.selected = NO;
    [self.playAudioBtn setTitle:@"点击播放" forState:UIControlStateNormal];
    [self.playAnimationV stopAnimating];
    
    [self.songItem removeObserver:self forKeyPath:@"status"];
    [[NSNotificationCenter defaultCenter] removeObserver:self];

}
/**
 *  @author ZX, 16-08-23 10:08:38
 *
 *  点击播放
 *
 */
- (void)playAction:(UIButton *)sender{
    if (self.isForwarding) {
        if (sender.selected) {
            
            self.playAnimationV.image = [UIImage imageNamed:@"yr_circle_audioplay_3"];
            [sender setTitle:@"点击播放" forState:UIControlStateNormal];
            [self.playAnimationV stopAnimating];
            [self.player pause];
            sender.selected = NO;
            
        }else{
            
            if (self.isPlay) {
                [sender setTitle:@"停止播放" forState:UIControlStateNormal];
                
                self.playAnimationV.hidden = NO;
                NSMutableArray  *arrayM=[NSMutableArray array];
                for (int i=1; i<=3; i++) {
                    [arrayM addObject:[UIImage imageNamed:[NSString stringWithFormat:@"yr_circle_audioplay_%d",i]]];
                }
                //设置动画数组
                [self.playAnimationV setAnimationImages:arrayM];
                //设置动画播放次数
                [self.playAnimationV setAnimationRepeatCount:0];
                //设置动画播放时间
                [self.playAnimationV setAnimationDuration:3*0.4];
                //开始动画
                [self.playAnimationV startAnimating];
                
                [self.player play];
                sender.selected = YES;
            }
        }
    }else{
        NSAttributedString *arrtString = [[NSAttributedString alloc]initWithString:@"转发挣收益" attributes:@{NSForegroundColorAttributeName:[UIColor themeColor]}];
        YRAlertView *alertView = [[YRAlertView alloc] initWithTitle:@"转发之后才可以接收语音" cancelButtonText:@"再看看" confirmButtonText:(NSString*)arrtString];
            [alertView show];
        alertView.addConfirmAction = ^(){
            self.forward(YES);
        };
    }
    
}
- (void)deleteNotifier:(NSNotification *)notification{
    
    [self.songItem removeObserver:self forKeyPath:@"status"];
    [[NSNotificationCenter defaultCenter] removeObserver:self];

}

@end
