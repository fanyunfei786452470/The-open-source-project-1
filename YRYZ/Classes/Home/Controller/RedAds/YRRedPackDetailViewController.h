//
//  YRRedPackDetailViewController.h
//  YRYZ
//
//  Created by weishibo on 16/8/18.
//  Copyright © 2016年 yryz. All rights reserved.
//

#import "BaseViewController.h"
#import "YRRedAdsModel.h"

@interface YRRedPackDetailViewController : BaseViewController

@property (nonatomic,strong) NSURL      *url;

@property (nonatomic,assign) NSInteger  time;


@property (nonatomic ,strong)YRRedAdsModel  *redPackerModel;

@end
