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
#import "YRProductDetail.h"
#import "YRProductListModel.h"
#import "YRCircleListModel.h"
#import "YRProductListModel.h"
@interface YRAudioUrlPlayView : UIView

//playState 0没有登录 1没有转发 2代表播放 3推荐
typedef void(^Forwarding)(NSInteger  playState);
@property (nonatomic,weak) id timeObserve;
@property (nonatomic,strong)  AVPlayer *player;
@property (nonatomic,strong)  AVPlayerItem * songItem;
@property (nonatomic,assign) BOOL isPlay;
@property (nonatomic,assign) BOOL isForwarding;
//播放按钮
@property (nonatomic,copy) Forwarding forward;


@property(strong ,nonatomic)YRProductListModel          *productListModel;

@property(strong ,nonatomic)YRProductDetail             *productDetail;

@property(nonatomic , strong)YRCircleListModel          *circleListModel;


@property (nonatomic,assign) NSInteger          type;//type2 是圈子



- (instancetype)initWithFrame:(CGRect)frame AudioUrl:(NSString *)audioUrl AudioTime:(NSString *)time productListModel:(YRProductListModel*)productListModel;
- (instancetype)initWithFrame:(CGRect)frame AudioUrl:(NSString *)audioUrl AudioTime:(NSInteger)time productDetail:(YRProductDetail*)productDetail;

@end
