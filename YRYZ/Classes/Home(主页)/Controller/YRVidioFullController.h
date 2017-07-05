//
//  YRVidioFullController.h
//  YRYZ
//
//  Created by Sean on 16/8/16.
//  Copyright © 2016年 yryz. All rights reserved.
//

#import "BaseViewController.h"
#import "YRVidioDetailController.h"

#import <ZFPlayer.h>
@interface YRVidioFullController : BaseViewController
@property (weak, nonatomic) IBOutlet ZFPlayerView *myPlayerView;

@property (nonatomic,strong) NSURL *url;

@property (nonatomic,assign) NSInteger time;
@end
