//
//  YRSoundRecordingViewController.m
//  YRYZ
//
//  Created by Rongzhong on 16/8/4.
//  Copyright © 2016年 yryz. All rights reserved.
//

#import "YRSoundRecordingViewController.h"
#import "YRProgressView.h"
#import <AVFoundation/AVFoundation.h>
#import "lame.h"

#define kRecordAudioFile @"myRecord.caf"

typedef enum{
    RecordTypeStartRecording,
    RecordTypeEndRecording,
    RecordTypePlayRecording,
    RecordTypeEndPlayRecording,
    
} RecordType;


@interface YRSoundRecordingViewController ()<AVAudioRecorderDelegate,AVAudioPlayerDelegate>

@property (nonatomic,strong ) UILabel         *tintLabel;

@property (nonatomic,strong ) UILabel         *timeLabel;

@property (nonatomic,strong ) AVAudioRecorder *audioRecorder;//音频录音机
@property (nonatomic,strong ) AVAudioPlayer   *audioPlayer;//音频播放器，用于播放录音文件
@property (nonatomic,strong ) NSTimer         *timer;//录音声波监控（注意这里暂时不对播放进行监控）
@property (strong, nonatomic) UIButton        *record;//开始录音
@property (strong, nonatomic) UIButton        *pause;//暂停录音
@property (strong, nonatomic) UIButton        *resume;//恢复录音
@property (strong, nonatomic) UIButton        *stop;//停止录音
@property (weak, nonatomic) UIButton        *audioRecorderButton;
@property (strong, nonatomic) UIProgressView  *audioPower;//音频波动
@property (strong, nonatomic) YRProgressView  * progressView;
@property (strong, nonatomic) UIButton        *nextStepButton;//下一步
@property (strong, nonatomic) UIButton        *reRecorderButton;//重录
@property (strong, nonatomic) NSData          *data;//语音文件

@end

@implementation YRSoundRecordingViewController
{
    RecordType recordType;
    NSInteger recordTime;
}

#pragma mark - 控制器视图方法

- (NSMutableArray *)dataSource{
    if (!_dataSource) {
        _dataSource = [NSMutableArray array];
    }
    return _dataSource;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    
    recordType = RecordTypeStartRecording;
    recordTime = 0;
    
    [self setTitle:@"录音"];
    
    [self setLeftNavButtonWithTitle:@"取消"];
    
    [self setAudioSession];
    
    [self initUI];
}

- (void)leftNavAction:(UIButton *)button{

    @weakify(self);
    if (self.data) {
        YRAlertView *alertView = [[YRAlertView alloc] initWithTitle:@"确定退出编辑?" cancelButtonText:@"取消" confirmButtonText:@"确定"];
        
        alertView.addCancelAction = ^{
            
        };
        alertView.addConfirmAction = ^{
            @strongify(self);
            
            [self dismissViewControllerAnimated:YES completion:nil];
            
        };
        
        [alertView show];
        
    }else{
        
        [self dismissViewControllerAnimated:YES completion:nil];

    }
}

-(void)initUI
{
    
    _tintLabel = [[UILabel alloc]init];
    _tintLabel.frame = YRRectMake(0, 90, 320, 18);
    _tintLabel.text = @"点击开始录音，最多可以录制120\"";
    _tintLabel.textAlignment = NSTextAlignmentCenter;
    _tintLabel.textColor = [UIColor grayColorOne];
    _tintLabel.font = [UIFont systemFontOfSize:18];
    [self.view addSubview:_tintLabel];
    
    _progressView = [[YRProgressView alloc]initWithFrame:YRRectMake(98, 140, 124, 124)];
    _progressView.percent = 0.5;
    _progressView.arcBackColor = RGB_COLOR(225, 225, 225);
    _progressView.arcUnfinishColor = RGB_COLOR(254, 96, 96);
    _progressView.arcFinishColor = RGB_COLOR(254, 96, 96);
    _progressView.width = 6;
    _progressView.percent = 0;
    [self.view addSubview:_progressView];
    
    _timeLabel = [[UILabel alloc]init];
    _timeLabel.frame = YRRectMake(0, 270, 320, 16);
    _timeLabel.text = @"0\"";
    _timeLabel.textAlignment = NSTextAlignmentCenter;
    _timeLabel.textColor = RGB_COLOR(254, 96, 96);
    _timeLabel.font = [UIFont systemFontOfSize:16];
    [self.view addSubview:_timeLabel];
    
    
    UIButton *audioRecorderButton       = [UIButton buttonWithType:UIButtonTypeCustom];
    audioRecorderButton.tag             = 100;
    audioRecorderButton.frame           = YRRectMake(132.5, 174.5, 55, 55);
    [audioRecorderButton setBackgroundImage:[UIImage imageNamed:@"startRecordingImage"] forState:UIControlStateNormal];
    audioRecorderButton.titleLabel.font = [UIFont systemFontOfSize:18];
    
    [audioRecorderButton setTitleColor:[UIColor themeColor] forState:UIControlStateNormal];
    
    [audioRecorderButton addTarget:self action:@selector(recordButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    self.audioRecorderButton = audioRecorderButton;
    [self.view addSubview:audioRecorderButton];
    
    UIImageView *animationImageView = [[UIImageView alloc]init];
    animationImageView.frame        = YRRectMake(0, 0, 55, 55);
    animationImageView.tag          = 1;
    [audioRecorderButton addSubview:animationImageView];
    animationImageView.hidden       = YES;

    self.reRecorderButton                    = [UIButton buttonWithType:UIButtonTypeCustom];
    self.reRecorderButton.frame              = YRRectMake(21.5, 330, 130, 34);
    self.reRecorderButton.backgroundColor    = RGB_COLOR(204, 204, 204);
    self.reRecorderButton.layer.cornerRadius = 17 * SCREEN_WIDTH /320.0f;
    [self.reRecorderButton setTitle:@"重录" forState:UIControlStateNormal];
    self.reRecorderButton.titleLabel.font    = [UIFont systemFontOfSize:18];
    [self.reRecorderButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    self.reRecorderButton.enabled            = NO;
    [self.reRecorderButton addTarget:self action:@selector(reRecordAction) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.reRecorderButton];
    
    self.nextStepButton                    = [UIButton buttonWithType:UIButtonTypeCustom];
    self.nextStepButton.frame              = YRRectMake(168.5, 330, 130, 34);
    self.nextStepButton.backgroundColor    = RGB_COLOR(204, 204, 204);
    self.nextStepButton.layer.cornerRadius = 17 * SCREEN_WIDTH /320.0f;
    [self.nextStepButton setTitle:@"下一步" forState:UIControlStateNormal];
    self.nextStepButton.titleLabel.font    = [UIFont systemFontOfSize:18];
    [self.nextStepButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    self.nextStepButton.enabled            = NO;
    [self.nextStepButton addTarget:self action:@selector(nextStepAction) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.nextStepButton];
    
}

-(void)nextStepAction{
    
    if (recordTime <3) {
        [MBProgressHUD showError:@"语音时长未满3s,请重新录制"];
        
    }else{
        NSString *urlStr=[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
//        urlStr=[urlStr stringByAppendingPathComponent:kRecordAudioFile];
//        
//        NSString *urlStr = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
//        NSString *audioFileSavePath = [urlStr stringByAppendingPathComponent:kRecordAudioFile];
        NSString *mp3FilePath = [urlStr stringByAppendingPathComponent:@"test.mp3"];
        
        @weakify(self);
        [self dismissViewControllerAnimated:YES completion:^{
            @strongify(self);
            if ([self.delegate respondsToSelector:@selector(didClickDataSource:AudioPath:AudioTime:)]) {
                [self.delegate didClickDataSource:self.dataSource AudioPath:mp3FilePath AudioTime:[NSString stringWithFormat:@"%ld",recordTime]];
            }
        }];
    }
}

-(void)reRecordAction{
    
    recordType = RecordTypeStartRecording;
    
    self.nextStepButton.enabled = NO;
    [self.nextStepButton setBackgroundColor: RGB_COLOR(204, 204, 204)];
    
    self.reRecorderButton.enabled = NO;
    [self.reRecorderButton setBackgroundColor:RGB_COLOR(204, 204, 204)];
    
    UIButton *audioRecorderButton   = [self.view viewWithTag:100];
    [audioRecorderButton setBackgroundImage:[UIImage imageNamed:@"startRecordingImage"] forState:UIControlStateNormal];
    UIImageView *animationImageView = [audioRecorderButton viewWithTag:1];
    animationImageView.hidden       = YES;
    _tintLabel.text       = @"点击开始录音，最多可以录制120\"";
    _progressView.percent = 0;
    _timeLabel.text       = @"0\"";
    recordTime            = 0;
    [_timer invalidate];
    [self.audioPlayer stop];
    self.audioPlayer = nil;
}

-(void)recordButtonClick:(UIButton*)audioRecorderButton{
    switch (recordType) {
        case RecordTypeStartRecording:
        {
            [self startRecordind];
            if ([self canRecord]) {
                recordType = RecordTypeEndRecording;
                [audioRecorderButton setBackgroundImage:[UIImage imageNamed:@"recordingImage"] forState:UIControlStateNormal];
                _tintLabel.text = @"录音中，点击停止录音";
                _timer = [NSTimer scheduledTimerWithTimeInterval:1.0f target:self selector:@selector(timerFired) userInfo:nil repeats:YES];
            }
        }
            break;
        case RecordTypeEndRecording:
        {
            recordType = RecordTypePlayRecording;
            [_timer invalidate];
            _progressView.percent = 1;
            _tintLabel.text = @"点击试听";
            [audioRecorderButton setBackgroundImage:[UIImage imageNamed:@"playRecordingImage"] forState:UIControlStateNormal];
            
            [self endRecordind];
        }
            break;
        case RecordTypePlayRecording:
        {
            recordType = RecordTypeEndPlayRecording;
            _tintLabel.text = @"语音播放中，点击停止播放";
            [audioRecorderButton setBackgroundImage:[UIImage imageNamed:@""] forState:UIControlStateNormal];
            
            UIImageView *animationImageView = [audioRecorderButton viewWithTag:1];
            animationImageView.hidden = NO;
            NSMutableArray  *arrayM=[NSMutableArray array];
            for (int i=0; i<5; i++) {
                [arrayM addObject:[UIImage imageNamed:[NSString stringWithFormat:@"recordingAnimation-%d",i+1]]];
            }
            //设置动画数组
            [animationImageView setAnimationImages:arrayM];
            //设置动画播放次数
            [animationImageView setAnimationRepeatCount:0];
            //设置动画播放时间
            [animationImageView setAnimationDuration:5*0.075];
            //开始动画
            [animationImageView startAnimating];
            [self playRecordind];
        }
            break;
        case RecordTypeEndPlayRecording:
        {
            recordType = RecordTypePlayRecording;
            UIImageView *animationImageView = [audioRecorderButton viewWithTag:1];
            animationImageView.hidden = YES;
            _tintLabel.text = @"点击试听";
            [audioRecorderButton setBackgroundImage:[UIImage imageNamed:@"playRecordingImage"] forState:UIControlStateNormal];
            [self endPlayRecordind];
        }
            break;
        default:
            break;
    }
}

-(void)timerFired{
    
    recordTime += 1;
    _progressView.percent = recordTime /120.0f;
    _timeLabel.text = [NSString stringWithFormat:@"%ld\"",recordTime];
    
    if (recordTime == 120) {
        if ([self.audioRecorder isRecording]) {
            
            recordType = RecordTypePlayRecording;
            [_timer invalidate];
            _progressView.percent = 1;
            _tintLabel.text = @"点击试听";
            [self.audioRecorderButton setBackgroundImage:[UIImage imageNamed:@"playRecordingImage"] forState:UIControlStateNormal];
            
            [self endRecordind];
            
        }
    }
}

#pragma mark - 私有方法
/**
 *  设置音频会话
 */
-(void)setAudioSession{
    AVAudioSession *audioSession=[AVAudioSession sharedInstance];
    //设置为播放和录音状态，以便可以在录制完之后播放录音
    [audioSession setCategory:AVAudioSessionCategoryPlayAndRecord error:nil];
    [audioSession setActive:YES error:nil];
}

/**
 *  取得录音文件保存路径
 *
 *  @return 录音文件路径
 */

-(NSURL *)getSavePath{
    NSString *urlStr=[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
    urlStr=[urlStr stringByAppendingPathComponent:kRecordAudioFile];
    NSLog(@"file path:%@",urlStr);
    NSURL *url=[NSURL fileURLWithPath:urlStr];
    return url;
}

/**
 *  取得录音文件设置
 *
 *  @return 录音设置
 */
-(NSDictionary *)getAudioSetting{
    
    NSMutableDictionary *dicM=[NSMutableDictionary dictionary];
    
    //设置录音格式
    [dicM setObject:@(kAudioFormatLinearPCM) forKey:AVFormatIDKey];
    //设置录音采样率，8000是电话采样率，对于一般录音已经够了
    [dicM setObject:@(11025.0) forKey:AVSampleRateKey];
    //设置通道,这里采用单声道
    [dicM setObject:@(2) forKey:AVNumberOfChannelsKey];
    //每个采样点位数,分为8、16、24、32
    //[dicM setObject:@(8) forKey:AVLinearPCMBitDepthKey];
    //是否使用浮点数采样
    //[dicM setObject:@(YES) forKey:AVLinearPCMIsFloatKey];
    
    [dicM setObject:@(AVAudioQualityMin) forKey:AVEncoderAudioQualityKey];

    //....其他设置等
    return dicM;
}

/**
 *  获得录音机对象
 *
 *  @return 录音机对象
 */
-(AVAudioRecorder *)audioRecorder{
    if (!_audioRecorder) {
        //创建录音文件保存路径
        NSURL *url=[self getSavePath];
        //创建录音格式设置
        NSDictionary *setting=[self getAudioSetting];
        //创建录音机
        NSError *error=nil;
        _audioRecorder=[[AVAudioRecorder alloc]initWithURL:url settings:setting error:&error];
        _audioRecorder.delegate=self;
        _audioRecorder.meteringEnabled=YES;//如果要监控声波则必须设置为YES
        
        if (error) {
            NSLog(@"创建录音机对象时发生错误，错误信息：%@",error.localizedDescription);
            return nil;
        }
    }
    return _audioRecorder;
}

/**
 *  创建播放器
 *
 *  @return 播放器
 */
-(AVAudioPlayer *)audioPlayer{
    if (!_audioPlayer) {
        NSURL *url=[self getSavePath];
        NSError *error=nil;
        
        _audioPlayer=[[AVAudioPlayer alloc]initWithContentsOfURL:url error:&error];
        _audioPlayer.numberOfLoops=0;
        _audioPlayer.delegate = self;
        [_audioPlayer prepareToPlay];
        if (error) {
            NSLog(@"创建播放器过程中发生错误，错误信息：%@",error.localizedDescription);
            return nil;
        }
    }
    return _audioPlayer;
}

/**
 *  录音声波监控定制器
 *
 *  @return 定时器
 */
-(NSTimer *)timer{
    if (!_timer) {
        _timer=[NSTimer scheduledTimerWithTimeInterval:0.1f target:self selector:@selector(audioPowerChange) userInfo:nil repeats:YES];
    }
    return _timer;
}

/**
 *  录音声波状态设置
 */
-(void)audioPowerChange{
    [self.audioRecorder updateMeters];//更新测量值
    float power= [self.audioRecorder averagePowerForChannel:0];//取得第一个通道的音频，注意音频强度范围时-160到0
    CGFloat progress=(1.0/160.0)*(power+160.0);
    [self.audioPower setProgress:progress];
}
#pragma mark - UI事件
/**
 *  点击录音按钮
 *
 *  @param sender 录音按钮
 */
- (void)startRecordind {
    
    if (![self.audioRecorder isRecording]) {
        [self.audioRecorder record];//首次使用应用时如果调用record方法会询问用户是否允许使用麦克风
        self.timer.fireDate=[NSDate distantPast];
    }
}

/**
 *  点击暂定按钮
 *
 *  @param sender 暂停按钮
 */
- (void)pauseClick:(UIButton *)sender {
    
    if ([self.audioRecorder isRecording]) {
        
        [self.audioRecorder peakPowerForChannel:0];
        
        [self.audioRecorder pause];
        
        self.timer.fireDate=[NSDate distantFuture];
    }
}

/**
 *  点击恢复按钮
 *  恢复录音只需要再次调用record，AVAudioSession会帮助你记录上次录音位置并追加录音
 *
 *  @param sender 恢复按钮
 */
- (void)playRecordind{
    if (![self.audioPlayer isPlaying]) {
        
        self.audioPlayer.volume=1.0;
        
        UInt32 doChangeDefaultRoute = 1;
        AudioSessionSetProperty(kAudioSessionProperty_OverrideCategoryDefaultToSpeaker,sizeof(doChangeDefaultRoute), &doChangeDefaultRoute);
        
        [self.audioPlayer play];
    }
}

- (void)endPlayRecordind{
    [self.audioPlayer stop];
}

/**
 *  点击停止按钮
 *
 *  @param sender 停止按钮
 */
- (void)endRecordind {
    [self.audioRecorder stop];
    //self.timer.fireDate=[NSDate distantFuture];
    //self.audioPower.progress=0.0;
}

#pragma mark - 录音机代理方法
/**
 *  录音完成，录音完成后播放录音
 *
 *  @param recorder 录音机对象
 *  @param flag     是否成功
 */
-(void)audioRecorderDidFinishRecording:(AVAudioRecorder *)recorder successfully:(BOOL)flag{

    self.data = [NSData dataWithContentsOfURL:recorder.url];
    
    [NSThread detachNewThreadSelector:@selector(audio_PCMtoMP3) toTarget:self withObject:nil];
    
    //NSLog(@"录音完成!%@",self.data);
    
    if (self.data) {
        self.nextStepButton.enabled = YES;
        [self.nextStepButton setBackgroundColor:[UIColor themeColor]];
        
        self.reRecorderButton.enabled = YES;
        [self.reRecorderButton setBackgroundColor:[UIColor themeColor]];
    }
}
-(void)audioPlayerDidFinishPlaying:(AVAudioPlayer *)player successfully:(BOOL)flag{
    NSLog(@"音乐播放完成...");
    recordType = RecordTypePlayRecording;
    UIImageView *animationImageView = [self.audioRecorderButton viewWithTag:1];
    animationImageView.hidden = YES;
    _tintLabel.text = @"点击试听";
    [self.audioRecorderButton setBackgroundImage:[UIImage imageNamed:@"playRecordingImage"] forState:UIControlStateNormal];
    [self endPlayRecordind];
}




- (void)audioPlayerEndInterruption:(AVAudioPlayer *)player
{
    [self.audioPlayer play];
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

- (void)audio_PCMtoMP3
{
    NSString *urlStr = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
    NSString *audioFileSavePath = [urlStr stringByAppendingPathComponent:kRecordAudioFile];
    NSString *mp3FilePath = [urlStr stringByAppendingPathComponent:@"test.mp3"];
    
    @try {
        int read, write;
        
        FILE *pcm = fopen([audioFileSavePath cStringUsingEncoding:1], "rb");  //source 被转换的音频文件位置
        fseek(pcm, 4*1024, SEEK_CUR);                                   //skip file header
        FILE *mp3 = fopen([mp3FilePath cStringUsingEncoding:1], "wb");  //output 输出生成的Mp3文件位置
        
        const int PCM_SIZE = 8192;
        const int MP3_SIZE = 8192;
        short int pcm_buffer[PCM_SIZE*2];
        unsigned char mp3_buffer[MP3_SIZE];
        
        lame_t lame = lame_init();
        lame_set_in_samplerate(lame, 11025.0);
        lame_set_VBR(lame, vbr_default);
        lame_init_params(lame);
        
        do {
            read = fread(pcm_buffer, 2*sizeof(short int), PCM_SIZE, pcm);
            if (read == 0)
                write = lame_encode_flush(lame, mp3_buffer, MP3_SIZE);
            else
                write = lame_encode_buffer_interleaved(lame, pcm_buffer, read, mp3_buffer, MP3_SIZE);
            
            fwrite(mp3_buffer, write, 1, mp3);
            
        } while (read != 0);
        
        lame_close(lame);
        fclose(mp3);
        fclose(pcm);
    }
    @catch (NSException *exception) {
        NSLog(@"%@",[exception description]);
    }
    @finally {
        audioFileSavePath = mp3FilePath;
        NSLog(@"MP3生成成功: %@",audioFileSavePath);
    }
}


- (long long) fileSizeAtPath:(NSString*) filePath{
    
    NSFileManager* manager = [NSFileManager defaultManager];
    
    if ([manager fileExistsAtPath:filePath]){
        
        return [[manager attributesOfItemAtPath:filePath error:nil] fileSize];
    }
    return 0;
}


@end
