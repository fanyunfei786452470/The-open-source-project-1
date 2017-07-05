//
//  YRVidioDetailController.h
//  YRYZ
//
//  Created by weishibo on 16/8/15.
//  Copyright © 2016年 yryz. All rights reserved.
//

#import "BaseViewController.h"
#import "YRProductListModel.h"
@interface YRVidioDetailController : BaseViewController

@property(strong ,nonatomic)YRProductListModel  *productListModel;

@property (nonatomic,strong) NSURL          *url;

@property (nonatomic,assign) NSInteger      time;

@end
