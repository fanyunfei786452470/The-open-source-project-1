//
//  YRAVPlayerView.m
//  YRYZ
//
//  Created by Mrs_zhang on 16/8/10.
//  Copyright © 2016年 yryz. All rights reserved.
//

#import "YRAVPlayerView.h"


@interface YRAVPlayerView()

@end

@implementation YRAVPlayerView

- (instancetype)initWithFrame:(CGRect)frame IsRequest:(BOOL)isRequest WithPathOrUrl:(NSString *)pathOrUrl{

    self = [super initWithFrame:frame];
    if (self) {
        
        AVPlayerItem *item;
        if (isRequest) {
        item  = [AVPlayerItem playerItemWithURL:[NSURL URLWithString:@"http://static.tripbe.com/videofiles/20121214/9533522808.f4v.mp4"]];
        }else{
        item  = [AVPlayerItem playerItemWithURL:[NSURL fileURLWithPath:pathOrUrl]];
         
        }
        
        self.player = [AVPlayer playerWithPlayerItem:item];
        
        self.yrLayer = [AVPlayerLayer playerLayerWithPlayer:self.player];
        
        self.yrLayer.frame = CGRectMake(0, 0, SCREEN_WIDTH,  SCREEN_WIDTH*9/16);
        
        self.yrLayer.backgroundColor = [[UIColor blackColor]CGColor];
        
        [self.layer addSublayer:self.yrLayer];
        
        
        [self.player play];
        
    }
    return self;
}

@end
