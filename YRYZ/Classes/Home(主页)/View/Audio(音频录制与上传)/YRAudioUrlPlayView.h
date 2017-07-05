//
//  YRAudioUrlPlayView.h
//  YRYZ
//
//  Created by Mrs_zhang on 16/8/23.
//  Copyright © 2016年 yryz. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>
#import <AVKit/AVKit.h>


@interface YRAudioUrlPlayView : UIView
typedef void(^Forwarding)(BOOL isClick);
@property (nonatomic,weak) id timeObserve;
@property (nonatomic,strong)  AVPlayer *player;
@property (nonatomic,strong)  AVPlayerItem * songItem;
@property (nonatomic,assign) BOOL isPlay;
@property (nonatomic,assign) BOOL isForwarding;
//转发按钮
@property (nonatomic,copy) Forwarding forward;
- (instancetype)initWithFrame:(CGRect)frame AudioUrl:(NSString *)audioUrl AudioTime:(NSString *)time;

@end
