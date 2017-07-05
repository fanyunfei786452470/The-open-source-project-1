//
//  YRReleasedVideoController.h
//  YRYZ
//
//  Created by Sean on 16/8/15.
//  Copyright © 2016年 yryz. All rights reserved.
//

#import "BaseViewController.h"

@interface YRReleasedVideoController : BaseViewController

@property (nonatomic,copy) NSString *videoPath;
@property (nonatomic,strong) UIImage *thumbnailImg;

@property (nonatomic,strong) NSMutableArray *videoTypeArr;


@end
