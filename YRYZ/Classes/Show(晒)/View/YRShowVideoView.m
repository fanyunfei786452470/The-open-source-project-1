//
//  AskGameView.m
//  BoardGame
//
//  Created by 张享 on 16/3/11.
//  Copyright © 2016年 ZX. All rights reserved.
//  主题弹框

#import "YRShowVideoView.h"
#import "YRAVPlayerView.h"
#import <AVFoundation/AVFoundation.h>

@interface YRShowVideoWindow : UIView

@end
@implementation YRShowVideoWindow
- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        self.autoresizingMask = UIViewAutoresizingFlexibleWidth| UIViewAutoresizingFlexibleHeight;
        self.opaque = NO;
    }
    return self;
}
- (void)drawRect:(CGRect)rect {
    // Drawing code
    CGContextRef context = UIGraphicsGetCurrentContext();
    [[UIColor colorWithWhite:0 alpha:0.5] set];
    CGContextFillRect(context, self.bounds);
}
@end

#pragma mark - GameView
@interface YRShowVideoView(){
    BOOL _isAnimating;
}

@property (nonatomic,strong) YRShowVideoWindow *showVideoWindow;
@property (nonatomic,strong) YRAVPlayerView *VideoView;


@end
@implementation YRShowVideoView

- (NSArray *)data{
    if (!_data) {
        _data = [NSArray array];
    }
    return _data;
}

- (instancetype)initWithFrame:(CGRect)frame IsRequest:(BOOL)isRequest WithPathOrUrl:(NSString *)pathOrUrl{
    self = [super initWithFrame:CGRectMake(0, (SCREEN_HEIGHT-SCREEN_WIDTH*9/16)/2, SCREEN_WIDTH, SCREEN_WIDTH*9/16)];
    if (self) {
//        self.backgroundColor = [UIColor whiteColor];
        [self addTapGesturesTarget:self selector:@selector(tapAction)];
        
        YRAVPlayerView *avPlayer = [[YRAVPlayerView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_WIDTH*9/16) IsRequest:isRequest WithPathOrUrl:pathOrUrl];
        [self addSubview:avPlayer];
        self.VideoView = avPlayer;
    }
    return self;
}

#pragma mark - getter 
- (YRShowVideoWindow *)showVideoWindow{
    if (!_showVideoWindow) {
        _showVideoWindow = [[YRShowVideoWindow alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
        _showVideoWindow.alpha = 0.0;
    }
    return _showVideoWindow;
}

#pragma mark - public
- (void)show{
    [self.showVideoWindow addSubview:self];
    __weak typeof(self) weakSelf = self;
//    CGRect frame = self.frame;
//    frame.origin.y = self.showVideoWindow.bounds.size.height - frame.size.height;
    UIWindow * keyWindow = [[UIApplication sharedApplication] keyWindow];
    [keyWindow addSubview:self.showVideoWindow];
    [UIView animateWithDuration:0.15 animations:^{
        weakSelf.showVideoWindow.alpha = 1.0f;
    } completion:^(BOOL finished) {
        if (finished) {
            [UIView animateWithDuration:0.2 animations:^{
//                weakSelf.frame = frame;
            } completion:^(BOOL finished) {

            }];
        }
    }];
}
- (void)dismiss{

    __weak typeof(self) weakSelf = self;
    [UIView animateWithDuration:0.1 animations:^{
        CGAffineTransform transform = self.transform;
        weakSelf.transform = CGAffineTransformScale(transform, 1.2, 1.2);
    } completion:^(BOOL finished) {

        [UIView animateWithDuration:0.3 animations:^{
            weakSelf.showVideoWindow.alpha = 0.0;
            CGAffineTransform transform = weakSelf.transform;
            weakSelf.transform = CGAffineTransformScale(transform, 0.01, 0.01);

        } completion:^(BOOL finished) {
            [weakSelf removeFromSuperview];
            [weakSelf.showVideoWindow removeFromSuperview];
            [self.VideoView.yrLayer removeAllSublayers];
            
            [self.VideoView.player pause];
            [self.VideoView.player replaceCurrentItemWithPlayerItem:nil];
            
            self.VideoView.player = nil;
        }];
    }];

 
}

- (void)tapAction{

    [self dismiss];
}

@end
