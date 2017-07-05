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

@property (nonatomic,weak) UIImage *ima;

@property (weak, nonatomic) IBOutlet UIImageView *image;

@property (nonatomic,strong) NSURL *url;

@property (nonatomic,assign) NSInteger time;

@property (nonatomic,weak) YRVidioDetailController *delegate;
@end
