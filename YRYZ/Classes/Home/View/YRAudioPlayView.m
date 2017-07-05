//
//  YRAudioProgressView.m
//  YRYZ
//
//  Created by Mrs_zhang on 16/8/23.
//  Copyright © 2016年 yryz. All rights reserved.
//

#import "YRAudioPlayView.h"
#import <AVFoundation/AVFoundation.h>

@interface YRAudioPlayView()<AVAudioPlayerDelegate>

@property (nonatomic,strong) UIImageView *playAnimationV;

@property (nonatomic,strong) AVAudioPlayer *audioPlayer;//播放器

@property (nonatomic,strong) UIButton *playAudioBtn;

@end

@implementation YRAudioPlayView


- (instancetype)initWithFrame:(CGRect)frame AudioPath:(NSString *)audioPath AudioTime:(NSString *)time{
   
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
        
        UILabel *timeLab  = [[UILabel alloc] initWithFrame:CGRectMake(frame.size.width-60, 10, 50, 20)];
        timeLab.textAlignment = NSTextAlignmentCenter;
        timeLab.textColor = [UIColor whiteColor];
        timeLab.text      = time;
        [self addSubview:timeLab];
        
        NSURL *url = [NSURL fileURLWithPath:audioPath];
 
        NSError *error = nil;
        _audioPlayer = [[AVAudioPlayer alloc]initWithContentsOfURL:url error:&error];
        //设置播放器属性
        _audioPlayer.numberOfLoops = 0;//设置为0不循环
        _audioPlayer.delegate = self;
        _audioPlayer.volume = 0.8;
        [_audioPlayer prepareToPlay];//加载音频文件到缓存

    }

    return self;
}

/**
 *  @author ZX, 16-08-23 10:08:38
 *
 *  点击播放
 *
 */
- (void)playAction:(UIButton *)sender{

    
    if (sender.selected) {
        
        self.playAnimationV.image = [UIImage imageNamed:@"yr_circle_audioplay_3"];
        [sender setTitle:@"点击播放" forState:UIControlStateNormal];
        [self.playAnimationV stopAnimating];
        [self.audioPlayer pause];

        sender.selected = NO;
    }else{
        
        [[NSNotificationCenter defaultCenter] postNotificationName:TranSuccess_Audio_Notification_Key object:self];
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

        [self playAudio];
     
        sender.selected = YES;
    }
}

- (void)playAudio{
    
    if (![self.audioPlayer isPlaying]) {
        
        self.audioPlayer.volume=1.0;
        UInt32 doChangeDefaultRoute = 1;
        AudioSessionSetProperty(kAudioSessionProperty_OverrideCategoryDefaultToSpeaker,sizeof(doChangeDefaultRoute), &doChangeDefaultRoute);
        
        [self.audioPlayer play];
    }
}

#pragma mark - 播放器代理方法
-(void)audioPlayerDidFinishPlaying:(AVAudioPlayer *)player successfully:(BOOL)flag{
    NSLog(@"音乐播放完成...");
    
    self.playAnimationV.image  = [UIImage imageNamed:@"yr_circle_audioplay_3"];
    self.playAudioBtn.selected = NO;
    [self.playAudioBtn setTitle:@"点击播放" forState:UIControlStateNormal];
    [self.playAnimationV stopAnimating];

}

- (void)audioPlayerEndInterruption:(AVAudioPlayer *)player
{
    [self.audioPlayer play];
}
@end
