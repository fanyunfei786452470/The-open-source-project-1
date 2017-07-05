//
//  YRRedPaperPaymentViewController.h
//  YRYZ
//
//  Created by Rongzhong on 16/7/12.
//  Copyright © 2016年 yryz. All rights reserved.
//

#import "BaseViewController.h"
#import "YRProductListModel.h"
#import "YRCircleListModel.h"
#import "YRProductDetail.h"
#import "YRVidioDetailController.h"
@protocol TranSuccessDelegate <NSObject>

- (void)tranSuccessDelegate:(YRProductListModel*)productListModel    circleListModel:(YRCircleListModel*)circleListModel indexPosition:(NSInteger)indexPosition;
@end


@interface YRRedPaperPaymentViewController : BaseViewController
@property(nonatomic ,weak)YRProductListModel  *productModel;
@property(nonatomic ,weak)YRProductDetail     *productDetail;
@property(nonatomic ,weak)YRProductDetail     *circleDetail;
@property(nonatomic ,weak)YRCircleListModel   *circleModel;

typedef void (^RefreshBlock)();
//充值
@property (strong, nonatomic) RefreshBlock  refreshBlock;


@property (nonatomic ,assign)NSInteger         indexPosition;

@property (nonatomic ,assign) id<TranSuccessDelegate>   tranSuccessDelegate;


@property (nonatomic,weak) YRVidioDetailController *delegate;

//0为广告红包，1为圈子红包
@property NSInteger type;

@end
