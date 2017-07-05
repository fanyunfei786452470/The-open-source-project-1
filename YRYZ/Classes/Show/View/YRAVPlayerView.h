//
//  YRAVPlayerView.h
//  YRYZ
//
//  Created by Mrs_zhang on 16/8/10.
//  Copyright © 2016年 yryz. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AVKit/AVKit.h>
#import <AVFoundation/AVFoundation.h>

@interface YRAVPlayerView : UIView

@property (nonatomic,strong)  AVPlayer *player;
@property (nonatomic,strong)  AVPlayerLayer *yrLayer;
- (instancetype)initWithFrame:(CGRect)frame IsRequest:(BOOL)isRequest WithPathOrUrl:(NSString *)pathOrUrl;
@end
