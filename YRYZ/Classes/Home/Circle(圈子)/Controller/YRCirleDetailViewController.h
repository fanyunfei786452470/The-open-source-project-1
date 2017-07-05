//
//  YRCirleDetailViewController.h
//  YRYZ
//
//  Created by weishibo on 16/8/15.
//  Copyright © 2016年 yryz. All rights reserved.
//

#import "BaseViewController.h"
#import "YRCircleListModel.h"
#import "YRProductDetail.h"
@interface YRCirleDetailViewController : BaseViewController

@property (nonatomic, assign) InfoProductType                productType;
@property(nonatomic , strong)YRCircleListModel               *circleListModel;

@property (nonatomic,assign) NSInteger      time;
@property (nonatomic,strong) NSURL          *url;


@property (nonatomic ,assign) CGFloat                  commentHeigt;//内容高度

@property (nonatomic,strong) UIImage                      *shareImage;
@property(nonatomic,strong)YRProductDetail                  *productDetail;

@property (nonatomic,assign) BOOL       isMySelfProuduct;
@end
