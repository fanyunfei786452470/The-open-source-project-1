//
//  YRVidioDetailController.h
//  YRYZ
//
//  Created by weishibo on 16/8/15.
//  Copyright © 2016年 yryz. All rights reserved.
//

#import "BaseViewController.h"
#import "YRProductListModel.h"


@protocol VideoTranSucessDelegate <NSObject>

- (void)videoTranSucessDelegate:(NSInteger)readStatus;

@end

@interface YRNewVideoDetailViewController : BaseViewController

@property(strong ,nonatomic)YRProductListModel      *productListModel;

@property(strong ,nonatomic)NSString                *productId;

@property (nonatomic,strong) NSURL          *url;

@property (nonatomic,assign) NSInteger      time;


@property (nonatomic,strong) UIImage                      *shareImage;


@property (nonatomic ,assign) id<VideoTranSucessDelegate>   videoTranSucessDelegate;



@property (nonatomic ,assign) CGFloat                  commentHeigt;//内容高度

- (void)infoReadStatus;
@end
