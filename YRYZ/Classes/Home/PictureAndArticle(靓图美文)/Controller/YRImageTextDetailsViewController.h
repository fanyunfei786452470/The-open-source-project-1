//
//  YRImageTextDetailsViewController.h
//  YRYZ
//
//  Created by Mrs_zhang on 16/7/15.
//  Copyright © 2016年 yryz. All rights reserved.
//

#import "BaseViewController.h"
#import "YRProductListModel.h"
#import "YRProductDetail.h"

@protocol DetaiSuccessDelegate <NSObject>

- (void)detaiSuccessDelegate:(YRProductListModel*)productListModel;

@end
@interface YRImageTextDetailsViewController : BaseViewController
@property(strong ,nonatomic)YRProductListModel *productListModel;
@property(nonatomic ,assign)BOOL  isMySelfProuduct; //自己的作品
@property (nonatomic,strong) UIImage                      *shareImage;


@property (nonatomic ,assign) id<DetaiSuccessDelegate>   detaiSuccessDelegate;



@end
