//
//  YRRedPaperAdPaymemtViewController.h
//  YRYZ
//
//  Created by Rongzhong on 16/8/18.
//  Copyright © 2016年 yryz. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "YRRedAdsPaymentModel.h"
#import "YRRedAdsModel.h"
@interface YRRedPaperAdPaymemtViewController : UIViewController

{
    float banlce;
}
@property (strong,nonatomic)YRRedAdsPaymentModel * model;

@property (nonatomic,weak) YRRedAdsModel *mineModel;
//是否是在续费
@property (nonatomic,assign) BOOL isAgainTry;

@property (nonatomic,copy) NSString * wishUpDate;

@end
