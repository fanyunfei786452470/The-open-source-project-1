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



@interface YRVidioDetailController : BaseViewController

@property(strong ,nonatomic)YRProductListModel  *productListModel;

@property (nonatomic,strong) NSURL          *url;

@property (nonatomic,assign) NSInteger      time;


@property (nonatomic,strong) UIImage                      *shareImage;


@property (nonatomic ,assign) id<VideoTranSucessDelegate>   videoTranSucessDelegate;



@property (nonatomic ,assign) CGFloat                  commentHeigt;//内容高度
//是否刷新数据
@property (nonatomic, assign) BOOL                           isFectDetail;


@property (nonatomic, assign) BOOL                           isOriginalWorks;//是否我的原创作品


- (void)infoReadStatus;
@end
